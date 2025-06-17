import 'package:dio/dio.dart';
import 'dart:math';

/// Modelo de dados para resposta da API PaperQuotes (https://paperquotes.com/api-docs/#quotes-by-language)
/// Contém apenas o texto da frase.
class Quote {
  final String text;

  Quote({
    required this.text,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    // A API PaperQuotes retorna as frases em uma lista dentro do campo 'results'.
    // Exemplo de resposta:
    // {
    //   "results": [
    //     { "quote": "Texto da frase" },
    //     ...
    //   ]
    // }
    String raw = json['quote'] ?? '';
    // Remove aspas e espaços do início e fim (duplas, simples, curvas)
    String clean = raw.trim();
    // Lista de aspas a remover
    final aspas = ['"', '"', '"', '„', '‟', '\'', '«', '»'];
    for (final a in aspas) {
      if (clean.startsWith(a)) clean = clean.substring(1);
      if (clean.endsWith(a)) clean = clean.substring(0, clean.length - 1);
      clean = clean.trim();
    }
    return Quote(
      text: clean,
    );
  }

  /// Lista de frases motivacionais como fallback
  static const List<String> _fallbackQuotes = [
    "Acredite em você mesmo e tudo será possível.",
    "Cada dia é uma nova oportunidade para crescer.",
    "A vida é bela quando você encontra sua própria flor para cuidar.",
    "Pequenos passos diários levam a grandes transformações.",
    "Sua jornada de autocuidado é única e valiosa.",
    "Cultive seus sonhos como cuida de suas plantas.",
    "A paciência e o amor são os melhores fertilizantes para o crescimento.",
    "Cada momento de cuidado consigo mesmo é um investimento no seu futuro.",
    "Você é capaz de florescer mesmo nos momentos mais difíceis.",
    "A natureza nos ensina que crescer leva tempo, e está tudo bem.",
    "Como uma planta que busca a luz, você sempre encontra seu caminho.",
    "Regue seus sonhos com dedicação e veja-os florescer.",
    "Cada novo dia é uma semente de possibilidades infinitas.",
    "Transforme seus obstáculos em degraus para o crescimento.",
    "O cuidado de hoje é a felicidade de amanhã."
  ];

  /// Busca uma frase motivacional com fallback local
  static Future<Quote> fetchQuote() async {
    try {
      // Tenta buscar na API PaperQuotes primeiro
      final dio = createDioQuoteApi();
      final response = await dio.get('apiv1/quotes/', queryParameters: {
        'lang': 'pt',
        'curated': '1',
      });
      
      if (response.statusCode == 200 && 
          response.data['results'] != null && 
          response.data['results'].isNotEmpty) {
        final results = response.data['results'];
        final randomIndex = Random().nextInt(results.length);
        print('[Quote] Frase obtida da API PaperQuotes');
        return Quote.fromJson(results[randomIndex]);
      } else {
        // Se a API não retornar dados válidos, usa fallback
        print('[Quote] API não retornou dados válidos, usando fallback');
        return _getFallbackQuote();
      }
    } catch (e) {
      print('[Quote] Erro na API: $e');
      // Se a API estiver fora do ar (erro 522 ou qualquer outro), usa fallback
      print('[Quote] Usando frase local como fallback');
      return _getFallbackQuote();
    }
  }

  /// Retorna uma frase local aleatória
  static Quote _getFallbackQuote() {
    final randomIndex = Random().nextInt(_fallbackQuotes.length);
    return Quote(text: _fallbackQuotes[randomIndex]);
  }

  /// Retorna uma frase local específica por índice (para testes)
  static Quote getFallbackQuoteByIndex(int index) {
    if (index >= 0 && index < _fallbackQuotes.length) {
      return Quote(text: _fallbackQuotes[index]);
    }
    return _getFallbackQuote();
  }

  /// Retorna o número total de frases locais disponíveis
  static int get totalFallbackQuotes => _fallbackQuotes.length;

  /// Configuração do Dio para a API PaperQuotes
  static Dio createDioQuoteApi() {
    Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        baseUrl: 'https://api.paperquotes.com/',
      ),
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        print('[PaperQuotes] Request: \\${options.method} \\${options.uri}');
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        print('[PaperQuotes] Response: \\${response.statusCode}');
        if (response.statusCode == 200) {
          print('[PaperQuotes] Dados recebidos com sucesso');
        } else {
          print('[PaperQuotes] Erro na resposta: ${response.statusMessage}');
        }
        return handler.next(response);
      },
      onError: (error, handler) async {
        print('[PaperQuotes] Error: \\${error.message}');
        return handler.next(error);
      },
    ));
    return dio;
  }
} 