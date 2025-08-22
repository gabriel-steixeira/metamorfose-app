/**
 * File: map_service.dart
 * Description: Serviço para gerenciamento de mapa e localização.
 *
 * Responsabilidades:
 * - Gerenciar permissões de localização
 * - Buscar floriculturas via Google Places API
 * - Calcular distâncias
 * - Criar marcadores para o mapa
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:metamorfose_flutter/config/environment.dart';
import 'package:metamorfose_flutter/state/map/map_state.dart';
import 'package:metamorfose_flutter/services/map_service_web.dart' if (dart.library.io) 'package:metamorfose_flutter/services/map_service_stub.dart';

/// Resultado de uma operação de busca
class SearchResult {
  final bool success;
  final List<Floricultura> floriculturas;
  final String? errorMessage;

  SearchResult({
    required this.success,
    required this.floriculturas,
    this.errorMessage,
  });

  factory SearchResult.success(List<Floricultura> floriculturas) {
    return SearchResult(
      success: true,
      floriculturas: floriculturas,
    );
  }

  factory SearchResult.error(String message) {
    return SearchResult(
      success: false,
      floriculturas: [],
      errorMessage: message,
    );
  }
}

/// Resultado de operação de localização
class LocationResult {
  final bool success;
  final Position? position;
  final LocationPermission? permission;
  final String? errorMessage;

  LocationResult({
    required this.success,
    this.position,
    this.permission,
    this.errorMessage,
  });

  factory LocationResult.success(Position position, LocationPermission permission) {
    return LocationResult(
      success: true,
      position: position,
      permission: permission,
    );
  }

  factory LocationResult.error(String message, [LocationPermission? permission]) {
    return LocationResult(
      success: false,
      permission: permission,
      errorMessage: message,
    );
  }
}

/// Serviço para gerenciamento de mapa e localização
class MapService {
  final Dio _dio;
  final MapServiceWeb? _webService;

  MapService() : _dio = Dio(), _webService = kIsWeb ? MapServiceWeb() : null;

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

  /// Busca floriculturas próximas automaticamente
  Future<SearchResult> searchNearbyFloriculturas(Position position) async {
    // Se estiver na web, usa o serviço web para evitar CORS
    if (kIsWeb && _webService != null) {
      return _webService!.searchNearbyFloriculturas(position);
    }
    
    try {
      final String apiKey = Environment.googlePlacesApiKey;
      if (apiKey.isEmpty) {
        return SearchResult.error('API Key não configurada');
      }

      final String location = '${position.latitude},${position.longitude}';
      const int radius = 15000; // 15km de raio

      final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
          'location=$location&'
          'radius=$radius&'
          'type=florist&'
          'key=$apiKey';

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'REQUEST_DENIED') {
          return SearchResult.error('API Key não autorizada. Verifique as configurações no Google Console.');
        }

        if (data['status'] == 'OK') {
          List<Floricultura> results = [];

          for (var place in data['results'] as List) {
            final placeLocation = place['geometry']['location'];
            final distancia = _calculateDistance(
              position.latitude,
              position.longitude,
              placeLocation['lat'],
              placeLocation['lng'],
            );

            results.add(
              Floricultura(
                id: place['place_id'],
                nome: place['name'],
                endereco: place['vicinity'] ?? 'Endereço não disponível',
                distancia: distancia,
                status: (place['opening_hours']?['open_now'] == true) ? 'Open' : 'Closed',
                tiposAceitos: 'Flores,Plantas,Decoração',
                latitude: placeLocation['lat'],
                longitude: placeLocation['lng'],
              ),
            );
          }

          // Ordena por distância e pega apenas as 20 mais próximas
          results.sort((a, b) => a.distancia.compareTo(b.distancia));
          results = results.take(20).toList();

          return SearchResult.success(results);
        } else {
          // Se não encontrar nenhuma, retorna lista vazia sem erro
          return SearchResult.success([]);
        }
      } else {
        return SearchResult.error('Erro na API: ${response.statusCode}');
      }
    } catch (e) {
      return SearchResult.error('Erro de rede: $e');
    }
  }

  /// Busca floriculturas com termo específico
  Future<SearchResult> searchFloriculturas(Position position, String query) async {
    // Se estiver na web, usa o serviço web para evitar CORS
    if (kIsWeb && _webService != null) {
      return _webService!.searchFloriculturas(position, query);
    }
    
    try {
      if (query.isEmpty) {
        return SearchResult.success([]);
      }

      final String apiKey = Environment.googlePlacesApiKey;
      if (apiKey.isEmpty) {
        return SearchResult.error('API Key não configurada');
      }

      final String location = '${position.latitude},${position.longitude}';
      const int radius = 10000; // 10km de raio

      final String url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?'
          'query=floricultura $query&'
          'location=$location&'
          'radius=$radius&'
          'type=florist&'
          'key=$apiKey';

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data['status'] == 'OK') {
          List<Floricultura> results = [];

          for (var place in data['results'] as List) {
            final placeLocation = place['geometry']['location'];
            final distancia = _calculateDistance(
              position.latitude,
              position.longitude,
              placeLocation['lat'],
              placeLocation['lng'],
            );

            results.add(
              Floricultura(
                id: place['place_id'],
                nome: place['name'],
                endereco: place['formatted_address'] ?? 'Endereço não disponível',
                distancia: distancia,
                status: (place['opening_hours']?['open_now'] == true) ? 'Open' : 'Closed',
                tiposAceitos: 'Flores,Plantas,Decoração',
                latitude: placeLocation['lat'],
                longitude: placeLocation['lng'],
              ),
            );
          }

          // Ordena por distância
          results.sort((a, b) => a.distancia.compareTo(b.distancia));

          return SearchResult.success(results);
        } else {
          return SearchResult.error('Nenhum resultado encontrado para "$query"');
        }
      } else {
        return SearchResult.error('Erro na API: ${response.statusCode}');
      }
    } catch (e) {
      return SearchResult.error('Erro de rede: $e');
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

  /// Dispose do service
  void dispose() {
    _dio.close();
  }
}