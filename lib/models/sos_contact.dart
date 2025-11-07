/**
 * File: sos_contact.dart
 * Description: Modelo para contatos de emergência do SOS
 *
 * Responsabilidades:
 * - Definir estrutura de contatos de confiança
 * - Gerenciar informações de contato para emergências
 *
 * Author: Gabriel Teixeira
 * Created on: 19-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

class SosContact {
  final String id;
  final String name;
  final String phoneNumber;
  final String? message;
  final bool isActive;
  final DateTime createdAt;

  const SosContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.message,
    this.isActive = true,
    required this.createdAt,
  });

  SosContact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? message,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return SosContact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      message: message ?? this.message,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'message': message,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SosContact.fromJson(Map<String, dynamic> json) {
    return SosContact(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      message: json['message'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SosContact &&
        other.id == id &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.message == message &&
        other.isActive == isActive &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        phoneNumber.hashCode ^
        message.hashCode ^
        isActive.hashCode ^
        createdAt.hashCode;
  }
}
