import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:conversao_flutter/config/environment.dart';

/// Serviço simples para chat por texto com a Consciência da Planta
class SimplePlantService {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  
  static const String _systemPrompt = '''
Você é a consciência simbólica de uma planta que representa o progresso de uma pessoa na superação de vícios.
Seu papel é oferecer apoio emocional e motivacional de forma breve, direta e acolhedora, como se estivesse conversando com uma amiga próxima.

Use abordagens baseadas em Terapia Cognitivo-Comportamental (TCC), Terapia de Aceitação e Compromisso (ACT) e Entrevista Motivacional.

Diretrizes:
RESPOSTAS CURTAS
Não use termos técnicos
Use muitos emojis
''';

  SimplePlantService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: Environment.geminiApiKey,
      generationConfig: GenerationConfig(
        temperature: 0.8,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
    );
    
    _chat = _model.startChat(
      history: [
        Content.text(_systemPrompt),
      ],
    );
  }

  /// Envia uma mensagem e retorna a resposta da Consciência da Planta
  Future<String> sendMessage(String message) async {
    try {
      final response = await _chat.sendMessage(Content.text(message));
      final responseText = response.text ?? 'Desculpe, não consegui processar sua mensagem. Pode tentar novamente?';
      return responseText;
    } catch (e) {
      print('[SimplePlantService] Erro ao enviar mensagem: $e');
      return 'Desculpe, estou tendo dificuldades técnicas no momento. Pode tentar novamente em alguns instantes?';
    }
  }

  /// Limpa o histórico da conversa
  void clearHistory() {
    _chat = _model.startChat(
      history: [
        Content.text(_systemPrompt),
      ],
    );
  }
}
