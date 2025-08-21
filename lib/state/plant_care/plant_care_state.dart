/**
 * File: plant_care_state.dart
 * Description: Estado da tela de cuidados da planta
 *
 * Responsabilidades:
 * - Gerenciar informações da planta
 * - Gerenciar tarefas do dia
 * - Controlar carregamento e erros
 *
 * Author: Evelin Cordeiro
 * Created on: 06-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

/// Estado de carregamento
enum LoadingState { idle, loading, success, error }

/// Estado da tela de cuidados da planta
class PlantCareState {
  final LoadingState plantInfoLoadingState;
  final LoadingState todayTasksLoadingState;
  final Map<String, dynamic>? plantInfo;
  final List<dynamic> todayTasks;
  final String? plantInfoError;
  final String? todayTasksError;
  final String? errorMessage;
  final String? successMessage;
  final bool isSharingProgress;

  const PlantCareState({
    this.plantInfoLoadingState = LoadingState.idle,
    this.todayTasksLoadingState = LoadingState.idle,
    this.plantInfo,
    this.todayTasks = const [],
    this.plantInfoError,
    this.todayTasksError,
    this.errorMessage,
    this.successMessage,
    this.isSharingProgress = false,
  });

  /// Copia o estado com novos valores
  PlantCareState copyWith({
    LoadingState? plantInfoLoadingState,
    LoadingState? todayTasksLoadingState,
    Map<String, dynamic>? plantInfo,
    List<dynamic>? todayTasks,
    String? plantInfoError,
    String? todayTasksError,
    String? errorMessage,
    String? successMessage,
    bool? isSharingProgress,
  }) {
    return PlantCareState(
      plantInfoLoadingState:
          plantInfoLoadingState ?? this.plantInfoLoadingState,
      todayTasksLoadingState:
          todayTasksLoadingState ?? this.todayTasksLoadingState,
      plantInfo: plantInfo ?? this.plantInfo,
      todayTasks: todayTasks ?? this.todayTasks,
      plantInfoError: plantInfoError ?? this.plantInfoError,
      todayTasksError: todayTasksError ?? this.todayTasksError,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      isSharingProgress: isSharingProgress ?? this.isSharingProgress,
    );
  }

  /// Getters de conveniência
  bool get hasError => errorMessage != null;
  bool get hasSuccess => successMessage != null;
  bool get isPlantInfoLoading => plantInfoLoadingState == LoadingState.loading;
  bool get isTodayTasksLoading =>
      todayTasksLoadingState == LoadingState.loading;
  bool get isLoading =>
      isPlantInfoLoading || isTodayTasksLoading;
  bool get hasTodayTasks => todayTasks.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlantCareState &&
        other.plantInfoLoadingState == plantInfoLoadingState &&
        other.todayTasksLoadingState == todayTasksLoadingState &&
        other.plantInfo == plantInfo &&
        other.todayTasks == todayTasks &&
        other.plantInfoError == plantInfoError &&
        other.todayTasksError == todayTasksError &&
        other.errorMessage == errorMessage &&
        other.successMessage == successMessage &&
        other.isSharingProgress == isSharingProgress;
  }

  @override
  int get hashCode {
    return plantInfoLoadingState.hashCode ^
        todayTasksLoadingState.hashCode ^
        plantInfo.hashCode ^
        todayTasks.hashCode ^
        plantInfoError.hashCode ^
        todayTasksError.hashCode ^
        errorMessage.hashCode ^
        successMessage.hashCode ^
        isSharingProgress.hashCode;
  }

  @override
  String toString() {
    return 'PlantCareState(plantInfoState: $plantInfoLoadingState, todayTasksState: $todayTasksLoadingState, plantInfo: $plantInfo, todayTasks: $todayTasks, plantInfoError: $plantInfoError, todayTasksError: $todayTasksError, error: $errorMessage, success: $successMessage, isSharingProgress: $isSharingProgress)';
  }
}
