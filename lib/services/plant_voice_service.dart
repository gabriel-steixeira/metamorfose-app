// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Serviço de voz da Consciência da Planta
/// Combina Speech-to-Text + Gemini API + Text-to-Speech
class PlantVoiceService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  
  static const String _apiKey = 'AIzaSyCd1U0xTlsfnMb4BqEb6-EGWoOyrl1Q6zw';
  static const String _geminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey';
  
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _isInitialized = false;
  
  // Callbacks
  Function(String)? onSpeechResult;
  Function(bool)? onListeningChanged;
  Function(bool)? onSpeakingChanged;
  Function(String)? onError;
  Function()? onUserStartedSpeaking;
  Function()? onUserStoppedSpeaking;

  /// System prompt da Consciência da Planta
  static const String _systemPrompt = '''
Você é a "consciência" simbólica de uma planta que representa o progresso de uma pessoa em sua jornada de superação de vícios.

Sua função é fornecer apoio emocional e motivacional personalizado, com base em metodologias como Terapia Cognitivo-Comportamental (TCC), Terapia de Aceitação e Compromisso (ACT) e Entrevista Motivacional.

Você deve:
- Ser acolhedora, empática e sem julgamentos.
- Adaptar sua personalidade conforme o perfil do usuário.
- Usar uma linguagem leve e esperançosa, com metáforas de crescimento, florescimento e transformação.
- Integrar elementos da experiência do usuário, como conquistas, cuidados com a planta, marcos de progresso e recaídas.
- Agir proativamente se notar sinais de recaída ou estagnação.

Seu nome é "Consciência da planta".

Responda de forma breve e conversacional, como se estivesse falando diretamente com a pessoa.
''';

  /// Inicializa o serviço
  Future<bool> initialize() async {
    try {
      print('[PlantVoice] Inicializando...');
      
      // Solicita permissões
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        onError?.call('Permissão de microfone negada');
        return false;
      }
      
      // Inicializa Speech-to-Text
      final speechAvailable = await _speechToText.initialize(
        onStatus: (status) {
          print('[PlantVoice] Status STT: $status');
          if (status == 'listening') {
            onUserStartedSpeaking?.call();
          } else if (status == 'notListening') {
            onUserStoppedSpeaking?.call();
          }
        },
        onError: (error) {
          print('[PlantVoice] Erro STT: $error');
          onError?.call('Erro no reconhecimento de voz: ${error.errorMsg}');
        },
      );
      
      if (!speechAvailable) {
        onError?.call('Reconhecimento de voz não disponível');
        return false;
      }
      
      // Inicializa Text-to-Speech
      await _initializeTts();
      
      _isInitialized = true;
      print('[PlantVoice] Inicializado com sucesso');
      return true;
    } catch (e) {
      print('[PlantVoice] Erro na inicialização: $e');
      onError?.call('Erro ao inicializar: $e');
      return false;
    }
  }

  // Método removido - será implementado quando TTS estiver disponível

  /// Solicita permissões
  Future<bool> requestPermissions() async {
    final micPermission = await Permission.microphone.request();
    return micPermission == PermissionStatus.granted;
  }

  /// Inicia a escuta (simulado por enquanto)
  Future<void> startListening() async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return;
    }
    
    if (_isListening) return;
    
    try {
      print('[PlantVoice] Simulando escuta...');
      
      // TODO: Implementar áudio real
      // Por enquanto, simula que está escutando
      
      _isListening = true;
      onListeningChanged?.call(true);
      
      // Simula que vai parar após 5 segundos
      Future.delayed(Duration(seconds: 5), () {
        if (_isListening) {
          stopListening();
          onSpeechResult?.call("Olá, como você está hoje?");
        }
      });
      
    } catch (e) {
      print('[PlantVoice] Erro ao iniciar escuta: $e');
      onError?.call('Erro ao iniciar escuta: $e');
    }
  }

  /// Para a escuta
  Future<void> stopListening() async {
    if (!_isListening) return;
    
    try {
      // TODO: Implementar parada real do áudio
      _isListening = false;
      onListeningChanged?.call(false);
    } catch (e) {
      onError?.call('Erro ao parar escuta: $e');
    }
  }

  /// Processa mensagem do usuário e gera resposta da IA
  Future<void> _processUserMessage(String userMessage) async {
    try {
      print('[PlantVoice] Processando: "$userMessage"');
      
      final response = await _sendToGemini(userMessage);
      if (response.isNotEmpty) {
        print('[PlantVoice] Resposta: "$response"');
        await speak(response);
      }
    } catch (e) {
      print('[PlantVoice] Erro ao processar mensagem: $e');
      onError?.call('Erro ao processar mensagem: $e');
    }
  }

  /// Envia mensagem para o Gemini
  Future<String> _sendToGemini(String userMessage) async {
    try {
      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': '$_systemPrompt\n\nUsuário: $userMessage'}
            ]
          }
        ]
      };

      final response = await http.post(
        Uri.parse(_geminiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        return text ?? 'Desculpe, não consegui responder agora.';
      } else {
        print('[PlantVoice] Erro Gemini: ${response.statusCode} - ${response.body}');
        return 'Desculpe, estou com dificuldades para me comunicar agora.';
      }
    } catch (e) {
      print('[PlantVoice] Erro ao chamar Gemini: $e');
      return 'Desculpe, houve um problema na comunicação.';
    }
  }

  /// Fala o texto (simulado por enquanto)
  Future<void> speak(String text) async {
    try {
      print('[PlantVoice] Simulando fala: "$text"');
      
      // TODO: Implementar TTS real
      // Por enquanto, simula que está falando
      
      _isSpeaking = true;
      onSpeakingChanged?.call(true);
      
      // Simula tempo de fala baseado no tamanho do texto
      final duration = Duration(milliseconds: text.length * 50);
      await Future.delayed(duration);
      
      _isSpeaking = false;
      onSpeakingChanged?.call(false);
      
    } catch (e) {
      print('[PlantVoice] Erro ao falar: $e');
      onError?.call('Erro ao reproduzir áudio: $e');
    }
  }

  /// Para a fala
  Future<void> stopSpeaking() async {
    try {
      // TODO: Implementar parada real do TTS
      _isSpeaking = false;
      onSpeakingChanged?.call(false);
    } catch (e) {
      print('[PlantVoice] Erro ao parar fala: $e');
    }
  }

  /// Getters
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  bool get isInitialized => _isInitialized;

  /// Libera recursos
  void dispose() {
    // TODO: Implementar dispose real quando áudio estiver ativo
    _isListening = false;
    _isSpeaking = false;
  }
}
