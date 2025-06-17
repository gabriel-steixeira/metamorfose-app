/// File: map_screen.dart
/// Description: Tela de mapa do aplicativo Metamorfose para localizar floriculturas.
///
/// Responsabilidades:
/// - Exibir mapa com floriculturas próximas
/// - Listar floriculturas em formato de lista
/// - Gerenciar localização do usuário
/// - Interface de busca
///
/// NOTA: Para implementar o Google Maps real, adicione as seguintes dependências no pubspec.yaml:
/// dependencies:
///   google_maps_flutter: ^2.5.0
///   geolocator: ^10.1.0
/// 
/// E descomente as importações e código relacionado ao Google Maps abaixo.
///
/// Author: Gabriel Teixeira
/// Created on: atual
/// Last modified: atual
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:conversao_flutter/config/environment.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

/// Modelo para representar uma floricultura
class Floricultura {
  final String id;
  final String nome;
  final String endereco;
  final double distancia;
  final String status;
  final String tiposAceitos;
  final double latitude;
  final double longitude;

  Floricultura({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.distancia,
    required this.status,
    required this.tiposAceitos,
    required this.latitude,
    required this.longitude,
  });
}

/// Tela de mapa para localizar floriculturas próximas
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final FocusNode _searchFocusNode;
  int _selectedTabIndex = 0; // 0 = Mapa, 1 = Lista
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLoadingLocation = true;
  bool _isSearching = false;
  bool _isMapReady = false;
  Set<Marker> _markers = {};
  List<Floricultura> _searchResults = [];
  final Dio _dio = Dio();

  // Lista de floriculturas próximas (será preenchida automaticamente pela API)
  final List<Floricultura> _floriculturas = [];

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    
    // Aguarda um pequeno delay para garantir que a tela foi totalmente carregada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRequestPermissions();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _dio.close();
    super.dispose();
  }

  /// Verifica e força a solicitação de permissões
  Future<void> _checkAndRequestPermissions() async {
    // Força a verificação de permissão imediatamente
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied || 
        permission == LocationPermission.unableToDetermine) {
      await Future.delayed(const Duration(milliseconds: 500)); // Pequeno delay
      _getCurrentLocation();
    } else {
      _getCurrentLocation();
    }
  }

  /// Busca floriculturas próximas automaticamente (sem termo de busca)
  Future<void> _searchNearbyFloriculturas() async {
    if (_currentPosition == null) return;
    
    setState(() {
      _isSearching = true;
    });

    try {
      // Configuração da API Key através do Environment
      final String apiKey = Environment.googlePlacesApiKey;
      final String location = '${_currentPosition!.latitude},${_currentPosition!.longitude}';
      const int radius = 15000; // 15km de raio para busca inicial

      // URL da Google Places API - Nearby Search (melhor para busca próxima)
      final String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
          'location=$location&'
          'radius=$radius&'
          'type=florist&'
          'key=$apiKey';

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['status'] == 'REQUEST_DENIED') {
          setState(() {
            _isSearching = false;
          });
          _showSearchErrorDialog('API Key não autorizada. Verifique as configurações no Google Console.');
          return;
        }
        
        if (data['status'] == 'OK') {
          List<Floricultura> results = [];
          
          for (var place in data['results'] as List) {
            final placeLocation = place['geometry']['location'];
            final distancia = _calculateDistance(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
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

          setState(() {
            _floriculturas.clear();
            _floriculturas.addAll(results);
            _isSearching = false;
          });

          // Atualiza marcadores no mapa
          _createMarkers();

        } else {
          setState(() {
            _isSearching = false;
          });
          // Se não encontrar nenhuma, mantém a lista vazia mas não mostra erro
        }
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      // Para busca automática, não mostra erro - apenas mantém lista vazia
    }
  }

  /// Busca floriculturas próximas usando Google Places API
  Future<void> _searchFloriculturas(String query) async {
    if (query.isEmpty || _currentPosition == null) return;
    
    setState(() {
      _isSearching = true;
    });

    try {
      // Configuração da API Key através do Environment
      final String apiKey = Environment.googlePlacesApiKey;
      final String location = '${_currentPosition!.latitude},${_currentPosition!.longitude}';
      const int radius = 10000; // 10km de raio

      // URL da Google Places API - Text Search
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
            final location = place['geometry']['location'];
            final distancia = _calculateDistance(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              location['lat'],
              location['lng'],
            );

            results.add(
              Floricultura(
                id: place['place_id'],
                nome: place['name'],
                endereco: place['formatted_address'] ?? 'Endereço não disponível',
                distancia: distancia,
                status: (place['opening_hours']?['open_now'] == true) ? 'Open' : 'Closed',
                tiposAceitos: 'Flores,Plantas,Decoração',
                latitude: location['lat'],
                longitude: location['lng'],
              ),
            );
          }

          // Ordena por distância
          results.sort((a, b) => a.distancia.compareTo(b.distancia));

          setState(() {
            _searchResults = results;
            _isSearching = false;
          });

          // Atualiza marcadores no mapa
          _updateMarkersWithSearchResults();

          // Move o mapa para mostrar os resultados
          if (results.isNotEmpty && _mapController != null) {
            _fitMapToResults();
          }

        } else {
          setState(() {
            _searchResults = [];
            _isSearching = false;
          });
          
          // Mostra mensagem de erro baseada no status
          String errorMessage = 'Nenhuma floricultura encontrada';
          if (data['status'] == 'ZERO_RESULTS') {
            errorMessage = 'Nenhuma floricultura encontrada para "$query"';
          } else if (data['status'] == 'REQUEST_DENIED') {
            errorMessage = 'Erro na API Key do Google Places';
          }
          
          _showSearchErrorDialog(errorMessage);
        }
      }
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      _showSearchErrorDialog('Erro ao buscar floriculturas: ${e.toString()}');
    }
  }

  /// Calcula a distância entre dois pontos em quilômetros
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  /// Atualiza os marcadores no mapa com os resultados da busca
  void _updateMarkersWithSearchResults() {
    _markers.clear();

    // Adiciona marcador da localização atual
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow: const InfoWindow(title: 'Sua localização'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Adiciona marcadores dos resultados da busca
    for (var floricultura in _searchResults) {
      _markers.add(
        Marker(
          markerId: MarkerId(floricultura.id),
          position: LatLng(floricultura.latitude, floricultura.longitude),
          infoWindow: InfoWindow(
            title: floricultura.nome,
            snippet: '${floricultura.distancia.toStringAsFixed(1)} km - ${floricultura.status == 'Open' ? 'Aberto' : 'Fechado'}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            floricultura.status == 'Open' 
                ? BitmapDescriptor.hueGreen 
                : BitmapDescriptor.hueRed,
          ),
        ),
      );
    }

    setState(() {});
  }

  /// Ajusta o mapa para mostrar todos os resultados da busca
  void _fitMapToResults() async {
    if (_searchResults.isEmpty || _mapController == null) return;

    double minLat = _searchResults.first.latitude;
    double maxLat = _searchResults.first.latitude;
    double minLng = _searchResults.first.longitude;
    double maxLng = _searchResults.first.longitude;

    for (var result in _searchResults) {
      minLat = minLat < result.latitude ? minLat : result.latitude;
      maxLat = maxLat > result.latitude ? maxLat : result.latitude;
      minLng = minLng < result.longitude ? minLng : result.longitude;
      maxLng = maxLng > result.longitude ? maxLng : result.longitude;
    }

    // Inclui a localização atual
    if (_currentPosition != null) {
      minLat = minLat < _currentPosition!.latitude ? minLat : _currentPosition!.latitude;
      maxLat = maxLat > _currentPosition!.latitude ? maxLat : _currentPosition!.latitude;
      minLng = minLng < _currentPosition!.longitude ? minLng : _currentPosition!.longitude;
      maxLng = maxLng > _currentPosition!.longitude ? maxLng : _currentPosition!.longitude;
    }

    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    await _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100.0),
    );
  }

  /// Mostra diálogo de erro na busca
  void _showSearchErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro na Busca'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Obtém a localização atual do usuário
  Future<void> _getCurrentLocation() async {
    try {
      // Verifica se o serviço de localização está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      
              if (!serviceEnabled) {
        setState(() {
          _isLoadingLocation = false;
        });
        _showLocationServiceDialog();
        return;
      }

      // Verifica a permissão atual
      LocationPermission permission = await Geolocator.checkPermission();

      // Se a permissão foi negada ou não determinada, solicita novamente
      if (permission == LocationPermission.denied || 
          permission == LocationPermission.unableToDetermine) {
        // Aguarda um pouco antes de solicitar para garantir que a UI está pronta
        await Future.delayed(const Duration(milliseconds: 300));
        
        permission = await Geolocator.requestPermission();
        
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoadingLocation = false;
          });
          _showPermissionDeniedDialog();
          return;
        }
      }

      // Se a permissão foi negada permanentemente
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoadingLocation = false;
        });
        _showPermissionDeniedForeverDialog();
        return;
      }

      // Verifica se finalmente temos permissão
      if (permission != LocationPermission.whileInUse && 
          permission != LocationPermission.always) {
        setState(() {
          _isLoadingLocation = false;
        });
        _showPermissionDeniedDialog();
        return;
      }
      
      // Obtém a posição atual com configurações mais flexíveis
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, // Mudou para medium para ser mais rápido
        timeLimit: const Duration(seconds: 15), // Aumentou o timeout
        forceAndroidLocationManager: false, // Usa o FusedLocationProvider no Android
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      // Busca floriculturas próximas automaticamente
      _searchNearbyFloriculturas();
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      _showLocationErrorDialog(e.toString());
    }
  }

  /// Mostra diálogo quando o serviço de localização está desabilitado
  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Serviço de Localização'),
          content: const Text(
            'O serviço de localização está desabilitado. '
            'Por favor, habilite-o nas configurações do dispositivo.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openLocationSettings();
              },
              child: const Text('Abrir Configurações'),
            ),
          ],
        );
      },
    );
  }

  /// Mostra diálogo quando a permissão é negada
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permissão Necessária'),
          content: const Text(
            'É necessário permitir o acesso à localização para encontrar '
            'floriculturas próximas a você.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _getCurrentLocation(); // Tenta novamente
              },
              child: const Text('Tentar Novamente'),
            ),
          ],
        );
      },
    );
  }

  /// Mostra diálogo quando a permissão é negada permanentemente
  void _showPermissionDeniedForeverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permissão Negada'),
          content: const Text(
            'A permissão de localização foi negada permanentemente. '
            'Para usar este recurso, habilite a permissão nas configurações do app.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openAppSettings();
              },
              child: const Text('Abrir Configurações'),
            ),
          ],
        );
      },
    );
  }

  /// Mostra diálogo de erro genérico
  void _showLocationErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro de Localização'),
          content: Text(
            'Ocorreu um erro ao obter sua localização:\n\n$error\n\n'
            'Verifique se o GPS está ligado e tente novamente.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _getCurrentLocation(); // Tenta novamente
              },
              child: const Text('Tentar Novamente'),
            ),
          ],
        );
      },
    );
  }

  /// Cria os marcadores no mapa
  void _createMarkers() {
    _markers.clear();

    // Adiciona marcador da localização atual
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow: const InfoWindow(title: 'Sua localização'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Adiciona marcadores das floriculturas
    for (var floricultura in _floriculturas) {
      _markers.add(
        Marker(
          markerId: MarkerId(floricultura.id),
          position: LatLng(floricultura.latitude, floricultura.longitude),
          infoWindow: InfoWindow(
            title: floricultura.nome,
            snippet: '${floricultura.distancia} km - ${floricultura.status}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            floricultura.status == 'Open' 
                ? BitmapDescriptor.hueGreen 
                : BitmapDescriptor.hueRed,
          ),
        ),
      );
    }

    setState(() {});
  }

  /// Constrói a barra de abas customizada
  Widget _buildCustomTabBar() {
    return Container(
      width: double.infinity,
      height: 43,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: MetamorfoseColors.greyLightest2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 0;
                });
              },
              child: Container(
                height: 35,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: _selectedTabIndex == 0
                    ? ShapeDecoration(
                        color: MetamorfoseColors.whiteLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: MetamorfoseColors.shadowLight,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      )
                    : null,
                child: Center(
                  child: Text(
                    'Mapa',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectedTabIndex == 0 
                          ? MetamorfoseColors.greyMedium 
                          : MetamorfoseColors.greyLight,
                      fontSize: 16,
                      fontFamily: 'DIN Next for Duolingo',
                      fontWeight: _selectedTabIndex == 0 
                          ? FontWeight.w700 
                          : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTabIndex = 1;
                });
              },
              child: Container(
                height: 35,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: _selectedTabIndex == 1
                    ? ShapeDecoration(
                        color: MetamorfoseColors.whiteLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: MetamorfoseColors.shadowLight,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          )
                        ],
                      )
                    : null,
                child: Center(
                  child: Text(
                    'Lista',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectedTabIndex == 1 
                          ? MetamorfoseColors.greyMedium 
                          : MetamorfoseColors.greyLight,
                      fontSize: 16,
                      fontFamily: 'DIN Next for Duolingo',
                      fontWeight: _selectedTabIndex == 1 
                          ? FontWeight.w700 
                          : FontWeight.w400,
                      height: 1.40,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói a barra de pesquisa
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Container(
        height: 48,
        decoration: ShapeDecoration(
          color: MetamorfoseColors.whiteLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
            BoxShadow(
              color: MetamorfoseColors.shadowLight,
              blurRadius: 4,
              offset: Offset(0, 2),
              spreadRadius: 0,
            )
          ],
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.text,
          enableSuggestions: false,
          autocorrect: false,
          maxLines: 1,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              _searchFloriculturas(value.trim());
              _searchFocusNode.unfocus(); // Remove o foco após buscar
            }
          },
          onTap: () {
            // Otimização: Força foco único
            if (!_searchFocusNode.hasFocus) {
              _searchFocusNode.requestFocus();
            }
          },
          decoration: InputDecoration(
            hintText: 'Buscar floriculturas...',
            hintStyle: const TextStyle(
              color: MetamorfoseColors.greyLight,
              fontSize: 16,
              fontFamily: 'DIN Next for Duolingo',
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: _isSearching
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          MetamorfoseColors.purpleNormal,
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: SvgPicture.asset(
                      'assets/images/search.svg',
                      width: 16,
                      height: 16,
                    ),
                  ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: MetamorfoseColors.greyMedium,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchResults = [];
                      });
                      _createMarkers(); // Volta aos marcadores originais
                    },
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: MetamorfoseColors.purpleNormal,
                    ),
                    onPressed: () {
                      if (_searchController.text.trim().isNotEmpty) {
                        _searchFloriculturas(_searchController.text.trim());
                      }
                    },
                  ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          style: const TextStyle(
            color: MetamorfoseColors.blackNormal,
            fontSize: 16,
            fontFamily: 'DIN Next for Duolingo',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  /// Constrói a visualização do mapa
  Widget _buildMapView() {
    if (_isLoadingLocation) {
      return const Center(
        child: CircularProgressIndicator(
          color: MetamorfoseColors.purpleNormal,
        ),
      );
    }

    if (_currentPosition == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off,
              size: 64,
              color: MetamorfoseColors.greyLight,
            ),
            const SizedBox(height: 16),
            const Text(
              'Não foi possível obter sua localização',
              style: TextStyle(
                color: MetamorfoseColors.greyMedium,
                fontSize: 16,
                fontFamily: 'DIN Next for Duolingo',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Verifique as permissões de localização',
              style: TextStyle(
                color: MetamorfoseColors.greyLight,
                fontSize: 14,
                fontFamily: 'DIN Next for Duolingo',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoadingLocation = true;
                });
                _getCurrentLocation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MetamorfoseColors.purpleNormal,
                foregroundColor: MetamorfoseColors.whiteLight,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Tentar Novamente',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'DIN Next for Duolingo',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        setState(() {
          _isMapReady = true;
        });
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        zoom: 14.0,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      // Otimizações de performance
      liteModeEnabled: false,
      trafficEnabled: false,
      buildingsEnabled: false,
      compassEnabled: false,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: false,
      zoomGesturesEnabled: true,
      mapType: MapType.normal,
    );
  }

  /// Constrói um item da lista de floriculturas
  Widget _buildFloriculturaItem(Floricultura floricultura) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: MetamorfoseColors.whiteLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: MetamorfoseColors.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        children: [
          // Ícone da floricultura
          Container(
            width: 48,
            height: 48,
            decoration: const ShapeDecoration(
              color: MetamorfoseColors.purpleLight,
              shape: CircleBorder(),
            ),
            child: const Icon(
              Icons.local_florist,
              color: MetamorfoseColors.whiteLight,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Informações da floricultura
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  floricultura.nome,
                  style: const TextStyle(
                    color: MetamorfoseColors.blackNormal,
                    fontSize: 16,
                    fontFamily: 'DIN Next for Duolingo',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      floricultura.status == 'Open' ? 'Aberto' : 'Fechado',
                      style: TextStyle(
                        color: floricultura.status == 'Open' 
                            ? MetamorfoseColors.greenNormal 
                            : MetamorfoseColors.redNormal,
                        fontSize: 12,
                        fontFamily: 'DIN Next for Duolingo',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${floricultura.distancia} km',
                      style: const TextStyle(
                        color: MetamorfoseColors.greyMedium,
                        fontSize: 12,
                        fontFamily: 'DIN Next for Duolingo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  floricultura.tiposAceitos,
                  style: const TextStyle(
                    color: MetamorfoseColors.greyLight,
                    fontSize: 12,
                    fontFamily: 'DIN Next for Duolingo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói a visualização da lista
  Widget _buildListView() {
    // Decide qual lista mostrar: resultados da busca (limitado a 5) ou lista padrão
    final List<Floricultura> displayList = _searchResults.isNotEmpty 
        ? _searchResults.take(5).toList()
        : _floriculturas;
    
    final String title = _searchResults.isNotEmpty 
        ? 'Resultados da Busca (${_searchResults.length} encontradas)'
        : 'Floriculturas Próximas';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: MetamorfoseColors.blackNormal,
                  fontSize: 20,
                  fontFamily: 'DIN Next for Duolingo',
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (_searchResults.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Mostrando 5 primeiras • ${_searchController.text}',
                  style: const TextStyle(
                    color: MetamorfoseColors.greyMedium,
                    fontSize: 14,
                    fontFamily: 'DIN Next for Duolingo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (displayList.isEmpty && _searchController.text.isNotEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: MetamorfoseColors.greyLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma floricultura encontrada',
                    style: const TextStyle(
                      color: MetamorfoseColors.greyMedium,
                      fontSize: 16,
                      fontFamily: 'DIN Next for Duolingo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tente buscar por outro termo',
                    style: const TextStyle(
                      color: MetamorfoseColors.greyLight,
                      fontSize: 14,
                      fontFamily: 'DIN Next for Duolingo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                return _buildFloriculturaItem(displayList[index]);
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MetamorfoseColors.whiteLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header com botão voltar e título
            Container(
              width: double.infinity,
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/arrow_back.svg',
                      width: 34,
                      height: 34,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Floriculturas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MetamorfoseColors.blackNormal,
                        fontSize: 20,
                        fontFamily: 'DIN Next for Duolingo',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Para balancear o botão voltar
                ],
              ),
            ),
            
            // Barra de pesquisa
            _buildSearchBar(),
            
            // Tab Bar customizado
            _buildCustomTabBar(),
            
            const SizedBox(height: 16),
            
            // Conteúdo baseado na aba selecionada
            Expanded(
              child: _selectedTabIndex == 0 
                  ? _buildMapView() 
                  : _buildListView(),
            ),
          ],
        ),
      ),
    );
  }
}
