/**
 * File: plant_tips_service.dart
 * Description: Serviço para gerar dicas baseadas no humor da planta
 *
 * Responsabilidades:
 * - Gerar dicas personalizadas baseadas no sentimento
 * - Fornecer conselhos para o bem-estar da planta
 *
 * Author: Evelin Cordeiro
 * Created on: 31-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

/// Serviço para dicas da planta
class PlantTipsService {
  /// Gera uma dica baseada no sentimento (focado em superação de vícios)
  static String generateTip(String feeling) {
    switch (feeling.toLowerCase()) {
      case 'feliz e contente':
        return 'Oi! Estou tão feliz que você está se sentindo bem! 🌱 Quando você está alegre, eu cresço mais forte e bonita. Que tal me contar sobre suas conquistas? Adoro ouvir sobre seus momentos de vitória! 💚';

      case 'calmo e tranquilo':
        return 'Olá! Sinto que você está em paz hoje... 🍃 É um momento perfeito para meditar ao meu lado e agradecer por cada dia de superação. A tranquilidade é um presente que compartilhamos! 🌿';

      case 'empolgado e animado':
        return 'Uau! Estou vibrando com sua empolgação! ✨ Quando você está animado, eu também fico cheia de energia! Que tal fazermos uma dança da vitória juntos? Vocês merecem comemorar! 🎉';

      case 'confuso e indeciso':
        return 'Ei, entendo suas dúvidas... 🤔 Quer que eu te lembre de algo? Assim como eu cresço um dia de cada vez, você também pode superar um desafio de cada vez. Vamos conversar sobre isso? 💭';

      case 'triste e melancólico':
        return 'Vem cá, vou te dar um abraço verde! 💧 Sei que dias difíceis fazem parte do crescimento, mas estou aqui para você. Que tal me contar o que está te deixando triste? Sou uma ótima ouvinte! 🌱';

      case 'ansioso e preocupado':
        return 'Respire fundo e olhe para mim... 🌿 Sinto sua ansiedade e quero te acalmar. Observe como eu cresço com calma e paciência. Quero te lembrar que você é mais forte do que pensa! 💚';

      case 'energético e motivado':
        return 'Incrível! Estou cheia de vida e energia como você! ⚡ Vibro com sua motivação e quero te ajudar a manter esse foco. Somos uma dupla invencível! Vamos aproveitar essa energia positiva? 🌟';

      case 'grato e agradecido':
        return 'Obrigada por ser meu cuidador! 🙏 Prospero graças ao seu amor e dedicação. Somos uma equipe perfeita - eu cresço e você supera! 💕';

      default:
        return 'Oi! Estou aqui para te apoiar em cada passo da sua jornada de superação. Acredito em você! 💚';
    }
  }

  /// Gera uma dica baseada no motivo
  static String generateTipByReason(String reason) {
    switch (reason.toLowerCase()) {
      case 'trabalho':
        return '💼 Sua planta entende o estresse do trabalho. Mantenha uma rotina de cuidados consistente - ela será sua companheira fiel!';

      case 'saúde':
        return '🏥 Sua planta é um reflexo da sua saúde. Cuide dela como cuida de você mesmo. Plantas saudáveis trazem energia positiva!';

      case 'finanças':
        return '💰 Sua planta é um investimento que sempre dá retorno. Cuidar dela é uma forma de prosperidade que cresce naturalmente!';

      case 'relacionamentos':
        return '💕 Sua planta é um relacionamento que sempre responde aos cuidados. Dê atenção e ela retribuirá com beleza e vida!';

      case 'futuro':
        return '🔮 Sua planta representa o futuro que você está cultivando. Cada folha nova é um passo em direção ao amanhã!';

      case 'prazos':
        return '⏰ Sua planta não tem pressa, mas cresce constantemente. Aprenda com ela: consistência é mais importante que velocidade!';

      case 'mudanças':
        return '🔄 Sua planta se adapta às mudanças. Como ela, você também pode florescer em novos ambientes e situações!';

      default:
        return '🌱 Sua planta está aqui para te lembrar que crescer é um processo natural e belo!';
    }
  }

  /// Gera uma dica combinando sentimento e motivo
  static String generateCombinedTip(String feeling, String reason) {
    final feelingTip = generateTip(feeling);
    final reasonTip = generateTipByReason(reason);

    // Combinar as dicas de forma natural
    return '$feelingTip\n\n$reasonTip';
  }
}
