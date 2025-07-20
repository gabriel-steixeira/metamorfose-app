/**
 * File: voice_chat_state.dart
 * Description: Estados para a tela de chat por voz.
 *
 * Responsabilidades:
 * - Definir estados de gravação de áudio
 * - Gerenciar estado de animações
 * - Estados de conversação
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/models/chat_message.dart';

/// Estados de gravação de áudio
enum VoiceRecordingState {
  idle,       // Não está gravando
  listening,  // Gravando áudio
  processing, // Processando áudio
  error,      // Erro na gravação
}

/// Estado principal do chat por voz
class VoiceChatState {
  final VoiceRecordingState recordingState;
  final bool isListening;
  final String? errorMessage;
  final String currentMessage;
  final bool animationsEnabled;
  final List<ChatMessage> messages;

  const VoiceChatState({
    this.recordingState = VoiceRecordingState.idle,
    this.isListening = false,
    this.errorMessage,
    this.currentMessage = 'Oi, eu sou Perona',
    this.animationsEnabled = true,
    this.messages = const [],
  });

  /// Cria uma cópia do estado com novos valores
  VoiceChatState copyWith({
    VoiceRecordingState? recordingState,
    bool? isListening,
    String? errorMessage,
    String? currentMessage,
    bool? animationsEnabled,
    List<ChatMessage>? messages,
  }) {
    return VoiceChatState(
      recordingState: recordingState ?? this.recordingState,
      isListening: isListening ?? this.isListening,
      errorMessage: errorMessage,
      currentMessage: currentMessage ?? this.currentMessage,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      messages: messages ?? this.messages,
    );
  }

  /// Getters de conveniência
  bool get isIdle => recordingState == VoiceRecordingState.idle;
  bool get isProcessing => recordingState == VoiceRecordingState.processing;
  bool get hasError => errorMessage != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VoiceChatState &&
        other.recordingState == recordingState &&
        other.isListening == isListening &&
        other.errorMessage == errorMessage &&
        other.currentMessage == currentMessage &&
        other.animationsEnabled == animationsEnabled &&
        listEquals(other.messages, messages);
  }

  @override
  int get hashCode {
    return recordingState.hashCode ^
        isListening.hashCode ^
        errorMessage.hashCode ^
        currentMessage.hashCode ^
        animationsEnabled.hashCode ^
        messages.hashCode;
  }

  @override
  String toString() {
    return 'VoiceChatState(recordingState: $recordingState, isListening: $isListening, currentMessage: $currentMessage, messages: ${messages.length})';
  }
} 