/**
 * File: plant_care_state.dart
 * Description: Estado da tela de cuidados da planta
 *
 * Responsabilidades:
 * - Gerenciar informações da planta
 * - Gerenciar carregamento de fotos do diário visual
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
  final LoadingState visualDiaryLoadingState;
  final LoadingState todayTasksLoadingState;
  final Map<String, dynamic>? plantInfo;
  final List<dynamic> visualDiaryPhotos;
  final List<dynamic> todayTasks;
  final String? plantInfoError;
  final String? visualDiaryError;
  final String? todayTasksError;
  final String? errorMessage;
  final String? successMessage;
  final bool isTakingPhoto;
  final bool isSharingProgress;

  const PlantCareState({
    this.plantInfoLoadingState = LoadingState.idle,
    this.visualDiaryLoadingState = LoadingState.idle,
    this.todayTasksLoadingState = LoadingState.idle,
    this.plantInfo,
    this.visualDiaryPhotos = const [],
    this.todayTasks = const [],
    this.plantInfoError,
    this.visualDiaryError,
    this.todayTasksError,
    this.errorMessage,
    this.successMessage,
    this.isTakingPhoto = false,
    this.isSharingProgress = false,
  });

  /// Copia o estado com novos valores
  PlantCareState copyWith({
    LoadingState? plantInfoLoadingState,
    LoadingState? visualDiaryLoadingState,
    LoadingState? todayTasksLoadingState,
    Map<String, dynamic>? plantInfo,
    List<dynamic>? visualDiaryPhotos,
    List<dynamic>? todayTasks,
    String? plantInfoError,
    String? visualDiaryError,
    String? todayTasksError,
    String? errorMessage,
    String? successMessage,
    bool? isTakingPhoto,
    bool? isSharingProgress,
  }) {
    return PlantCareState(
      plantInfoLoadingState:
          plantInfoLoadingState ?? this.plantInfoLoadingState,
      visualDiaryLoadingState:
          visualDiaryLoadingState ?? this.visualDiaryLoadingState,
      todayTasksLoadingState:
          todayTasksLoadingState ?? this.todayTasksLoadingState,
      plantInfo: plantInfo ?? this.plantInfo,
      visualDiaryPhotos: visualDiaryPhotos ?? this.visualDiaryPhotos,
      todayTasks: todayTasks ?? this.todayTasks,
      plantInfoError: plantInfoError ?? this.plantInfoError,
      visualDiaryError: visualDiaryError ?? this.visualDiaryError,
      todayTasksError: todayTasksError ?? this.todayTasksError,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      isTakingPhoto: isTakingPhoto ?? this.isTakingPhoto,
      isSharingProgress: isSharingProgress ?? this.isSharingProgress,
    );
  }

  /// Getters de conveniência
  bool get hasError => errorMessage != null;
  bool get hasSuccess => successMessage != null;
  bool get isPlantInfoLoading => plantInfoLoadingState == LoadingState.loading;
  bool get isVisualDiaryLoading =>
      visualDiaryLoadingState == LoadingState.loading;
  bool get isTodayTasksLoading =>
      todayTasksLoadingState == LoadingState.loading;
  bool get isLoading =>
      isPlantInfoLoading || isVisualDiaryLoading || isTodayTasksLoading;
  bool get hasVisualDiaryPhotos => visualDiaryPhotos.isNotEmpty;
  bool get hasTodayTasks => todayTasks.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlantCareState &&
        other.plantInfoLoadingState == plantInfoLoadingState &&
        other.visualDiaryLoadingState == visualDiaryLoadingState &&
        other.todayTasksLoadingState == todayTasksLoadingState &&
        other.plantInfo == plantInfo &&
        other.visualDiaryPhotos == visualDiaryPhotos &&
        other.todayTasks == todayTasks &&
        other.plantInfoError == plantInfoError &&
        other.visualDiaryError == visualDiaryError &&
        other.todayTasksError == todayTasksError &&
        other.errorMessage == errorMessage &&
        other.successMessage == successMessage &&
        other.isTakingPhoto == isTakingPhoto &&
        other.isSharingProgress == isSharingProgress;
  }

  @override
  int get hashCode {
    return plantInfoLoadingState.hashCode ^
        visualDiaryLoadingState.hashCode ^
        todayTasksLoadingState.hashCode ^
        plantInfo.hashCode ^
        visualDiaryPhotos.hashCode ^
        todayTasks.hashCode ^
        plantInfoError.hashCode ^
        visualDiaryError.hashCode ^
        todayTasksError.hashCode ^
        errorMessage.hashCode ^
        successMessage.hashCode ^
        isTakingPhoto.hashCode ^
        isSharingProgress.hashCode;
  }

  @override
  String toString() {
    return 'PlantCareState(plantInfoState: $plantInfoLoadingState, visualDiaryState: $visualDiaryLoadingState, todayTasksState: $todayTasksLoadingState, plantInfo: $plantInfo, visualDiaryPhotos: $visualDiaryPhotos, todayTasks: $todayTasks, plantInfoError: $plantInfoError, visualDiaryError: $visualDiaryError, todayTasksError: $todayTasksError, error: $errorMessage, success: $successMessage, isTakingPhoto: $isTakingPhoto, isSharingProgress: $isSharingProgress)';
  }
}
