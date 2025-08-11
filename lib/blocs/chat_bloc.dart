import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';

// Eventos do Chat
abstract class ChatEvent {}
class SendMessageEvent extends ChatEvent {
  final String message;
  final Map<String, dynamic>? userProfile;
  SendMessageEvent(this.message, {this.userProfile});
}

// Estado do Chat
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  ChatState({
    required this.messages,
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GeminiService geminiService;

  ChatBloc({required this.geminiService}) : super(ChatState(messages: [])) {
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final userMsg = ChatMessage(
      text: event.message,
      isUser: true,
      timestamp: DateTime.now(),
    );
    emit(state.copyWith(
      messages: List.from(state.messages)..add(userMsg),
      isLoading: true,
      error: null,
    ));
    try {
      final response = await geminiService.sendMessage(event.message, userProfile: event.userProfile);
      final botMsg = ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      emit(state.copyWith(
        messages: List.from(state.messages)..add(botMsg),
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Erro ao enviar mensagem: $e'));
    }
  }
}