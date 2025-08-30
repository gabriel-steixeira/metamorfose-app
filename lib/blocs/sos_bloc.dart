/**
 * File: sos_bloc.dart
 * Description: BLoC para gerenciamento do estado da tela do SOS
 *
 * Responsabilidades:
 * - Gerenciar contatos de emergência
 * - Controlar exercícios de respiração
 * - Processar ações do SOS
 * - Coordenar estados de loading e erro
 *
 * Author: Gabriel Teixeira
 * Created on: 19-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/state/sos/sos_state.dart';
import 'package:metamorfose_flutter/state/sos/sos_events.dart';
import 'package:metamorfose_flutter/services/sos_service.dart';
import 'package:metamorfose_flutter/models/breathing_exercise.dart';
import 'dart:async';

/// BLoC para a tela do SOS
class SosBloc extends Bloc<SosEvent, SosState> {
  final SosService _service;
  Timer? _breathingTimer;

  SosBloc({SosService? service})
      : _service = service ?? SosService(),
        super(const SosState()) {
    
    on<InitializeSosEvent>(_onInitialize);
    on<LoadEmergencyContactEvent>(_onLoadEmergencyContact);
    on<LoadExercisesEvent>(_onLoadExercises);
    on<ActivateSosEvent>(_onActivateSos);
    on<DeactivateSosEvent>(_onDeactivateSos);
    on<StartBreathingExerciseEvent>(_onStartBreathingExercise);
    on<StopBreathingExerciseEvent>(_onStopBreathingExercise);
    on<UpdateBreathingCycleEvent>(_onUpdateBreathingCycle);
    on<SaveEmergencyContactEvent>(_onSaveEmergencyContact);
    on<RemoveEmergencyContactEvent>(_onRemoveEmergencyContact);
    on<UpdateEmergencyContactEvent>(_onUpdateEmergencyContact);
    on<SendEmergencyMessageEvent>(_onSendEmergencyMessage);
    on<MakeEmergencyCallEvent>(_onMakeEmergencyCall);
    on<OpenWhatsAppEvent>(_onOpenWhatsApp);
    on<OpenNearbyPsychologistsEvent>(_onOpenNearbyPsychologists);
    on<ClearSosErrorEvent>(_onClearError);
  }

  /// Inicializa a tela carregando todos os dados
  Future<void> _onInitialize(
    InitializeSosEvent event,
    Emitter<SosState> emit,
  ) async {
    try {
      // Iniciar carregamento paralelo
      add(LoadEmergencyContactEvent());
      add(LoadExercisesEvent());
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Erro ao inicializar tela do SOS',
      ));
    }
  }

  /// Carrega contato de emergência
  Future<void> _onLoadEmergencyContact(
    LoadEmergencyContactEvent event,
    Emitter<SosState> emit,
  ) async {
    try {
      debugPrint('🔍 SOS BLoC - Carregando contato de emergência...');
      
      emit(state.copyWith(
        contactLoadingState: LoadingState.loading,
        contactError: null,
      ));

      final contacts = await _service.loadContacts();
      debugPrint('🔍 SOS BLoC - Contatos carregados: ${contacts.length}');
      
      // Pega apenas o primeiro contato ativo ou null se não houver
      final emergencyContact = contacts.isNotEmpty ? contacts.first : null;
      debugPrint('🔍 SOS BLoC - Contato selecionado: ${emergencyContact?.name} (ativo: ${emergencyContact?.isActive})');
      
      emit(state.copyWith(
        contactLoadingState: LoadingState.success,
        emergencyContact: emergencyContact,
        contactError: null,
      ));
      
      debugPrint('🔍 SOS BLoC - Estado emitido com sucesso');
    } catch (e) {
      debugPrint('🔍 SOS BLoC - Erro ao carregar contato: $e');
      emit(state.copyWith(
        contactLoadingState: LoadingState.error,
        contactError: e.toString(),
      ));
    }
  }

  /// Carrega exercícios de respiração
  Future<void> _onLoadExercises(
    LoadExercisesEvent event,
    Emitter<SosState> emit,
  ) async {
    try {
      emit(state.copyWith(
        exercisesLoadingState: LoadingState.loading,
        exercisesError: null,
      ));

      final exercises = await _service.loadExercises();
      
      emit(state.copyWith(
        exercisesLoadingState: LoadingState.success,
        exercises: exercises,
        exercisesError: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        exercisesLoadingState: LoadingState.error,
        exercisesError: e.toString(),
      ));
    }
  }

  /// Ativa o SOS
  void _onActivateSos(
    ActivateSosEvent event,
    Emitter<SosState> emit,
  ) {
    emit(state.copyWith(isSosActive: true));
  }

  /// Desativa o SOS
  void _onDeactivateSos(
    DeactivateSosEvent event,
    Emitter<SosState> emit,
  ) {
    emit(state.copyWith(isSosActive: false));
  }

  /// Inicia exercício de respiração
  void _onStartBreathingExercise(
    StartBreathingExerciseEvent event,
    Emitter<SosState> emit,
  ) {
    emit(state.copyWith(
      isBreathingActive: true,
      currentBreathingCycle: 1,
      totalBreathingCycles: event.exercise.cycles,
      currentBreathingPhase: 'inhale',
    ));
    
    _startBreathingTimer(event.exercise);
  }

  /// Para exercício de respiração
  void _onStopBreathingExercise(
    StopBreathingExerciseEvent event,
    Emitter<SosState> emit,
  ) {
    _breathingTimer?.cancel();
    emit(state.copyWith(
      isBreathingActive: false,
      currentBreathingCycle: 0,
      totalBreathingCycles: 0,
      currentBreathingPhase: 'inhale',
    ));
  }

  /// Atualiza ciclo de respiração
  void _onUpdateBreathingCycle(
    UpdateBreathingCycleEvent event,
    Emitter<SosState> emit,
  ) {
    emit(state.copyWith(
      currentBreathingCycle: event.currentCycle,
      totalBreathingCycles: event.totalCycles,
      currentBreathingPhase: event.currentPhase,
    ));
  }

  /// Salva contato de emergência
  Future<void> _onSaveEmergencyContact(
    SaveEmergencyContactEvent event,
    Emitter<SosState> emit,
  ) async {
    try {
      // ✅ VALIDAR se o contato tem dados válidos
      if (event.contact.name.trim().isEmpty || event.contact.phoneNumber.trim().isEmpty) {
        debugPrint('🗑️ SOS BLoC - ❌ Contato com dados inválidos, não salvando');
        emit(state.copyWith(
          errorMessage: 'Nome e telefone são obrigatórios',
        ));
        return;
      }
      
      // Se já existe um contato, remove primeiro
      if (state.emergencyContact != null) {
        await _service.removeContact(state.emergencyContact!.id);
      }
      
      await _service.addContact(event.contact);
      emit(state.copyWith(emergencyContact: event.contact));
      
      debugPrint('🗑️ SOS BLoC - ✅ Contato salvo com sucesso: ${event.contact.name}');
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Erro ao salvar contato: $e',
      ));
    }
  }

  /// Remove contato de emergência - IMPLEMENTAÇÃO SIMPLIFICADA
  Future<void> _onRemoveEmergencyContact(
    RemoveEmergencyContactEvent event,
    Emitter<SosState> emit,
  ) async {
    try {
      debugPrint('🗑️ SOS BLoC - ===== REMOÇÃO INICIADA =====');
      
      if (state.emergencyContact != null) {
        final contactName = state.emergencyContact!.name;
        final contactId = state.emergencyContact!.id;
        
        debugPrint('🗑️ SOS BLoC - Removendo contato: $contactName (ID: $contactId)');
        
        // 1. Remove do SharedPreferences
        await _service.removeContact(contactId);
        debugPrint('🗑️ SOS BLoC - ✅ Contato removido do SharedPreferences');
        
        // 2. Emite estado com contato null (SIMPLES E DIRETO)
        emit(state.copyWith(
          emergencyContact: null,
          contactLoadingState: LoadingState.success,
          contactError: null,
        ));
        
        debugPrint('🗑️ SOS BLoC - ✅ Estado emitido: emergencyContact = null');
        debugPrint('🗑️ SOS BLoC - ✅ hasEmergencyContact = false');
        
      } else {
        debugPrint('🗑️ SOS BLoC - ❌ Nenhum contato para remover');
        emit(state.copyWith(
          errorMessage: 'Nenhum contato de emergência para remover',
        ));
      }
      
      debugPrint('🗑️ SOS BLoC - ===== REMOÇÃO FINALIZADA =====');
      
    } catch (e) {
      debugPrint('🗑️ SOS BLoC - ❌ ERRO na remoção: $e');
      emit(state.copyWith(
        errorMessage: 'Erro ao remover contato: $e',
      ));
    }
  }

  /// Atualiza contato de emergência
  Future<void> _onUpdateEmergencyContact(
    UpdateEmergencyContactEvent event,
    Emitter<SosState> emit,
  ) async {
    try {
      await _service.updateContact(event.contact);
      emit(state.copyWith(emergencyContact: event.contact));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Erro ao atualizar contato: $e',
      ));
    }
  }

  /// Envia mensagem de emergência
  Future<void> _onSendEmergencyMessage(
    SendEmergencyMessageEvent event,
    Emitter<SosState> emit,
  ) async {
    try {
      await _service.sendSMS(event.contact, customMessage: event.customMessage);
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Erro ao enviar mensagem: $e',
      ));
    }
  }

  /// Faz chamada de emergência
  Future<void> _onMakeEmergencyCall(
    MakeEmergencyCallEvent event,
    Emitter<SosState> emit,
  ) async {
    try {
      debugPrint('📞 SOS BLoC - Recebido MakeEmergencyCallEvent para: ${event.contact.name} - ${event.contact.phoneNumber}');
      debugPrint('📞 SOS BLoC - Chamando _service.makeCall...');
      await _service.makeCall(event.contact);
      debugPrint('📞 SOS BLoC - _service.makeCall executado com sucesso');
    } catch (e) {
      debugPrint('📞 SOS BLoC - Erro na chamada: $e');
      emit(state.copyWith(
        errorMessage: 'Erro ao fazer chamada: $e',
      ));
    }
  }

  /// Abre WhatsApp
  Future<void> _onOpenWhatsApp(
    OpenWhatsAppEvent event,
    Emitter<SosState> emit,
  ) async {
    try {
      debugPrint('💬 SOS BLoC - Recebido OpenWhatsAppEvent para: ${event.contact.name} - ${event.contact.phoneNumber}');
      debugPrint('💬 SOS BLoC - Chamando _service.openWhatsApp...');
      await _service.openWhatsApp(event.contact, customMessage: event.customMessage);
      debugPrint('💬 SOS BLoC - _service.openWhatsApp executado com sucesso');
    } catch (e) {
      debugPrint('💬 SOS BLoC - Erro no WhatsApp: $e');
      emit(state.copyWith(
        errorMessage: 'Erro ao abrir WhatsApp: $e',
      ));
    }
  }

  /// Abre mapa com psicólogos próximos
  Future<void> _onOpenNearbyPsychologists(
    OpenNearbyPsychologistsEvent event,
    Emitter<SosState> emit,
  ) async {
    try {
      await _service.openNearbyPsychologists();
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Erro ao abrir mapa: $e',
      ));
    }
  }

  /// Limpa erros
  void _onClearError(
    ClearSosErrorEvent event,
    Emitter<SosState> emit,
  ) {
    emit(state.copyWith(
      errorMessage: null,
      contactError: null,
      exercisesError: null,
    ));
  }

  /// Recarrega dados
  Future<void> _onRefreshSosData(
    RefreshSosDataEvent event,
    Emitter<SosState> emit,
  ) async {
    add(LoadEmergencyContactEvent());
    add(LoadExercisesEvent());
  }

  /// Inicia timer para exercício de respiração
  void _startBreathingTimer(BreathingExercise exercise) {
    int currentCycle = 1;
    int currentPhaseIndex = 0;
    final phases = ['inhale', 'hold', 'exhale'];
    final durations = [
      exercise.inhaleSeconds,
      exercise.holdSeconds,
      exercise.exhaleSeconds,
    ];

    _breathingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentCycle > exercise.cycles) {
        timer.cancel();
        add(StopBreathingExerciseEvent());
        return;
      }

      final currentPhase = phases[currentPhaseIndex];
      final currentDuration = durations[currentPhaseIndex];

      add(UpdateBreathingCycleEvent(
        currentCycle: currentCycle,
        totalCycles: exercise.cycles,
        currentPhase: currentPhase,
      ));

      if (currentPhaseIndex < phases.length - 1) {
        currentPhaseIndex++;
      } else {
        currentPhaseIndex = 0;
        currentCycle++;
      }
    });
  }

  @override
  Future<void> close() {
    _breathingTimer?.cancel();
    return super.close();
  }
}
