/**
 * File: map_bloc.dart
 * Description: BLoC para gerenciamento do estado da tela de mapa.
 *
 * Responsabilidades:
 * - Gerenciar localização do usuário
 * - Controlar busca de floriculturas
 * - Gerenciar estados do GoogleMaps
 * - Controlar navegação entre tabs (Mapa/Lista)
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:conversao_flutter/state/map/map_state.dart';
import 'package:conversao_flutter/services/map_service.dart';

/// Eventos do MapBloc
abstract class MapEvent {}

/// Evento para inicializar o mapa (carregar localização)
class MapInitializeEvent extends MapEvent {}

/// Evento para alternar entre tabs
class MapChangeTabEvent extends MapEvent {
  final MapTabIndex tabIndex;
  MapChangeTabEvent(this.tabIndex);
}

/// Evento para buscar floriculturas próximas
class MapSearchNearbyEvent extends MapEvent {}

/// Evento para buscar floriculturas com termo
class MapSearchWithQueryEvent extends MapEvent {
  final String query;
  MapSearchWithQueryEvent(this.query);
}

/// Evento para limpar busca
class MapClearSearchEvent extends MapEvent {}

/// Evento quando o GoogleMap está pronto
class MapGoogleMapReadyEvent extends MapEvent {
  final GoogleMapController controller;
  MapGoogleMapReadyEvent(this.controller);
}

/// Evento para atualizar marcadores
class MapUpdateMarkersEvent extends MapEvent {}

/// Evento para recarregar localização
class MapReloadLocationEvent extends MapEvent {}

/// BLoC para gerenciamento da tela de mapa
class MapBloc extends Bloc<MapEvent, MapState> {
  final MapService _mapService;

  MapBloc(this._mapService) : super(const MapState()) {
    on<MapInitializeEvent>(_onInitialize);
    on<MapChangeTabEvent>(_onChangeTab);
    on<MapSearchNearbyEvent>(_onSearchNearby);
    on<MapSearchWithQueryEvent>(_onSearchWithQuery);
    on<MapClearSearchEvent>(_onClearSearch);
    on<MapGoogleMapReadyEvent>(_onGoogleMapReady);
    on<MapUpdateMarkersEvent>(_onUpdateMarkers);
    on<MapReloadLocationEvent>(_onReloadLocation);
  }

  /// Handler para inicializar o mapa
  void _onInitialize(MapInitializeEvent event, Emitter<MapState> emit) async {
    // Inicia o loading da localização
    emit(state.copyWith(
      locationState: state.locationState.copyWith(isLoading: true),
    ));

    // Obtém a localização
    final locationResult = await _mapService.getCurrentLocation();

    if (locationResult.success && locationResult.position != null) {
      final newLocationState = state.locationState.copyWith(
        isLoading: false,
        position: locationResult.position,
        permission: locationResult.permission,
        errorMessage: null,
      );

      emit(state.copyWith(locationState: newLocationState));

      // Busca floriculturas próximas automaticamente
      add(MapSearchNearbyEvent());
    } else {
      final newLocationState = state.locationState.copyWith(
        isLoading: false,
        errorMessage: locationResult.errorMessage,
        permission: locationResult.permission,
      );

      emit(state.copyWith(locationState: newLocationState));
    }
  }

  /// Handler para alterar tab
  void _onChangeTab(MapChangeTabEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(selectedTab: event.tabIndex));
  }

  /// Handler para buscar floriculturas próximas
  void _onSearchNearby(MapSearchNearbyEvent event, Emitter<MapState> emit) async {
    if (state.locationState.position == null) return;

    // Inicia loading da busca
    final newSearchState = state.searchState.copyWith(
      isSearching: true,
      errorMessage: null,
    );
    emit(state.copyWith(searchState: newSearchState));

    // Executa busca
    final searchResult = await _mapService.searchNearbyFloriculturas(
      state.locationState.position!,
    );

    if (searchResult.success) {
      final updatedSearchState = state.searchState.copyWith(
        isSearching: false,
        nearbyResults: searchResult.floriculturas,
        errorMessage: null,
      );

      emit(state.copyWith(searchState: updatedSearchState));

      // Atualiza marcadores
      add(MapUpdateMarkersEvent());
    } else {
      final errorSearchState = state.searchState.copyWith(
        isSearching: false,
        errorMessage: searchResult.errorMessage,
      );

      emit(state.copyWith(searchState: errorSearchState));
    }
  }

  /// Handler para buscar com termo específico
  void _onSearchWithQuery(MapSearchWithQueryEvent event, Emitter<MapState> emit) async {
    if (state.locationState.position == null) return;

    // Se query está vazia, limpa resultados de busca
    if (event.query.isEmpty) {
      final clearedSearchState = state.searchState.copyWith(
        searchResults: [],
        currentQuery: '',
        errorMessage: null,
      );
      emit(state.copyWith(searchState: clearedSearchState));
      add(MapUpdateMarkersEvent());
      return;
    }

    // Inicia loading da busca
    final newSearchState = state.searchState.copyWith(
      isSearching: true,
      currentQuery: event.query,
      errorMessage: null,
    );
    emit(state.copyWith(searchState: newSearchState));

    // Executa busca com termo
    final searchResult = await _mapService.searchFloriculturas(
      state.locationState.position!,
      event.query,
    );

    if (searchResult.success) {
      final updatedSearchState = state.searchState.copyWith(
        isSearching: false,
        searchResults: searchResult.floriculturas,
        errorMessage: null,
      );

      emit(state.copyWith(searchState: updatedSearchState));

      // Atualiza marcadores
      add(MapUpdateMarkersEvent());
    } else {
      final errorSearchState = state.searchState.copyWith(
        isSearching: false,
        errorMessage: searchResult.errorMessage,
      );

      emit(state.copyWith(searchState: errorSearchState));
    }
  }

  /// Handler para limpar busca
  void _onClearSearch(MapClearSearchEvent event, Emitter<MapState> emit) {
    final clearedSearchState = state.searchState.copyWith(
      searchResults: [],
      currentQuery: '',
      errorMessage: null,
    );

    emit(state.copyWith(searchState: clearedSearchState));

    // Atualiza marcadores para mostrar apenas floriculturas próximas
    add(MapUpdateMarkersEvent());
  }

  /// Handler quando GoogleMap está pronto
  void _onGoogleMapReady(MapGoogleMapReadyEvent event, Emitter<MapState> emit) {
    final newMapState = state.mapState.copyWith(
      controller: event.controller,
      isReady: true,
    );

    emit(state.copyWith(mapState: newMapState));

    // Centraliza no usuário se tiver localização
    if (state.locationState.position != null) {
      _centerMapOnUser(event.controller, state.locationState.position!);
    }
  }

  /// Handler para atualizar marcadores
  void _onUpdateMarkers(MapUpdateMarkersEvent event, Emitter<MapState> emit) {
    final floriculturas = state.searchState.displayResults;
    final markers = _mapService.createMarkers(floriculturas);

    final newMapState = state.mapState.copyWith(markers: markers);
    emit(state.copyWith(mapState: newMapState));
  }

  /// Handler para recarregar localização
  void _onReloadLocation(MapReloadLocationEvent event, Emitter<MapState> emit) {
    add(MapInitializeEvent());
  }

  /// Centraliza o mapa na localização do usuário
  void _centerMapOnUser(GoogleMapController controller, position) {
    final cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14.0,
    );

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Future<void> close() {
    _mapService.dispose();
    return super.close();
  }
} 