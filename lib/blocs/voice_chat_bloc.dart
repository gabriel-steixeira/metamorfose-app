/**
 * File: voice_chat_bloc.dart
 * Description: BLoC para gerenciamento do estado de chat por voz.
 *
 * Responsabilidades:
 * - Gerenciar estado de gravação de áudio
 * - Processar eventos de interação de voz
 * - Coordenar com serviço de voz
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metamorfose_flutter/state/voice_chat/voice_chat_state.dart';
import 'package:metamorfose_flutter/models/chat_message.dart';
import 'package:metamorfose_flutter/services/voice_chat_service.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Eventos do VoiceChatBloc
abstract class VoiceChatEvent {}

/// Evento para inicializar o serviço de voz
class VoiceChatInitializeEvent extends VoiceChatEvent {}

/// Evento para alternar gravação (toggle)
class VoiceChatToggleListeningEvent extends VoiceChatEvent {}

/// Evento para iniciar gravação
class VoiceChatStartListeningEvent extends VoiceChatEvent {}

/// Evento para parar gravação
class VoiceChatStopListeningEvent extends VoiceChatEvent {}

/// Evento para processar áudio gravado
class VoiceChatProcessAudioEvent extends VoiceChatEvent {}

/// Evento para limpar erro
class VoiceChatClearErrorEvent extends VoiceChatEvent {}

/// Evento para atualizar mensagem
class VoiceChatUpdateMessageEvent extends VoiceChatEvent {
  final String message;
  VoiceChatUpdateMessageEvent(this.message);
}

class LoadChatHistoryEvent extends VoiceChatEvent {
  final String uid;
  LoadChatHistoryEvent(this.uid);
}

class SendMessageEvent extends VoiceChatEvent {
  final String uid;
  final String text;
  SendMessageEvent({required this.uid, required this.text});
}

/// BLoC para gerenciamento de chat por voz
class VoiceChatBloc extends Bloc<VoiceChatEvent, VoiceChatState> {
  final VoiceChatService _voiceChatService;

  VoiceChatBloc({VoiceChatService? service})
      : _voiceChatService = service ?? VoiceChatService(),
        super(const VoiceChatState()) {
    
    on<VoiceChatInitializeEvent>(_onInitialize);
    on<VoiceChatToggleListeningEvent>(_onToggleListening);
    on<VoiceChatStartListeningEvent>(_onStartListening);
    on<VoiceChatStopListeningEvent>(_onStopListening);
    on<VoiceChatProcessAudioEvent>(_onProcessAudio);
    on<VoiceChatClearErrorEvent>(_onClearError);
    on<VoiceChatUpdateMessageEvent>(_onUpdateMessage);
    on<LoadChatHistoryEvent>(_onLoadChatHistory);
    on<SendMessageEvent>(_onSendMessage);
  }

  /// Inicializa o serviço de voz
  Future<void> _onInitialize(
    VoiceChatInitializeEvent event,
    Emitter<VoiceChatState> emit,
  ) async {
    try {
      final result = await _voiceChatService.initialize();
      
      if (!result.success) {
        emit(state.copyWith(
          errorMessage: result.errorMessage,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Erro ao inicializar serviço de voz',
      ));
    }
  }

  /// Alterna estado de gravação
  Future<void> _onToggleListening(
    VoiceChatToggleListeningEvent event,
    Emitter<VoiceChatState> emit,
  ) async {
    if (state.isListening) {
      add(VoiceChatStopListeningEvent());
    } else {
      add(VoiceChatStartListeningEvent());
    }
  }

  /// Inicia gravação de áudio
  Future<void> _onStartListening(
    VoiceChatStartListeningEvent event,
    Emitter<VoiceChatState> emit,
  ) async {
    try {
      emit(state.copyWith(
        recordingState: VoiceRecordingState.listening,
        isListening: true,
        errorMessage: null,
      ));

      final result = await _voiceChatService.startListening();
      
      if (!result.success) {
        emit(state.copyWith(
          recordingState: VoiceRecordingState.error,
          isListening: false,
          errorMessage: result.errorMessage,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        recordingState: VoiceRecordingState.error,
        isListening: false,
        errorMessage: 'Erro ao iniciar gravação',
      ));
    }
  }

  /// Para gravação de áudio
  Future<void> _onStopListening(
    VoiceChatStopListeningEvent event,
    Emitter<VoiceChatState> emit,
  ) async {
    try {
      emit(state.copyWith(
        recordingState: VoiceRecordingState.processing,
        isListening: false,
      ));

      final stopResult = await _voiceChatService.stopListening();
      
      if (stopResult.success) {
        // Processa o áudio gravado
        add(VoiceChatProcessAudioEvent());
      } else {
        emit(state.copyWith(
          recordingState: VoiceRecordingState.error,
          errorMessage: stopResult.errorMessage,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        recordingState: VoiceRecordingState.error,
        errorMessage: 'Erro ao parar gravação',
      ));
    }
  }

  /// Processa áudio gravado
  Future<void> _onProcessAudio(
    VoiceChatProcessAudioEvent event,
    Emitter<VoiceChatState> emit,
  ) async {
    try {
      final result = await _voiceChatService.processAudio();
      
      if (result.success && result.message != null) {
        emit(state.copyWith(
          recordingState: VoiceRecordingState.idle,
          currentMessage: result.message!,
          errorMessage: null,
        ));
      } else {
        emit(state.copyWith(
          recordingState: VoiceRecordingState.error,
          errorMessage: result.errorMessage ?? 'Erro ao processar áudio',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        recordingState: VoiceRecordingState.error,
        errorMessage: 'Erro ao processar áudio',
      ));
    }
  }

  /// Limpa erro do estado
  Future<void> _onClearError(
    VoiceChatClearErrorEvent event,
    Emitter<VoiceChatState> emit,
  ) async {
    emit(state.copyWith(errorMessage: null));
  }

  /// Atualiza mensagem atual
  Future<void> _onUpdateMessage(
    VoiceChatUpdateMessageEvent event,
    Emitter<VoiceChatState> emit,
  ) async {
    emit(state.copyWith(currentMessage: event.message));
  }

  Future<void> _onLoadChatHistory(
    LoadChatHistoryEvent event,
    Emitter<VoiceChatState> emit,
  ) async {
    final messages = await _voiceChatService.getChatHistory(event.uid);
    emit(state.copyWith(messages: messages));
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<VoiceChatState> emit,
  ) async {
    final uuid = Uuid();
    final userMsg = ChatMessage(
      id: uuid.v4(),
      text: event.text,
      sender: 'user',
      timestamp: Timestamp.now(),
    );
    // Salvar mensagem do usuário
    await _voiceChatService.saveMessage(uid: event.uid, message: userMsg);
    final updatedMessages = List<ChatMessage>.from(state.messages)..add(userMsg);
    emit(state.copyWith(messages: updatedMessages, currentMessage: event.text));

    // Chamar Gemini
    try {
      final response = await _voiceChatService.getGeminiResponse(event.text);
      final llmMsg = ChatMessage(
        id: uuid.v4(),
        text: response,
        sender: 'llm',
        timestamp: Timestamp.now(),
      );
      await _voiceChatService.saveMessage(uid: event.uid, message: llmMsg);
      emit(state.copyWith(messages: [...updatedMessages, llmMsg], currentMessage: response));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Erro ao obter resposta da IA: $e'));
    }
  }

  @override
  Future<void> close() {
    _voiceChatService.dispose();
    return super.close();
  }
} 