/**
 * File: map_service_web.dart
 * Description: Serviço para gerenciamento de mapa e localização específico para web.
 *
 * Responsabilidades:
 * - Gerenciar permissões de localização na web
 * - Buscar floriculturas via Google Places API usando JavaScript interop
 * - Calcular distâncias
 * - Criar marcadores para o mapa
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:metamorfose_flutter/state/map/map_state.dart';
import 'package:metamorfose_flutter/services/map_service.dart';

/// Serviço para gerenciamento de mapa e localização específico para web
class MapServiceWeb {
  js.JsObject? _placesService;
  
  /// Inicializa o serviço do Google Places
  void _initializePlacesService() {
    if (_placesService == null) {
      // Cria um elemento div temporário para o PlacesService
      final mapDiv = html.DivElement();
      final map = js.JsObject(js.context['google']['maps']['Map'], [mapDiv]);
      _placesService = js.JsObject(js.context['google']['maps']['places']['PlacesService'], [map]);
    }
  }

  /// Obtém a localização atual do usuário
  Future<LocationResult> getCurrentLocation() async {
    try {
      // Verifica se o serviço de localização está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationResult.error('Serviço de localização desabilitado');
      }

      // Verifica permissões
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationResult.error(
            'Permissão de localização negada',
            permission,
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationResult.error(
          'Permissão de localização permanentemente negada. Habilite nas configurações.',
          permission,
        );
      }

      // Obtém a posição atual
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return LocationResult.success(position, permission);
    } catch (e) {
      return LocationResult.error('Erro ao obter localização: $e');
    }
  }

  /// Busca floriculturas próximas usando Google Places JavaScript API
  Future<SearchResult> searchNearbyFloriculturas(Position position) async {
    try {
      _initializePlacesService();
      
      final completer = Completer<SearchResult>();
      
      // Cria o request para busca de lugares próximos
      final request = js.JsObject.jsify({
        'location': {
          'lat': position.latitude,
          'lng': position.longitude,
        },
        'radius': 15000, // 15km
        'type': 'florist',
      });

      // Callback para processar os resultados
      final callback = js.allowInterop((results, status, pagination) {
        try {
          final statusStr = status.toString();
          
          if (statusStr == 'OK') {
            final List<Floricultura> floriculturas = [];
            
            for (int i = 0; i < results.length; i++) {
              final place = results[i];
              final geometry = place['geometry'];
              final location = geometry['location'];
              
              final lat = location.callMethod('lat');
              final lng = location.callMethod('lng');
              
              final distancia = _calculateDistance(
                position.latitude,
                position.longitude,
                lat,
                lng,
              );
              
              final openingHours = place['opening_hours'];
              final isOpen = openingHours != null ? openingHours['open_now'] == true : false;
              
              floriculturas.add(
                Floricultura(
                  id: place['place_id'] ?? 'unknown_${i}',
                  nome: place['name'] ?? 'Nome não disponível',
                  endereco: place['vicinity'] ?? 'Endereço não disponível',
                  distancia: distancia,
                  status: isOpen ? 'Open' : 'Closed',
                  tiposAceitos: 'Flores,Plantas,Decoração',
                  latitude: lat,
                  longitude: lng,
                ),
              );
            }
            
            // Ordena por distância e pega apenas as 20 mais próximas
            floriculturas.sort((a, b) => a.distancia.compareTo(b.distancia));
            final limitedResults = floriculturas.take(20).toList();
            
            completer.complete(SearchResult.success(limitedResults));
          } else if (statusStr == 'ZERO_RESULTS') {
            completer.complete(SearchResult.success([]));
          } else {
            completer.complete(SearchResult.error('Erro na busca: $statusStr'));
          }
        } catch (e) {
          completer.complete(SearchResult.error('Erro ao processar resultados: $e'));
        }
      });

      // Executa a busca
      _placesService!.callMethod('nearbySearch', [request, callback]);
      
      return completer.future;
    } catch (e) {
      return SearchResult.error('Erro na busca: $e');
    }
  }

  /// Busca floriculturas com termo específico usando Google Places JavaScript API
  Future<SearchResult> searchFloriculturas(Position position, String query) async {
    try {
      if (query.isEmpty) {
        return SearchResult.success([]);
      }
      
      _initializePlacesService();
      
      final completer = Completer<SearchResult>();
      
      // Cria o request para busca de texto
      final request = js.JsObject.jsify({
        'query': 'floricultura $query',
        'location': {
          'lat': position.latitude,
          'lng': position.longitude,
        },
        'radius': 10000, // 10km
      });

      // Callback para processar os resultados
      final callback = js.allowInterop((results, status, pagination) {
        try {
          final statusStr = status.toString();
          
          if (statusStr == 'OK') {
            final List<Floricultura> floriculturas = [];
            
            for (int i = 0; i < results.length; i++) {
              final place = results[i];
              final geometry = place['geometry'];
              final location = geometry['location'];
              
              final lat = location.callMethod('lat');
              final lng = location.callMethod('lng');
              
              final distancia = _calculateDistance(
                position.latitude,
                position.longitude,
                lat,
                lng,
              );
              
              final openingHours = place['opening_hours'];
              final isOpen = openingHours != null ? openingHours['open_now'] == true : false;
              
              floriculturas.add(
                Floricultura(
                  id: place['place_id'] ?? 'unknown_${i}',
                  nome: place['name'] ?? 'Nome não disponível',
                  endereco: place['formatted_address'] ?? 'Endereço não disponível',
                  distancia: distancia,
                  status: isOpen ? 'Open' : 'Closed',
                  tiposAceitos: 'Flores,Plantas,Decoração',
                  latitude: lat,
                  longitude: lng,
                ),
              );
            }
            
            // Ordena por distância
            floriculturas.sort((a, b) => a.distancia.compareTo(b.distancia));
            
            completer.complete(SearchResult.success(floriculturas));
          } else if (statusStr == 'ZERO_RESULTS') {
            completer.complete(SearchResult.error('Nenhum resultado encontrado para "$query"'));
          } else {
            completer.complete(SearchResult.error('Erro na busca: $statusStr'));
          }
        } catch (e) {
          completer.complete(SearchResult.error('Erro ao processar resultados: $e'));
        }
      });

      // Executa a busca de texto
      _placesService!.callMethod('textSearch', [request, callback]);
      
      return completer.future;
    } catch (e) {
      return SearchResult.error('Erro na busca: $e');
    }
  }

  /// Cria marcadores para o mapa
  Set<Marker> createMarkers(List<Floricultura> floriculturas) {
    return floriculturas.map((floricultura) {
      return Marker(
        markerId: MarkerId(floricultura.id),
        position: LatLng(floricultura.latitude, floricultura.longitude),
        infoWindow: InfoWindow(
          title: floricultura.nome,
          snippet: '${floricultura.endereco}\n${floricultura.distancia.toStringAsFixed(1)}km',
        ),
        icon: floricultura.isOpen 
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    }).toSet();
  }

  /// Calcula distância entre duas coordenadas (Fórmula de Haversine)
  double _calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    const double earthRadius = 6371; // Raio da Terra em km

    double dLat = _degreesToRadians(endLatitude - startLatitude);
    double dLon = _degreesToRadians(endLongitude - startLongitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(startLatitude)) *
        cos(_degreesToRadians(endLatitude)) *
        sin(dLon / 2) *
        sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  /// Converte graus para radianos
  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}