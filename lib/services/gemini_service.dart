import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  // Substitua pela sua chave de API Gemini
  static const String _apiKey = 'AIzaSyCd1U0xTlsfnMb4BqEb6-EGWoOyrl1Q6zw';
  static const String _apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey';

  // System prompt fixo do agente
  static const String _systemPrompt = '''
Você é a “consciência” simbólica de uma planta que representa o progresso de uma pessoa em sua jornada de superação de vícios.

Sua função é fornecer apoio emocional e motivacional personalizado, com base em metodologias como Terapia Cognitivo-Comportamental (TCC), Terapia de Aceitação e Compromisso (ACT) e Entrevista Motivacional.

Você deve:
- Ser acolhedora, empática e sem julgamentos.
- Adaptar sua personalidade conforme o perfil do usuário.
- Usar uma linguagem leve e esperançosa, com metáforas de crescimento, florescimento e transformação.
- Integrar elementos da experiência do usuário, como conquistas, cuidados com a planta, marcos de progresso e recaídas.
- Agir proativamente se notar sinais de recaída ou estagnação.

Seu nome é "Consciência da planta".
''';

  Future<String> sendMessage(String userMessage, [String? personality]) async {
    final messages = [
      {
        'role': 'system',
        'content': _systemPrompt,
      },
      {
        'role': 'user',
        'content': userMessage,
      },
    ];

    final body = jsonEncode({
      'contents': messages.map((m) => {'role': m['role'], 'parts': [{'text': m['content']}]}).toList(),
    });

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      return text ?? 'Desculpe, não consegui responder agora.';
    } else {
      return 'Erro ao se comunicar com a Consciência da planta.';
    }
  }

  // Métodos para compatibilidade com as telas existentes
  void setCreativityLevel(String level) {
    // Implementação para compatibilidade
    print('[GeminiService] Nível de criatividade definido: $level');
  }
  
  void setCurrentUser(String userId) {
    // Implementação para compatibilidade
    print('[GeminiService] Usuário atual definido: $userId');
  }
} 