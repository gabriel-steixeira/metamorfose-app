/**
 * File: calendar_photo.dart
 * Description: Modelo para fotos do calendário visual
 *
 * Responsabilidades:
 * - Definir estrutura de dados para fotos do calendário
 * - Incluir data, URL da imagem e descrição
 * - Suportar serialização para Firestore
 *
 * Author: Evelin Cordeiro
 * Created on: 31-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

/// Modelo para fotos do calendário visual
class CalendarPhoto {
  final String id;
  final DateTime date;
  final String imageUrl;
  final String? localPath; 
  final Uint8List? imageBytes; 
  final String? description;
  final String? plantId;
  final String? tip; 
  final DateTime createdAt;
  final DateTime updatedAt;

  CalendarPhoto({
    required this.id,
    required this.date,
    required this.imageUrl,
    this.localPath,
    this.imageBytes,
    this.description,
    this.plantId,
    this.tip,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria uma instância a partir de um documento do Firestore
  factory CalendarPhoto.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CalendarPhoto(
      id: doc.id,
      date: (data['date'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'] ?? '',
      localPath: data['localPath'],
      description: data['description'],
      plantId: data['plantId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Converte para um Map para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'imageUrl': imageUrl,
      'localPath': localPath,
      'description': description,
      'plantId': plantId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Cria uma cópia com novos valores
  CalendarPhoto copyWith({
    String? id,
    DateTime? date,
    String? imageUrl,
    String? localPath,
    Uint8List? imageBytes,
    String? description,
    String? plantId,
    String? tip,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CalendarPhoto(
      id: id ?? this.id,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      localPath: localPath ?? this.localPath,
      imageBytes: imageBytes ?? this.imageBytes,
      description: description ?? this.description,
      plantId: plantId ?? this.plantId,
      tip: tip ?? this.tip,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'CalendarPhoto(id: $id, date: $date, imageUrl: $imageUrl, localPath: $localPath, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CalendarPhoto && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
