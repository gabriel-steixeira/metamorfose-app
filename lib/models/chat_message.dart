/**
 * File: chat_message.dart
 * Description: Modelo para mensagens do chat.
 *
 * Responsabilidades:
 * - Definir estrutura das mensagens
 * - Factory methods para criar mensagens
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

class ChatMessage {
  final String content;
  final bool isUser;
  final String sender;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    required this.sender,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ChatMessage.user(String content) =>
      ChatMessage(content: content, isUser: true, sender: 'Usuário');

  factory ChatMessage.assistant(String content, String sender) =>
      ChatMessage(content: content, isUser: false, sender: sender);

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        content: json['content'] as String,
        isUser: json['isUser'] as bool,
        sender: json['sender'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  Map<String, dynamic> toJson() => {
        'content': content,
        'isUser': isUser,
        'sender': sender,
        'timestamp': timestamp.toIso8601String(),
      };
}
