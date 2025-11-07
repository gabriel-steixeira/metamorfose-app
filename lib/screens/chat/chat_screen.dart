/// File: chat_screen.dart
/// Description: Tela de chat híbrido (voz e texto) com integração completa de IA.
///
/// Responsabilidades:
/// - Interface de chat híbrido (voz e texto)
/// - Integração com personalidades
///
/// Author: Evelin Cordeiro
/// Created on: 31-08-2025
/// Last modified: 31-08-2025
///
/// Version: 1.0.0
/// Squad: Metamorfose

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/theme/typography.dart';
import 'package:metamorfose_flutter/utils/app_constants.dart';
import 'package:metamorfose_flutter/components/chat_bubble.dart';
import 'package:metamorfose_flutter/components/avatar.dart';

import 'package:metamorfose_flutter/blocs/voice_chat_bloc.dart';
import 'package:metamorfose_flutter/blocs/text_chat_bloc.dart';
import 'package:metamorfose_flutter/services/gemini_service.dart';
import 'package:metamorfose_flutter/services/plant_care_service.dart';
import 'package:metamorfose_flutter/services/hybrid_auth_service.dart';
import 'package:metamorfose_flutter/services/speech_service.dart';
import 'package:metamorfose_flutter/models/user_model.dart';
import 'package:metamorfose_flutter/models/chat_message.dart';

/// Tela principal de chat híbrido (voz e texto) com o assistente usando BLoC.
class ChatScreen extends StatefulWidget {
  /// Personalidade específica para iniciar a conversa (opcional)
  final PersonalityType? initialPersonality;

  const ChatScreen({
    super.key,
    this.initialPersonality,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _circleController;

  UserModel? _currentUser;
  Map<String, dynamic>? _plantInfo;
  bool _isVoiceMode = true; // true para voz, false para texto
  final TextEditingController _textController = TextEditingController();
  bool _isListening = false;
  String _currentStatusText = '';
  List<String> _messageParts = [];
  int _currentPartIndex = 0;
  Timer? _textDisplayTimer;
  int _processingMessageIndex = 0;
  Timer? _processingMessageTimer;

  // Mensagens temáticas da consciência da planta durante processamento
  static const List<String> _processingMessages = [
    'Estamos acordando sua plantinha...',
    'Ela está se preparando para você...',
    'Está quase pronta, aguarde um momento...',
    'Sua plantinha está pensando...',
    'Ela está organizando as ideias...',
    'Quase lá, ela está se concentrando...',
    'Sua plantinha está absorvendo tudo...',
    'Ela está se preparando para responder...',
    'Aguarde, ela está processando...',
    'Sua plantinha está refletindo sobre isso...',
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _circleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _loadCurrentUser();
    _loadPlantInfo();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Inicializa o VoiceChatBloc automaticamente
      context.read<VoiceChatBloc>().add(VoiceChatInitializeEvent());
      
      if (widget.initialPersonality != null) {
        context
            .read<VoiceChatBloc>()
            .add(VoiceChatChangePersonalityEvent(
              widget.initialPersonality!,
              silent: true, // Inicialização silenciosa
            ));
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _circleController.dispose();
    _textController.dispose();
    _textDisplayTimer?.cancel();
    _processingMessageTimer?.cancel();
    super.dispose();
  }

  /// Obtém mensagem de processamento rotativa
  String _getProcessingMessage() {
    return _processingMessages[_processingMessageIndex % _processingMessages.length];
  }

  /// Inicia rotação de mensagens de processamento
  void _startProcessingMessageRotation() {
    _processingMessageTimer?.cancel();
    _processingMessageIndex = 0;
    
    // Rotaciona mensagem a cada 2 segundos
    _processingMessageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _processingMessageIndex = (_processingMessageIndex + 1) % _processingMessages.length;
        });
      } else {
        timer.cancel();
      }
    });
  }

  /// Para rotação de mensagens de processamento
  void _stopProcessingMessageRotation() {
    _processingMessageTimer?.cancel();
    _processingMessageIndex = 0;
  }

  void _displayPlantMessage(String fullMessage) {
    setState(() {
      _messageParts = _splitMessageIntoParts(fullMessage);
      _currentPartIndex = 0;
    });

    _showNextMessagePart();
  }

  List<String> _splitMessageIntoParts(String message) {
    final words = message.split(' ');
    final parts = <String>[];
    String currentPart = '';

    for (String word in words) {
      String testPart = currentPart.isEmpty ? word : '$currentPart $word';

      if (testPart.length <= AppConstants.messageSplitLength) {
        currentPart = testPart;
      } else {
        if (currentPart.isNotEmpty) {
          parts.add(currentPart);
          currentPart = word;
        } else {
          parts.add(word);
        }
      }
    }

    if (currentPart.isNotEmpty) {
      parts.add(currentPart);
    }

    return parts;
  }

  void _showNextMessagePart() {
    if (_currentPartIndex < _messageParts.length) {
      setState(() {
        _currentStatusText = _messageParts[_currentPartIndex];
      });

      _currentPartIndex++;

      // Mostrar próxima parte após timeout definido
      _textDisplayTimer?.cancel();
      _textDisplayTimer = Timer(AppConstants.messageDisplayTimeout, () {
        if (_currentPartIndex < _messageParts.length) {
          _showNextMessagePart();
        } else {
          // Terminou de mostrar todas as partes
          setState(() {
            _currentStatusText = '';
          });
        }
      });
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      final authService = HybridAuthService();
      final user = await authService.getCurrentUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar usuário: $e');
    }
  }

  Future<void> _loadPlantInfo() async {
    try {
      debugPrint('🌱 Chat: Iniciando carregamento dos dados da planta...');
      // Usar PlantCareService diretamente (mesma lógica do plant-care)
      final plantCareService = PlantCareService();
      final plantInfo = await plantCareService.loadPlantInfo();

      if (mounted) {
        setState(() {
          _plantInfo = plantInfo;
        });
        debugPrint('🌱 Chat: Dados da planta carregados: $plantInfo');

        // Define o nome da planta no voice chat
        if (plantInfo['name'] != null) {
          context
              .read<VoiceChatBloc>()
              .add(VoiceChatSetPlantNameEvent(plantInfo['name'] as String));
        }

        // Define o nome do usuário no voice chat
        if (_currentUser?.name != null || _currentUser?.completeName != null) {
          context
              .read<VoiceChatBloc>()
              .add(VoiceChatSetUserNameEvent(_currentUser!));
        }
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar informações da planta: $e');
    }
  }

  String _getPlantSvgAsset(int? colorValue) {
    if (colorValue == MetamorfoseColors.blueNormal.value) {
      return 'assets/images/plantsetup/plantsetup_blue.svg';
    }
    if (colorValue == MetamorfoseColors.greenNormal.value) {
      return 'assets/images/plantsetup/plantsetup_green.svg';
    }
    if (colorValue == MetamorfoseColors.pinkNormal.value) {
      return 'assets/images/plantsetup/plantsetup_pink.svg';
    }
    return 'assets/images/plantsetup/plantsetup.svg'; // Roxo padrão
  }

  void _toggleListening() {
    final voiceChatState = context.read<VoiceChatBloc>().state;
    
    // Verificar se pode interagir - permitir apenas se:
    // 1. Está gravando (pode parar)
    // 2. Pode iniciar gravação (idle e não ocupado)
    // 3. Não está falando, processando ou com erro
    final canInteract = voiceChatState.isRecording || 
        (voiceChatState.canStartRecording && 
         voiceChatState.speechState != SpeechState.speaking &&
         voiceChatState.speechState != SpeechState.error &&
         !voiceChatState.isProcessing);
    
    if (!canInteract) {
      debugPrint('⚠️ Não é possível iniciar gravação: sistema ocupado (estado: ${voiceChatState.speechState}, isBusy: ${voiceChatState.isBusy})');
      return;
    }

    setState(() {
      _isListening = !_isListening;
      _currentStatusText = _isListening ? AppConstants.listeningMessage : '';
    });
    context.read<VoiceChatBloc>().add(VoiceChatToggleListeningEvent());
  }

  void _sendTextMessageWithContext(BuildContext context) {
    final message = _textController.text.trim();
    if (message.isNotEmpty) {
      try {
        // Usar o contexto específico do BlocConsumer
        final voiceChatBloc = BlocProvider.of<VoiceChatBloc>(context);
        final currentPersonality = voiceChatBloc.state.currentPersonality;

        debugPrint(
            '📤 Enviando mensagem com contexto: "$message" com personalidade: $currentPersonality');

        // Usar o contexto do BlocConsumer para acessar TextChatBloc
        final textChatBloc = BlocProvider.of<TextChatBloc>(context);
        final plantName = _plantInfo?['name'] as String?;
        textChatBloc.add(SendMessageEvent(message, currentPersonality,
            plantName: plantName, user: _currentUser));

        _textController.clear();
        debugPrint('✅ Mensagem enviada com sucesso via contexto');
      } catch (e) {
        debugPrint('❌ Erro ao enviar mensagem via contexto: $e');
      }
    }
  }

  /// Header responsivo com navegação, nome da planta, toggle e seletor de personalidade
  Widget _buildHeader(VoiceChatState state) {
    // Valores responsivos
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final topPadding = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 8.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final bottomPadding = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 18.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 12.0),
      ],
    ).value;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding).copyWith(
          top: topPadding,
          bottom: bottomPadding,
        ),
        child: Row(
          children: [
            // Botão de voltar responsivo
            IconButton(
              onPressed: () => context.go('/home'),
              icon: Icon(
                Icons.arrow_back_ios,
                color: MetamorfoseColors.whiteLight,
                size: iconSize,
              ),
            ),

            SizedBox(width: spacing),

            // Nome da planta responsivo
            Flexible(
              child: Text(
                _plantInfo?['name'] ?? 'Chat',
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: MetamorfoseColors.whiteLight,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.start,
              ),
            ),

            const Spacer(),

            // Toggle responsivo no meio
            _buildChatModeToggle(),

            const Spacer(),

            // Seletor de personalidade responsivo
            _buildPersonalitySelector(state),
          ],
        ),
      ),
    );
  }

  /// Toggle responsivo entre Voice e Text
  Widget _buildChatModeToggle() {
    final toggleWidth = ResponsiveValue<double>(
      context,
      defaultValue: 110.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 100.0),
        Condition.largerThan(name: TABLET, value: 120.0),
      ],
    ).value;

    final toggleHeight = ResponsiveValue<double>(
      context,
      defaultValue: 40.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 36.0),
        Condition.largerThan(name: TABLET, value: 44.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 3.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 2.0),
        Condition.largerThan(name: TABLET, value: 4.0),
      ],
    ).value;

    return Container(
      width: toggleWidth,
      height: toggleHeight,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: MetamorfoseColors.whiteLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          Expanded(
              child: _buildToggleOption(Icons.mic_rounded, true, _isVoiceMode)),
          Expanded(
              child: _buildToggleOption(
                  Icons.chat_bubble_outline, false, !_isVoiceMode)),
        ],
      ),
    );
  }

  Widget _buildToggleOption(IconData icon, bool isVoice, bool isSelected) {
    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 9.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 8.0),
        Condition.largerThan(name: TABLET, value: 12.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
      ],
    ).value;

    return GestureDetector(
      onTap: () => _handleToggleChange(isVoice),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? MetamorfoseColors.whiteLight : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Icon(
            icon,
            size: iconSize,
            color: isSelected
                ? MetamorfoseColors.purpleNormal
                : MetamorfoseColors.whiteLight,
          ),
        ),
      ),
    );
  }

  void _handleToggleChange(bool isVoice) {
    setState(() {
      _isVoiceMode = isVoice;
    });

    // Se entrando no modo texto, inicializar com mensagem de boas-vindas
    if (!isVoice) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          final textChatBloc = BlocProvider.of<TextChatBloc>(context);
          final plantName = _plantInfo?['name'] as String?;
          textChatBloc.add(InitializeWithWelcomeEvent(plantName: plantName));
          setState(() {});
        } catch (e) {
          debugPrint('❌ Erro ao inicializar chat de texto: $e');
        }
      });
    }
  }

  /// Seletor de personalidade responsivo
  Widget _buildPersonalitySelector(VoiceChatState state) {
    final selectorSize = ResponsiveValue<double>(
      context,
      defaultValue: 50.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 45.0),
        Condition.largerThan(name: TABLET, value: 55.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final height = ResponsiveValue<double>(
      context,
      defaultValue: 40.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 36.0),
        Condition.largerThan(name: TABLET, value: 44.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
      ],
    ).value;

    final offset = ResponsiveValue<double>(
      context,
      defaultValue: 50.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 45.0),
        Condition.largerThan(name: TABLET, value: 55.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    return Container(
      width: selectorSize,
      height: height,
      decoration: BoxDecoration(
        color: MetamorfoseColors.whiteLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: PopupMenuButton<PersonalityType>(
        initialValue: state.currentPersonality,
        icon: Icon(
          Icons.psychology,
          color: MetamorfoseColors.whiteLight,
          size: iconSize,
        ),
        offset: Offset(0, offset),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: MetamorfoseColors.whiteLight,
        onSelected: (PersonalityType personality) {
          context.read<VoiceChatBloc>().add(
                VoiceChatChangePersonalityEvent(personality, silent: false),
              );
        },
        itemBuilder: (BuildContext context) {
          return PersonalityType.values.map((PersonalityType personality) {
            return PopupMenuItem<PersonalityType>(
              value: personality,
              child: Row(
                children: [
                  Icon(
                    _getPersonalityIcon(personality),
                    color: MetamorfoseColors.purpleNormal,
                    size: iconSize,
                  ),
                  SizedBox(width: spacing),
                  Text(
                    _getPersonalityLabel(personality),
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                      color: MetamorfoseColors.greyMedium,
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }).toList();
        },
      ),
    );
  }

  String _getPersonalityLabel(PersonalityType personality) {
    switch (personality) {
      case PersonalityType.padrao:
        return 'Padrão';
      case PersonalityType.sarcastica:
        return 'Sarcástica';
      case PersonalityType.engracada:
        return 'Engraçada';
      case PersonalityType.persistente:
        return 'Persistente';
    }
  }

  IconData _getPersonalityIcon(PersonalityType personality) {
    switch (personality) {
      case PersonalityType.padrao:
        return Icons.favorite;
      case PersonalityType.sarcastica:
        return Icons.psychology;
      case PersonalityType.engracada:
        return Icons.sentiment_very_satisfied;
      case PersonalityType.persistente:
        return Icons.fitness_center;
    }
  }

  /// Interface de voz com design baseado na referência
  Widget _buildVoiceInterface(VoiceChatState state) {
    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 60.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 40.0),
        Condition.largerThan(name: TABLET, value: 80.0),
      ],
    ).value;

    final textHeight = ResponsiveValue<double>(
      context,
      defaultValue: 80.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 60.0),
        Condition.largerThan(name: TABLET, value: 100.0),
      ],
    ).value;

    final bottomSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 32.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 40.0),
      ],
    ).value;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding).copyWith(
        top: padding,
        bottom: 0, // Sem padding inferior para ficar próximo ao footer
      ),
      child: Column(
        children: [
          // Conteúdo superior com scroll
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Espaço mínimo no topo
                  SizedBox(height: spacing * 0.5),

                  // Foto da planta - posição fixa
                  _buildPlantImage(),

                  SizedBox(height: spacing),

                  // Container com altura fixa para o texto
                  SizedBox(
                    height: textHeight,
                    child: Center(
                      child: _buildWelcomeMessage(state),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botão fixo na parte inferior - próximo ao footer
          SafeArea(
            top: false,
            minimum: EdgeInsets.only(
              bottom: bottomSpacing,
            ),
            child: _buildTextInput(),
          ),
        ],
      ),
    );
  }

  /// Interface de texto moderna
  Widget _buildTextInterface(VoiceChatState state) {
    final listPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final loadingPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final loadingVerticalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 12.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return Column(
      children: [
        // Lista de mensagens ocupando todo espaço
        Expanded(
          child: BlocBuilder<TextChatBloc, TextChatState>(
            builder: (context, textChatState) {
              if (textChatState.messages.isEmpty) {
                // Mostrar mensagem inicial centralizada
                return _buildInitialTextMessage();
              }

              return ListView.builder(
                padding: EdgeInsets.all(listPadding),
                itemCount: textChatState.messages.length,
                itemBuilder: (context, index) {
                  final message = textChatState.messages[index];
                  return _buildMessageBubble(message);
                },
              );
            },
          ),
        ),

        // Loading indicator
        BlocBuilder<TextChatBloc, TextChatState>(
          builder: (context, textChatState) {
            if (textChatState.isLoading) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: loadingPadding,
                  vertical: loadingVerticalPadding,
                ),
                color: MetamorfoseColors.whiteLight,
                child: Row(
                  children: [
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            MetamorfoseColors.purpleNormal),
                      ),
                    ),
                    SizedBox(width: spacing),
                    Text(
                      '${_plantInfo?['name'] ?? AppConstants.defaultPlantName} ${AppConstants.loadingMessage}',
                      style: TextStyle(
                        color: MetamorfoseColors.greyMedium,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'DinNext',
                        fontSize: fontSize,
                      ),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // Input de mensagem fixo no bottom
        _buildTextInput(),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final avatar = message.isUser
        ? Avatar.user(
            photoUrl: _currentUser?.photoUrl,
            initials: _getUserInitials(),
          )
        : Avatar.plant(
            svgPath: _plantInfo != null
                ? _getPlantSvgAsset(_plantInfo!['potColorValue'])
                : null,
            plantImageUrl: _plantInfo?['plantImageUrl'] as String?,
          );

    return ChatBubble(
      message: message,
      avatar: avatar,
    );
  }

  String _getUserInitials() {
    final userName = _currentUser?.name ?? _currentUser?.completeName ?? 'U';
    return userName.length >= 2
        ? userName.substring(0, 2).toUpperCase()
        : userName.toUpperCase();
  }

  void _handleTextSubmission(String value) {
    final message = value.trim();
    if (message.isNotEmpty) {
      try {
        final voiceChatBloc = BlocProvider.of<VoiceChatBloc>(context);
        final currentPersonality = voiceChatBloc.state.currentPersonality;
        final textChatBloc = BlocProvider.of<TextChatBloc>(context);
        final plantName = _plantInfo?['name'] as String?;

        textChatBloc.add(SendMessageEvent(
          message,
          currentPersonality,
          plantName: plantName,
        ));

        _textController.clear();
      } catch (e) {
        debugPrint('❌ Erro ao enviar mensagem: $e');
      }
    }
  }

  Widget _buildInitialTextMessage() {
    final greeting = AssetUtils.getGreetingByTime();

    final imageSize = ResponsiveValue<double>(
      context,
      defaultValue: 120.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 100.0),
        Condition.largerThan(name: TABLET, value: 140.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 32.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 40.0),
      ],
    ).value;

    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 40.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 56.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 22.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 20.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final blurRadius = ResponsiveValue<double>(
      context,
      defaultValue: 15.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Planta do usuário centralizada
            Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                        MetamorfoseColors.purpleNormal.withValues(alpha: 0.2),
                    blurRadius: blurRadius,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: _buildSmallPlantImage(),
            ),

            SizedBox(height: spacing),

            // Texto de boas-vindas centralizado
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                'Como posso ajudar você esta $greeting?',
                textAlign: TextAlign.center,
                style: AppTypography.displayMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: MetamorfoseColors.greyMedium,
                  fontSize: fontSize,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantImage() {
    final containerSize = ResponsiveValue<double>(
      context,
      defaultValue: 280.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 240.0),
        Condition.largerThan(name: TABLET, value: 320.0),
      ],
    ).value;

    final plantSize = ResponsiveValue<double>(
      context,
      defaultValue: 200.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 160.0),
        Condition.largerThan(name: TABLET, value: 240.0),
      ],
    ).value;

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _circleController]),
      builder: (context, child) {
        return SizedBox(
          width: containerSize,
          height: containerSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Círculos animados ao redor
              if (_currentStatusText.isNotEmpty &&
                  _currentStatusText != 'Ouvindo...') ...[
                // Círculo roxo externo
                Transform.rotate(
                  angle: _circleController.value * 2 * 3.14159,
                  child: Transform.scale(
                    scale: 1.0 + 0.1 * _pulseController.value,
                    child: Container(
                      width: containerSize - 20,
                      height: containerSize - 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: MetamorfoseColors.purpleNormal
                              .withValues(alpha: 0.8),
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                // Círculo verde médio
                Transform.rotate(
                  angle: -_circleController.value * 2 * 3.14159,
                  child: Transform.scale(
                    scale: 1.0 + 0.15 * (1 - _pulseController.value),
                    child: Container(
                      width: containerSize - 40,
                      height: containerSize - 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: MetamorfoseColors.greenLight
                              .withValues(alpha: 0.7),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                // Círculo roxo interno
                Transform.rotate(
                  angle: _circleController.value * 1.5 * 3.14159,
                  child: Transform.scale(
                    scale: 1.0 + 0.2 * _pulseController.value,
                    child: Container(
                      width: containerSize - 60,
                      height: containerSize - 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: MetamorfoseColors.purpleLight
                              .withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                // Círculo verde interno
                Transform.rotate(
                  angle: -_circleController.value * 1.8 * 3.14159,
                  child: Transform.scale(
                    scale: 1.0 + 0.1 * (1 - _pulseController.value),
                    child: Container(
                      width: containerSize - 80,
                      height: containerSize - 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: MetamorfoseColors.greenNormal
                              .withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              // Planta no centro
              Container(
                width: plantSize,
                height: plantSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: MetamorfoseColors.purpleNormal.withValues(
                          alpha: 0.2 + 0.1 * _pulseController.value),
                      blurRadius: 15 + 10 * _pulseController.value,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: _buildPlantImageWidget(),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Constrói o widget da imagem da planta (foto real ou SVG)
  Widget _buildPlantImageWidget() {
    final plantSize = ResponsiveValue<double>(
      context,
      defaultValue: 200.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 160.0),
        Condition.largerThan(name: TABLET, value: 240.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 70.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 50.0),
        Condition.largerThan(name: TABLET, value: 90.0),
      ],
    ).value;

    if (_plantInfo == null) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: MetamorfoseColors.purpleLight,
        ),
        child: Icon(
          Icons.eco,
          size: iconSize,
          color: MetamorfoseColors.whiteLight,
        ),
      );
    }

    // Priorizar foto real da planta se disponível
    final plantImageUrl = _plantInfo!['plantImageUrl'] as String?;
    if (plantImageUrl != null && plantImageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          plantImageUrl,
          width: plantSize,
          height: plantSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback para SVG se a foto falhar
            return SvgPicture.asset(
              _getPlantSvgAsset(_plantInfo!['potColorValue']),
              fit: BoxFit.contain,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: MetamorfoseColors.purpleLight,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: MetamorfoseColors.whiteLight,
                ),
              ),
            );
          },
        ),
      );
    }

    // Fallback para SVG se não houver foto
    return SvgPicture.asset(
      _getPlantSvgAsset(_plantInfo!['potColorValue']),
      fit: BoxFit.contain,
    );
  }

  /// Constrói a imagem pequena da planta para o texto inicial
  Widget _buildSmallPlantImage() {
    final imageSize = ResponsiveValue<double>(
      context,
      defaultValue: 120.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 100.0),
        Condition.largerThan(name: TABLET, value: 140.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 50.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 40.0),
        Condition.largerThan(name: TABLET, value: 60.0),
      ],
    ).value;

    if (_plantInfo == null) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: MetamorfoseColors.purpleLight,
        ),
        child: Icon(
          Icons.eco,
          size: iconSize,
          color: MetamorfoseColors.whiteLight,
        ),
      );
    }

    // Priorizar foto real da planta se disponível
    final plantImageUrl = _plantInfo!['plantImageUrl'] as String?;
    if (plantImageUrl != null && plantImageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          plantImageUrl,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback para SVG se a foto falhar
            return SvgPicture.asset(
              _getPlantSvgAsset(_plantInfo!['potColorValue']),
              fit: BoxFit.contain,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: MetamorfoseColors.purpleLight,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: MetamorfoseColors.whiteLight,
                ),
              ),
            );
          },
        ),
      );
    }

    // Fallback para SVG se não houver foto
    return SvgPicture.asset(
      _getPlantSvgAsset(_plantInfo!['potColorValue']),
      fit: BoxFit.contain,
    );
  }

  Widget _buildWelcomeMessage(VoiceChatState voiceChatState) {
    // Obter nome do usuário com fallback adequado
    String userName = 'você';
    if (_currentUser != null) {
      userName = _currentUser?.name?.trim() ?? 
                 _currentUser?.completeName?.trim() ?? 
                 'você';
      // Capitalizar primeira letra
      if (userName.isNotEmpty && userName != 'você') {
        userName = userName[0].toUpperCase() + userName.substring(1).toLowerCase();
      }
    }

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 20.0),
        Condition.largerThan(name: TABLET, value: 28.0),
      ],
    ).value;

    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 40.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 56.0),
      ],
    ).value;

    // Verificar estado do VoiceChatBloc para mostrar processamento
    final isProcessing = voiceChatState.speechState == SpeechState.processing ||
        voiceChatState.isProcessing;

    // Se está processando, mostrar indicador de carregamento com mensagem temática
    if (isProcessing && !voiceChatState.isSpeaking) {
      // Iniciar rotação de mensagens se ainda não estiver rodando
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startProcessingMessageRotation();
      });

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  MetamorfoseColors.purpleNormal,
                ),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _getProcessingMessage(),
                key: ValueKey(_processingMessageIndex),
                textAlign: TextAlign.center,
                style: AppTypography.displayMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: MetamorfoseColors.greyMedium,
                  fontSize: fontSize * 0.85,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    } else {
      // Parar rotação quando não estiver mais processando
      _stopProcessingMessageRotation();
    }

    // Se está ouvindo, mostrar "Ouvindo..."
    if (_isListening || voiceChatState.speechState == SpeechState.listening) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Text(
          'Ouvindo...',
          textAlign: TextAlign.center,
          style: AppTypography.displayMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: MetamorfoseColors.greyMedium,
            fontSize: fontSize,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    // Se tem status text (planta falando), mostrar com animação
    if (_currentStatusText.isNotEmpty && _currentStatusText != 'Ouvindo...') {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Text(
          _currentStatusText,
          textAlign: TextAlign.center,
          style: AppTypography.displayMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: MetamorfoseColors.greyMedium,
            fontSize: fontSize,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    // Mensagem padrão
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: RichText(
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            TextSpan(
              text: userName,
              style: AppTypography.displayMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: MetamorfoseColors.greenLight,
                fontSize: fontSize,
              ),
            ),
            TextSpan(
              text: ', vamos\nconversar?',
              style: AppTypography.displayMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: MetamorfoseColors.greyMedium,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    if (_isVoiceMode) {
      // Microfone igual ao bottom navigation
      final buttonSize = ResponsiveValue<double>(
        context,
        defaultValue: 80.0,
        conditionalValues: const [
          Condition.smallerThan(name: MOBILE, value: 70.0),
          Condition.largerThan(name: TABLET, value: 90.0),
        ],
      ).value;

      final borderRadius = ResponsiveValue<double>(
        context,
        defaultValue: 28.0,
        conditionalValues: const [
          Condition.smallerThan(name: MOBILE, value: 24.0),
          Condition.largerThan(name: TABLET, value: 32.0),
        ],
      ).value;

      final iconSize = ResponsiveValue<double>(
        context,
        defaultValue: 40.0,
        conditionalValues: const [
          Condition.smallerThan(name: MOBILE, value: 35.0),
          Condition.largerThan(name: TABLET, value: 45.0),
        ],
      ).value;

      final blurRadius = ResponsiveValue<double>(
        context,
        defaultValue: 8.0,
        conditionalValues: const [
          Condition.smallerThan(name: MOBILE, value: 6.0),
          Condition.largerThan(name: TABLET, value: 10.0),
        ],
      ).value;

      return BlocBuilder<VoiceChatBloc, VoiceChatState>(
        builder: (context, voiceChatState) {
          // Lógica simplificada: pode interagir se:
          // 1. Está gravando (pode parar a qualquer momento)
          // 2. Estado é idle E não está processando E não está falando E não tem erro
          final isIdle = voiceChatState.speechState == SpeechState.idle;
          final isReady = isIdle && 
                         !voiceChatState.isProcessing && 
                         !voiceChatState.isSpeaking &&
                         !voiceChatState.hasError;
          
          final canInteract = voiceChatState.isRecording || isReady;
          
          final isBusy = voiceChatState.isBusy || 
                         voiceChatState.speechState == SpeechState.speaking ||
                         voiceChatState.speechState == SpeechState.error ||
                         voiceChatState.speechState == SpeechState.processing;
          
          // SEMPRE mostrar o botão (nunca esconder), apenas desabilitar quando necessário
          // Usar SizedBox para garantir que o botão tenha espaço mesmo se houver problemas de layout
          return SizedBox(
            width: double.infinity,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: canInteract ? _toggleListening : null,
                  borderRadius: BorderRadius.circular(borderRadius),
                  splashColor: canInteract 
                      ? MetamorfoseColors.whiteLight.withValues(alpha: 0.2)
                      : Colors.transparent,
                  highlightColor: canInteract
                      ? MetamorfoseColors.whiteLight.withValues(alpha: 0.1)
                      : Colors.transparent,
                  child: Opacity(
                    opacity: canInteract ? 1.0 : 0.6,
                    child: Container(
                      width: buttonSize,
                      height: buttonSize,
                      decoration: BoxDecoration(
                        gradient: _isListening
                            ? LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  MetamorfoseColors.redNormal,
                                  MetamorfoseColors.redNormal.withValues(alpha: 0.8),
                                ],
                              )
                            : isBusy && !_isListening
                                ? LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      MetamorfoseColors.greyMedium,
                                      MetamorfoseColors.greyMedium.withValues(alpha: 0.8),
                                    ],
                                  )
                                : const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      MetamorfoseColors.purpleLight,
                                      MetamorfoseColors.greenLight,
                                    ],
                                  ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: MetamorfoseColors.blackNormal.withValues(alpha: 0.2),
                            blurRadius: blurRadius,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          final scale = _isListening
                              ? 1.0 + (0.2 * _pulseController.value)
                              : 1.0 + (0.1 * _pulseController.value);
                          return Transform.scale(
                            scale: scale,
                            child: Icon(
                              _isListening
                                  ? Icons.fiber_manual_record
                                  : Icons.mic_rounded,
                              size: iconSize,
                              color: MetamorfoseColors.whiteLight,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    // Input estilo referência para modo texto
    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final minHeight = ResponsiveValue<double>(
      context,
      defaultValue: 40.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 36.0),
        Condition.largerThan(name: TABLET, value: 44.0),
      ],
    ).value;

    final maxHeight = ResponsiveValue<double>(
      context,
      defaultValue: 120.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 100.0),
        Condition.largerThan(name: TABLET, value: 140.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
      ],
    ).value;

    final buttonSize = ResponsiveValue<double>(
      context,
      defaultValue: 40.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 36.0),
        Condition.largerThan(name: TABLET, value: 44.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final buttonPadding = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 10.0),
      ],
    ).value;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: MetamorfoseColors.whiteLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        border: Border.all(
          color: MetamorfoseColors.greyLight,
          width: 1,
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo de texto expandido
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: minHeight,
                  maxHeight: maxHeight,
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  style: TextStyle(
                    color: MetamorfoseColors.blackNormal,
                    fontSize: fontSize,
                    fontFamily: 'DinNext',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Digite uma mensagem...',
                    hintStyle: TextStyle(
                      color: MetamorfoseColors.greyMedium,
                      fontSize: fontSize,
                      fontFamily: 'DinNext',
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      left: padding,
                      right: padding,
                      top: buttonPadding,
                      bottom: buttonPadding + 2,
                    ),
                  ),
                  onSubmitted: (value) => _handleTextSubmission(value),
                ),
              ),

              // Linha dos botões
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Botão de microfone sem fundo
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _toggleListening,
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: Padding(
                        padding: EdgeInsets.all(buttonPadding),
                        child: Icon(
                          Icons.mic_rounded,
                          size: iconSize,
                          color: MetamorfoseColors.greyMedium,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: spacing),

                  // Botão de enviar com cor purple
                  BlocConsumer<TextChatBloc, TextChatState>(
                    listener: (context, state) {},
                    builder: (context, textChatState) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _sendTextMessageWithContext(context),
                          borderRadius: BorderRadius.circular(borderRadius),
                          splashColor: MetamorfoseColors.whiteLight
                              .withValues(alpha: 0.2),
                          highlightColor: MetamorfoseColors.whiteLight
                              .withValues(alpha: 0.1),
                          child: Container(
                            width: buttonSize,
                            height: buttonSize,
                            decoration: BoxDecoration(
                              color: MetamorfoseColors.purpleNormal,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: MetamorfoseColors.blackNormal
                                      .withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.send_rounded,
                              size: iconSize,
                              color: MetamorfoseColors.whiteLight,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TextChatBloc>(
          create: (context) => TextChatBloc(GeminiService()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<VoiceChatBloc, VoiceChatState>(
            listener: (context, state) {
              if (state.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: MetamorfoseColors.redNormal,
                  ),
                );
              }

              // Atualizar estado de escuta baseado no speechState
              if (state.speechState == SpeechState.listening) {
                setState(() {
                  _isListening = true;
                  _currentStatusText = '';
                });
                _stopProcessingMessageRotation();
              } else if (state.speechState == SpeechState.idle && !state.isProcessing && !state.isSpeaking) {
                setState(() {
                  _isListening = false;
                });
                _stopProcessingMessageRotation();
              }

              // Quando está processando, limpar mensagem anterior e iniciar rotação
              if (state.speechState == SpeechState.processing || state.isProcessing) {
                setState(() {
                  _isListening = false;
                  _currentStatusText = '';
                });
                _startProcessingMessageRotation();
              }

              // Quando a planta está falando ou em erro, parar tudo
              if (state.speechState == SpeechState.speaking || state.speechState == SpeechState.error) {
                setState(() {
                  _isListening = false;
                });
                _stopProcessingMessageRotation();
                
                // Se está falando e tem mensagem, exibir
                if (state.isSpeaking && state.currentMessage.isNotEmpty && state.speechState == SpeechState.speaking) {
                  _displayPlantMessage(state.currentMessage);
                }
              }
            },
          ),
        ],
        child: BlocBuilder<VoiceChatBloc, VoiceChatState>(
          builder: (context, state) {
            return Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  gradient: MetamorfoseGradients.softPurpleGradient,
                ),
                child: Column(
                  children: [
                    // Header
                    _buildHeader(state),

                    // Conteúdo principal
                    Expanded(
                      child: _isVoiceMode
                          ? _buildVoiceInterface(state)
                          : _buildTextInterface(state),
                    ),
                  ],
                ),
              ),
              // Não mostrar bottom navigation em nenhum modo do chat
              bottomNavigationBar: null,
            );
          },
        ),
      ),
    );
  }
}
