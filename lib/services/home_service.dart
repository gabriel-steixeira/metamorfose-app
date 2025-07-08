/**
 * File: home_service.dart
 * Description: Serviço para gerenciamento de dados da tela inicial.
 *
 * Responsabilidades:
 * - Gerenciar API de clima (Weather)
 * - Gerenciar API de quotes motivacionais
 * - Gerenciar notificações de boas-vindas
 * - Centralizar lógica de chamadas assíncronas
 * - Tratamento de erros e fallbacks
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:async';
import 'package:conversao_flutter/models/weather.dart';
import 'package:conversao_flutter/models/quote.dart';
import 'package:conversao_flutter/services/notification_service.dart';

/// Resultado de uma operação de clima
class WeatherResult {
  final bool success;
  final Weather? weather;
  final String? errorMessage;

  WeatherResult({
    required this.success,
    this.weather,
    this.errorMessage,
  });

  factory WeatherResult.success(Weather weather) {
    return WeatherResult(
      success: true,
      weather: weather,
    );
  }

  factory WeatherResult.error(String message) {
    return WeatherResult(
      success: false,
      errorMessage: message,
    );
  }
}

/// Resultado de uma operação de quote
class QuoteResult {
  final bool success;
  final Quote? quote;
  final String? errorMessage;

  QuoteResult({
    required this.success,
    this.quote,
    this.errorMessage,
  });

  factory QuoteResult.success(Quote quote) {
    return QuoteResult(
      success: true,
      quote: quote,
    );
  }

  factory QuoteResult.error(String message) {
    return QuoteResult(
      success: false,
      errorMessage: message,
    );
  }
}

/// Resultado combinado de ambas as operações
class HomeDataResult {
  final WeatherResult weatherResult;
  final QuoteResult quoteResult;

  HomeDataResult({
    required this.weatherResult,
    required this.quoteResult,
  });
}

/// Serviço para gerenciamento de dados da home
class HomeService {
  final NotificationService _notificationService;

  HomeService({NotificationService? notificationService})
      : _notificationService = notificationService ?? NotificationService();

  /// Carrega dados do clima (método esperado pelo BLoC)
  Future<Weather> loadWeatherData() async {
    try {
      return await Weather.fetchWeatherWithLocation();
    } catch (e) {
      throw Exception('Erro ao carregar clima: $e');
    }
  }

  /// Carrega quote do dia (método esperado pelo BLoC)
  Future<Quote> loadQuoteData() async {
    try {
      return await Quote.fetchQuote();
    } catch (e) {
      throw Exception('Erro ao carregar mensagem: $e');
    }
  }

  // O método `showWelcomeNotification` foi removido pois a lógica de notificação
  // agora é gerenciada centralmente pelo `NotificationService` com Firebase
  // e não deve ser disparada manualmente a partir de outros serviços.

  /// Busca dados do clima (método legado - mantido para compatibilidade)
  Future<WeatherResult> fetchWeather() async {
    try {
      final weather = await loadWeatherData();
      return WeatherResult.success(weather);
    } catch (e) {
      return WeatherResult.error(e.toString());
    }
  }

  /// Busca quote motivacional (método legado - mantido para compatibilidade)
  Future<QuoteResult> fetchQuote() async {
    try {
      final quote = await loadQuoteData();
      return QuoteResult.success(quote);
    } catch (e) {
      return QuoteResult.error(e.toString());
    }
  }

  /// Busca ambos os dados em paralelo
  Future<HomeDataResult> fetchAllData() async {
    final results = await Future.wait([
      fetchWeather(),
      fetchQuote(),
    ]);

    return HomeDataResult(
      weatherResult: results[0] as WeatherResult,
      quoteResult: results[1] as QuoteResult,
    );
  }

  /// Recarrega apenas os dados do clima
  Future<WeatherResult> refreshWeather() async {
    return fetchWeather();
  }

  /// Recarrega apenas a quote
  Future<QuoteResult> refreshQuote() async {
    return fetchQuote();
  }

  /// Recarrega todos os dados
  Future<HomeDataResult> refreshAllData() async {
    return fetchAllData();
  }

  /// Dispose do service (para futura expansão)
  void dispose() {
    // Placeholder para cleanup se necessário
  }
} 