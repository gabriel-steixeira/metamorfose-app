/**
 * File: app_constants.dart
 * Description: Constantes globais do aplicativo Metamorfose.
 *
 * Responsabilidades:
 * - Definir constantes globais para o aplicativo
 * - Fornecer acesso a constantes comuns
 *
 * Author: Evelin Cordeiro
 * Created on: 31-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

class AppConstants {
  // Privado para prevenir instanciação
  AppConstants._();

  // Animações
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration pulseAnimationDuration = Duration(seconds: 2);

  // Tamanhos base (serão multiplicados pelos fatores responsivos)
  static const double baseFontSize = 16.0;
  static const double basePadding = 16.0;
  static const double baseSpacing = 8.0;
  static const double baseBorderRadius = 12.0;
  static const double baseIconSize = 24.0;

  // Limites de conteúdo
  static const int maxChatMessageLength = 1000;
  static const int maxPlantNameLength = 50;
  static const int messageSplitLength =
      60; // Caracteres por linha no voice chat

  // Timeouts
  static const Duration messageDisplayTimeout = Duration(seconds: 3);
  static const Duration networkTimeout = Duration(seconds: 15);

  // Paths de assets
  static const String defaultPlantSvg =
      'assets/images/plantsetup/plantsetup.svg';
  static const String bluePlantSvg =
      'assets/images/plantsetup/plantsetup_blue.svg';
  static const String greenPlantSvg =
      'assets/images/plantsetup/plantsetup_green.svg';
  static const String pinkPlantSvg =
      'assets/images/plantsetup/plantsetup_pink.svg';

  // Mensagens padrão
  static const String defaultPlantName = 'Plantinha';
  static const String defaultWelcomeMessage = 'Como posso te ajudar hoje?';
  static const String loadingMessage = 'está digitando...';
  static const String listeningMessage = 'Ouvindo...';
  static const String errorMessage =
      'Desculpe, não consegui processar sua mensagem no momento. Pode tentar novamente?';

  // Voice Chat
  static const String voiceChatPlaceholder = 'Escrever mensagem';
  static const int voiceChatCircleCount = 4;
  static const double voiceChatImageSize = 200.0;
  static const double voiceChatImageContainerSize = 280.0;

  // Chat bubble
  static const double chatBubbleMaxWidthRatio =
      0.8; // 80% da largura da tela no mobile
  static const double chatBubbleTabletWidthRatio =
      0.7; // 70% da largura máxima no tablet+
  static const double chatAvatarSize = 32.0;

  // Header
  static const double headerIconSize = 20.0;
  static const double headerToggleWidth = 110.0;
  static const double headerToggleHeight = 40.0;
  static const double headerSelectorSize = 50.0;

  // Z-indexes (para layers)
  static const int backgroundLayer = 0;
  static const int contentLayer = 1;
  static const int overlayLayer = 2;
  static const int modalLayer = 3;
  static const int tooltipLayer = 4;
}

/// Enums para tipos comuns
enum LoadingState { initial, loading, loaded, error }

enum ChatMode { voice, text }

enum MessageType { user, assistant, system }

/// Utilitários para assets
class AssetUtils {
  AssetUtils._();

  static String getPlantSvgPath(int? colorValue) {
    // Verificar se colorValue não é nulo antes de comparar
    if (colorValue != null) {
      // Comparar com os valores das cores do tema
      if (colorValue == 0xFF42A5F5)
        return AppConstants.bluePlantSvg; // blueNormal
      if (colorValue == 0xFF66BB6A)
        return AppConstants.greenPlantSvg; // greenNormal
      if (colorValue == 0xFFEC407A)
        return AppConstants.pinkPlantSvg; // pinkNormal
    }
    return AppConstants.defaultPlantSvg; // roxo padrão
  }

  static String getGreetingByTime() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'manhã';
    if (hour < 18) return 'tarde';
    return 'noite';
  }
}

/// Validadores comuns
class Validators {
  Validators._();

  static bool isValidMessage(String? message) {
    return message != null &&
        message.trim().isNotEmpty &&
        message.length <= AppConstants.maxChatMessageLength;
  }

  static bool isValidPlantName(String? name) {
    return name != null &&
        name.trim().isNotEmpty &&
        name.length <= AppConstants.maxPlantNameLength;
  }

  static String sanitizeMessage(String message) {
    return message.trim().substring(
        0,
        message.length > AppConstants.maxChatMessageLength
            ? AppConstants.maxChatMessageLength
            : message.length);
  }
}
