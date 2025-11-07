/**
 * File: home_bloc.dart
 * Description: BLoC para gerenciamento do estado da tela principal
 *
 * Responsabilidades:
 * - Gerenciar carregamento de dados do clima
 * - Gerenciar carregamento de quotes motivacionais
 * - Processar notificações de boas-vindas
 * - Coordenar estados de loading e erro
 *
 * Author: Gabriel Teixeira
 * Created on: 30-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/state/home/home_state.dart';
import 'package:metamorfose_flutter/services/home_service.dart';

/// Eventos do HomeBloc
abstract class HomeEvent {}

/// Evento para inicializar a tela
class InitializeHomeEvent extends HomeEvent {}

/// Evento para carregar dados do clima
class LoadWeatherEvent extends HomeEvent {}

/// Evento para carregar quote do dia
class LoadQuoteEvent extends HomeEvent {}

/// Evento para mostrar notificação de boas-vindas
class ShowWelcomeNotificationEvent extends HomeEvent {}

/// Evento para recarregar todos os dados
class RefreshHomeDataEvent extends HomeEvent {}

/// Evento para limpar erros
class ClearErrorEvent extends HomeEvent {}

/// BLoC para a tela principal
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeService _service;

  HomeBloc({HomeService? service})
      : _service = service ?? HomeService(),
        super(const HomeState()) {
    
    on<InitializeHomeEvent>(_onInitialize);
    on<LoadWeatherEvent>(_onLoadWeather);
    on<LoadQuoteEvent>(_onLoadQuote);
    on<ShowWelcomeNotificationEvent>(_onShowWelcomeNotification);
    on<RefreshHomeDataEvent>(_onRefreshHomeData);
    on<ClearErrorEvent>(_onClearError);
  }

  /// Inicializa a tela carregando todos os dados
  Future<void> _onInitialize(
    InitializeHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Iniciar carregamento paralelo
      add(LoadWeatherEvent());
      add(LoadQuoteEvent());
      
      // Mostrar notificação de boas-vindas após um delay
      Future.delayed(const Duration(milliseconds: 1500), () {
        add(ShowWelcomeNotificationEvent());
      });
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Erro ao inicializar tela principal',
      ));
    }
  }

  /// Carrega dados do clima
  Future<void> _onLoadWeather(
    LoadWeatherEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Iniciar carregamento
      emit(state.copyWith(
        weatherLoadingState: LoadingState.loading,
        weatherError: null,
      ));

      // Carregar dados do clima
      final weather = await _service.loadWeatherData();
      
      emit(state.copyWith(
        weatherLoadingState: LoadingState.success,
        weather: weather,
        weatherError: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        weatherLoadingState: LoadingState.error,
        weatherError: e.toString(),
      ));
    }
  }

  /// Carrega quote do dia
  Future<void> _onLoadQuote(
    LoadQuoteEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // Iniciar carregamento
      emit(state.copyWith(
        quoteLoadingState: LoadingState.loading,
        quoteError: null,
      ));

      // Carregar quote
      final quote = await _service.loadQuoteData();
      
      emit(state.copyWith(
        quoteLoadingState: LoadingState.success,
        quote: quote,
        quoteError: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        quoteLoadingState: LoadingState.error,
        quoteError: e.toString(),
      ));
    }
  }

  /// Mostra notificação de boas-vindas
  Future<void> _onShowWelcomeNotification(
    ShowWelcomeNotificationEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      // A chamada para a notificação de boas-vindas foi removida
      // pois essa lógica agora é gerenciada de forma centralizada.
      // await _service.showWelcomeNotification();
    } catch (e) {
      debugPrint('❌ Erro ao mostrar notificação de boas-vindas: $e');
      // Não emitir erro para não atrapalhar a UX
    }
  }

  /// Recarrega todos os dados
  Future<void> _onRefreshHomeData(
    RefreshHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    // Recarregar dados em paralelo
    add(LoadWeatherEvent());
    add(LoadQuoteEvent());
  }

  /// Limpa erros do estado
  Future<void> _onClearError(
    ClearErrorEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(errorMessage: null));
  }
} 