import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';

/// Serviço para streaming de áudio em Flutter
/// Baseado no audio-streamer.ts do copy-of-chatterbots
class AudioStreamerService {
  static const MethodChannel _channel = MethodChannel('audio_streamer');
  
  bool _isPlaying = false;
  bool _isInitialized = false;
  
  // Callbacks
  Function()? onComplete;
  Function(String error)? onError;

  /// Inicializa o serviço de áudio
  Future<bool> initialize() async {
    try {
      final result = await _channel.invokeMethod('initialize');
      _isInitialized = result == true;
      print('[AudioStreamer] Inicializado: $_isInitialized');
      return _isInitialized;
    } catch (e) {
      print('[AudioStreamer] Erro ao inicializar: $e');
      onError?.call('Erro ao inicializar áudio: $e');
      return false;
    }
  }

  /// Adiciona dados PCM16 para reprodução
  void addPCM16(Uint8List pcmData) {
    if (!_isInitialized) {
      print('[AudioStreamer] Não inicializado');
      return;
    }

    try {
      _channel.invokeMethod('addPCM16', {'data': pcmData});
      
      if (!_isPlaying) {
        _isPlaying = true;
        _startPlayback();
      }
    } catch (e) {
      print('[AudioStreamer] Erro ao adicionar PCM16: $e');
      onError?.call('Erro ao reproduzir áudio: $e');
    }
  }

  /// Inicia a reprodução
  void _startPlayback() async {
    try {
      await _channel.invokeMethod('startPlayback');
      print('[AudioStreamer] Reprodução iniciada');
    } catch (e) {
      print('[AudioStreamer] Erro ao iniciar reprodução: $e');
      onError?.call('Erro ao iniciar reprodução: $e');
    }
  }

  /// Para a reprodução
  void stop() async {
    try {
      await _channel.invokeMethod('stop');
      _isPlaying = false;
      print('[AudioStreamer] Reprodução parada');
    } catch (e) {
      print('[AudioStreamer] Erro ao parar reprodução: $e');
    }
  }

  /// Resume a reprodução
  void resume() async {
    try {
      await _channel.invokeMethod('resume');
      print('[AudioStreamer] Reprodução retomada');
    } catch (e) {
      print('[AudioStreamer] Erro ao retomar reprodução: $e');
    }
  }

  /// Marca como completo
  void complete() {
    _isPlaying = false;
    onComplete?.call();
    print('[AudioStreamer] Reprodução completa');
  }

  /// Verifica se está reproduzindo
  bool get isPlaying => _isPlaying;

  /// Verifica se está inicializado
  bool get isInitialized => _isInitialized;

  /// Libera recursos
  void dispose() {
    stop();
    _isInitialized = false;
  }
}

/// Implementação simplificada usando just_audio para PCM16
class SimpleAudioStreamerService {
  bool _isPlaying = false;
  final List<Uint8List> _audioQueue = [];
  Timer? _playbackTimer;
  
  // Callbacks
  Function()? onComplete;
  Function(String error)? onError;

  /// Inicializa o serviço
  Future<bool> initialize() async {
    print('[SimpleAudioStreamer] Inicializado');
    return true;
  }

  /// Adiciona dados PCM16 para reprodução (simulado)
  void addPCM16(Uint8List pcmData) {
    _audioQueue.add(pcmData);
    print('[SimpleAudioStreamer] Adicionado ${pcmData.length} bytes de áudio');
    
    if (!_isPlaying && _audioQueue.isNotEmpty) {
      _startPlayback();
    }
  }

  /// Simula reprodução de áudio
  void _startPlayback() {
    _isPlaying = true;
    print('[SimpleAudioStreamer] Iniciando reprodução simulada...');
    
    _playbackTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_audioQueue.isNotEmpty) {
        final chunk = _audioQueue.removeAt(0);
        print('[SimpleAudioStreamer] Reproduzindo chunk de ${chunk.length} bytes');
      } else {
        timer.cancel();
        _isPlaying = false;
        onComplete?.call();
        print('[SimpleAudioStreamer] Reprodução completa');
      }
    });
  }

  /// Para a reprodução
  void stop() {
    _playbackTimer?.cancel();
    _audioQueue.clear();
    _isPlaying = false;
    print('[SimpleAudioStreamer] Reprodução parada');
  }

  /// Resume a reprodução
  void resume() {
    if (_audioQueue.isNotEmpty && !_isPlaying) {
      _startPlayback();
    }
  }

  /// Marca como completo
  void complete() {
    stop();
    onComplete?.call();
  }

  /// Verifica se está reproduzindo
  bool get isPlaying => _isPlaying;

  /// Libera recursos
  void dispose() {
    stop();
  }
}
