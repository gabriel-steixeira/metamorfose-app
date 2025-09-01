/**
 * File: calendar_state.dart
 * Description: Estado para o BLoC do calendário visual
 *
 * Responsabilidades:
 * - Definir estados de loading para diferentes operações
 * - Gerenciar dados das fotos do calendário
 * - Controlar estados de erro e sucesso
 *
 * Author: Assistant
 * Created on: 15-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:metamorfose_flutter/models/calendar_photo.dart';

/// Estados de loading
enum LoadingState {
  initial,
  loading,
  success,
  error,
}

/// Estado do calendário
class CalendarState {
  final LoadingState photosLoadingState;
  final LoadingState uploadLoadingState;
  final List<CalendarPhoto> photos;
  final CalendarPhoto? selectedPhoto;
  final String? errorMessage;
  final String? successMessage;
  final DateTime currentDate;
  final bool isTakingPhoto;
  final bool isShowingPhotoDetails;

  const CalendarState({
    this.photosLoadingState = LoadingState.initial,
    this.uploadLoadingState = LoadingState.initial,
    this.photos = const [],
    this.selectedPhoto,
    this.errorMessage,
    this.successMessage,
    required this.currentDate,
    this.isTakingPhoto = false,
    this.isShowingPhotoDetails = false,
  });

  /// Cria uma cópia com novos valores
  CalendarState copyWith({
    LoadingState? photosLoadingState,
    LoadingState? uploadLoadingState,
    List<CalendarPhoto>? photos,
    CalendarPhoto? selectedPhoto,
    String? errorMessage,
    String? successMessage,
    DateTime? currentDate,
    bool? isTakingPhoto,
    bool? isShowingPhotoDetails,
  }) {
    return CalendarState(
      photosLoadingState: photosLoadingState ?? this.photosLoadingState,
      uploadLoadingState: uploadLoadingState ?? this.uploadLoadingState,
      photos: photos ?? this.photos,
      selectedPhoto: selectedPhoto ?? this.selectedPhoto,
      errorMessage: errorMessage,
      successMessage: successMessage,
      currentDate: currentDate ?? this.currentDate,
      isTakingPhoto: isTakingPhoto ?? this.isTakingPhoto,
      isShowingPhotoDetails:
          isShowingPhotoDetails ?? this.isShowingPhotoDetails,
    );
  }

  /// Verifica se há erro
  bool get hasError => errorMessage != null;

  /// Verifica se há sucesso
  bool get hasSuccess => successMessage != null;

  /// Verifica se está carregando fotos
  bool get isLoadingPhotos => photosLoadingState == LoadingState.loading;

  /// Verifica se está fazendo upload
  bool get isUploading => uploadLoadingState == LoadingState.loading;

  /// Verifica se há fotos
  bool get hasPhotos => photos.isNotEmpty;

  /// Obtém fotos de um mês específico
  List<CalendarPhoto> getPhotosForMonth(int year, int month) {
    return photos.where((photo) {
      return photo.date.year == year && photo.date.month == month;
    }).toList();
  }

  /// Verifica se há foto em uma data específica
  bool hasPhotoOnDate(DateTime date) {
    return photos.any((photo) {
      return photo.date.year == date.year &&
          photo.date.month == date.month &&
          photo.date.day == date.day;
    });
  }

  /// Obtém foto de uma data específica
  CalendarPhoto? getPhotoOnDate(DateTime date) {
    try {
      return photos.firstWhere((photo) {
        return photo.date.year == date.year &&
            photo.date.month == date.month &&
            photo.date.day == date.day;
      });
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'CalendarState(photosLoadingState: $photosLoadingState, uploadLoadingState: $uploadLoadingState, photos: ${photos.length}, selectedPhoto: $selectedPhoto, errorMessage: $errorMessage, successMessage: $successMessage, currentDate: $currentDate, isTakingPhoto: $isTakingPhoto, isShowingPhotoDetails: $isShowingPhotoDetails)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalendarState &&
        other.photosLoadingState == photosLoadingState &&
        other.uploadLoadingState == uploadLoadingState &&
        other.photos == photos &&
        other.selectedPhoto == selectedPhoto &&
        other.errorMessage == errorMessage &&
        other.successMessage == successMessage &&
        other.currentDate == currentDate &&
        other.isTakingPhoto == isTakingPhoto &&
        other.isShowingPhotoDetails == isShowingPhotoDetails;
  }

  @override
  int get hashCode {
    return Object.hash(
      photosLoadingState,
      uploadLoadingState,
      photos,
      selectedPhoto,
      errorMessage,
      successMessage,
      currentDate,
      isTakingPhoto,
      isShowingPhotoDetails,
    );
  }
}
