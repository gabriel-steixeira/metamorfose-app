/**
 * File: speech_services.dart
 * Description: Serviço robusto de reconhecimento e síntese de voz (STT e TTS) com tratamento de erros e otimizações.
 *
 * Responsabilidades:
 * - Inicializar e configurar Speech-To-Text (STT) com configurações otimizadas
 * - Inicializar e configurar Text-To-Speech (TTS) com voz preferencial e ajustes de fala
 * - Gerenciar estados internos do processo de voz (idle, ouvindo, processando, falando, erro)
 * - Emitir callbacks para monitoramento de estado, reconhecimento de texto e erros
 * - Controlar fluxo de gravação com timeout automático e resultados parciais
 * - Processar texto para melhor pronúncia antes da síntese
 * - Permitir verificação de permissões e obtenção de idiomas disponíveis
 * - Realizar parada segura e limpeza de recursos
 *
 * Author: Evelin Cordeiro
 * Created on: 08-08-2025
 * Last modified: 08-08-2025
 * 
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Estados do serviço de fala
enum SpeechState {
  idle,
  listening,
  processing,
  speaking,
  error
}

/// Configurações para Text-To-Speech (TTS) otimizadas para pt-BR.
class TTSConfig {
  static const String language = "pt-BR";
  static const double speechRate = 1.7;
  static const double pitch = 1.1;
  static const double volume = 1.0;
  static const Map<String, String> preferredVoice = {
    "name": "pt-BR-Standard-B", 
    "locale": "pt-BR"
  };
}

/// Configurações para Speech-To-Text (STT) otimizadas para pt_BR.
class STTConfig {
  static const String localeId = "pt_BR";
  static const Duration listenDuration = Duration(seconds: 30);
  static const Duration pauseDuration = Duration(seconds: 3);
  static const Duration timeoutDuration = Duration(seconds: 35);
}

/// Resultado do reconhecimento de voz contendo texto, sucesso, confiança e erro opcional.
class RecognitionResult {
  final String text;
  final bool isSuccess;
  final double confidence;
  final String? error;

  /// Construtor principal.
  const RecognitionResult({
    required this.text,
    required this.isSuccess,
    this.confidence = 0.0,
    this.error,
  });

  /// Factory para resultado de sucesso.
  factory RecognitionResult.success(String text, [double confidence = 1.0]) =>
      RecognitionResult(text: text, isSuccess: true, confidence: confidence);
  
  /// Factory para resultado de erro.
  factory RecognitionResult.error(String error) =>
      RecognitionResult(text: '', isSuccess: false, error: error);
}

/// Serviço principal para controle do reconhecimento (STT) e síntese (TTS) de voz.
class SpeechServices {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _stt = SpeechToText();
  
  bool _isInitialized = false;
  SpeechState _currentState = SpeechState.idle;
  String _lastRecognizedText = '';
  Timer? _listeningTimeout;
  
  /// Callbacks para monitoramento de estado, texto reconhecido e erros.
  Function(SpeechState)? onStateChanged;
  Function(String)? onTextRecognized;
  Function(String)? onError;

  /// Indica se os serviços foram inicializados.
  bool get isInitialized => _isInitialized;

  /// Estado atual do serviço (idle, listening, etc).
  SpeechState get currentState => _currentState;

  /// Indica se está gravando (ouvindo).
  bool get isRecording => _stt.isListening;

  /// Indica se está em fala (TTS).
  bool get isSpeaking => _currentState == SpeechState.speaking;

  /// Último texto reconhecido.
  String get lastRecognizedText => _lastRecognizedText;

  /// Atualiza estado interno e dispara callback.
  void _setState(SpeechState newState) {
    if (_currentState != newState) {
      _currentState = newState;
      onStateChanged?.call(newState);
      debugPrint('🔄 SpeechState: $newState');
    }
  }

  /// Inicializa TTS e STT com configurações e tratamento robusto de erros.
  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      _setState(SpeechState.processing);
      
      await _initializeTTS();
      
      final sttAvailable = await _stt.initialize(
        onStatus: (status) => debugPrint('📱 STT Status: $status'),
        onError: (error) {
          debugPrint('❌ STT Error: $error');
          onError?.call('Erro no reconhecimento: ${error.errorMsg}');
        },
      );
      
      if (!sttAvailable) {
        throw Exception('Reconhecimento de voz não disponível neste dispositivo');
      }
      
      _isInitialized = true;
      _setState(SpeechState.idle);
      debugPrint('✅ SpeechServices inicializado com sucesso');
      
    } catch (e) {
      _setState(SpeechState.error);
      debugPrint('❌ Erro na inicialização: $e');
      onError?.call('Erro ao inicializar serviços de voz');
      rethrow;
    }
  }

  /// Configura TTS com parâmetros, voz preferencial e handlers.
  Future<void> _initializeTTS() async {
    try {
      await _tts.setLanguage(TTSConfig.language);
      await _tts.setSpeechRate(TTSConfig.speechRate);
      await _tts.setPitch(TTSConfig.pitch);
      await _tts.setVolume(TTSConfig.volume);
      
      // Tenta setar voz específica (fallback silencioso)
      try {
        await _tts.setVoice(TTSConfig.preferredVoice);
        debugPrint('✅ Voz específica configurada');
      } catch (e) {
        debugPrint('⚠️ Voz específica não disponível, usando padrão');
      }
      
      // Tenta configurar queue mode (fallback silencioso)
      try {
        await _tts.setQueueMode(1);
      } catch (e) {
        debugPrint('⚠️ Queue mode não suportado');
      }
      
      // Configura handlers para eventos TTS
      _tts.setStartHandler(() => _setState(SpeechState.speaking));
      _tts.setCompletionHandler(() => _setState(SpeechState.idle));
      _tts.setErrorHandler((msg) {
        debugPrint('❌ TTS Error: $msg');
        _setState(SpeechState.error);
        onError?.call('Erro na síntese de voz');
      });
      
    } catch (e) {
      debugPrint('❌ Erro configurando TTS: $e');
      rethrow;
    }
  }

  /// Inicia gravação de voz com timeout automático.
  Future<void> startRecording() async {
    if (!_isInitialized) await init();
    
    if (_currentState == SpeechState.listening) {
      debugPrint('⚠️ Já está gravando');
      return;
    }

    try {
      _setState(SpeechState.listening);
      _lastRecognizedText = '';
      
      _listeningTimeout?.cancel();
      _listeningTimeout = Timer(STTConfig.timeoutDuration, () {
        debugPrint('⏰ Timeout de gravação');
        stopRecording();
      });

      await _stt.listen(
        onResult: (result) {
          _lastRecognizedText = result.recognizedWords;
          onTextRecognized?.call(_lastRecognizedText);
          debugPrint("🎤 Reconhecido: '$_lastRecognizedText' (${result.confidence})");
        },
        localeId: STTConfig.localeId,
        listenFor: STTConfig.listenDuration,
        pauseFor: STTConfig.pauseDuration,
        partialResults: true,
        onSoundLevelChange: (level) {
          // Pode ser usado para visualização do nível sonoro
        },
      );
      
      debugPrint('🎤 Gravação iniciada');
      
    } catch (e) {
      _setState(SpeechState.error);
      debugPrint('❌ Erro ao iniciar gravação: $e');
      onError?.call('Erro ao iniciar gravação');
      rethrow;
    }
  }

  /// Para gravação e retorna resultado final do reconhecimento.
  Future<RecognitionResult> stopRecording() async {
    try {
      _listeningTimeout?.cancel();
      
      if (_stt.isListening) {
        await _stt.stop();
      }
      
      _setState(SpeechState.processing);
      await Future.delayed(const Duration(milliseconds: 300));
      
      final result = _lastRecognizedText.trim();
      _setState(SpeechState.idle);
      
      if (result.isEmpty) {
        debugPrint('⚠️ Nenhum texto reconhecido');
        return RecognitionResult.error('Nenhum áudio detectado');
      }
      
      debugPrint('✅ Gravação finalizada: "$result"');
      return RecognitionResult.success(result);
      
    } catch (e) {
      _setState(SpeechState.error);
      debugPrint('❌ Erro ao parar gravação: $e');
      return RecognitionResult.error('Erro ao processar áudio');
    }
  }

  /// Método legado para obter texto reconhecido (compatibilidade).
  Future<String> stopRecordingLegacy() async {
    final result = await stopRecording();
    return result.isSuccess ? result.text : '';
  }

  /// Executa síntese de voz para o texto informado, com preprocessamento.
  Future<bool> speak(String text) async {
    if (!_isInitialized) await init();
    
    if (text.trim().isEmpty) {
      debugPrint('⚠️ Texto vazio para falar');
      return false;
    }

    try {
      await _tts.stop();
      _setState(SpeechState.speaking);
      
      final processedText = _preprocessText(text);
      debugPrint('🔊 Falando: "$processedText"');
      
      final result = await _tts.speak(processedText);
      if (result == 1) {
        debugPrint('✅ Síntese de voz concluída');
        return true;
      } else {
        throw Exception('TTS retornou código: $result');
      }
      
    } catch (e) {
      _setState(SpeechState.error);
      debugPrint('❌ Erro na síntese: $e');
      onError?.call('Erro ao reproduzir áudio');
      return false;
    }
  }

  /// Ajusta texto para melhorar pronúncia e fluidez.
  String _preprocessText(String text) {
    return text
        .replaceAll('...', '. ')
        .replaceAll('!!', '!')
        .replaceAll('??', '?')
        .replaceAll(' ,', ',')
        .replaceAll(' .', '.')
        .replaceAll('  ', ' ')
        .trim();
  }

  /// Para todos os processos de fala e reconhecimento.
  Future<void> stop() async {
    try {
      _listeningTimeout?.cancel();
      
      if (_stt.isListening) {
        await _stt.stop();
      }
      
      await _tts.stop();
      _setState(SpeechState.idle);
      
    } catch (e) {
      debugPrint('❌ Erro ao parar serviços: $e');
    }
  }

  /// Verifica se a permissão de microfone está concedida.
  Future<bool> checkMicrophonePermission() async {
    if (!_isInitialized) await init();
    return await _stt.hasPermission;
  }

  /// Obtém a lista de idiomas suportados para reconhecimento.
  Future<List<String>> getAvailableLocales() async {
    if (!_isInitialized) await init();
    final locales = await _stt.locales();
    return locales.map((locale) => locale.localeId).toList();
  }

  /// Limpeza e cancelamento de timers e serviços.
  void dispose() {
    _listeningTimeout?.cancel();
    stop();
  }
}
