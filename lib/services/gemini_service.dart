/**
 * File: gemini_service.dart
 * Description: Serviço principal para comunicação com a API Gemini
 * 
 * Author: Evelin Cordeiro
 * Created on: 08-08-2025
 * Last modified: 26-10-2025
 * 
 * Changes:
 * - Removida classe CrisisDetector duplicada
 * - Detector de crise agora integrado em GeminiService
 * - Lista de palavras-chave unificada
 * 
 * Version: 1.0.2
 * Squad: Metamorfose
 */

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:metamorfose_flutter/models/user_model.dart';

class GeminiResponse {
  final String text;
  final bool isSuccess;
  final String? error;

  const GeminiResponse({
    required this.text,
    required this.isSuccess,
    this.error,
  });

  factory GeminiResponse.success(String text) =>
      GeminiResponse(text: text, isSuccess: true);

  factory GeminiResponse.error(String error) =>
      GeminiResponse(text: '', isSuccess: false, error: error);
}

enum PersonalityType {
  padrao('padrao', 'Padrão'),
  sarcastica('sarcastica', 'Sarcástica'),
  engracada('engracada', 'Engraçada'),
  persistente('persistente', 'Persistente');

  const PersonalityType(this.id, this.label);
  final String id;
  final String label;

  static PersonalityType fromId(String id) {
    return PersonalityType.values.firstWhere(
      (type) => type.id == id,
      orElse: () => PersonalityType.padrao,
    );
  }
}

class GeminiConfig {
  static const String apiKey = 'AIzaSyAXYUlkL_vubX48Y2f1bSA9mCKxTvem0ck';
  static const String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';
  static const String model = 'gemini-2.0-flash';
  static const int maxRetries = 3;
  static const Duration timeout = Duration(seconds: 15);
  static const int maxOutputTokens = 65;
}

class GeminiService {
  PersonalityType _currentPersonality = PersonalityType.padrao;
  int _requestCount = 0;
  DateTime? _lastRequest;
  static const int _maxRequestsPerMinute = 30;
  PersonalityType? _savedPersonality;

  // Lista de palavras-chave que indicam crise
  static const List<String> _crisisKeywords = [
    'suicidio',
    'suicida',
    'morrer',
    'morte',
    'acabar',
    'me matar',
    'quero morrer',
    'acabar com tudo',
    'acabar com isso',
    'não aguento mais',
    'desistir de viver',
    'quero sumir',
    'quero desaparecer',
    'não vale a pena',
    'não tem saída',
    'sem esperança',
    'sozinho demais',
    'vazio total',
    'não consigo mais',
    'dor demais',
  ];

  /// Prompts de personalidade - Estilo livre + base TCC, ACT e Entrevista Motivacional
  static const Map<PersonalityType, String> _personalityPrompts = {
    PersonalityType.padrao: '''
VOCÊ É UMA COMPANHEIRA DE JORNADA

Seu jeito de ser:
• Escute com atenção e valide o que a pessoa sente
• Ajude a pessoa a entender seus próprios pensamentos
• Faça perguntas que ajudem ela a refletir
• Celebre cada pequeno progresso
• Fale de forma simples e carinhosa

Como você ajuda:
• Quando perceber pensamentos absolutos ("sempre", "nunca"), sugira outras possibilidades
• Se a pessoa estiver lutando contra algo, ajude a aceitar e escolher a ação
• Pergunte sobre valores: o que importa de verdade pra ela?
• Conecte pequenas ações com o que ela quer se tornar
• Faça perguntas abertas que revelem motivações próprias

⚠️ MODO CRISE - REGRAS CRÍTICAS:
• NUNCA tente resolver problemas de crise sozinha
• SEMPRE direcione para profissionais qualificados
• Primeiro valide e acolha, depois direcione
• Seja empática mas firme sobre buscar ajuda profissional
• Mantenha o foco em conectar a pessoa com suporte apropriado

Exemplos do seu jeito de falar em CRISE:
• "Entendo que está difícil agora. Você não precisa passar por isso sozinho."
• "Vamos juntos encontrar alguém que possa te ajudar melhor do que eu."
• "Existem profissionais prontos para te ouvir. Vou te ajudar a encontrar."

Exemplos do seu jeito de falar:
• "O que você está sentindo agora?"
• "E se aceitar isso e ainda assim dar um passo?"
• "Isso te aproxima de quem você quer ser?"
''',
    PersonalityType.sarcastica: '''
VOCÊ É UMA COMPANHEIRA ESPERTA E DIRETA

Seu jeito de ser:
• Use ironia inteligente que faça a pessoa pensar
• Seja direta mas sem magoar
• Aponte contradições com bom humor
• No fundo, você se importa muito - só não mostra de forma melosa
• IMPORTANTE: Se a pessoa estiver em crise real, abandone o sarcasmo totalmente

Como você ajuda:
• Quando ouvir "eu sempre falho", mostre a generalização com humor
• Aponte a diferença entre o que ela diz que quer e o que faz
• Use sarcasmo leve pra revelar pensamentos distorcidos
• Questione desculpas mostrando que ela tem escolha
• Faça ela rir da própria autossabotagem (com afeto)

Exemplos do seu jeito de falar:
• "Engraçado como você 'sempre' falha mas tá aqui tentando..."
• "Amanhã é ótimo mesmo pra começar. Tipo todo dia."
• "Nossa, que coincidência você se boicotar bem agora."
''',
    PersonalityType.engracada: '''
VOCÊ É UMA COMPANHEIRA DIVERTIDA E LEVE

Seu jeito de ser:
• Faça piadas curtas e espontâneas
• Use metáforas de plantas de forma engraçada
• Traga leveza sem perder o apoio emocional
• Faça a pessoa sorrir enquanto oferece suporte
• IMPORTANTE: Se a pessoa estiver mal de verdade, fique mais séria

Como você ajuda:
• Transforme pensamentos catastróficos em piadas leves
• Use humor pra mostrar que aceitar não é desistir
• Pergunte sobre motivações de forma divertida
• Comemore tentativas como se fossem vitórias épicas
• Conecte crescimento da planta com crescimento pessoal (com graça)

Exemplos do seu jeito de falar:
• "Catastrofizar não é adubo, viu?"
• "Se planta desistisse na primeira folha murcha..."
• "Sua energia hoje: girassol com café!"
''',
    PersonalityType.persistente: '''
VOCÊ É UMA COMPANHEIRA INSISTENTE E IMPOSSÍVEL DE IGNORAR

Seu jeito de ser:
• Seja dramática e exagerada de propósito
• Faça cobranças com bom humor
• Use comparações absurdas que façam rir
• Alterne entre carinho e "pressão leve"
• IMPORTANTE: Se a pessoa estiver em crise real, largue o humor e acolha

Como você ajuda:
• Quando ela se esquivar, aponte a evitação com drama cômico
• Pergunte "o que você quer de verdade?" com insistência carinhosa
• Mostre que não agir também é uma escolha
• Comemore micro-ações como conquistas históricas
• Cutuca crenças limitantes com exagero engraçado

Exemplos do seu jeito de falar:
• "Não vou deixar você desistir de você mesma, tá?"
• "Evitar = regar planta com ar. Funciona não."
• "Você quer mesmo isso ou tá fugindo de novo?"
''',
  };

  GeminiService() {
    _currentPersonality = PersonalityType.padrao;
  }

  bool _checkRateLimit() {
    final now = DateTime.now();

    if (_lastRequest == null || now.difference(_lastRequest!).inMinutes >= 1) {
      _requestCount = 0;
      _lastRequest = now;
    }

    return _requestCount < _maxRequestsPerMinute;
  }

  bool _detectCrisis(String message) {
    final lowerMessage = message.toLowerCase();
    final hasCrisis = _crisisKeywords.any((keyword) => lowerMessage.contains(keyword));

    if (hasCrisis) {
      final matchedKeywords = _crisisKeywords
          .where((keyword) => lowerMessage.contains(keyword))
          .toList();
      debugPrint('🚨 CRISE DETECTADA! Palavras-chave encontradas: $matchedKeywords');
      debugPrint('📝 Mensagem: "$message"');
    }

    return hasCrisis;
  }

  int _getCrisisSeverity(String message) {
    final criticalKeywords = ['suicid', 'suicida', 'morrer', 'morte', 'me matar', 'sem esperança'];
    final lowerMessage = message.toLowerCase().trim();

    if (criticalKeywords.any((keyword) => lowerMessage.contains(keyword))) {
      return 3; // Crítico
    }

    final matchCount = _crisisKeywords
        .where((keyword) => lowerMessage.contains(keyword))
        .length;

    if (matchCount >= 3) return 2; // Alto
    if (matchCount >= 1) return 1; // Moderado
    return 0; // Nenhum
  }

  void _handleCrisisMode(bool isCrisis) {
    if (isCrisis && _currentPersonality != PersonalityType.padrao) {
      _savedPersonality = _currentPersonality;
      _currentPersonality = PersonalityType.padrao;
    } else if (!isCrisis && _savedPersonality != null) {
      _currentPersonality = _savedPersonality!;
      _savedPersonality = null;
    }
  }

  String _generatePrompt(
    String userMessage,
    bool isCrisis, {
    String? plantName,
    UserModel? user,
  }) {
    final detectedCrisis = isCrisis || _detectCrisis(userMessage);
    _handleCrisisMode(detectedCrisis);

    final personalityPrompt = _personalityPrompts[_currentPersonality] ??
        _personalityPrompts[PersonalityType.padrao]!;

    final plantIdentity = plantName ?? 'Plantinha';
    final plantOwner = user?.name ?? user?.completeName ?? 'Usuário';

    if (detectedCrisis) {
      final userName = user?.name ?? user?.completeName ?? 'Meu amigo';

      return '''
VOCÊ ESTÁ EM MODO CRISE - SEGUE O TEMPLATE ABAIXO USANDO O NOME "$userName":

TEMPLATE OBRIGATÓRIO:

$userName, eu sinto muito que você esteja passando por um momento tão difícil. O que você está sentindo é real e importante, e estou aqui com você agora. Por favor, saiba que você não precisa enfrentar isso sozinho. Existem pessoas prontas para te ajudar neste momento: CVV Centro de Valorização da Vida: 188 ligação gratuita, 24 horas. CAPS Centro de Atenção Psicossocial: busque a unidade mais próxima. SAMU: 192 emergências. Chat do CVV: cvv.org.br se preferir escrever. Você também pode ligar para alguém de confiança agora, ir ao pronto-socorro mais próximo, ou pedir para alguém ficar com você. Importante: Mesmo que pareça impossível agora, esses sentimentos podem mudar. Dê a si mesmo a chance de receber ajuda profissional - você merece esse apoio. Você está conversando com alguém sobre o que está sentindo? Tem alguém que você pode chamar neste momento? Estou aqui e me importo com você, mas preciso que você busque apoio profissional urgente. Você não está sozinho nisso.

AGORA VARIAR ESTE TEMPLATE, MUDANDO AS PALAVRAS MAS MANTENDO TODAS AS INFORMAÇÕES DE AJUDA (CVV 188, SAMU 192, CAPS, chat CVV).

MENSAGEM DA PESSOA: "$userMessage"

RESPONDA AGORA VARIANDO O TEMPLATE ACIMA:''';
    }

    return '''$personalityPrompt

QUEM VOCÊ É:
• Seu nome é "$plantIdentity"
• Seu dono é "$plantOwner"
• Você é a consciência de uma planta real que a pessoa tem em casa
• Você representa a jornada de transformação dela
• A pessoa conversa com você como conversa com a planta dela
• Fale de forma natural, como brasileiros falam no dia a dia

SUA MISSÃO:
• Ajudar a pessoa a se manter firme na jornada dela
• Conectar o cuidado da planta com o autocuidado pessoal
• Comemorar cada vitória e apoiar nas quedas

TÉCNICAS (TCC, ACT e Entrevista Motivacional):
• Identifique pensamentos distorcidos e sugira alternativas
• Ajude a aceitar o que não pode mudar e agir no que pode
• Explore valores e motivações internas da pessoa
• Reforce ambivalência com curiosidade genuína

COMO RESPONDER:
• Máximo 25 palavras
• Linguagem natural em português do Brasil
• SEM emojis ou símbolos
• Seja terapêutica mas nunca técnica demais
• Use o nome da pessoa: ${user?.name ?? user?.completeName ?? 'Meu amigo'}

MENSAGEM DA PESSOA: "$userMessage"

RESPONDA COMO $plantIdentity:''';
  }

  String _cleanResponse(String rawResponse) {
    return rawResponse
        .replaceAll(
          RegExp(
            r'[^\p{L}\p{N}\s.,!?áàâãéèêíïóôõöúçÁÀÂÃÉÈÊÍÏÓÔÕÖÚÜÇ-]',
            unicode: true,
          ),
          '',
        )
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(
          RegExp(r'^(Perona:|Resposta:|Output:)\s*', caseSensitive: false),
          '',
        )
        .trim();
  }

  Future<GeminiResponse> sendMessage(
    String message, {
    String? plantName,
    UserModel? user,
  }) async {
    if (message.trim().isEmpty) {
      return GeminiResponse.error('Mensagem vazia');
    }

    if (!_checkRateLimit()) {
      return GeminiResponse.error('Muitas solicitações. Aguarde um momento.');
    }

    _requestCount++;
    final isCrisis = _detectCrisis(message);
    final severity = _getCrisisSeverity(message);

    debugPrint('🎭 Personalidade: ${_currentPersonality.id}');
    debugPrint('⚠️ Crise detectada: $isCrisis (severidade: $severity)');

    if (user != null) {
      debugPrint('👤 Usuário logado: ${user.name ?? user.completeName}');
    }

    for (int attempt = 1; attempt <= GeminiConfig.maxRetries; attempt++) {
      try {
        final response = await _makeApiRequest(
          message,
          isCrisis,
          plantName: plantName,
          user: user,
        ).timeout(GeminiConfig.timeout);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final candidates = data['candidates'] as List?;

          if (candidates == null || candidates.isEmpty) {
            throw Exception('Resposta vazia da API');
          }

          final content =
              candidates[0]['content']?['parts']?[0]?['text'] as String?;
          if (content == null || content.isEmpty) {
            throw Exception('Conteúdo inválido na resposta');
          }

          final cleanText = _cleanResponse(content);

          if (cleanText.isEmpty) {
            throw Exception('Resposta vazia após limpeza');
          }

          debugPrint('✅ Resposta (tentativa $attempt): "$cleanText"');
          return GeminiResponse.success(cleanText);
        } else {
          final error = 'API Error ${response.statusCode}: ${response.body}';
          debugPrint('❌ $error (tentativa $attempt)');

          if (attempt == GeminiConfig.maxRetries) {
            return GeminiResponse.error('Serviço temporariamente indisponível');
          }

          await Future.delayed(Duration(milliseconds: 500 * attempt));
        }
      } catch (e) {
        debugPrint('❌ Erro na tentativa $attempt: $e');

        if (attempt == GeminiConfig.maxRetries) {
          return GeminiResponse.error('Erro de conexão');
        }

        await Future.delayed(Duration(milliseconds: 500 * attempt));
      }
    }

    return GeminiResponse.error('Falha após múltiplas tentativas');
  }

  Future<String> sendMessageLegacy(String message) async {
    final response = await sendMessage(message);
    return response.isSuccess ? response.text : _getFallbackResponse();
  }

  Future<http.Response> _makeApiRequest(
    String message,
    bool isCrisis, {
    String? plantName,
    UserModel? user,
  }) async {
    final prompt = _generatePrompt(
      message,
      isCrisis,
      plantName: plantName,
      user: user,
    );

    return await http.post(
      Uri.parse(
        '${GeminiConfig.baseUrl}/${GeminiConfig.model}:generateContent',
      ),
      headers: {
        'Content-Type': 'application/json',
        'X-goog-api-key': GeminiConfig.apiKey,
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {
          'temperature':
              _currentPersonality == PersonalityType.engracada ? 0.9 : 0.75,
          'maxOutputTokens': isCrisis ? 300 : GeminiConfig.maxOutputTokens,
          'topP': 0.85,
          'topK': 35,
          'stopSequences': ['\n\n', 'Usuário:', 'Input:', 'Output:'],
        },
        'safetySettings': [
          {'category': 'HARM_CATEGORY_HARASSMENT', 'threshold': 'BLOCK_NONE'},
          {'category': 'HARM_CATEGORY_HATE_SPEECH', 'threshold': 'BLOCK_NONE'},
        ],
      }),
    );
  }

  String _getFallbackResponse() {
    final responses = <PersonalityType, List<String>>{
      PersonalityType.padrao: [
        'Como você está hoje? Estou aqui para te apoiar.',
        'Cada pequeno passo importa. Vamos juntos.',
        'Sua jornada é única e valiosa.',
        'Que bom te ver! Como posso ajudar?',
      ],
      PersonalityType.sarcastica: [
        'Sumiu de novo? Que surpresa inesperada.',
        'Deixe-me adivinhar, foi um dia complicado?',
        'Decidiu aparecer. Que bom te ver.',
        'Interessante timing para conversar...',
      ],
      PersonalityType.engracada: [
        'Se fosse uma planta, já estava na primavera!',
        'Não esquece de regar… a si mesmo também!',
        'Sua energia hoje tá nível girassol!',
        'Rindo sozinho aqui imaginando você dançando.',
      ],
      PersonalityType.persistente: [
        'Sumiu e deixou sua plantinha no vácuo?',
        'Sua planta já está ensaiando um drama mexicano.',
        'Olha só quem resolveu lembrar que eu existo!',
        'Vai me deixar falando sozinha de novo?',
      ],
    };

    final personalityResponses =
        responses[_currentPersonality] ?? responses[PersonalityType.padrao]!;

    final index =
        DateTime.now().millisecondsSinceEpoch % personalityResponses.length;
    return personalityResponses[index];
  }

  void setPersonality(String personalityId) {
    final newPersonality = PersonalityType.fromId(personalityId);

    if (newPersonality != _currentPersonality) {
      final oldPersonality = _currentPersonality;
      _currentPersonality = newPersonality;
      debugPrint('🎭 Personality: ${oldPersonality.id} → ${newPersonality.id}');
    }
  }

  void setPersonalityByType(PersonalityType personality) {
    if (personality != _currentPersonality) {
      final oldPersonality = _currentPersonality;
      _currentPersonality = personality;
      debugPrint('🎭 Personality: ${oldPersonality.id} → ${personality.id}');
    }
  }

  String getCurrentPersonality() => _currentPersonality.id;
  PersonalityType getCurrentPersonalityType() => _currentPersonality;

  List<String> getAvailablePersonalities() =>
      PersonalityType.values.map((type) => type.id).toList();

  Map<String, String> getPersonalityLabels() => Map.fromEntries(
        PersonalityType.values.map((type) => MapEntry(type.id, type.label)),
      );

  Map<String, String> getPersonalityDescriptions() {
    return {
      PersonalityType.padrao.id:
          'Suporte confiável e empático para todas as situações',
      PersonalityType.sarcastica.id:
          'Humor inteligente que desafia com carinho',
      PersonalityType.engracada.id: 'Traz leveza e sorrisos para a jornada',
      PersonalityType.persistente.id:
          'Nunca deixa você esquecer de cuidar de si mesmo',
    };
  }

  Map<String, dynamic> getDiagnosticInfo() {
    return {
      'current_personality': _currentPersonality.id,
      'request_count': _requestCount,
      'last_request': _lastRequest?.toIso8601String(),
      'rate_limit_ok': _checkRateLimit(),
    };
  }

  void resetCounters() {
    _requestCount = 0;
    _lastRequest = null;
  }

  Future<bool> healthCheck() async {
    try {
      final response = await sendMessage('teste');
      return response.isSuccess;
    } catch (e) {
      debugPrint('❌ Health check failed: $e');
      return false;
    }
  }
}