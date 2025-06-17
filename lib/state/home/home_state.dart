/**
 * File: home_state.dart
 * Description: Estados para o gerenciamento da tela inicial.
 *
 * Responsabilidades:
 * - Definir estados da UI da home
 * - Gerenciar estado de clima (Weather API)
 * - Gerenciar estado de quotes (Quote API)
 * - Controlar estados de loading e erro
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:conversao_flutter/models/weather.dart';
import 'package:conversao_flutter/models/quote.dart';

/// Enum para estados de operações assíncronas
enum DataState {
  loading,
  success,
  error,
}

/// Estado do clima
class WeatherState {
  final DataState state;
  final Weather? weather;
  final String? errorMessage;

  const WeatherState({
    this.state = DataState.loading,
    this.weather,
    this.errorMessage,
  });

  WeatherState copyWith({
    DataState? state,
    Weather? weather,
    String? errorMessage,
  }) {
    return WeatherState(
      state: state ?? this.state,
      weather: weather ?? this.weather,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoading => state == DataState.loading;
  bool get isSuccess => state == DataState.success;
  bool get isError => state == DataState.error;
  bool get hasWeather => weather != null;
  bool get hasError => errorMessage != null;
}

/// Estado das quotes motivacionais
class QuoteState {
  final DataState state;
  final Quote? quote;
  final String? errorMessage;

  const QuoteState({
    this.state = DataState.loading,
    this.quote,
    this.errorMessage,
  });

  QuoteState copyWith({
    DataState? state,
    Quote? quote,
    String? errorMessage,
  }) {
    return QuoteState(
      state: state ?? this.state,
      quote: quote ?? this.quote,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoading => state == DataState.loading;
  bool get isSuccess => state == DataState.success;
  bool get isError => state == DataState.error;
  bool get hasQuote => quote != null;
  bool get hasError => errorMessage != null;
}

/// Estado principal da home
class HomeState {
  final WeatherState weatherState;
  final QuoteState quoteState;

  const HomeState({
    this.weatherState = const WeatherState(),
    this.quoteState = const QuoteState(),
  });

  HomeState copyWith({
    WeatherState? weatherState,
    QuoteState? quoteState,
  }) {
    return HomeState(
      weatherState: weatherState ?? this.weatherState,
      quoteState: quoteState ?? this.quoteState,
    );
  }

  /// Verifica se há algum carregamento em andamento
  bool get isLoading => weatherState.isLoading || quoteState.isLoading;

  /// Verifica se todos os dados foram carregados com sucesso
  bool get isFullyLoaded => weatherState.isSuccess && quoteState.isSuccess;

  /// Verifica se há algum erro
  bool get hasErrors => weatherState.hasError || quoteState.hasError;
} 