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
import 'package:metamorfose_flutter/state/plant_config/plant_config_state.dart';
import 'package:metamorfose_flutter/services/plant_config_service.dart';
import 'package:metamorfose_flutter/theme/colors.dart';

/// Eventos do PlantConfigBloc
abstract class PlantConfigEvent {}

/// Evento para inicializar o formulário
class InitializePlantConfigEvent extends PlantConfigEvent {
  final String uid;
  InitializePlantConfigEvent(this.uid);
}

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

/// Evento para salvar configuração da planta
class SavePlantConfigEvent extends PlantConfigEvent {
  final String uid;
  SavePlantConfigEvent(this.uid);
}

/// BLoC para configuração da planta
class PlantConfigBloc extends Bloc<PlantConfigEvent, PlantConfigState> {
  final PlantConfigService _service;

  PlantConfigBloc({PlantConfigService? service})
      : _service = service ?? PlantConfigService(),
        super(const PlantConfigState(uid: '')) {
    
    on<InitializePlantConfigEvent>(_onInitialize);
    on<LoadSavedConfigurationEvent>(_onLoadSavedConfiguration);
    on<UpdatePlantNameEvent>(_onUpdatePlantName);
    on<SelectPlantTypeEvent>(_onSelectPlantType);
    on<SelectPlantColorEvent>(_onSelectPlantColor);
    on<ValidateFormEvent>(_onValidateForm);
    on<TakeFirstPhotoEvent>(_onTakeFirstPhoto);
    on<SkipPhotoEvent>(_onSkipPhoto);
    on<ClearErrorEvent>(_onClearError);
    on<SavePlantConfigEvent>(_onSavePlantConfig);
  }

  /// Inicializa o formulário com valores padrão
  Future<void> _onInitialize(
    InitializePlantConfigEvent event,
    Emitter<PlantConfigState> emit,
  ) async {
    try {
      // Inicializar com valores padrão e uid
      final initialState = PlantConfigState(
        uid: event.uid,
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
    print('📝 BLoC recebeu UpdatePlantNameEvent: "${event.name}"');
    
    // Evitar atualização desnecessária se o valor for igual
    if (state.plantName == event.name) {
      print('📝 Nome igual ao anterior, ignorando');
      return;
    }
    
    emit(state.copyWith(
      plantName: event.name,
      errorMessage: null, // Limpar erro anterior
    ));

    // Validar apenas se o campo não estiver vazio
    // Removendo validação de tamanho mínimo que pode causar problemas
    if (event.name.trim().isNotEmpty) {
      print('📝 Nome não vazio, disparando validação');
      add(ValidateFormEvent());
    } else {
      print('📝 Nome vazio, resetando validação');
      // Resetar validação se campo estiver vazio
      emit(state.copyWith(
        validationState: ValidationState.initial,
        errorMessage: null,
      ));
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
    print('🔍 Validando formulário...');
    print('  - Nome: "${state.plantName}"');
    print('  - Planta: "${state.selectedPlant}"');
    print('  - Cor: ${state.selectedColor}');
    
    try {
      final validation = _service.validateForm(state);
      
      print('  - Resultado: ${validation.isValid ? "VÁLIDO" : "INVÁLIDO"}');
      if (!validation.isValid) {
        print('  - Erro: ${validation.error}');
      }
      
      emit(state.copyWith(
        validationState: validation.state,
        errorMessage: validation.error,
      ));
    } catch (e) {
      print('  - Erro na validação: $e');
      emit(state.copyWith(
        validationState: ValidationState.invalid,
        errorMessage: 'Erro na validação',
      ));
    }
  }

  /// Processa captura da primeira foto
  /// REQUER VALIDAÇÃO COMPLETA DO FORMULÁRIO
  Future<void> _onTakeFirstPhoto(
    TakeFirstPhotoEvent event,
    Emitter<PlantConfigState> emit,
  ) async {
    // Debug: Verificar estado atual
    print('🌱 TakeFirstPhoto - Estado atual:');
    print('  - Nome: "${state.plantName}"');
    print('  - Planta: "${state.selectedPlant}"');
    print('  - Cor: ${state.selectedColor}');
    print('  - Validação: ${state.validationState}');
    print('  - canSave: ${state.canSave}');
    
    // Forçar validação antes de verificar
    final validation = _service.validateForm(state);
    print('  - Validação forçada: ${validation.isValid} (${validation.error})');
    
    // Atualizar estado com validação
    emit(state.copyWith(
      validationState: validation.state,
      errorMessage: validation.error,
    ));
    
    // Verificar se pode salvar após validação
    if (!validation.isValid) {
      print('❌ Formulário inválido: ${validation.error}');
      return;
    }

    try {
      // Iniciar processo de salvamento
      emit(state.copyWith(
        loadingState: LoadingState.saving,
        errorMessage: null,
      ));

      // Salvar configuração primeiro (validação incluída)
      final saveResult = await _service.savePlantConfiguration(state, uid: state.uid);
      
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
  /// NÃO REQUER VALIDAÇÃO - NAVEGA DIRETAMENTE
  Future<void> _onSkipPhoto(
    SkipPhotoEvent event,
    Emitter<PlantConfigState> emit,
  ) async {
    try {
      // Iniciar processo de navegação sem validação
      emit(state.copyWith(
        loadingState: LoadingState.saving,
        errorMessage: null,
      ));

      // Simular processo de skip (sem salvar configuração)
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

  /// Salva a configuração da planta com o UID do usuário
  Future<void> _onSavePlantConfig(
    SavePlantConfigEvent event,
    Emitter<PlantConfigState> emit,
  ) async {
    print('💾 BLoC recebeu SavePlantConfigEvent');
    print('  - UID: ${event.uid}');

    // Forçar validação antes de salvar
    final validation = _service.validateForm(state);
    print('  - Validação forçada: ${validation.isValid} (${validation.error})');

    // Atualizar estado com validação
    emit(state.copyWith(
      validationState: validation.state,
      errorMessage: validation.error,
    ));

    // Verificar se pode salvar após validação
    if (!validation.isValid) {
      print('❌ Formulário inválido: ${validation.error}');
      return;
    }

    try {
      // Iniciar processo de salvamento
      emit(state.copyWith(
        loadingState: LoadingState.saving,
        errorMessage: null,
      ));

      // Salvar configuração primeiro (validação incluída)
      final saveResult = await _service.savePlantConfiguration(state, uid: state.uid);
      
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
        errorMessage: 'Erro ao salvar configuração da planta',
      ));
    }
  }
} 