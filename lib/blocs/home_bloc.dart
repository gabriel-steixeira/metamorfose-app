/**
 * File: home_bloc.dart
 * Description: BLoC para gerenciamento do estado da tela inicial.
 *
 * Responsabilidades:
 * - Gerenciar carregamento de dados iniciais
 * - Controlar estados de Weather e Quote
 * - Gerenciar refreshs individuais e conjunto
 * - Tratamento de erros e estados de loading
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conversao_flutter/state/home/home_state.dart';
import 'package:conversao_flutter/services/home_service.dart';

/// Eventos do HomeBloc
abstract class HomeEvent {}

/// Evento para carregar dados iniciais
class HomeLoadDataEvent extends HomeEvent {}

/// Evento para recarregar apenas o clima
class HomeRefreshWeatherEvent extends HomeEvent {}

/// Evento para recarregar apenas a quote
class HomeRefreshQuoteEvent extends HomeEvent {}

/// Evento para recarregar todos os dados
class HomeRefreshAllEvent extends HomeEvent {}

/// BLoC para gerenciamento da tela inicial
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeService _homeService;

  HomeBloc(this._homeService) : super(const HomeState()) {
    on<HomeLoadDataEvent>(_onLoadData);
    on<HomeRefreshWeatherEvent>(_onRefreshWeather);
    on<HomeRefreshQuoteEvent>(_onRefreshQuote);
    on<HomeRefreshAllEvent>(_onRefreshAll);
  }

  /// Handler para carregar dados iniciais
  void _onLoadData(HomeLoadDataEvent event, Emitter<HomeState> emit) async {
    // Inicia loading para ambos
    emit(state.copyWith(
      weatherState: state.weatherState.copyWith(
        state: DataState.loading,
        errorMessage: null,
      ),
      quoteState: state.quoteState.copyWith(
        state: DataState.loading,
        errorMessage: null,
      ),
    ));

    // Busca dados em paralelo
    final result = await _homeService.fetchAllData();

    // Processa resultado do clima
    final newWeatherState = result.weatherResult.success
        ? state.weatherState.copyWith(
            state: DataState.success,
            weather: result.weatherResult.weather,
            errorMessage: null,
          )
        : state.weatherState.copyWith(
            state: DataState.error,
            errorMessage: result.weatherResult.errorMessage,
          );

    // Processa resultado da quote
    final newQuoteState = result.quoteResult.success
        ? state.quoteState.copyWith(
            state: DataState.success,
            quote: result.quoteResult.quote,
            errorMessage: null,
          )
        : state.quoteState.copyWith(
            state: DataState.error,
            errorMessage: result.quoteResult.errorMessage,
          );

    // Emite novo estado
    emit(state.copyWith(
      weatherState: newWeatherState,
      quoteState: newQuoteState,
    ));
  }

  /// Handler para recarregar apenas o clima
  void _onRefreshWeather(HomeRefreshWeatherEvent event, Emitter<HomeState> emit) async {
    // Inicia loading apenas para weather
    emit(state.copyWith(
      weatherState: state.weatherState.copyWith(
        state: DataState.loading,
        errorMessage: null,
      ),
    ));

    // Busca dados do clima
    final result = await _homeService.refreshWeather();

    // Processa resultado
    final newWeatherState = result.success
        ? state.weatherState.copyWith(
            state: DataState.success,
            weather: result.weather,
            errorMessage: null,
          )
        : state.weatherState.copyWith(
            state: DataState.error,
            errorMessage: result.errorMessage,
          );

    // Emite novo estado
    emit(state.copyWith(weatherState: newWeatherState));
  }

  /// Handler para recarregar apenas a quote
  void _onRefreshQuote(HomeRefreshQuoteEvent event, Emitter<HomeState> emit) async {
    // Inicia loading apenas para quote
    emit(state.copyWith(
      quoteState: state.quoteState.copyWith(
        state: DataState.loading,
        errorMessage: null,
      ),
    ));

    // Busca quote
    final result = await _homeService.refreshQuote();

    // Processa resultado
    final newQuoteState = result.success
        ? state.quoteState.copyWith(
            state: DataState.success,
            quote: result.quote,
            errorMessage: null,
          )
        : state.quoteState.copyWith(
            state: DataState.error,
            errorMessage: result.errorMessage,
          );

    // Emite novo estado
    emit(state.copyWith(quoteState: newQuoteState));
  }

  /// Handler para recarregar todos os dados
  void _onRefreshAll(HomeRefreshAllEvent event, Emitter<HomeState> emit) async {
    // Inicia loading para ambos
    emit(state.copyWith(
      weatherState: state.weatherState.copyWith(
        state: DataState.loading,
        errorMessage: null,
      ),
      quoteState: state.quoteState.copyWith(
        state: DataState.loading,
        errorMessage: null,
      ),
    ));

    // Busca todos os dados em paralelo
    final result = await _homeService.refreshAllData();

    // Processa resultado do clima
    final newWeatherState = result.weatherResult.success
        ? state.weatherState.copyWith(
            state: DataState.success,
            weather: result.weatherResult.weather,
            errorMessage: null,
          )
        : state.weatherState.copyWith(
            state: DataState.error,
            errorMessage: result.weatherResult.errorMessage,
          );

    // Processa resultado da quote
    final newQuoteState = result.quoteResult.success
        ? state.quoteState.copyWith(
            state: DataState.success,
            quote: result.quoteResult.quote,
            errorMessage: null,
          )
        : state.quoteState.copyWith(
            state: DataState.error,
            errorMessage: result.quoteResult.errorMessage,
          );

    // Emite novo estado
    emit(state.copyWith(
      weatherState: newWeatherState,
      quoteState: newQuoteState,
    ));
  }

  @override
  Future<void> close() {
    _homeService.dispose();
    return super.close();
  }
} 