/**
 * File: text_chat_bloc.dart
 * Description: Gerencia a lógica de chat de texto com controle de estado, eventos e comunicação com IA.
 *
 * Responsabilidades:
 * - Controlar estados do chat de texto (carregamento, mensagens, erros)
 * - Processar mensagens de texto com o serviço Gemini (IA)
 * - Gerenciar mudança de personalidade da IA
 * - Emitir estados atualizados para UI e lógica reativa via Bloc
 * - Oferecer diagnóstico interno para debug e monitoramento
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 08-08-2025
 * Last modified: 31-08-2025
 * 
 * Changes:
 * - Implementação inicial do TextChatBloc com controle de fluxo de texto e IA (Evelin Cordeiro)
 * - Correção do isFirstMessage para preservar estado durante carregamento
 * 
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:metamorfose_flutter/models/chat_message.dart';
import 'package:metamorfose_flutter/services/gemini_service.dart';
import 'package:metamorfose_flutter/models/user_model.dart';

// Events
abstract class TextChatEvent {}

class SendMessageEvent extends TextChatEvent {
  final String message;
  final PersonalityType personality;
  final String? plantName;
  final UserModel? user;

  SendMessageEvent(this.message, this.personality, {this.plantName, this.user});
}

class ClearChatEvent extends TextChatEvent {}

class InitializeWithWelcomeEvent extends TextChatEvent {
  final String? plantName;

  InitializeWithWelcomeEvent({this.plantName});
}

class ResetConversationEvent extends TextChatEvent {}

// States
abstract class TextChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final bool isFirstMessage;

  const TextChatState({
    required this.messages,
    this.isLoading = false,
    this.error,
    this.isFirstMessage = false,
  });
}

class TextChatInitial extends TextChatState {
  const TextChatInitial() : super(messages: const []);
}

class TextChatWithWelcome extends TextChatState {
  TextChatWithWelcome({String? plantName})
      : super(messages: [
          ChatMessage(
            content: 'Como posso te ajudar hoje?',
            isUser: false,
            sender: plantName ?? 'Plantinha',
          ),
        ], isFirstMessage: true);
}

class TextChatLoading extends TextChatState {
  const TextChatLoading(List<ChatMessage> messages,
      {bool isFirstMessage = false})
      : super(
            messages: messages,
            isLoading: true,
            isFirstMessage: isFirstMessage);
}

class TextChatLoaded extends TextChatState {
  const TextChatLoaded(List<ChatMessage> messages,
      {bool isFirstMessage = false})
      : super(messages: messages, isFirstMessage: isFirstMessage);
}

class TextChatError extends TextChatState {
  const TextChatError(List<ChatMessage> messages, String error)
      : super(messages: messages, error: error);
}

// BLoC
class TextChatBloc extends Bloc<TextChatEvent, TextChatState> {
  final GeminiService _geminiService;

  TextChatBloc(this._geminiService) : super(const TextChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<ClearChatEvent>(_onClearChat);
    on<InitializeWithWelcomeEvent>(_onInitializeWithWelcome);
    on<ResetConversationEvent>(_onResetConversation);
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<TextChatState> emit) async {
    try {
      final updatedMessages = List<ChatMessage>.from(state.messages);
      updatedMessages.add(ChatMessage.user(event.message));

      emit(TextChatLoading(updatedMessages,
          isFirstMessage: state.isFirstMessage));

      _geminiService.setPersonalityByType(event.personality);

      final userName = state.isFirstMessage ? event.user?.name : null;

      debugPrint(
          '💬 Text Chat - isFirstMessage: ${state.isFirstMessage}, userName: $userName, plantName: ${event.plantName}');

      final geminiResponse = await _geminiService.sendMessage(event.message,
          plantName: event.plantName, user: event.user);

      final plantName = event.plantName ?? 'Plantinha';
      if (geminiResponse.isSuccess) {
        updatedMessages
            .add(ChatMessage.assistant(geminiResponse.text, plantName));
      } else {
        updatedMessages.add(ChatMessage.assistant(
            'Desculpe, não consegui processar sua mensagem no momento. Pode tentar novamente?',
            plantName));
      }
      emit(TextChatLoaded(updatedMessages, isFirstMessage: false));
    } catch (e) {
      final updatedMessages = List<ChatMessage>.from(state.messages);
      updatedMessages.add(ChatMessage.user(event.message));
      emit(TextChatError(updatedMessages, e.toString()));
    }
  }

  void _onClearChat(ClearChatEvent event, Emitter<TextChatState> emit) {
    emit(const TextChatInitial());
  }

  void _onInitializeWithWelcome(
      InitializeWithWelcomeEvent event, Emitter<TextChatState> emit) {
    emit(TextChatWithWelcome(plantName: event.plantName));
  }

  void _onResetConversation(
      ResetConversationEvent event, Emitter<TextChatState> emit) {
    final currentMessages = state.messages;
    emit(TextChatLoaded(currentMessages, isFirstMessage: true));
  }
}
