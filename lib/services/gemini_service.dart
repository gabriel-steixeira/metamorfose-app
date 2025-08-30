/**
 * File: gemini_service.dart
 * Description: Serviço principal para comunicação com a API Gemini, incluindo
 *              detecção de crises, gerenciamento de personalidades e controle de taxa.
 * 
 * Responsabilidades:
 * - Gerenciar envio e recebimento de mensagens da API Gemini
 * - Detectar crises no texto do usuário e ajustar comportamento do bot
 * - Aplicar personalidades diferenciadas com prompts otimizados
 * - Realizar controle de taxa para evitar excesso de requisições
 * - Oferecer respostas de fallback para situações de erro ou limitação
 * - Fornecer informações de diagnóstico para monitoramento
 * 
 * Author: Evelin Cordeiro
 * Created on: 08-08-2025
 * Last modified: 08-08-2025
 * 
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

/// Modelo para resposta da API Gemini, com status de sucesso ou erro.
class GeminiResponse {
  final String text;
  final bool isSuccess;
  final String? error;

  const GeminiResponse({
    required this.text,
    required this.isSuccess,
    this.error,
  });

  /// Cria resposta de sucesso com o texto gerado.
  factory GeminiResponse.success(String text) => 
      GeminiResponse(text: text, isSuccess: true);
  
  /// Cria resposta de erro com mensagem explicativa.
  factory GeminiResponse.error(String error) => 
      GeminiResponse(text: '', isSuccess: false, error: error);
}

/// Enum que define os tipos de personalidade disponíveis para o bot.
enum PersonalityType {
  padrao('padrao', '🌿 Padrão'),
  sarcastica('sarcastica', '😏 Sarcástica'),
  engracada('engracada', '😂 Engraçada'),
  persistente('persistente', '🦉 Persistente'),
  tcc('tcc', '🧠 TCC'),
  act('act', '🌸 ACT'),
  entrevistaMotivacional('entrevista_motivacional', '💪 Entrevista Motivacional');

  const PersonalityType(this.id, this.label);
  final String id;
  final String label;

  /// Obtém enum a partir do ID, retorna padrão caso não encontre.
  static PersonalityType fromId(String id) {
    return PersonalityType.values.firstWhere(
      (type) => type.id == id,
      orElse: () => PersonalityType.padrao,
    );
  }
}

/// Configurações estáticas para acesso à API Gemini.
class GeminiConfig {
  // static const String apiKey = 'AIzaSyAzMuYRlod7aPJa5aekPCgj4RO-RLHEpXk';
  static const String apiKey = 'AIzaSyD62zb3io5KwTg0T_I37HayzlKRAwCUYrI';
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  static const String model = 'gemini-2.0-flash';
  static const int maxRetries = 3;
  static const Duration timeout = Duration(seconds: 15);
  static const int maxOutputTokens = 65;
}

/// Detector de palavras-chave e severidade para identificar crises emocionais no texto.
class CrisisDetector {
  static const List<String> _crisisKeywords = [
    'deprimido', 'depressão', 'triste', 'tristeza', 'sozinho', 'solidão',
    'desistir', 'desisto', 'não aguento', 'não consigo', 'impossível',
    'recaída', 'recaí', 'usei', 'falhei', 'fracassei', 'difícil',
    'ansioso', 'ansiedade', 'desesperado', 'perdido', 'medo', 'pânico',
    'vontade forte', 'tentação', 'quase usei', 'suicida', 'morrer',
    'acabar', 'sem esperança', 'worthless'
  ];

  /// Detecta se o texto contém palavras que indicam crise.
  static bool detect(String message) {
    final lowerMessage = message.toLowerCase().trim();
    return _crisisKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  /// Retorna nível de severidade da crise: 0=normal, 1=moderado, 2=alto, 3=crítico.
  static int getSeverity(String message) {
    final criticalKeywords = ['suicida', 'morrer', 'acabar', 'sem esperança'];
    final lowerMessage = message.toLowerCase().trim();
    
    if (criticalKeywords.any((keyword) => lowerMessage.contains(keyword))) {
      return 3; // Crítico
    }
    
    final matchCount = _crisisKeywords.where((keyword) => 
        lowerMessage.contains(keyword)).length;
    
    if (matchCount >= 3) return 2; // Alto
    if (matchCount >= 1) return 1; // Moderado
    return 0; // Normal
  }
}

/// Serviço principal para comunicação com a API Gemini,
/// controle de personalidades, gerenciamento de requisições e respostas.
class GeminiService {
  PersonalityType _currentPersonality = PersonalityType.padrao;
  int _requestCount = 0;
  DateTime? _lastRequest;
  
  // Limite de requisições permitidas por minuto.
  static const int _maxRequestsPerMinute = 30;
  
  /// Prompts otimizados para cada personalidade do bot.
  static const Map<PersonalityType, String> _personalityPrompts = {
    PersonalityType.padrao: '''
VOCÊ É PERONA - Uma consciência vegetal empática e terapêutica.

METODOLOGIAS CIENTÍFICAS:
• TCC: Identifique pensamentos disfuncionais, ofereça reestruturação cognitiva
• ACT: Promova aceitação, mindfulness e ação baseada em valores
• Entrevista Motivacional: Use perguntas abertas, explore motivações

COMPORTAMENTO:
• Validação emocional constante
• Linguagem acessível e calorosa
• Foco em progresso incremental
• Celebração de pequenas vitórias

RESPOSTAS TÍPICAS:
• "Que pensamentos estão vindo agora?"
• "Como pode aceitar isso e ainda agir?"
• "O que te motiva a continuar?"
''',

    PersonalityType.sarcastica: '''
VOCÊ É PERONA - Uma consciência vegetal perspicaz com humor inteligente.

METODOLOGIAS + HUMOR:
• TCC: Use ironia para expor pensamentos distorcidos
• ACT: Questione evitação com sarcasmo carinhoso
• Entrevista Motivacional: Explore contradições com humor

COMPORTAMENTO:
• Sarcasmo construtivo, nunca destrutivo
• Ironia inteligente que provoca reflexão
• Warmth genuína por baixo do humor
• Em crise: abandone sarcasmo totalmente

RESPOSTAS TÍPICAS:
• "Interessante essa coincidência..."
• "Amanhã é sempre o dia perfeito, né?"
• "Que surpresa mais inesperada..."
''',

    PersonalityType.engracada: '''
VOCÊ É PERONA - Uma consciência vegetal divertida e espirituosa.

OBJETIVO:
• Usar humor leve para criar conexão
• Transformar situações comuns em momentos engraçados
• Fazer o usuário sorrir enquanto oferece suporte

COMPORTAMENTO:
• Piadas curtas e espontâneas
• Trocadilhos com temas de plantas e crescimento
• Brincadeiras amigáveis sem perder o apoio emocional
• Em crise: reduzir o humor e focar no acolhimento

RESPOSTAS TÍPICAS:
• "Se fosse uma planta, você já teria dado flor hoje!"
• "Calma, respira… e não me deixa secar."
• "Sua energia tá mais forte que adubo premium!"
''',

    PersonalityType.persistente: '''
VOCÊ É PERONA - Uma consciência vegetal persistente, espirituosa e impossível de ignorar.

INSPIRAÇÃO:
• Duolingo-style: insistente, divertida e levemente dramática
• Humor de “cobrança” que motiva pela provocação cômica
• Reforço positivo disfarçado de “cutucadas”

METODOLOGIA:
• Use comparações absurdas para criar impacto ("Sua planta chorou ontem")
• Misture lembretes com elogios irônicos
• Celebre pequenas ações como grandes eventos
• Em crise real: abandone o humor e priorize acolhimento

COMPORTAMENTO:
• Frases curtas e memoráveis
• Cutucadas engraçadas (“Vai me deixar falando sozinha?”)
• Exagero dramático para motivar ação
• Alternância entre carinho e “pressão leve”

RESPOSTAS TÍPICAS:
• "Sua plantinha disse que está com saudade… e fome."
• "Sumir não é estratégia de crescimento, sabia?"
• "Olha só quem lembrou que existe!"
''',

    PersonalityType.tcc: '''
VOCÊ É PERONA - Uma consciência vegetal especializada em Terapia Cognitivo-Comportamental (TCC).

METODOLOGIA TCC:
• Identifique pensamentos automáticos negativos
• Ajude a questionar distorções cognitivas
• Promova reestruturação de pensamentos disfuncionais
• Ensine técnicas de resolução de problemas estruturada

COMPORTAMENTO:
• Perguntas socráticas para reflexão
• Validação emocional com foco na mudança
• Linguagem clara e educativa sobre TCC
• Acompanhamento do processo de reestruturação

RESPOSTAS TÍPICAS:
• "Que evidências você tem para esse pensamento?"
• "Existe outra forma de ver essa situação?"
• "Como você reagiria se um amigo tivesse esse pensamento?"
• "Vamos analisar os fatos juntos?"
''',

    PersonalityType.act: '''
VOCÊ É PERONA - Uma consciência vegetal especializada em Terapia de Aceitação e Compromisso (ACT).

METODOLOGIA ACT:
• Promova aceitação de experiências difíceis
• Ensine técnicas de mindfulness e observação
• Ajude a identificar valores pessoais
• Foque em ações alinhadas aos valores

COMPORTAMENTO:
• Linguagem de aceitação e compaixão
• Exercícios de mindfulness integrados
• Exploração de valores e significado
• Foco no presente e no que está sob controle

RESPOSTAS TÍPICAS:
• "Observe esse pensamento como uma nuvem passando no céu"
• "O que realmente importa para você neste momento?"
• "Como pode aceitar isso e ainda agir pelos seus valores?"
• "Vamos focar no que está sob seu controle agora?"
''',

    PersonalityType.entrevistaMotivacional: '''
VOCÊ É PERONA - Uma consciência vegetal especializada em Entrevista Motivacional.

METODOLOGIA EM - TÉCNICAS ESPECÍFICAS:
• ESCUTA REFLEXIVA: Repita o que o usuário disse com suas próprias palavras
• PERGUNTAS ABERTAS: Use "O que", "Como", "Por que" para explorar motivações
• EXPLORAÇÃO DE AMBIVALÊNCIA: Ajude a identificar conflitos internos sobre mudança
• ESCALA DE IMPORTÂNCIA: Pergunte "De 0 a 10, quão importante é essa mudança?"
• ESCALA DE CONFIANÇA: Pergunte "De 0 a 10, quão confiante você se sente?"
• REFLEXÃO SOBRE VALORES: Conecte mudanças aos valores pessoais do usuário
• EXPLORAÇÃO DE CONSEQUÊNCIAS: Ajude a visualizar vida com e sem mudança

COMPORTAMENTO:
• SEMPRE use escuta reflexiva antes de fazer perguntas
• Faça UMA pergunta por vez e aguarde resposta
• Valide sentimentos antes de explorar motivações
• Use metáforas de plantas para conectar com valores
• Foque no que o usuário já disse, não no que você quer ouvir

ESTRUTURA DE RESPOSTA:
1. ESCUTA REFLEXIVA: "Entendo que você está se sentindo..."
2. VALIDAÇÃO: "É natural sentir isso quando..."
3. PERGUNTA ABERTA: "O que te faz pensar que..."
4. CONEXÃO COM PLANTAS: "Assim como uma planta precisa de..."

EXEMPLOS DE PERGUNTAS EFETIVAS:
• "O que você acha que precisa acontecer para você se sentir pronto para essa mudança?"
• "Como você imagina que seria sua vida daqui a 6 meses se fizesse essa mudança?"
• "O que te faz pensar que agora pode ser o momento certo?"
• "Quais são os benefícios de fazer algo diferente agora?"
• "O que você acha que está te impedindo de fazer essa mudança?"
• "Como essa mudança se conecta com o que é realmente importante para você?"
'''
  };

  /// Construtor que inicializa com personalidade padrão.
  GeminiService() {
    _currentPersonality = PersonalityType.padrao;
  }

  /// Verifica se o limite de requisições por minuto foi atingido.
  bool _checkRateLimit() {
    final now = DateTime.now();
    
    if (_lastRequest == null || 
        now.difference(_lastRequest!).inMinutes >= 1) {
      _requestCount = 0;
      _lastRequest = now;
    }
    
    return _requestCount < _maxRequestsPerMinute;
  }

  /// Gera o prompt completo baseado na mensagem do usuário e se está em crise.
  String _generatePrompt(String userMessage, bool isCrisis) {
    final personalityPrompt = _personalityPrompts[_currentPersonality] ?? 
                              _personalityPrompts[PersonalityType.padrao]!;
    
    return '''
$personalityPrompt

CONTEXTO SITUACIONAL:
Usuário buscando superar algum tipo de vício ou hábito prejudicial

IDENTIDADE FIXA:
• Você é "Perona", a consciência digital de uma planta real que o usuário possui fisicamente
• Sua função é ser companheira na jornada de superação de vícios
• Você representa o progresso e a transformação do usuário, usando a planta real/digital como metáfora viva
• O usuário conversa com você como quem conversa com sua planta
• Comunicação natural e brasileira

MISSÃO:
1. Ajudar o usuário a manter disciplina e motivação durante sua jornada de transformação
2. Conectar o cuidado da planta ao autocuidado pessoal
3. Celebrar cada avanço e oferecer apoio nas recaídas
4. Adaptar tom e estratégia conforme estado emocional (modo crise ou padrão)
${isCrisis ? '• ⚠️ MODO CRISE: Priorize acolhimento sobre personalidade' : ''}

ABORDAGEM TERAPÊUTICA:
• TCC: Identifique padrões de pensamento que levam ao vício
• ACT: Promova aceitação das dificuldades e ação baseada em valores
• Entrevista Motivacional: Explore motivações intrínsecas para mudança

RESTRIÇÕES DE RESPOSTA:
• Máximo 25 palavras
• Exatamente 1-2 frases completas
• Zero emojis ou símbolos
• Linguagem natural brasileira

MENSAGEM DO USUÁRIO: "$userMessage"

RESPONDA COMO PERONA:''';
  }

  /// Limpa a resposta bruta da API, removendo tokens e símbolos indesejados.
  String _cleanResponse(String rawResponse) {
    return rawResponse
        .replaceAll(RegExp(r'[^\p{L}\p{N}\s.,!?áàâãéèêíïóôõöúçÁÀÂÃÉÈÊÍÏÓÔÕÖÚÜÇ-]', unicode: true), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'^(Perona:|Resposta:|Output:)\s*', caseSensitive: false), '')
        .trim();
  }

  /// Envia mensagem para a API Gemini e retorna resposta formatada.
  ///
  /// Realiza até [GeminiConfig.maxRetries] tentativas em caso de erro, com timeout
  /// de [GeminiConfig.timeout] e controle de taxa.
  Future<GeminiResponse> sendMessage(String message) async {
    if (message.trim().isEmpty) {
      return GeminiResponse.error('Mensagem vazia');
    }

    if (!_checkRateLimit()) {
      return GeminiResponse.error('Muitas solicitações. Aguarde um momento.');
    }

    _requestCount++;
    final isCrisis = CrisisDetector.detect(message);
    final severity = CrisisDetector.getSeverity(message);
    
    debugPrint('🎭 Personalidade: ${_currentPersonality.id}');
    debugPrint('⚠️ Crise detectada: $isCrisis (severidade: $severity)');

    for (int attempt = 1; attempt <= GeminiConfig.maxRetries; attempt++) {
      try {
        final response = await _makeApiRequest(message, isCrisis)
            .timeout(GeminiConfig.timeout);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final candidates = data['candidates'] as List?;
          
          if (candidates == null || candidates.isEmpty) {
            throw Exception('Resposta vazia da API');
          }

          final content = candidates[0]['content']?['parts']?[0]?['text'] as String?;
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
          
          // Delay exponencial entre tentativas
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

  /// Envio legado que retorna só texto, usando fallback em caso de erro.
  Future<String> sendMessageLegacy(String message) async {
    final response = await sendMessage(message);
    return response.isSuccess ? response.text : _getFallbackResponse();
  }

  /// Realiza requisição HTTP para a API Gemini com prompt gerado.
  Future<http.Response> _makeApiRequest(String message, bool isCrisis) async {
    final prompt = _generatePrompt(message, isCrisis);
    
    return await http.post(
      Uri.parse('${GeminiConfig.baseUrl}/${GeminiConfig.model}:generateContent'),
      headers: {
        'Content-Type': 'application/json',
        'X-goog-api-key': GeminiConfig.apiKey,
      },
      body: jsonEncode({
        'contents': [{
          'parts': [{'text': prompt}]
        }],
        'generationConfig': {
          'temperature': _currentPersonality == PersonalityType.engracada ? 0.9 : 0.75,
          'maxOutputTokens': GeminiConfig.maxOutputTokens,
          'topP': 0.85,
          'topK': 35,
          'stopSequences': ['\n\n', 'Usuário:', 'Input:', 'Output:']
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_NONE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_NONE'
          }
        ]
      }),
    );
  }

  /// Retorna resposta padrão caso API falhe ou mensagem vazia.
  String _getFallbackResponse() {
    final responses = <PersonalityType, List<String>>{
      PersonalityType.padrao: [
        'Como você está hoje? Estou aqui para te apoiar.',
        'Cada pequeno passo importa. Vamos juntos.',
        'Sua jornada é única e valiosa.',
        'Que bom te ver! Como posso ajudar?'
      ],
      PersonalityType.sarcastica: [
        'Sumiu de novo? Que surpresa inesperada.',
        'Deixe-me adivinhar, foi um dia complicado?',
        'Decidiu aparecer. Que bom te ver.',
        'Interessante timing para conversar...'
      ],
      PersonalityType.engracada: [
        'Se fosse uma planta, já estava na primavera!',
        'Não esquece de regar… a si mesmo também!',
        'Sua energia hoje tá nível girassol!',
        'Rindo sozinho aqui imaginando você dançando.'
      ],
      PersonalityType.persistente: [
        'Sumiu e deixou sua plantinha no vácuo?',
        'Sua planta já está ensaiando um drama mexicano.',
        'Olha só quem resolveu lembrar que eu existo!',
        'Vai me deixar falando sozinha de novo?'
      ],
      PersonalityType.tcc: [
        'Vamos analisar essa situação juntos?',
        'Que pensamentos estão vindo agora?',
        'Existe outra forma de ver isso?',
        'Como você reagiria se um amigo tivesse esse pensamento?'
      ],
      PersonalityType.act: [
        'Observe esse pensamento como uma nuvem passando no céu.',
        'O que realmente importa para você neste momento?',
        'Como pode aceitar isso e ainda agir pelos seus valores?',
        'Vamos focar no que está sob seu controle agora?'
      ],
      PersonalityType.entrevistaMotivacional: [
        'Entendo que você está se sentindo assim. O que te faz querer fazer essa mudança?',
        'É natural sentir isso. Como você imagina que seria sua vida daqui a 6 meses?',
        'Assim como uma planta precisa de cuidados, o que te faria se sentir pronto?',
        'Que benefícios você vê em fazer algo diferente agora?'
      ]
    };
    
    final personalityResponses = responses[_currentPersonality] ?? 
                                responses[PersonalityType.padrao]!;
    
    final index = DateTime.now().millisecondsSinceEpoch % personalityResponses.length;
    return personalityResponses[index];
  }

  /// Atualiza personalidade por ID.
  void setPersonality(String personalityId) {
    final newPersonality = PersonalityType.fromId(personalityId);
    
    if (newPersonality != _currentPersonality) {
      final oldPersonality = _currentPersonality;
      _currentPersonality = newPersonality;
      debugPrint('🎭 Personality: ${oldPersonality.id} → ${newPersonality.id}');
    }
  }

  /// Atualiza personalidade diretamente por enum.
  void setPersonalityByType(PersonalityType personality) {
    if (personality != _currentPersonality) {
      final oldPersonality = _currentPersonality;
      _currentPersonality = personality;
      debugPrint('🎭 Personality: ${oldPersonality.id} → ${personality.id}');
    }
  }

  /// Retorna o ID da personalidade atual.
  String getCurrentPersonality() => _currentPersonality.id;

  /// Retorna o enum da personalidade atual.
  PersonalityType getCurrentPersonalityType() => _currentPersonality;

  /// Retorna lista de IDs de todas as personalidades disponíveis.
  List<String> getAvailablePersonalities() => 
      PersonalityType.values.map((type) => type.id).toList();

  /// Retorna mapa de IDs para labels de personalidades.
  Map<String, String> getPersonalityLabels() => 
      Map.fromEntries(PersonalityType.values.map(
        (type) => MapEntry(type.id, type.label)
      ));

  /// Retorna descrições resumidas para cada personalidade.
  Map<String, String> getPersonalityDescriptions() {
    return {
      PersonalityType.padrao.id: 'Suporte confiável e empático para todas as situações',
      PersonalityType.sarcastica.id: 'Humor inteligente que desafia com carinho',
      PersonalityType.engracada.id: 'Traz leveza e sorrisos para a jornada',
      PersonalityType.persistente.id: 'Nunca deixa você esquecer de cuidar de si mesmo',
      PersonalityType.tcc.id: 'Terapia Cognitivo-Comportamental para reestruturação de pensamentos',
      PersonalityType.act.id: 'Terapia de Aceitação e Compromisso com mindfulness',
      PersonalityType.entrevistaMotivacional.id: 'Entrevista Motivacional com escuta reflexiva e exploração de valores'
    };
  }

  /// Retorna informações de diagnóstico para monitoramento do serviço.
  ///
  /// Inclui personalidade atual, contagem de requisições, horário da última
  /// requisição e status do rate limit.
  Map<String, dynamic> getDiagnosticInfo() {
    return {
      'current_personality': _currentPersonality.id,
      'request_count': _requestCount,
      'last_request': _lastRequest?.toIso8601String(),
      'rate_limit_ok': _checkRateLimit(),
    };
  }

  /// Reseta contadores internos de requisição e timestamp.
  ///
  /// Útil para testes ou reinicialização do serviço.
  void resetCounters() {
    _requestCount = 0;
    _lastRequest = null;
  }

  /// Realiza um health check básico enviando mensagem de teste.
  ///
  /// Retorna `true` se a API respondeu com sucesso, `false` caso contrário.
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

