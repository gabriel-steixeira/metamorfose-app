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

/// Evento para finalizar configuração da planta
class FinishConfigurationEvent extends PlantConfigEvent {}

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
    on<FinishConfigurationEvent>(_onFinishConfiguration);
    on<ClearErrorEvent>(_onClearError);
  }

  /// Inicializa o formulário com valores padrão
  Future<void> _onInitialize(
    InitializePlantConfigEvent event,
    Emitter<PlantConfigState> emit,
  ) async {
    try {
      // Verificar se já existe planta cadastrada
      final hasPlant = await _service.hasExistingPlant();
      if (hasPlant) {
        emit(state.copyWith(loadingState: LoadingState.navigating));
        return;
      }
      
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
    final trimmedName = event.name.trim();
    print('📝 BLoC recebeu UpdatePlantNameEvent: "${trimmedName}"');
    
    if (state.plantName == trimmedName) {
      print('📝 Nome igual ao anterior, ignorando');
      return;
    }
    
    emit(state.copyWith(
      plantName: trimmedName,
      errorMessage: null,
      nameError: null, // Limpar erro de nome
    ));
  
    // Sempre validar após atualização
    add(ValidateFormEvent());
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
    
    try {
      // Validar nome
      final nameValidation = _service.validatePlantName(state.plantName);
      print('  - Name valid: ${nameValidation.isValid} error: ${nameValidation.error}');
      
      // Validar tipo de planta
      final plantValidation = _service.validatePlantSelection(state.selectedPlant);
      print('  - Plant valid: ${plantValidation.isValid} error: ${plantValidation.error}');
      
      // Validar cor
      final colorValidation = _service.validateColorSelection(state.selectedColor);
      print('  - Color valid: ${colorValidation.isValid} error: ${colorValidation.error}');
      
      // Determinar estado geral
      final isValid = nameValidation.isValid && plantValidation.isValid && colorValidation.isValid;
      print('  - Overall isValid: $isValid');
      
      emit(state.copyWith(
        validationState: isValid ? ValidationState.valid : ValidationState.invalid,
        nameError: nameValidation.isValid ? null : nameValidation.error,
        errorMessage: isValid ? null : 'Por favor, corrija os erros',
      ));
    } catch (e) {
      print('  - Erro na validação: $e');
      emit(state.copyWith(
        validationState: ValidationState.invalid,
        nameError: 'Erro na validação',
        errorMessage: 'Erro na validação',
      ));
    }
  }

  /// Finaliza configuração da planta sem foto
  Future<void> _onFinishConfiguration(
    FinishConfigurationEvent event,
    Emitter<PlantConfigState> emit,
  ) async {
    // Forçar validação antes de salvar
    final validation = _service.validateForm(state);
    
    // Atualizar estado com validação
    emit(state.copyWith(
      validationState: validation.state,
      errorMessage: validation.error,
    ));
    
    // Verificar se pode salvar após validação
    if (!validation.isValid) {
      return;
    }

    try {
      // Iniciar processo de salvamento
      emit(state.copyWith(
        loadingState: LoadingState.saving,
        errorMessage: null,
      ));

      // Salvar configuração sem imagem
      final saveResult = await _service.savePlantConfiguration(state);
      
      if (!saveResult.success) {
        emit(state.copyWith(
          loadingState: LoadingState.idle,
          errorMessage: saveResult.error,
        ));
        return;
      }

      // Sucesso - definir estado de navegação
      emit(state.copyWith(
        loadingState: LoadingState.navigating,
      ));
    } catch (e) {
      emit(state.copyWith(
        loadingState: LoadingState.idle,
        errorMessage: 'Erro ao finalizar configuração',
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