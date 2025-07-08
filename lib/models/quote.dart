import 'dart:math';

/// Modelo de dados para quotes motivacionais
/// Sistema focado em frases locais em português específicas para superação de vícios
class Quote {
  final String text;

  Quote({
    required this.text,
  });

  /// Lista expandida de frases motivacionais em português para superação de vícios
  /// Cada frase é cuidadosamente selecionada para o contexto do projeto Metamorfose
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
    "O cuidado de hoje é a felicidade de amanhã.",
    "Sua força interior é maior do que qualquer tempestade.",
    "Cada respiração é uma chance de recomeçar.",
    "O progresso não precisa ser perfeito, apenas constante.",
    "Você é o jardineiro da sua própria vida.",
    "Pequenas mudanças hoje criam grandes resultados amanhã.",
    "A coragem não é a ausência do medo, mas agir apesar dele.",
    "Sua jornada é única, não compare com a de outros.",
    "O que você planta hoje, colherá no futuro.",
    "Seja gentil consigo mesmo durante o processo de crescimento.",
    "Cada dia vencido é uma vitória a ser celebrada.",
    "Você tem tudo o que precisa para superar este desafio.",
    "A mudança começa com um único passo corajoso.",
    "Sua determinação é mais forte que qualquer obstáculo.",
    "Lembre-se: você já superou 100% dos seus dias difíceis.",
    "O autocuidado não é egoísmo, é necessidade.",
    "Sua metamorfose acontece um dia de cada vez.",
    "Como uma borboleta, você está se transformando constantemente.",
    "Cada escolha saudável é um ato de amor próprio.",
    "Você merece toda a felicidade que está construindo.",
    "Sua planta cresce porque você escolhe cuidar dela diariamente.",
    "A força para mudar sempre esteve dentro de você.",
    "Celebre cada pequena vitória no seu caminho.",
    "Você é mais resiliente do que imagina.",
    "Sua jornada de cura inspira outros ao seu redor.",
    "O amor próprio é o primeiro passo para qualquer transformação.",
  ];

  /// Busca uma frase motivacional do sistema local
  /// Sempre retorna frases em português específicas para o contexto de superação
  static Future<Quote> fetchQuote() async {
    try {
      // Simular um pequeno delay para manter a experiência natural
      await Future.delayed(const Duration(milliseconds: 300));
      
      print('[Quote] Usando sistema local de frases motivacionais');
      return _getLocalQuote();
    } catch (e) {
      print('[Quote] Erro inesperado, usando frase padrão: $e');
      return _getLocalQuote();
    }
  }

  /// Retorna uma frase local aleatória
  static Quote _getLocalQuote() {
    final randomIndex = Random().nextInt(_fallbackQuotes.length);
    final selectedQuote = _fallbackQuotes[randomIndex];
    
    print('[Quote] Frase selecionada: "$selectedQuote"');
    return Quote(text: selectedQuote);
  }

  /// Retorna uma frase local específica por índice (para testes)
  static Quote getQuoteByIndex(int index) {
    if (index >= 0 && index < _fallbackQuotes.length) {
      return Quote(text: _fallbackQuotes[index]);
    }
    return _getLocalQuote();
  }

  /// Retorna o número total de frases locais disponíveis
  static int get totalQuotes => _fallbackQuotes.length;

  /// Retorna uma frase específica para momentos de dificuldade
  static Quote getMotivationalQuote() {
    final motivationalQuotes = [
      "Sua força interior é maior do que qualquer tempestade.",
      "Você tem tudo o que precisa para superar este desafio.",
      "A mudança começa com um único passo corajoso.",
      "Lembre-se: você já superou 100% dos seus dias difíceis.",
      "Você é mais resiliente do que imagina.",
      "A força para mudar sempre esteve dentro de você.",
    ];
    
    final randomIndex = Random().nextInt(motivationalQuotes.length);
    return Quote(text: motivationalQuotes[randomIndex]);
  }

  /// Retorna uma frase específica para celebração de progresso
  static Quote getCelebrationQuote() {
    final celebrationQuotes = [
      "Cada dia vencido é uma vitória a ser celebrada.",
      "Celebre cada pequena vitória no seu caminho.",
      "Você merece toda a felicidade que está construindo.",
      "Sua metamorfose acontece um dia de cada vez.",
      "Como uma borboleta, você está se transformando constantemente.",
      "Sua jornada de cura inspira outros ao seu redor.",
    ];
    
    final randomIndex = Random().nextInt(celebrationQuotes.length);
    return Quote(text: celebrationQuotes[randomIndex]);
  }

  /// Retorna uma frase específica para autocuidado
  static Quote getSelfCareQuote() {
    final selfCareQuotes = [
      "O autocuidado não é egoísmo, é necessidade.",
      "Cada escolha saudável é um ato de amor próprio.",
      "O amor próprio é o primeiro passo para qualquer transformação.",
      "Seja gentil consigo mesmo durante o processo de crescimento.",
      "Cada momento de cuidado consigo mesmo é um investimento no seu futuro.",
      "Sua jornada de autocuidado é única e valiosa.",
    ];
    
    final randomIndex = Random().nextInt(selfCareQuotes.length);
    return Quote(text: selfCareQuotes[randomIndex]);
  }
} 