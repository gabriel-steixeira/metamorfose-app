/**
 * File: breathing_exercise.dart
 * Description: Modelo para exercícios de respiração do SOS
 *
 * Responsabilidades:
 * - Definir estrutura de exercícios de respiração
 * - Gerenciar técnicas de respiração para emergências
 *
 * Author: Gabriel Teixeira
 * Created on: 19-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

class BreathingExercise {
  final String id;
  final String name;
  final String description;
  final String instructions;
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;
  final int cycles;
  final String? audioUrl;
  final bool isActive;

  const BreathingExercise({
    required this.id,
    required this.name,
    required this.description,
    required this.instructions,
    required this.inhaleSeconds,
    required this.holdSeconds,
    required this.exhaleSeconds,
    required this.cycles,
    this.audioUrl,
    this.isActive = true,
  });

  BreathingExercise copyWith({
    String? id,
    String? name,
    String? description,
    String? instructions,
    int? inhaleSeconds,
    int? holdSeconds,
    int? exhaleSeconds,
    int? cycles,
    String? audioUrl,
    bool? isActive,
  }) {
    return BreathingExercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      inhaleSeconds: inhaleSeconds ?? this.inhaleSeconds,
      holdSeconds: holdSeconds ?? this.holdSeconds,
      exhaleSeconds: exhaleSeconds ?? this.exhaleSeconds,
      cycles: cycles ?? this.cycles,
      audioUrl: audioUrl ?? this.audioUrl,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'instructions': instructions,
      'inhaleSeconds': inhaleSeconds,
      'holdSeconds': holdSeconds,
      'exhaleSeconds': exhaleSeconds,
      'cycles': cycles,
      'audioUrl': audioUrl,
      'isActive': isActive,
    };
  }

  factory BreathingExercise.fromJson(Map<String, dynamic> json) {
    return BreathingExercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      instructions: json['instructions'] as String,
      inhaleSeconds: json['inhaleSeconds'] as int,
      holdSeconds: json['holdSeconds'] as int,
      exhaleSeconds: json['exhaleSeconds'] as int,
      cycles: json['cycles'] as int,
      audioUrl: json['audioUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  int get totalDurationSeconds => 
      (inhaleSeconds + holdSeconds + exhaleSeconds) * cycles;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BreathingExercise &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.instructions == instructions &&
        other.inhaleSeconds == inhaleSeconds &&
        other.holdSeconds == holdSeconds &&
        other.exhaleSeconds == exhaleSeconds &&
        other.cycles == cycles &&
        other.audioUrl == audioUrl &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        instructions.hashCode ^
        inhaleSeconds.hashCode ^
        holdSeconds.hashCode ^
        exhaleSeconds.hashCode ^
        cycles.hashCode ^
        audioUrl.hashCode ^
        isActive.hashCode;
  }
}
