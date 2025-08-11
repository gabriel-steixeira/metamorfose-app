/// Modelo para representar uma mensagem no chat de voz
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? personality;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.personality,
  });

  /// Cria uma mensagem do usuário
  factory ChatMessage.user(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );
  }

  /// Cria uma mensagem do assistente
  factory ChatMessage.assistant(String content, String personality) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
      personality: personality,
    );
  }

  /// Converte para Map (útil para persistência)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'personality': personality,
    };
  }

  /// Cria a partir de Map
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      content: map['content'],
      isUser: map['isUser'],
      timestamp: DateTime.parse(map['timestamp']),
      personality: map['personality'],
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, content: $content, isUser: $isUser, timestamp: $timestamp, personality: $personality)';
  }
} 