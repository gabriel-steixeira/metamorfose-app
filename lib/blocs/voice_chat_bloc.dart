/**
 * File: voice_chat_bloc.dart
 * Description: Gerencia a lógica de voz do chat com controle de estado, eventos e comunicação com serviços de fala e IA.
 *
 * Responsabilidades:
 * - Controlar estados do chat de voz (gravação, processamento, fala, erros)
 * - Inicializar e gerenciar serviços de reconhecimento de voz e síntese
 * - Processar mensagens de voz com o serviço Gemini (IA)
 * - Gerenciar mudança de personalidade da IA com resposta vocal
 * - Emitir estados atualizados para UI e lógica reativa via Bloc
 * - Oferecer diagnóstico interno para debug e monitoramento
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 08-08-2025
 * Last modified: 08-08-2025
 * 
 * Changes:
 * - Implementação inicial do VoiceChatBloc com controle de fluxo de voz e IA (Evelin Cordeiro)
 * 
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/speech_service.dart';
import '../services/gemini_service.dart';

/// Estado atual do chat de voz, contendo mensagem, flags de estado, personalidade e confiança do reconhecimento.
class VoiceChatState {
  final String currentMessage;
  final bool isRecording;
  final bool isProcessing;
  final bool isSpeaking;
  final bool hasError;
  final String? errorMessage;
  final PersonalityType currentPersonality;
  final SpeechState speechState;
  final double confidence;

  /// Construtor com valores padrão.
  const VoiceChatState({
    this.currentMessage = 'Oi, eu sou Perona! Como está hoje?',
    this.isRecording = false,
    this.isProcessing = false,
    this.isSpeaking = false,
    this.hasError = false,
    this.errorMessage,
    this.currentPersonality = PersonalityType.padrao,
    this.speechState = SpeechState.idle,
    this.confidence = 0.0,
  });

  /// Retorna uma cópia do estado atual com campos opcionais atualizados.
  VoiceChatState copyWith({
    String? currentMessage,
    bool? isRecording,
    bool? isProcessing,
    bool? isSpeaking,
    bool? hasError,
    String? errorMessage,
    PersonalityType? currentPersonality,
    SpeechState? speechState,
    double? confidence,
  }) {
    return VoiceChatState(
      currentMessage: currentMessage ?? this.currentMessage,
      isRecording: isRecording ?? this.isRecording,
      isProcessing: isProcessing ?? this.isProcessing,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPersonality: currentPersonality ?? this.currentPersonality,
      speechState: speechState ?? this.speechState,
      confidence: confidence ?? this.confidence,
    );
  }

  /// Indica se está em operação (gravando, processando ou falando).
  bool get isBusy => isRecording || isProcessing || isSpeaking;

  /// Indica se é possível iniciar gravação (estado idle e não ocupado).
  bool get canStartRecording => speechState == SpeechState.idle && !isBusy;
}

/// Eventos que o VoiceChatBloc pode receber para alterar estado ou executar ações.
abstract class VoiceChatEvent {}

/// Evento para inicializar serviços.
class VoiceChatInitializeEvent extends VoiceChatEvent {}

/// Evento para alternar entre iniciar/parar gravação.
class VoiceChatToggleListeningEvent extends VoiceChatEvent {}

/// Evento para limpar erros atuais.
class VoiceChatClearErrorEvent extends VoiceChatEvent {}

/// Evento para parar todos os processos (gravação, fala, etc).
class VoiceChatStopAllEvent extends VoiceChatEvent {}

/// Evento para trocar a personalidade da IA.
class VoiceChatChangePersonalityEvent extends VoiceChatEvent {
  final PersonalityType personality;
  final bool silent; // Se true, não emite mensagem de confirmação
  
  VoiceChatChangePersonalityEvent(this.personality, {this.silent = false});
}

/// Evento para atualizar estado do reconhecimento/fala.
class VoiceChatUpdateStateEvent extends VoiceChatEvent {
  final SpeechState speechState;
  VoiceChatUpdateStateEvent(this.speechState);
}

/// Bloc responsável pelo gerenciamento do chat de voz, integração com serviços de voz e IA.
class VoiceChatBloc extends Bloc<VoiceChatEvent, VoiceChatState> {
  final SpeechServices _speechServices = SpeechServices();
  final GeminiService _geminiService = GeminiService();
  bool _isInitialized = false;

  /// Construtor que configura os handlers para os eventos e callbacks dos serviços.
  VoiceChatBloc({PersonalityType? initialPersonality}) : super(VoiceChatState(
    currentPersonality: initialPersonality ?? PersonalityType.padrao,
  )) {
    on<VoiceChatInitializeEvent>(_onInitialize);
    on<VoiceChatToggleListeningEvent>(_onToggleListening);
    on<VoiceChatClearErrorEvent>(_onClearError);
    on<VoiceChatChangePersonalityEvent>(_onChangePersonality);
    on<VoiceChatStopAllEvent>(_onStopAll);
    on<VoiceChatUpdateStateEvent>(_onUpdateState);
    
    _setupSpeechCallbacks();
  }

  /// Configura callbacks do serviço de fala para enviar eventos ao Bloc.
  void _setupSpeechCallbacks() {
    _speechServices.onStateChanged = (speechState) {
      add(VoiceChatUpdateStateEvent(speechState));
    };
    
    _speechServices.onTextRecognized = (text) {
      debugPrint('📝 Texto reconhecido em tempo real: "$text"');
    };
    
    _speechServices.onError = (error) {
      add(VoiceChatClearErrorEvent());
    };
  }

  /// Inicializa serviços de fala e verifica permissões.
  Future<void> _onInitialize(
    VoiceChatInitializeEvent event,
    Emitter<VoiceChatState> emit,
  ) async {
    if (_isInitialized) return;
    
    try {
      debugPrint('🚀 Inicializando serviços...');
      
      emit(state.copyWith(
        isProcessing: true,
        currentMessage: 'Inicializando...'
      ));

      final hasPermission = await _speechServices.checkMicrophonePermission();
      if (!hasPermission) {
        throw Exception('Permissão de microfone necessária');
      }

      await _speechServices.init();
      _isInitialized = true;
      
      emit(state.copyWith(
        isProcessing: false,
        // Não sobrescrever a personalidade atual se já foi definida
        currentMessage: 'Oi, eu sou Perona! Como está hoje?',
        speechState: SpeechState.idle
      ));
      
      debugPrint('✅ Inicialização completa');
      
    } catch (e) {
      debugPrint('❌ Falha na inicialização: $e');
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Erro ao inicializar: ${e.toString()}',
        isProcessing: false,
        speechState: SpeechState.error
      ));
    }
  }

  /// Alterna entre iniciar e parar a gravação, incluindo processamento do texto e resposta via IA.
  Future<void> _onToggleListening(
    VoiceChatToggleListeningEvent event,
    Emitter<VoiceChatState> emit,
  ) async {
    if (!_isInitialized) {
      await _onInitialize(VoiceChatInitializeEvent(), emit);
      if (!_isInitialized) return;
    }

    try {
      if (state.isRecording) {
        debugPrint('🛑 Parando gravação...');
        
        emit(state.copyWith(
          isRecording: false,
          isProcessing: true,
          currentMessage: "Processando seu áudio..."
        ));

        final result = await _speechServices.stopRecording();
        
        if (!result.isSuccess || result.text.trim().isEmpty) {
          emit(state.copyWith(
            currentMessage: result.error ?? "Não consegui ouvir. Tente novamente!",
            isProcessing: false
          ));
          return;
        }

        debugPrint('📝 Texto final: "${result.text}" (confiança: ${result.confidence})');
        
        emit(state.copyWith(
          currentMessage: "Pensando na resposta...",
          confidence: result.confidence
        ));
        
        final geminiResponse = await _geminiService.sendMessage(result.text);
        
        if (!geminiResponse.isSuccess) {
          throw Exception(geminiResponse.error ?? 'Erro no processamento');
        }
        
        emit(state.copyWith(
          currentMessage: geminiResponse.text,
          isProcessing: false
        ));
        
        debugPrint('🔊 Reproduzindo resposta...');
        final speakSuccess = await _speechServices.speak(geminiResponse.text);
        
        if (!speakSuccess) {
          debugPrint('⚠️ Falha na síntese, mas continuando...');
        }
        
      } else {
        if (!state.canStartRecording) {
          debugPrint('⚠️ Não pode iniciar gravação no estado atual');
          return;
        }
        
        debugPrint('🎤 Iniciando gravação...');
        
        await _speechServices.startRecording();
        
        emit(state.copyWith(
          isRecording: true,
          currentMessage: "Estou te ouvindo...",
          isProcessing: false,
          hasError: false,
          errorMessage: null
        ));
      }
      
    } catch (e) {
      debugPrint('❌ Erro no toggle: $e');
      
      await _speechServices.stop();
      
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Erro: ${e.toString()}',
        isRecording: false,
        isProcessing: false,
        isSpeaking: false,
        currentMessage: 'Ops! Algo deu errado. Tente novamente.',
        speechState: SpeechState.error
      ));
    }
  }

  /// Atualiza estado interno baseado no estado do serviço de fala.
  void _onUpdateState(
    VoiceChatUpdateStateEvent event,
    Emitter<VoiceChatState> emit,
  ) {
    emit(state.copyWith(
      speechState: event.speechState,
      isSpeaking: event.speechState == SpeechState.speaking,
      isProcessing: event.speechState == SpeechState.processing
    ));
  }

  /// Para todos os serviços de fala e reseta o estado.
  Future<void> _onStopAll(
    VoiceChatStopAllEvent event,
    Emitter<VoiceChatState> emit,
  ) async {
    try {
      await _speechServices.stop();
      
      emit(state.copyWith(
        isRecording: false,
        isProcessing: false,
        isSpeaking: false,
        speechState: SpeechState.idle,
        currentMessage: 'Pronto! Como posso ajudar?'
      ));
      
    } catch (e) {
      debugPrint('❌ Erro ao parar serviços: $e');
    }
  }

  /// Limpa estado de erro.
  void _onClearError(
    VoiceChatClearErrorEvent event,
    Emitter<VoiceChatState> emit,
  ) {
    emit(state.copyWith(
      hasError: false, 
      errorMessage: null,
      speechState: SpeechState.idle
    ));
  }

  /// Altera a personalidade do assistente e confirma por voz.
  Future<void> _onChangePersonality(
    VoiceChatChangePersonalityEvent event,
    Emitter<VoiceChatState> emit,
  ) async {
    try {
      final newPersonality = event.personality;
      
      if (newPersonality == state.currentPersonality) {
        debugPrint('🎭 Personalidade já é ${newPersonality.id}');
        return;
      }

      debugPrint('🎭 Mudando personalidade: ${state.currentPersonality.id} → ${newPersonality.id}');
      
      if (state.isSpeaking) {
        await _speechServices.stop();
      }
      
      _geminiService.setPersonalityByType(newPersonality);
      
      // Se for uma mudança silenciosa (personalidade inicial), não emitir mensagem
      if (event.silent) {
        emit(state.copyWith(
          currentPersonality: newPersonality,
        ));
        debugPrint('✅ Personalidade inicial aplicada silenciosamente');
        return;
      }
      
      // Mensagem para mudança manual de personalidade
      final displayMessage = 'Personalidade alterada para ${newPersonality.label}!';
      final speakMessage = 'Mudei para ${newPersonality.label.substring(2)}!';
      
      emit(state.copyWith(
        currentPersonality: newPersonality,
        currentMessage: displayMessage
      ));
      
      await _speechServices.speak(speakMessage);
      
      debugPrint('✅ Personalidade alterada com sucesso');
      
    } catch (e) {
      debugPrint('❌ Erro ao alterar personalidade: $e');
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Erro ao mudar personalidade: ${e.toString()}'
      ));
    }
  }

  /// Retorna informações para diagnóstico interno do Bloc e serviços.
  Map<String, dynamic> getDiagnosticInfo() {
    return {
      'bloc_state': {
        'current_message': state.currentMessage,
        'is_recording': state.isRecording,
        'is_processing': state.isProcessing,
        'is_speaking': state.isSpeaking,
        'has_error': state.hasError,
        'personality': state.currentPersonality.id,
        'speech_state': state.speechState.toString(),
        'confidence': state.confidence,
      },
      'services': {
        'speech_initialized': _speechServices.isInitialized,
        'speech_state': _speechServices.currentState.toString(),
        'gemini_info': _geminiService.getDiagnosticInfo(),
      },
      'system': {
        'bloc_initialized': _isInitialized,
        'timestamp': DateTime.now().toIso8601String(),
      }
    };
  }

  /// Fecha os serviços corretamente ao destruir o Bloc.
  @override
  Future<void> close() async {
    debugPrint('🔄 Fechando VoiceChatBloc...');
    await _speechServices.stop();
    _speechServices.dispose();
    return super.close();
  }
}
