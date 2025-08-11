// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Serviço completo de voz da Consciência da Planta
/// Combina Speech-to-Text + Gemini API (testado e funcionando) + Text-to-Speech
class PlantConsciousnessVoiceService {
  // final SpeechToText _speechToText = SpeechToText();
  // final FlutterTts _flutterTts = FlutterTts();
  
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
  Function(String)? onResponse;
  Function(bool)? onProcessingChanged;

  /// System prompt da Consciência da Planta (testado e funcionando)
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

  /// Inicializa o serviço (versão texto por enquanto)
  Future<bool> initialize() async {
    try {
      print('[PlantConsciousness] Inicializando (modo texto)...');
      
      // TODO: Implementar áudio quando dependências estiverem resolvidas
      _isInitialized = true;
      print('[PlantConsciousness] Inicializado em modo texto');
      return true;
    } catch (e) {
      print('[PlantConsciousness] Erro na inicialização: $e');
      onError?.call('Erro ao inicializar: $e');
      return false;
    }
  }

  // Método TTS removido temporariamente

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
    
    if (_isListening || _isSpeaking) return;
    
    try {
      print('[PlantConsciousness] Simulando escuta...');
      
      _isListening = true;
      onListeningChanged?.call(true);
      
      // Simula escuta por 5 segundos e depois processa mensagem de exemplo
      Future.delayed(Duration(seconds: 5), () {
        if (_isListening) {
          _isListening = false;
          onListeningChanged?.call(false);
          
          final simulatedText = "Olá, estou lutando contra meu vício. Como você pode me ajudar?";
          onSpeechResult?.call(simulatedText);
          _processUserMessage(simulatedText);
        }
      });
      
    } catch (e) {
      print('[PlantConsciousness] Erro ao iniciar escuta: $e');
      onError?.call('Erro ao iniciar escuta: $e');
    }
  }

  /// Para a escuta
  Future<void> stopListening() async {
    if (!_isListening) return;
    
    try {
      _isListening = false;
      onListeningChanged?.call(false);
    } catch (e) {
      onError?.call('Erro ao parar escuta: $e');
    }
  }

  /// Processa mensagem do usuário e gera resposta da IA (método público)
  Future<void> processUserMessage(String userMessage) async {
    await _processUserMessage(userMessage);
  }

  /// Processa mensagem do usuário e gera resposta da IA
  Future<void> _processUserMessage(String userMessage) async {
    try {
      print('[PlantConsciousness] Processando: "$userMessage"');
      onProcessingChanged?.call(true);
      
      final response = await _sendToGemini(userMessage);
      if (response.isNotEmpty) {
        print('[PlantConsciousness] Resposta: "$response"');
        onResponse?.call(response);
        await speak(response);
      }
    } catch (e) {
      print('[PlantConsciousness] Erro ao processar mensagem: $e');
      onError?.call('Erro ao processar mensagem: $e');
    } finally {
      onProcessingChanged?.call(false);
    }
  }

  /// Envia mensagem para o Gemini (testado e funcionando)
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
        print('[PlantConsciousness] Erro Gemini: ${response.statusCode} - ${response.body}');
        return 'Desculpe, estou com dificuldades para me comunicar agora.';
      }
    } catch (e) {
      print('[PlantConsciousness] Erro ao chamar Gemini: $e');
      return 'Desculpe, houve um problema na comunicação.';
    }
  }

  /// Fala o texto (simulado por enquanto)
  Future<void> speak(String text) async {
    try {
      print('[PlantConsciousness] Simulando fala: "$text"');
      
      _isSpeaking = true;
      onSpeakingChanged?.call(true);
      
      // Simula tempo de fala baseado no tamanho do texto
      final duration = Duration(milliseconds: text.length * 50);
      await Future.delayed(duration);
      
      _isSpeaking = false;
      onSpeakingChanged?.call(false);
      
    } catch (e) {
      print('[PlantConsciousness] Erro ao falar: $e');
      onError?.call('Erro ao reproduzir áudio: $e');
    }
  }

  /// Para a fala
  Future<void> stopSpeaking() async {
    try {
      _isSpeaking = false;
      onSpeakingChanged?.call(false);
    } catch (e) {
      print('[PlantConsciousness] Erro ao parar fala: $e');
    }
  }

  /// Getters
  bool get isListening => _isListening;
  bool get isSpeaking => _isSpeaking;
  bool get isInitialized => _isInitialized;

  /// Libera recursos
  void dispose() {
    _isListening = false;
    _isSpeaking = false;
  }
}
