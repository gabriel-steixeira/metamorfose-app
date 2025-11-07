/**
 * File: calendar_bloc.dart
 * Description: BLoC para gerenciamento do estado da tela de calendário visual
 *
 * Responsabilidades:
 * - Gerenciar carregamento de fotos do calendário
 * - Gerenciar upload de novas fotos
 * - Gerenciar navegação entre meses
 * - Coordenar estados de loading e erro
 *
 * Author: Evelin Cordeiro
 * Created on: 31-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:metamorfose_flutter/state/calendar/calendar_state.dart';
import 'package:metamorfose_flutter/services/calendar_service.dart';
import 'package:metamorfose_flutter/models/calendar_photo.dart';
import 'package:metamorfose_flutter/services/local_photo_storage.dart';
import 'package:metamorfose_flutter/services/plant_tips_service.dart';

/// Eventos do CalendarBloc
abstract class CalendarEvent {}

/// Evento para inicializar a tela
class InitializeCalendarEvent extends CalendarEvent {}

/// Evento para carregar fotos de um mês específico
class LoadPhotosForMonthEvent extends CalendarEvent {
  final int year;
  final int month;

  LoadPhotosForMonthEvent({required this.year, required this.month});
}

/// Evento para carregar todas as fotos
class LoadAllPhotosEvent extends CalendarEvent {}

/// Evento para tirar foto
class TakePhotoEvent extends CalendarEvent {
  final DateTime date;
  final String? description;
  final String? plantId;

  TakePhotoEvent({
    required this.date,
    this.description,
    this.plantId,
  });
}

/// Evento para fazer upload de foto
class UploadPhotoEvent extends CalendarEvent {
  final File imageFile;
  final DateTime date;
  final String? description;
  final String? plantId;

  UploadPhotoEvent({
    required this.imageFile,
    required this.date,
    this.description,
    this.plantId,
  });
}

/// Evento para fazer upload de foto a partir de bytes
class UploadPhotoFromBytesEvent extends CalendarEvent {
  final Uint8List imageBytes;
  final DateTime date;
  final String? description;
  final String? plantId;

  UploadPhotoFromBytesEvent({
    required this.imageBytes,
    required this.date,
    this.description,
    this.plantId,
  });
}

/// Evento para salvar foto temporariamente (mock)
class SavePhotoTemporarilyEvent extends CalendarEvent {
  final Uint8List? imageBytes;
  final File? imageFile;
  final DateTime date;
  final String feeling;
  final String reason;

  SavePhotoTemporarilyEvent({
    this.imageBytes,
    this.imageFile,
    required this.date,
    required this.feeling,
    required this.reason,
  });
}

/// Evento para selecionar foto
class SelectPhotoEvent extends CalendarEvent {
  final String photoId;

  SelectPhotoEvent({required this.photoId});
}

/// Evento para atualizar descrição de foto
class UpdatePhotoDescriptionEvent extends CalendarEvent {
  final String photoId;
  final String description;

  UpdatePhotoDescriptionEvent({
    required this.photoId,
    required this.description,
  });
}

/// Evento para deletar foto
class DeletePhotoEvent extends CalendarEvent {
  final String photoId;

  DeletePhotoEvent({required this.photoId});
}

/// Evento para navegar para mês anterior
class PreviousMonthEvent extends CalendarEvent {}

/// Evento para navegar para próximo mês
class NextMonthEvent extends CalendarEvent {}

/// Evento para mudar para um mês específico
class ChangeMonthEvent extends CalendarEvent {
  final DateTime newDate;
  ChangeMonthEvent(this.newDate);
}

/// Evento para limpar erros
class ClearErrorEvent extends CalendarEvent {}

/// Evento para limpar sucessos
class ClearSuccessEvent extends CalendarEvent {}

/// BLoC para a tela de calendário
class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarService _service;

  CalendarBloc({CalendarService? service})
      : _service = service ?? CalendarService(),
        super(CalendarState(currentDate: DateTime.now())) {
    on<InitializeCalendarEvent>(_onInitialize);
    on<LoadPhotosForMonthEvent>(_onLoadPhotosForMonth);
    on<LoadAllPhotosEvent>(_onLoadAllPhotos);
    on<TakePhotoEvent>(_onTakePhoto);
    on<UploadPhotoEvent>(_onUploadPhoto);
    on<UploadPhotoFromBytesEvent>(_onUploadPhotoFromBytes);
    on<SavePhotoTemporarilyEvent>(_onSavePhotoTemporarily);
    on<SelectPhotoEvent>(_onSelectPhoto);
    on<UpdatePhotoDescriptionEvent>(_onUpdatePhotoDescription);
    on<DeletePhotoEvent>(_onDeletePhoto);
    on<PreviousMonthEvent>(_onPreviousMonth);
    on<NextMonthEvent>(_onNextMonth);
    on<ChangeMonthEvent>(_onChangeMonth);
    on<ClearErrorEvent>(_onClearError);
    on<ClearSuccessEvent>(_onClearSuccess);
  }

  /// Inicializa a tela carregando fotos do mês atual
  Future<void> _onInitialize(
    InitializeCalendarEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      // Carregar fotos do armazenamento local
      await LocalPhotoStorage.loadPhotos();

      final now = DateTime.now();
      add(LoadPhotosForMonthEvent(year: now.year, month: now.month));
    } catch (e) {
      print('Erro ao inicializar calendário: $e');
      // Continuar mesmo se falhar
      final now = DateTime.now();
      add(LoadPhotosForMonthEvent(year: now.year, month: now.month));
    }
  }

  /// Carrega fotos de um mês específico
  Future<void> _onLoadPhotosForMonth(
    LoadPhotosForMonthEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      emit(state.copyWith(
        photosLoadingState: LoadingState.loading,
        errorMessage: null,
      ));

      // Carregar fotos do armazenamento local
      final photos = LocalPhotoStorage.getPhotosForMonth(
        event.year,
        event.month,
      );

      emit(state.copyWith(
        photosLoadingState: LoadingState.success,
        photos: photos,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        photosLoadingState: LoadingState.error,
        errorMessage: 'Erro ao carregar fotos: ${e.toString()}',
      ));
    }
  }

  /// Carrega todas as fotos
  Future<void> _onLoadAllPhotos(
    LoadAllPhotosEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      emit(state.copyWith(
        photosLoadingState: LoadingState.loading,
        errorMessage: null,
      ));

      final photos = await _service.loadAllPhotos();

      emit(state.copyWith(
        photosLoadingState: LoadingState.success,
        photos: photos,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        photosLoadingState: LoadingState.error,
        errorMessage: 'Erro ao carregar fotos: ${e.toString()}',
      ));
    }
  }

  /// Prepara para tirar foto
  Future<void> _onTakePhoto(
    TakePhotoEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(
      isTakingPhoto: true,
      currentDate: event.date,
    ));
  }

  /// Faz upload de uma foto
  Future<void> _onUploadPhoto(
    UploadPhotoEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      emit(state.copyWith(
        uploadLoadingState: LoadingState.loading,
        errorMessage: null,
      ));

      final photo = await _service.uploadPhoto(
        imageFile: event.imageFile,
        date: event.date,
        description: event.description,
        plantId: event.plantId,
      );

      // Salvar foto no armazenamento local
      await LocalPhotoStorage.addPhoto(photo);

      // Recarregar fotos do mês atual
      add(LoadPhotosForMonthEvent(
        year: event.date.year,
        month: event.date.month,
      ));

      emit(state.copyWith(
        uploadLoadingState: LoadingState.success,
        successMessage: 'Foto salva com sucesso!',
        isTakingPhoto: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        uploadLoadingState: LoadingState.error,
        errorMessage: 'Erro ao salvar foto: ${e.toString()}',
        isTakingPhoto: false,
      ));
    }
  }

  /// Faz upload de uma foto a partir de bytes
  Future<void> _onUploadPhotoFromBytes(
    UploadPhotoFromBytesEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      emit(state.copyWith(
        uploadLoadingState: LoadingState.loading,
        errorMessage: null,
      ));

      final photo = await _service.uploadPhotoFromBytes(
        imageBytes: event.imageBytes,
        date: event.date,
        description: event.description,
        plantId: event.plantId,
      );

      // Salvar foto no armazenamento local
      await LocalPhotoStorage.addPhoto(photo);

      // Recarregar fotos do mês atual
      add(LoadPhotosForMonthEvent(
        year: event.date.year,
        month: event.date.month,
      ));

      emit(state.copyWith(
        uploadLoadingState: LoadingState.success,
        successMessage: 'Foto salva com sucesso!',
        isTakingPhoto: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        uploadLoadingState: LoadingState.error,
        errorMessage: 'Erro ao salvar foto: ${e.toString()}',
        isTakingPhoto: false,
      ));
    }
  }

  /// Salva foto temporariamente no estado local (mock)
  Future<void> _onSavePhotoTemporarily(
    SavePhotoTemporarilyEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      emit(state.copyWith(
        uploadLoadingState: LoadingState.loading,
        errorMessage: null,
      ));

      // Criar um ID único
      final photoId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

      // Criar descrição combinando sentimento e motivo
      final description = '${event.feeling} - ${event.reason}';

      // Gerar dica baseada no sentimento
      final tip = PlantTipsService.generateTip(event.feeling);

      // Determinar localPath para mobile - copiar arquivo para diretório permanente
      String? localPath;
      if (!kIsWeb && event.imageFile != null && event.imageFile!.existsSync()) {
        try {
          final user = FirebaseAuth.instance.currentUser;
          final appDir = await getApplicationDocumentsDirectory();
          final photosPath = '${appDir.path}/calendar_photos';
          final photosDir = Directory(photosPath);
          if (!await photosDir.exists()) {
            await photosDir.create(recursive: true);
          }
          
          final fileName =
              '${user?.uid ?? 'user'}_${event.date.millisecondsSinceEpoch}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          localPath = '${photosDir.path}/$fileName';
          
          // Copiar arquivo para diretório permanente
          await event.imageFile!.copy(localPath);
        } catch (e) {
          // Se falhar ao copiar, usar o caminho original como fallback
          localPath = event.imageFile!.path;
        }
      } else if (kIsWeb && event.imageBytes != null) {
        // Para web, não há localPath
        localPath = null;
      }

      // Criar objeto CalendarPhoto temporário
      final photo = CalendarPhoto(
        id: photoId,
        date: event.date,
        imageUrl: 'temp_url', // URL temporária
        imageBytes: event.imageBytes, // Bytes da imagem para web
        localPath: localPath, // Caminho local para mobile
        description: description,
        tip: tip,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Adicionar à lista de fotos existente
      final updatedPhotos = List<CalendarPhoto>.from(state.photos)..add(photo);

      emit(state.copyWith(
        photos: updatedPhotos,
        uploadLoadingState: LoadingState.success,
        successMessage: 'Registro salvo com sucesso!',
        isTakingPhoto: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        uploadLoadingState: LoadingState.error,
        errorMessage: 'Erro ao salvar registro: ${e.toString()}',
        isTakingPhoto: false,
      ));
    }
  }

  /// Seleciona uma foto
  Future<void> _onSelectPhoto(
    SelectPhotoEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      final photo = await _service.loadPhotoById(event.photoId);
      if (photo != null) {
        emit(state.copyWith(
          selectedPhoto: photo,
          isShowingPhotoDetails: true,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Erro ao carregar detalhes da foto: ${e.toString()}',
      ));
    }
  }

  /// Atualiza descrição de uma foto
  Future<void> _onUpdatePhotoDescription(
    UpdatePhotoDescriptionEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      await _service.updatePhotoDescription(
        photoId: event.photoId,
        description: event.description,
      );

      // Recarregar fotos para atualizar a lista
      add(LoadAllPhotosEvent());

      emit(state.copyWith(
        successMessage: 'Descrição atualizada com sucesso!',
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Erro ao atualizar descrição: ${e.toString()}',
      ));
    }
  }

  /// Deleta uma foto
  Future<void> _onDeletePhoto(
    DeletePhotoEvent event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      await _service.deletePhoto(event.photoId);

      // Recarregar fotos para atualizar a lista
      add(LoadAllPhotosEvent());

      emit(state.copyWith(
        successMessage: 'Foto deletada com sucesso!',
        selectedPhoto: null,
        isShowingPhotoDetails: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Erro ao deletar foto: ${e.toString()}',
      ));
    }
  }

  /// Navega para o mês anterior
  Future<void> _onPreviousMonth(
    PreviousMonthEvent event,
    Emitter<CalendarState> emit,
  ) async {
    final previousMonth = DateTime(
      state.currentDate.year,
      state.currentDate.month - 1,
      1,
    );

    emit(state.copyWith(currentDate: previousMonth));

    add(LoadPhotosForMonthEvent(
      year: previousMonth.year,
      month: previousMonth.month,
    ));
  }

  /// Navega para o próximo mês
  Future<void> _onNextMonth(
    NextMonthEvent event,
    Emitter<CalendarState> emit,
  ) async {
    final nextMonth = DateTime(
      state.currentDate.year,
      state.currentDate.month + 1,
      1,
    );

    emit(state.copyWith(currentDate: nextMonth));

    add(LoadPhotosForMonthEvent(
      year: nextMonth.year,
      month: nextMonth.month,
    ));
  }

  /// Muda para um mês específico
  Future<void> _onChangeMonth(
    ChangeMonthEvent event,
    Emitter<CalendarState> emit,
  ) async {
    final newDate = DateTime(event.newDate.year, event.newDate.month, 1);
    emit(state.copyWith(currentDate: newDate));
    add(LoadPhotosForMonthEvent(year: newDate.year, month: newDate.month));
  }

  /// Limpa erros do estado
  Future<void> _onClearError(
    ClearErrorEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(errorMessage: null));
  }

  /// Limpa sucessos do estado
  Future<void> _onClearSuccess(
    ClearSuccessEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(state.copyWith(successMessage: null));
  }
}
