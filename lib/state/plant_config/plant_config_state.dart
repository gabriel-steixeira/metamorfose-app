/**
 * File: plant_config_state.dart
 * Description: Estado da tela de configuração da planta virtual
 *
 * Responsabilidades:
 * - Gerenciar estado do formulário de configuração
 * - Controlar seleções e valores de input
 * - Validações de formulário
 *
 * Author: Gabriel Teixeira
 * Created on: 01-01-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:conversao_flutter/theme/colors.dart';

/// Estado da validação do formulário
enum ValidationState {
  initial,
  valid,
  invalid
}

/// Estado de carregamento
enum LoadingState {
  idle,
  saving,
  navigating
}

/// Opção de seleção para planta
class PlantOption {
  final String value;
  final String label;
  final IconData icon;

  const PlantOption({
    required this.value,
    required this.label,
    required this.icon,
  });

  static const List<PlantOption> values = [
    PlantOption(
      value: 'suculenta',
      label: 'Suculenta',
      icon: Icons.spa,
    ),
    PlantOption(
      value: 'samambaia',
      label: 'Samambaia',
      icon: Icons.eco,
    ),
    PlantOption(
      value: 'cacto',
      label: 'Cacto',
      icon: Icons.park,
    ),
  ];
}

/// Opção de cor para vaso
class ColorOption {
  final Color value;
  final String label;

  const ColorOption({
    required this.value,
    required this.label,
  });

  static const List<ColorOption> values = [
    ColorOption(
      value: MetamorfoseColors.purpleNormal,
      label: 'Roxo',
    ),
    ColorOption(
      value: MetamorfoseColors.greenNormal,
      label: 'Verde',
    ),
    ColorOption(
      value: MetamorfoseColors.blueNormal,
      label: 'Azul',
    ),
    ColorOption(
      value: MetamorfoseColors.pinkNormal,
      label: 'Rosa',
    ),
  ];
}

/// Estado da configuração da planta
class PlantConfigState {
  final String plantName;
  final String selectedPlant;
  final Color selectedColor;
  final ValidationState validationState;
  final LoadingState loadingState;
  final String? errorMessage;

  const PlantConfigState({
    this.plantName = '',
    this.selectedPlant = 'suculenta',
    this.selectedColor = MetamorfoseColors.purpleNormal,
    this.validationState = ValidationState.initial,
    this.loadingState = LoadingState.idle,
    this.errorMessage,
  });

  /// Copia o estado com novos valores
  PlantConfigState copyWith({
    String? plantName,
    String? selectedPlant,
    Color? selectedColor,
    ValidationState? validationState,
    LoadingState? loadingState,
    String? errorMessage,
  }) {
    return PlantConfigState(
      plantName: plantName ?? this.plantName,
      selectedPlant: selectedPlant ?? this.selectedPlant,
      selectedColor: selectedColor ?? this.selectedColor,
      validationState: validationState ?? this.validationState,
      loadingState: loadingState ?? this.loadingState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Getters de conveniência
  bool get isValid => validationState == ValidationState.valid;
  bool get isLoading => loadingState != LoadingState.idle;
  bool get isSaving => loadingState == LoadingState.saving;
  bool get isNavigating => loadingState == LoadingState.navigating;
  bool get hasError => errorMessage != null;
  bool get canSave => isValid && !isLoading;

  /// Valida se o nome da planta é válido
  bool get isNameValid => plantName.trim().isNotEmpty;

  /// Busca opção de planta por valor
  PlantOption get plantOption {
    return PlantOption.values.firstWhere(
      (option) => option.value == selectedPlant,
      orElse: () => PlantOption.values.first,
    );
  }

  /// Busca opção de cor por valor
  ColorOption get colorOption {
    return ColorOption.values.firstWhere(
      (option) => option.value == selectedColor,
      orElse: () => ColorOption.values.first,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlantConfigState &&
      other.plantName == plantName &&
      other.selectedPlant == selectedPlant &&
      other.selectedColor == selectedColor &&
      other.validationState == validationState &&
      other.loadingState == loadingState &&
      other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return plantName.hashCode ^
      selectedPlant.hashCode ^
      selectedColor.hashCode ^
      validationState.hashCode ^
      loadingState.hashCode ^
      errorMessage.hashCode;
  }

  @override
  String toString() {
    return 'PlantConfigState(name: $plantName, plant: $selectedPlant, color: ${colorOption.label}, validation: $validationState, loading: $loadingState, error: $errorMessage)';
  }
} 