/**
 * File: map_service_stub.dart
 * Description: Stub para MapServiceWeb em plataformas não-web.
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:metamorfose_flutter/services/map_service.dart';
import 'package:metamorfose_flutter/state/map/map_state.dart';

/// Stub para MapServiceWeb em plataformas não-web
class MapServiceWeb {
  Future<LocationResult> getCurrentLocation() async {
    throw UnsupportedError('MapServiceWeb não é suportado em plataformas não-web');
  }

  Future<SearchResult> searchNearbyFloriculturas(Position position) async {
    throw UnsupportedError('MapServiceWeb não é suportado em plataformas não-web');
  }

  Future<SearchResult> searchFloriculturas(Position position, String query) async {
    throw UnsupportedError('MapServiceWeb não é suportado em plataformas não-web');
  }

  Set<Marker> createMarkers(List<Floricultura> floriculturas) {
    throw UnsupportedError('MapServiceWeb não é suportado em plataformas não-web');
  }
}