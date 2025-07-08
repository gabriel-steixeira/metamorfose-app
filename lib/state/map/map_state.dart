/**
 * File: map_state.dart
 * Description: Estados para o gerenciamento da tela de mapa.
 *
 * Responsabilidades:
 * - Definir estados da UI do mapa
 * - Gerenciar estado de localização
 * - Controlar estados de busca e loading
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Enum para os tabs do mapa
enum MapTabIndex {
  map,
  list;

  int get value {
    switch (this) {
      case MapTabIndex.map:
        return 0;
      case MapTabIndex.list:
        return 1;
    }
  }
}

/// Estado da localização do usuário
class LocationState {
  final Position? position;
  final bool isLoading;
  final String? errorMessage;
  final LocationPermission? permission;
  final bool shouldShowError; // Nova propriedade

  const LocationState({
    this.isLoading = true,
    this.position,
    this.permission,
    this.errorMessage,
    this.shouldShowError = true, // Valor padrão
  });

  LocationState copyWith({
    bool? isLoading,
    Position? position,
    LocationPermission? permission,
    String? errorMessage,
    bool? shouldShowError,
  }) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      position: position ?? this.position,
      permission: permission ?? this.permission,
      errorMessage: errorMessage, // Permitir que seja nulo
      shouldShowError: shouldShowError ?? this.shouldShowError,
    );
  }

  bool get hasPosition => position != null;
  bool get hasError => errorMessage != null;
}

/// Estado de busca de floriculturas
class SearchState {
  final List<Floricultura> nearbyResults;
  final List<Floricultura> searchResults;
  final bool isSearching;
  final String? errorMessage;
  final String currentQuery;

  const SearchState({
    this.nearbyResults = const [],
    this.searchResults = const [],
    this.isSearching = false,
    this.errorMessage,
    this.currentQuery = '',
  });

  SearchState copyWith({
    List<Floricultura>? nearbyResults,
    List<Floricultura>? searchResults,
    bool? isSearching,
    String? errorMessage,
    String? currentQuery,
  }) {
    return SearchState(
      nearbyResults: nearbyResults ?? this.nearbyResults,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: errorMessage ?? this.errorMessage,
      currentQuery: currentQuery ?? this.currentQuery,
    );
  }

  bool get hasResults => nearbyResults.isNotEmpty || searchResults.isNotEmpty;
  bool get hasError => errorMessage != null;
  List<Floricultura> get displayResults => 
    currentQuery.isEmpty ? nearbyResults : searchResults;
}

/// Estado do mapa GoogleMaps
class GoogleMapState {
  final GoogleMapController? controller;
  final Set<Marker> markers;
  final bool isReady;
  final CameraPosition? initialPosition;

  const GoogleMapState({
    this.controller,
    this.markers = const {},
    this.isReady = false,
    this.initialPosition,
  });

  GoogleMapState copyWith({
    GoogleMapController? controller,
    Set<Marker>? markers,
    bool? isReady,
    CameraPosition? initialPosition,
  }) {
    return GoogleMapState(
      controller: controller ?? this.controller,
      markers: markers ?? this.markers,
      isReady: isReady ?? this.isReady,
      initialPosition: initialPosition ?? this.initialPosition,
    );
  }

  bool get hasController => controller != null;
}

/// Estado principal do mapa
class MapState {
  final MapTabIndex selectedTab;
  final LocationState locationState;
  final SearchState searchState;
  final GoogleMapState mapState;

  const MapState({
    this.selectedTab = MapTabIndex.map,
    this.locationState = const LocationState(),
    this.searchState = const SearchState(),
    this.mapState = const GoogleMapState(),
  });

  MapState copyWith({
    MapTabIndex? selectedTab,
    LocationState? locationState,
    SearchState? searchState,
    GoogleMapState? mapState,
  }) {
    return MapState(
      selectedTab: selectedTab ?? this.selectedTab,
      locationState: locationState ?? this.locationState,
      searchState: searchState ?? this.searchState,
      mapState: mapState ?? this.mapState,
    );
  }
}

/// Modelo para Floricultura (movido da tela)
class Floricultura {
  final String id;
  final String nome;
  final String endereco;
  final double distancia;
  final String status;
  final String tiposAceitos;
  final double latitude;
  final double longitude;

  const Floricultura({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.distancia,
    required this.status,
    required this.tiposAceitos,
    required this.latitude,
    required this.longitude,
  });

  bool get isOpen => status.toLowerCase() == 'open';
} 