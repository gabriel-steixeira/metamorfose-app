/**
 * File: plant_config_service.dart
 * Description: Serviço para configuração da planta virtual
 *
 * Responsabilidades:
 * - Validar dados de configuração da planta
 * - Persistir configuração localmente
 * - Gerenciar navegação entre telas
 *
 * Author: Gabriel Teixeira
 * Created on: 01-01-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/state/plant_config/plant_config_state.dart';
import 'package:metamorfose_flutter/theme/colors.dart';

/// Resultado de validação
class ValidationResult {
  final bool isValid;
  final String? error;
  final ValidationState state;

  const ValidationResult({
    required this.isValid,
    this.error,
    required this.state,
  });

  static const ValidationResult valid = ValidationResult(
    isValid: true,
    state: ValidationState.valid,
  );

  static ValidationResult invalid(String error) => ValidationResult(
    isValid: false,
    error: error,
    state: ValidationState.invalid,
  );
}

/// Resultado de operação de salvamento
class SaveResult {
  final bool success;
  final String? error;

  const SaveResult({
    required this.success,
    this.error,
  });

  static const SaveResult successful = SaveResult(success: true);
  
  static SaveResult failure(String error) => SaveResult(
    success: false,
    error: error,
  );
}

/// Serviço para configuração da planta virtual
class PlantConfigService {
  /// Valida o nome da planta
  ValidationResult validatePlantName(String name) {
    final trimmedName = name.trim();
    
    debugPrint('🌱 Validando nome da planta: "$trimmedName" (length: ${trimmedName.length})');
    
    if (trimmedName.isEmpty) {
      debugPrint('❌ Nome vazio');
      return ValidationResult.invalid('Nome da planta é obrigatório');
    }
    
    debugPrint('✅ Nome válido: "$trimmedName"');
    return ValidationResult.valid;
  }

  /// Valida a seleção de planta
  ValidationResult validatePlantSelection(String plantType) {
    final validTypes = PlantOption.values.map((option) => option.value).toList();
    
    if (!validTypes.contains(plantType)) {
      return ValidationResult.invalid('Tipo de planta inválido');
    }
    
    return ValidationResult.valid;
  }

  /// Valida a seleção de cor
  ValidationResult validateColorSelection(Color color) {
    // Lista de cores válidas
    final validColors = [
      MetamorfoseColors.purpleNormal,
      MetamorfoseColors.greenNormal,
      MetamorfoseColors.blueNormal,
      MetamorfoseColors.pinkNormal,
    ];
    
    if (!validColors.contains(color)) {
      return ValidationResult.invalid('Cor do vaso inválida');
    }
    
    return ValidationResult.valid;
  }

  /// Valida todo o formulário
  ValidationResult validateForm(PlantConfigState state) {
    // Validar nome
    final nameValidation = validatePlantName(state.plantName);
    if (!nameValidation.isValid) {
      return nameValidation;
    }
    
    // Validar tipo de planta
    final plantValidation = validatePlantSelection(state.selectedPlant);
    if (!plantValidation.isValid) {
      return plantValidation;
    }
    
    // Validar cor
    final colorValidation = validateColorSelection(state.selectedColor);
    if (!colorValidation.isValid) {
      return colorValidation;
    }
    
    return ValidationResult.valid;
  }

  /// Simula salvamento da configuração da planta
  /// Em uma implementação real, isso seria persistido em:
  /// - SharedPreferences para dados locais
  /// - Banco de dados local (SQLite/Hive)
  /// - API backend para sincronização
  Future<SaveResult> savePlantConfiguration(PlantConfigState state) async {
    try {
      // Simular delay de salvamento
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Validar antes de salvar
      final validation = validateForm(state);
      if (!validation.isValid) {
        return SaveResult.failure(validation.error ?? 'Dados inválidos');
      }

      // Aqui seria feito o salvamento real dos dados
      // Por exemplo:
      // - await SharedPreferences.getInstance()
      // - prefs.setString('plant_name', state.plantName)
      // - prefs.setString('plant_type', state.selectedPlant)
      // - prefs.setInt('plant_color', state.selectedColor.value)
      
      debugPrint('PlantConfig salva: ${state.toString()}');
      
      return SaveResult.successful;
    } catch (e) {
      debugPrint('Erro ao salvar configuração: $e');
      return SaveResult.failure('Erro ao salvar configuração');
    }
  }

  /// Carrega configuração salva (se existir)
  Future<PlantConfigState?> loadSavedConfiguration() async {
    try {
      // Simular delay de carregamento
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Aqui seria feito o carregamento real dos dados salvos
      // Por exemplo:
      // - final prefs = await SharedPreferences.getInstance()
      // - final name = prefs.getString('plant_name')
      // - final type = prefs.getString('plant_type')
      // - final colorValue = prefs.getInt('plant_color')
      
      // Por enquanto, retorna null (sem configuração salva)
      return null;
    } catch (e) {
      debugPrint('Erro ao carregar configuração: $e');
      return null;
    }
  }

  /// Simula captura de primeira foto da planta
  Future<SaveResult> captureFirstPhoto() async {
    try {
      // Simular processo de captura
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Aqui seria integrado com:
      // - camera package para captura
      // - image_picker para seleção
      // - Processamento e salvamento da imagem
      
      debugPrint('Primeira foto capturada com sucesso');
      
      return SaveResult.successful;
    } catch (e) {
      debugPrint('Erro ao capturar foto: $e');
      return SaveResult.failure('Erro ao capturar foto');
    }
  }

  /// Simula ignorar captura de foto
  Future<SaveResult> skipPhotoCapture() async {
    try {
      // Simular delay de navegação
      await Future.delayed(const Duration(milliseconds: 300));
      
      debugPrint('Captura de foto ignorada');
      
      return SaveResult.successful;
    } catch (e) {
      debugPrint('Erro ao pular foto: $e');
      return SaveResult.failure('Erro ao pular captura');
    }
  }
} 