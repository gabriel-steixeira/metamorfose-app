/**
 * File: plant_config_bloc.dart
 * Description: BLoC para gerenciamento do estado da configuração da planta
 *
 * Responsabilidades:
 * - Gerenciar estado do formulário de configuração
 * - Processar eventos de entrada do usuário
 * - Validar dados em tempo real
 * - Coordenar navegação e persistência
 *
 * Author: Gabriel Teixeira
 * Created on: 01-01-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:conversao_flutter/state/plant_config/plant_config_state.dart';
import 'package:conversao_flutter/services/plant_config_service.dart';
import 'package:conversao_flutter/theme/colors.dart';

/// Eventos do PlantConfigBloc
abstract class PlantConfigEvent {}

/// Evento para inicializar o formulário
class InitializePlantConfigEvent extends PlantConfigEvent {}

/// Evento para carregar configuração salva
class LoadSavedConfigurationEvent extends PlantConfigEvent {}

/// Evento para atualizar nome da planta
class UpdatePlantNameEvent extends PlantConfigEvent {
  final String name;
  UpdatePlantNameEvent(this.name);
}

/// Evento para selecionar tipo de planta
class SelectPlantTypeEvent extends PlantConfigEvent {
  final String plantType;
  SelectPlantTypeEvent(this.plantType);
}

/// Evento para selecionar cor do vaso
class SelectPlantColorEvent extends PlantConfigEvent {
  final Color color;
  SelectPlantColorEvent(this.color);
}

/// Evento para validar formulário
class ValidateFormEvent extends PlantConfigEvent {}

/// Evento para tirar primeira foto
class TakeFirstPhotoEvent extends PlantConfigEvent {}

/// Evento para ignorar captura de foto
class SkipPhotoEvent extends PlantConfigEvent {}

/// Evento para limpar erros
class ClearErrorEvent extends PlantConfigEvent {}

/// BLoC para configuração da planta
class PlantConfigBloc extends Bloc<PlantConfigEvent, PlantConfigState> {
  final PlantConfigService _service;

  PlantConfigBloc({PlantConfigService? service})
      : _service = service ?? PlantConfigService(),
        super(const PlantConfigState()) {
    
    on<InitializePlantConfigEvent>(_onInitialize);
    on<LoadSavedConfigurationEvent>(_onLoadSavedConfiguration);
    on<UpdatePlantNameEvent>(_onUpdatePlantName);
    on<SelectPlantTypeEvent>(_onSelectPlantType);
    on<SelectPlantColorEvent>(_onSelectPlantColor);
    on<ValidateFormEvent>(_onValidateForm);
    on<TakeFirstPhotoEvent>(_onTakeFirstPhoto);
    on<SkipPhotoEvent>(_onSkipPhoto);
    on<ClearErrorEvent>(_onClearError);
  }

  /// Inicializa o formulário com valores padrão
  Future<void> _onInitialize(
    InitializePlantConfigEvent event,
    Emitter<PlantConfigState> emit,
  ) async {
    try {
      // Inicializar com valores padrão
      const initialState = PlantConfigState(
        plantName: '',
        selectedPlant: 'suculenta',
        selectedColor: MetamorfoseColors.purpleNormal,
        validationState: ValidationState.initial,
        loadingState: LoadingState.idle,
      );

      emit(initialState);

      // Tentar carregar configuração salva
      add(LoadSavedConfigurationEvent());
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Erro ao inicializar formulário',
      ));
    }
  }

  /// Carrega configuração salva se existir
  Future<void> _onLoadSavedConfiguration(
    LoadSavedConfigurationEvent event,
    Emitter<PlantConfigState> emit,
  ) async {
    try {
      final savedConfig = await _service.loadSavedConfiguration();
      
      if (savedConfig != null) {
        emit(savedConfig.copyWith(
          validationState: ValidationState.initial,
          loadingState: LoadingState.idle,
        ));
        
        // Validar formulário carregado
        add(ValidateFormEvent());
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Erro ao carregar configuração salva',
      ));
    }
  }

  /// Atualiza nome da planta e valida
  Future<void> _onUpdatePlantName(
    UpdatePlantNameEvent event,
    Emitter<PlantConfigState> emit,
  ) async {
    emit(state.copyWith(
      plantName: event.name,
      errorMessage: null, // Limpar erro anterior
    ));

    // Validar em tempo real se o usuário já digitou algo
    if (event.name.isNotEmpty) {
      add(ValidateFormEvent());
    }
  }

  /// Seleciona tipo de planta e valida
  Future<void> _onSelectPlantType(
    SelectPlantTypeEvent event,
    Emitter<PlantConfigState> emit,
  ) async {
    emit(state.copyWith(
      selectedPlant: event.plantType,
      errorMessage: null,
    ));

    // Validar após seleção
    add(ValidateFormEvent());
  }

  /// Seleciona cor do vaso e valida
  Future<void> _onSelectPlantColor(
    SelectPlantColorEvent event,
    Emitter<PlantConfigState> emit,
  ) async {
    emit(state.copyWith(
      selectedColor: event.color,
      errorMessage: null,
    ));

    // Validar após seleção
    add(ValidateFormEvent());
  }

  /// Valida todo o formulário
  Future<void> _onValidateForm(
    ValidateFormEvent event,
    Emitter<PlantConfigState> emit,
  ) async {
    try {
      final validation = _service.validateForm(state);
      
      emit(state.copyWith(
        validationState: validation.state,
        errorMessage: validation.error,
      ));
    } catch (e) {
      emit(state.copyWith(
        validationState: ValidationState.invalid,
        errorMessage: 'Erro na validação',
      ));
    }
  }

  /// Processa captura da primeira foto
  Future<void> _onTakeFirstPhoto(
    TakeFirstPhotoEvent event,
    Emitter<PlantConfigState> emit,
  ) async {
    if (!state.canSave) {
      emit(state.copyWith(
        errorMessage: 'Complete o formulário antes de continuar',
      ));
      return;
    }

    try {
      // Iniciar processo de salvamento
      emit(state.copyWith(
        loadingState: LoadingState.saving,
        errorMessage: null,
      ));

      // Salvar configuração primeiro
      final saveResult = await _service.savePlantConfiguration(state);
      
      if (!saveResult.success) {
        emit(state.copyWith(
          loadingState: LoadingState.idle,
          errorMessage: saveResult.error,
        ));
        return;
      }

      // Processar captura de foto
      emit(state.copyWith(
        loadingState: LoadingState.navigating,
      ));

      final photoResult = await _service.captureFirstPhoto();
      
      if (photoResult.success) {
        // Sucesso - a navegação será tratada pela UI
        emit(state.copyWith(
          loadingState: LoadingState.idle,
        ));
      } else {
        emit(state.copyWith(
          loadingState: LoadingState.idle,
          errorMessage: photoResult.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        loadingState: LoadingState.idle,
        errorMessage: 'Erro ao processar captura de foto',
      ));
    }
  }

  /// Processa ação de ignorar foto
  Future<void> _onSkipPhoto(
    SkipPhotoEvent event,
    Emitter<PlantConfigState> emit,
  ) async {
    if (!state.canSave) {
      emit(state.copyWith(
        errorMessage: 'Complete o formulário antes de continuar',
      ));
      return;
    }

    try {
      // Iniciar processo de salvamento
      emit(state.copyWith(
        loadingState: LoadingState.saving,
        errorMessage: null,
      ));

      // Salvar configuração
      final saveResult = await _service.savePlantConfiguration(state);
      
      if (!saveResult.success) {
        emit(state.copyWith(
          loadingState: LoadingState.idle,
          errorMessage: saveResult.error,
        ));
        return;
      }

      // Processar skip da foto
      emit(state.copyWith(
        loadingState: LoadingState.navigating,
      ));

      final skipResult = await _service.skipPhotoCapture();
      
      if (skipResult.success) {
        // Sucesso - a navegação será tratada pela UI
        emit(state.copyWith(
          loadingState: LoadingState.idle,
        ));
      } else {
        emit(state.copyWith(
          loadingState: LoadingState.idle,
          errorMessage: skipResult.error,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        loadingState: LoadingState.idle,
        errorMessage: 'Erro ao ignorar captura de foto',
      ));
    }
  }

  /// Limpa erros do estado
  Future<void> _onClearError(
    ClearErrorEvent event,
    Emitter<PlantConfigState> emit,
  ) async {
    emit(state.copyWith(errorMessage: null));
  }
} 