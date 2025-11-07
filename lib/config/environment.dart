/**
 * File: environment.dart
 * Description: Configurações de ambiente para o aplicativo Metamorfose.
 *
 * Responsabilidades:
 * - Centralizar todas as configurações sensíveis
 * - Fornecer acesso seguro às API keys
 * - Gerenciar diferentes ambientes (dev, prod)
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

class Environment {
  // API Key diretamente configurada (para desenvolvimento)
  static const String _googleMapsApiKey = 'AIzaSyD2DQAH9nE9Q-IFLNyvv7-X8Vwrw_cEWlk';

  // Para produção, use variáveis de ambiente:
  // static const String _googleMapsApiKey = String.fromEnvironment(
  //   'GOOGLE_MAPS_API_KEY',
  //   defaultValue: '',
  // );

  static const String _googlePlacesApiKey = String.fromEnvironment(
    'GOOGLE_PLACES_API_KEY', 
    defaultValue: '',
  );

  static const String _paperQuotesApiKey = String.fromEnvironment(
    'PAPER_QUOTES_API_KEY',
    defaultValue: '',
  );

  static const String _openMeteoApiKey = String.fromEnvironment(
    'OPEN_METEO_API_KEY',
    defaultValue: '',
  );

  /// API Key para Google Maps
  static String get googleMapsApiKey {
    if (_googleMapsApiKey.isEmpty) {
      throw Exception('GOOGLE_MAPS_API_KEY não foi configurada! Verifique as variáveis de ambiente.');
    }
    return _googleMapsApiKey;
  }

  /// API Key para Google Places
  static String get googlePlacesApiKey {
    if (_googlePlacesApiKey.isNotEmpty) {
      return _googlePlacesApiKey;
    }
    // Fallback para usar a mesma key do Maps se Places não estiver configurada
    return googleMapsApiKey;
  }

  /// API Key para Paper Quotes (se necessário)
  static String get paperQuotesApiKey => _paperQuotesApiKey;

  /// API Key para Open Meteo (se necessário) 
  static String get openMeteoApiKey => _openMeteoApiKey;

  /// Verifica se todas as keys obrigatórias estão configuradas
  static bool get areRequiredKeysConfigured {
    return _googleMapsApiKey.isNotEmpty;
  }

  /// Retorna informações sobre o ambiente atual (para debug)
  static Map<String, dynamic> get environmentInfo {
    return {
      'hasGoogleMapsKey': _googleMapsApiKey.isNotEmpty,
      'hasGooglePlacesKey': _googlePlacesApiKey.isNotEmpty,
      'hasPaperQuotesKey': _paperQuotesApiKey.isNotEmpty,
      'hasOpenMeteoKey': _openMeteoApiKey.isNotEmpty,
    };
  }
} 