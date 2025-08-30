/**
 * File: sos_state.dart
 * Description: Estado da tela do SOS do Metamorfose
 *
 * Responsabilidades:
 * - Gerenciar estado do contato de emergência único
 * - Controlar exercícios de respiração
 * - Gerenciar carregamento e erros
 *
 * Author: Gabriel Teixeira
 * Created on: 19-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:metamorfose_flutter/models/sos_contact.dart';
import 'package:metamorfose_flutter/models/breathing_exercise.dart';
import 'package:flutter/foundation.dart';

/// Estado de carregamento
enum LoadingState {
  idle,
  loading,
  success,
  error
}

/// Estado da tela do SOS
class SosState {
  final LoadingState contactLoadingState;
  final LoadingState exercisesLoadingState;
  final SosContact? emergencyContact; // Alterado para um único contato
  final List<BreathingExercise> exercises;
  final String? contactError;
  final String? exercisesError;
  final String? errorMessage;
  final bool isSosActive;
  final bool isBreathingActive;
  final int currentBreathingCycle;
  final int totalBreathingCycles;
  final String currentBreathingPhase; // 'inhale', 'hold', 'exhale'

  const SosState({
    this.contactLoadingState = LoadingState.idle,
    this.exercisesLoadingState = LoadingState.idle,
    this.emergencyContact,
    this.exercises = const [],
    this.contactError,
    this.exercisesError,
    this.errorMessage,
    this.isSosActive = false,
    this.isBreathingActive = false,
    this.currentBreathingCycle = 0,
    this.totalBreathingCycles = 0,
    this.currentBreathingPhase = 'inhale',
  });

  /// Copia o estado com novos valores
  SosState copyWith({
    LoadingState? contactLoadingState,
    LoadingState? exercisesLoadingState,
    SosContact? emergencyContact,
    bool clearEmergencyContact = false,
    List<BreathingExercise>? exercises,
    String? contactError,
    String? exercisesError,
    String? errorMessage,
    bool? isSosActive,
    bool? isBreathingActive,
    int? currentBreathingCycle,
    int? totalBreathingCycles,
    String? currentBreathingPhase,
  }) {
    return SosState(
      contactLoadingState: contactLoadingState ?? this.contactLoadingState,
      exercisesLoadingState: exercisesLoadingState ?? this.exercisesLoadingState,
      emergencyContact: clearEmergencyContact ? null : (emergencyContact ?? this.emergencyContact),
      exercises: exercises ?? this.exercises,
      contactError: contactError ?? this.contactError,
      exercisesError: exercisesError ?? this.exercisesError,
      errorMessage: errorMessage ?? this.errorMessage,
      isSosActive: isSosActive ?? this.isSosActive,
      isBreathingActive: isBreathingActive ?? this.isBreathingActive,
      currentBreathingCycle: currentBreathingCycle ?? this.currentBreathingCycle,
      totalBreathingCycles: totalBreathingCycles ?? this.totalBreathingCycles,
      currentBreathingPhase: currentBreathingPhase ?? this.currentBreathingPhase,
    );
  }

  /// Getters de conveniência
  bool get hasError => errorMessage != null;
  bool get isContactLoading => contactLoadingState == LoadingState.loading;
  bool get isExercisesLoading => exercisesLoadingState == LoadingState.loading;
  bool get isLoading => isContactLoading || isExercisesLoading;
  
  /// ✅ Verificar se existe contato E se tem dados válidos
  bool get hasEmergencyContact {
    final hasContact = emergencyContact != null;
    final hasValidName = emergencyContact?.name.trim().isNotEmpty ?? false;
    final hasValidPhone = emergencyContact?.phoneNumber.trim().isNotEmpty ?? false;
    
    debugPrint('🔍 SOS State - hasEmergencyContact:');
    debugPrint('🔍 SOS State - hasContact: $hasContact');
    debugPrint('🔍 SOS State - hasValidName: $hasValidName');
    debugPrint('🔍 SOS State - hasValidPhone: $hasValidPhone');
    debugPrint('🔍 SOS State - Resultado: ${hasContact && hasValidName && hasValidPhone}');
    
    return hasContact && hasValidName && hasValidPhone;
  }
      
  bool get hasExercises => exercises.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SosState &&
        other.contactLoadingState == contactLoadingState &&
        other.exercisesLoadingState == exercisesLoadingState &&
        other.emergencyContact == emergencyContact &&
        other.exercises == exercises &&
        other.contactError == contactError &&
        other.exercisesError == exercisesError &&
        other.errorMessage == errorMessage &&
        other.isSosActive == isSosActive &&
        other.isBreathingActive == isBreathingActive &&
        other.currentBreathingCycle == currentBreathingCycle &&
        other.totalBreathingCycles == totalBreathingCycles &&
        other.currentBreathingPhase == currentBreathingPhase;
  }

  @override
  int get hashCode {
    return contactLoadingState.hashCode ^
        exercisesLoadingState.hashCode ^
        emergencyContact.hashCode ^
        exercises.hashCode ^
        contactError.hashCode ^
        exercisesError.hashCode ^
        errorMessage.hashCode ^
        isSosActive.hashCode ^
        isBreathingActive.hashCode ^
        currentBreathingCycle.hashCode ^
        totalBreathingCycles.hashCode ^
        currentBreathingPhase.hashCode;
  }

  @override
  String toString() {
    return 'SosState('
        'contactLoadingState: $contactLoadingState, '
        'exercisesLoadingState: $exercisesLoadingState, '
        'emergencyContact: $emergencyContact, '
        'exercises: $exercises, '
        'contactError: $contactError, '
        'exercisesError: $exercisesError, '
        'errorMessage: $errorMessage, '
        'isSosActive: $isSosActive, '
        'isBreathingActive: $isBreathingActive, '
        'currentBreathingCycle: $currentBreathingCycle, '
        'totalBreathingCycles: $totalBreathingCycles, '
        'currentBreathingPhase: $currentBreathingPhase)';
  }
}
