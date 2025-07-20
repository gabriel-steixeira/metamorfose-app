import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String text;
  final String sender; // 'user' ou 'llm'
  final Timestamp timestamp;
  final String? userNotes;

  ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.userNotes,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      text: data['text'] ?? '',
      sender: data['sender'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      userNotes: data['user_notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'sender': sender,
      'timestamp': timestamp,
      if (userNotes != null) 'user_notes': userNotes,
    };
  }
} 