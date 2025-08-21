/// File: text_chat_bloc.dart
/// Description: BLoC para gerenciar o chat de texto.
///
/// Responsabilidades:
/// - Gerenciar estado das mensagens
/// - Processar envio de mensagens
/// - Integrar com serviços de IA
///
/// Author: Gabriel Teixeira e Vitoria Lana
/// Created on: 29-05-2025
/// Last modified: 29-05-2025
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metamorfose_flutter/models/chat_message.dart';
import 'package:metamorfose_flutter/services/gemini_service.dart';

// Events
abstract class TextChatEvent {}

class SendMessageEvent extends TextChatEvent {
  final String message;
  final PersonalityType personality;
  
  SendMessageEvent(this.message, this.personality);
}

class ClearChatEvent extends TextChatEvent {}

// States
abstract class TextChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  
  const TextChatState({
    required this.messages,
    this.isLoading = false,
    this.error,
  });
}

class TextChatInitial extends TextChatState {
  TextChatInitial() : super(messages: [
    ChatMessage(
      content: 'Olá! Eu sou Perona, sua planta companheira! 🌿\n\nEstou aqui para te apoiar na sua jornada de superação e crescimento. Digite sua mensagem e eu responderei com carinho e sabedoria!',
      isUser: false,
      sender: 'Perona',
    ),
  ]);
}

class TextChatLoading extends TextChatState {
  const TextChatLoading(List<ChatMessage> messages) : super(messages: messages, isLoading: true);
}

class TextChatLoaded extends TextChatState {
  const TextChatLoaded(List<ChatMessage> messages) : super(messages: messages);
}

class TextChatError extends TextChatState {
  const TextChatError(List<ChatMessage> messages, String error) : super(messages: messages, error: error);
}

// BLoC
class TextChatBloc extends Bloc<TextChatEvent, TextChatState> {
  final GeminiService _geminiService;

  TextChatBloc(this._geminiService) : super(TextChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<ClearChatEvent>(_onClearChat);
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<TextChatState> emit) async {
    try {
      // Adiciona mensagem do usuário
      final updatedMessages = List<ChatMessage>.from(state.messages);
      updatedMessages.add(ChatMessage.user(event.message));
      
      emit(TextChatLoading(updatedMessages));

      // Define a personalidade no serviço e envia a mensagem usando o mesmo fluxo do VoiceChat
      _geminiService.setPersonalityByType(event.personality);
      final geminiResponse = await _geminiService.sendMessage(event.message);

      // Adiciona resposta da IA
      if (geminiResponse.isSuccess) {
        updatedMessages.add(ChatMessage.assistant(geminiResponse.text, 'Perona'));
      } else {
        updatedMessages.add(ChatMessage.assistant(
          'Desculpe, não consegui processar sua mensagem no momento. Pode tentar novamente?',
          'Perona'
        ));
      }
      emit(TextChatLoaded(updatedMessages));
      
    } catch (e) {
      final updatedMessages = List<ChatMessage>.from(state.messages);
      updatedMessages.add(ChatMessage.user(event.message));
      emit(TextChatError(updatedMessages, e.toString()));
    }
  }

  void _onClearChat(ClearChatEvent event, Emitter<TextChatState> emit) {
    emit(TextChatInitial());
  }
}
