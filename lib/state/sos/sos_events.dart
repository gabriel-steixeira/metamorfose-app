/**
 * File: sos_events.dart
 * Description: Eventos do BLoC do SOS do Metamorfose
 *
 * Responsabilidades:
 * - Definir eventos para gerenciar contato de emergência único
 * - Controlar exercícios de respiração
 * - Gerenciar ações do SOS
 *
 * Author: Gabriel Teixeira
 * Created on: 19-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:metamorfose_flutter/models/sos_contact.dart';
import 'package:metamorfose_flutter/models/breathing_exercise.dart';

/// Eventos do SosBloc
abstract class SosEvent {}

/// Evento para inicializar a tela do SOS
class InitializeSosEvent extends SosEvent {}

/// Evento para carregar contato de emergência
class LoadEmergencyContactEvent extends SosEvent {}

/// Evento para carregar exercícios de respiração
class LoadExercisesEvent extends SosEvent {}

/// Evento para ativar o SOS
class ActivateSosEvent extends SosEvent {}

/// Evento para desativar o SOS
class DeactivateSosEvent extends SosEvent {}

/// Evento para iniciar exercício de respiração
class StartBreathingExerciseEvent extends SosEvent {
  final BreathingExercise exercise;

  StartBreathingExerciseEvent(this.exercise);
}

/// Evento para parar exercício de respiração
class StopBreathingExerciseEvent extends SosEvent {}

/// Evento para atualizar ciclo de respiração
class UpdateBreathingCycleEvent extends SosEvent {
  final int currentCycle;
  final int totalCycles;
  final String currentPhase;

  UpdateBreathingCycleEvent({
    required this.currentCycle,
    required this.totalCycles,
    required this.currentPhase,
  });
}

/// Evento para salvar contato de emergência (substitui o anterior se existir)
class SaveEmergencyContactEvent extends SosEvent {
  final SosContact contact;

  SaveEmergencyContactEvent(this.contact);
}

/// Evento para remover contato de emergência
class RemoveEmergencyContactEvent extends SosEvent {}

/// Evento para atualizar contato de emergência
class UpdateEmergencyContactEvent extends SosEvent {
  final SosContact contact;

  UpdateEmergencyContactEvent(this.contact);
}

/// Evento para enviar mensagem de emergência via WhatsApp
class SendEmergencyMessageEvent extends SosEvent {
  final SosContact contact;
  final String? customMessage;

  SendEmergencyMessageEvent(this.contact, {this.customMessage});
}

/// Evento para fazer chamada de emergência
class MakeEmergencyCallEvent extends SosEvent {
  final SosContact contact;

  MakeEmergencyCallEvent(this.contact);
}

/// Evento para abrir WhatsApp
class OpenWhatsAppEvent extends SosEvent {
  final SosContact contact;
  final String? customMessage;

  OpenWhatsAppEvent(this.contact, {this.customMessage});
}

/// Evento para abrir psicólogos próximos
class OpenNearbyPsychologistsEvent extends SosEvent {}

/// Evento para limpar erros
class ClearSosErrorEvent extends SosEvent {}

/// Evento para recarregar dados
class RefreshSosDataEvent extends SosEvent {}
