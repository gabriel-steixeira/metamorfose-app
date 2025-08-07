/**
 * File: plant_care_bloc.dart
 * Description: BLoC para gerenciamento do estado da tela de cuidados da planta
 *
 * Responsabilidades:
 * - Gerenciar informações da planta
 * - Gerenciar carregamento de fotos do diário visual
 * - Gerenciar tarefas do dia
 * - Coordenar estados de loading e erro
 *
 * Author: Evelin Cordeiro
 * Created on: 06-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/state/plant_care/plant_care_state.dart';
import 'package:metamorfose_flutter/services/plant_care_service.dart';

/// Eventos do PlantCareBloc
abstract class PlantCareEvent {}

/// Evento para inicializar a tela
class InitializePlantCareEvent extends PlantCareEvent {}

/// Evento para carregar informações da planta
class LoadPlantInfoEvent extends PlantCareEvent {}

/// Evento para carregar fotos do diário visual
class LoadVisualDiaryEvent extends PlantCareEvent {}

/// Evento para carregar tarefas do dia
class LoadTodayTasksEvent extends PlantCareEvent {}

/// Evento para tirar nova foto
class TakeNewPhotoEvent extends PlantCareEvent {}

/// Evento para compartilhar progresso
class ShareProgressEvent extends PlantCareEvent {}

/// Evento para limpar erros
class ClearErrorEvent extends PlantCareEvent {}

/// BLoC para a tela de cuidados da planta
class PlantCareBloc extends Bloc<PlantCareEvent, PlantCareState> {
  final PlantCareService _service;

  PlantCareBloc({PlantCareService? service})
      : _service = service ?? PlantCareService(),
        super(const PlantCareState()) {
    on<InitializePlantCareEvent>(_onInitialize);
    on<LoadPlantInfoEvent>(_onLoadPlantInfo);
    on<LoadVisualDiaryEvent>(_onLoadVisualDiary);
    on<LoadTodayTasksEvent>(_onLoadTodayTasks);
    on<TakeNewPhotoEvent>(_onTakeNewPhoto);
    on<ShareProgressEvent>(_onShareProgress);
    on<ClearErrorEvent>(_onClearError);
  }

  /// Inicializa a tela carregando todos os dados
  Future<void> _onInitialize(
    InitializePlantCareEvent event,
    Emitter<PlantCareState> emit,
  ) async {
    try {
      // Carregar dados em paralelo
      add(LoadPlantInfoEvent());
      add(LoadVisualDiaryEvent());
      add(LoadTodayTasksEvent());
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Erro ao inicializar tela de cuidados da planta',
      ));
    }
  }

  /// Carrega informações da planta
  Future<void> _onLoadPlantInfo(
    LoadPlantInfoEvent event,
    Emitter<PlantCareState> emit,
  ) async {
    try {
      emit(state.copyWith(
        plantInfoLoadingState: LoadingState.loading,
        plantInfoError: null,
      ));

      final plantInfo = await _service.loadPlantInfo();

      emit(state.copyWith(
        plantInfoLoadingState: LoadingState.success,
        plantInfo: plantInfo,
        plantInfoError: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        plantInfoLoadingState: LoadingState.error,
        plantInfoError: e.toString(),
      ));
    }
  }

  /// Carrega fotos do diário visual
  Future<void> _onLoadVisualDiary(
    LoadVisualDiaryEvent event,
    Emitter<PlantCareState> emit,
  ) async {
    try {
      emit(state.copyWith(
        visualDiaryLoadingState: LoadingState.loading,
        visualDiaryError: null,
      ));

      final photos = await _service.loadVisualDiary();

      emit(state.copyWith(
        visualDiaryLoadingState: LoadingState.success,
        visualDiaryPhotos: photos,
        visualDiaryError: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        visualDiaryLoadingState: LoadingState.error,
        visualDiaryError: e.toString(),
      ));
    }
  }

  /// Carrega tarefas do dia
  Future<void> _onLoadTodayTasks(
    LoadTodayTasksEvent event,
    Emitter<PlantCareState> emit,
  ) async {
    try {
      emit(state.copyWith(
        todayTasksLoadingState: LoadingState.loading,
        todayTasksError: null,
      ));

      final tasks = await _service.loadTodayTasks();

      emit(state.copyWith(
        todayTasksLoadingState: LoadingState.success,
        todayTasks: tasks,
        todayTasksError: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        todayTasksLoadingState: LoadingState.error,
        todayTasksError: e.toString(),
      ));
    }
  }

  /// Tira nova foto
  Future<void> _onTakeNewPhoto(
    TakeNewPhotoEvent event,
    Emitter<PlantCareState> emit,
  ) async {
    try {
      emit(state.copyWith(isTakingPhoto: true));

      final success = await _service.takeNewPhoto();

      if (success) {
        // Recarregar fotos do diário visual
        add(LoadVisualDiaryEvent());
      }

      emit(state.copyWith(isTakingPhoto: false));
    } catch (e) {
      emit(state.copyWith(
        isTakingPhoto: false,
        errorMessage: 'Erro ao tirar foto: ${e.toString()}',
      ));
    }
  }

  /// Compartilha progresso
  Future<void> _onShareProgress(
    ShareProgressEvent event,
    Emitter<PlantCareState> emit,
  ) async {
    try {
      emit(state.copyWith(isSharingProgress: true));

      final success = await _service.shareProgress();

      emit(state.copyWith(isSharingProgress: false));

      if (success) {
        // Mostrar mensagem de sucesso
        emit(state.copyWith(
          successMessage: 'Progresso compartilhado com sucesso!',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isSharingProgress: false,
        errorMessage: 'Erro ao compartilhar progresso: ${e.toString()}',
      ));
    }
  }

  /// Limpa erros do estado
  Future<void> _onClearError(
    ClearErrorEvent event,
    Emitter<PlantCareState> emit,
  ) async {
    emit(state.copyWith(
      errorMessage: null,
      successMessage: null,
    ));
  }
}
