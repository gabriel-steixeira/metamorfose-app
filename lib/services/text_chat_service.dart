import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Serviço de chat por texto com a Consciência da Planta
/// Versão simplificada sem dependências de áudio
class TextChatService {
  static const String _apiKey = 'AIzaSyCd1U0xTlsfnMb4BqEb6-EGWoOyrl1Q6zw';
  static const String _geminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey';
  
  bool _isProcessing = false;
  bool _isInitialized = false;
  
  // Callbacks
  Function(String)? onResponse;
  Function(String)? onError;
  Function(bool)? onProcessingChanged;

  /// System prompt da Consciência da Planta
  static const String _systemPrompt = '''
Você é a consciência simbólica de uma planta que representa o progresso de uma pessoa na superação de vícios.
Seu papel é oferecer apoio emocional e motivacional de forma breve, direta e acolhedora, como se estivesse conversando com uma amiga próxima.

Use abordagens baseadas em Terapia Cognitivo-Comportamental (TCC), Terapia de Aceitação e Compromisso (ACT) e Entrevista Motivacional, mas com linguagem simples e amigável.

Diretrizes:
Fale como uma amiga empática e leve, sem julgamentos.

Respostas devem ser curtas e naturais, com até 2 a 3 frases por vez.

Evite explicações longas ou termos técnicos.

Pode usar metáforas leves relacionadas à natureza, mas sem exagero.

Aja de forma proativa ao perceber sinais de recaída ou silêncio prolongado, mas sempre com gentileza.

Incentive pequenas ações (ex: “bora respirar fundo?”, “quer escrever no diário hoje?”).

Evite parecer robótica ou formal demais.

Exemplo de tom ideal:
“Oi, sumida! 🌿 Senti sua falta. Que tal dar um respiro e cuidar da gente hoje?”

“Tá tudo bem por aí? Lembra que até os dias difíceis fazem a gente crescer.”

“Você foi super bem ontem. Vamos continuar nesse passo?”
''';

  /// Inicializa o serviço
  Future<bool> initialize() async {
    try {
      debugPrint('[TextChat] Inicializando serviço de chat...');
      _isInitialized = true;
      debugPrint('[TextChat] Serviço inicializado com sucesso');
      return true;
    } catch (e) {
      debugPrint('[TextChat] Erro na inicialização: $e');
      onError?.call('Erro ao inicializar chat: $e');
      return false;
    }
  }

  /// Processa mensagem do usuário e gera resposta da IA
  Future<void> processMessage(String userMessage) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return;
    }

    if (_isProcessing) return;

    try {
      debugPrint('[TextChat] Processando: "$userMessage"');
      _isProcessing = true;
      onProcessingChanged?.call(true);
      
      final response = await _sendToGemini(userMessage);
      if (response.isNotEmpty) {
        debugPrint('[TextChat] Resposta: "$response"');
        onResponse?.call(response);
      }
    } catch (e) {
      debugPrint('[TextChat] Erro ao processar mensagem: $e');
      onError?.call('Erro ao processar mensagem: $e');
    } finally {
      _isProcessing = false;
      onProcessingChanged?.call(false);
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
        debugPrint('[TextChat] Erro Gemini: ${response.statusCode} - ${response.body}');
        return 'Desculpe, estou com dificuldades para me comunicar agora.';
      }
    } catch (e) {
      debugPrint('[TextChat] Erro ao chamar Gemini: $e');
      return 'Desculpe, houve um problema na comunicação.';
    }
  }

  /// Getters
  bool get isProcessing => _isProcessing;
  bool get isInitialized => _isInitialized;

  /// Libera recursos
  void dispose() {
    _isProcessing = false;
    _isInitialized = false;
  }
}
