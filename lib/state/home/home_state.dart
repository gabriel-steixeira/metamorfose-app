/**
 * File: home_state.dart
 * Description: Estado da tela principal do Metamorfose
 *
 * Responsabilidades:
 * - Gerenciar estado do clima
 * - Gerenciar estado das mensagens do dia
 * - Controlar carregamento e erros
 *
 * Author: Gabriel Teixeira
 * Created on: 30-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:conversao_flutter/models/weather.dart';
import 'package:conversao_flutter/models/quote.dart';

/// Estado de carregamento
enum LoadingState {
  idle,
  loading,
  success,
  error
}

/// Estado da tela principal
class HomeState {
  final LoadingState weatherLoadingState;
  final LoadingState quoteLoadingState;
  final Weather? weather;
  final Quote? quote;
  final String? weatherError;
  final String? quoteError;
  final String? errorMessage;

  const HomeState({
    this.weatherLoadingState = LoadingState.idle,
    this.quoteLoadingState = LoadingState.idle,
    this.weather,
    this.quote,
    this.weatherError,
    this.quoteError,
    this.errorMessage,
  });

  /// Copia o estado com novos valores
  HomeState copyWith({
    LoadingState? weatherLoadingState,
    LoadingState? quoteLoadingState,
    Weather? weather,
    Quote? quote,
    String? weatherError,
    String? quoteError,
    String? errorMessage,
  }) {
    return HomeState(
      weatherLoadingState: weatherLoadingState ?? this.weatherLoadingState,
      quoteLoadingState: quoteLoadingState ?? this.quoteLoadingState,
      weather: weather ?? this.weather,
      quote: quote ?? this.quote,
      weatherError: weatherError ?? this.weatherError,
      quoteError: quoteError ?? this.quoteError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Getters de conveniência
  bool get hasError => errorMessage != null;
  bool get isWeatherLoading => weatherLoadingState == LoadingState.loading;
  bool get isQuoteLoading => quoteLoadingState == LoadingState.loading;
  bool get isLoading => isWeatherLoading || isQuoteLoading;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomeState &&
      other.weatherLoadingState == weatherLoadingState &&
      other.quoteLoadingState == quoteLoadingState &&
      other.weather == weather &&
      other.quote == quote &&
      other.weatherError == weatherError &&
      other.quoteError == quoteError &&
      other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return weatherLoadingState.hashCode ^
      quoteLoadingState.hashCode ^
      weather.hashCode ^
      quote.hashCode ^
      weatherError.hashCode ^
      quoteError.hashCode ^
      errorMessage.hashCode;
  }

  @override
  String toString() {
    return 'HomeState(weatherState: $weatherLoadingState, quoteState: $quoteLoadingState, weather: $weather, quote: $quote, weatherError: $weatherError, quoteError: $quoteError, error: $errorMessage)';
  }
} 