/**
 * File: chat_screen.dart
 * Description: Tela de chat híbrido (voz e texto) com integração completa de IA.
 *
 * Responsabilidades:
 * - Interface de chat híbrido (voz e texto)
 * - Integração com personalidades
 *
 * Author: Evelin Cordeiro
 * Created on: 31-08-2025
 * Last modified: 31-08-2025
 *
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/theme/typography.dart';
import 'package:metamorfose_flutter/utils/responsive_utils.dart';
import 'package:metamorfose_flutter/utils/app_constants.dart';
import 'package:metamorfose_flutter/components/chat_bubble.dart';
import 'package:metamorfose_flutter/components/avatar.dart';

import 'package:metamorfose_flutter/blocs/voice_chat_bloc.dart';
import 'package:metamorfose_flutter/blocs/text_chat_bloc.dart';
import 'package:metamorfose_flutter/blocs/plant_care_bloc.dart';
import 'package:metamorfose_flutter/state/plant_care/plant_care_state.dart';
import 'package:metamorfose_flutter/services/gemini_service.dart';
import 'package:metamorfose_flutter/services/plant_care_service.dart';
import 'package:metamorfose_flutter/services/hybrid_auth_service.dart';
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
      if (widget.initialPersonality != null) {
        context
            .read<VoiceChatBloc>()
            .add(VoiceChatChangePersonalityEvent(widget.initialPersonality!));
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _circleController.dispose();
    _textController.dispose();
    _textDisplayTimer?.cancel();
    super.dispose();
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
          final userName = _currentUser?.name ?? _currentUser?.completeName;
          context
              .read<VoiceChatBloc>()
              .add(VoiceChatSetUserNameEvent(userName!));
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
        final userName = _currentUser?.name ?? _currentUser?.completeName;
        textChatBloc.add(SendMessageEvent(message, currentPersonality,
            plantName: plantName, userName: userName));

        _textController.clear();
        debugPrint('✅ Mensagem enviada com sucesso via contexto');
      } catch (e) {
        debugPrint('❌ Erro ao enviar mensagem via contexto: $e');
      }
    }
  }

  /// Header responsivo com navegação, nome da planta, toggle e seletor de personalidade
  Widget _buildHeader(VoiceChatState state) {
    return SafeArea(
      child: Padding(
        padding: context.responsiveHorizontalPadding.copyWith(
          top: ResponsiveUtils.getResponsiveSpacing(context, 12),
          bottom: ResponsiveUtils.getResponsiveSpacing(context, 20),
        ),
        child: Row(
          children: [
            // Botão de voltar responsivo
            IconButton(
              onPressed: () => context.go('/home'),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: ResponsiveUtils.getResponsiveSpacing(context, 20),
              ),
            ),

            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),

            // Nome da planta responsivo
            Flexible(
              child: Text(
                _plantInfo?['name'] ?? 'Chat',
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
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
    final toggleWidth = ResponsiveUtils.getResponsiveSpacing(context, 110);
    final toggleHeight = ResponsiveUtils.getResponsiveSpacing(context, 40);
    final borderRadius = ResponsiveUtils.getResponsiveBorderRadius(context, 12);

    return Container(
      width: toggleWidth,
      height: toggleHeight,
      padding: EdgeInsets.all(ResponsiveUtils.getResponsiveSpacing(context, 3)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
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
    return GestureDetector(
      onTap: () => _handleToggleChange(isVoice),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getResponsiveBorderRadius(context, 9),
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: isSelected ? MetamorfoseColors.purpleNormal : Colors.white,
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
    final selectorSize = ResponsiveUtils.getResponsiveSpacing(context, 50);
    final borderRadius = ResponsiveUtils.getResponsiveBorderRadius(context, 12);

    return Container(
      width: selectorSize,
      height: ResponsiveUtils.getResponsiveSpacing(context, 40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: PopupMenuButton<PersonalityType>(
        initialValue: state.currentPersonality,
        icon: Icon(
          Icons.psychology,
          color: Colors.white,
          size: 20,
        ),
        offset: Offset(0, ResponsiveUtils.getResponsiveSpacing(context, 50)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: Colors.white,
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
                    size: 20,
                  ),
                  SizedBox(
                      width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                  Text(
                    _getPersonalityLabel(personality),
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      fontSize:
                          ResponsiveUtils.getResponsiveFontSize(context, 16),
                      fontWeight: FontWeight.w500,
                    ),
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
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(flex: 1),

          // Foto da planta - posição fixa
          _buildPlantImage(),

          const SizedBox(height: 60), // Mais espaço fixo

          // Container com altura fixa para o texto
          Container(
            height: 80, // Altura fixa para evitar movimento
            child: Center(
              child: _buildWelcomeMessage(),
            ),
          ),

          const Spacer(flex: 2),

          // Input de texto estilo referência
          _buildTextInput(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Interface de texto moderna
  Widget _buildTextInterface(VoiceChatState state) {
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

              return Container(
                // Sem cor de fundo - gradiente já está na tela
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: textChatState.messages.length,
                  itemBuilder: (context, index) {
                    final message = textChatState.messages[index];
                    return _buildMessageBubble(message);
                  },
                ),
              );
            },
          ),
        ),

        // Loading indicator
        BlocBuilder<TextChatBloc, TextChatState>(
          builder: (context, textChatState) {
            if (textChatState.isLoading) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            MetamorfoseColors.purpleNormal),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${_plantInfo?['name'] ?? AppConstants.defaultPlantName} ${AppConstants.loadingMessage}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'DinNext',
                      ),
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

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Planta do usuário centralizada
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: MetamorfoseColors.purpleNormal.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: _buildSmallPlantImage(),
            ),

            const SizedBox(height: 32),

            // Texto de boas-vindas centralizado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Como posso ajudar você esta $greeting?',
                textAlign: TextAlign.center,
                style: AppTypography.displayMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: MetamorfoseColors.greyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantImage() {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _circleController]),
      builder: (context, child) {
        return Container(
          width: 280,
          height: 280,
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
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              MetamorfoseColors.purpleNormal.withOpacity(0.8),
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
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: MetamorfoseColors.greenLight.withOpacity(0.7),
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
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: MetamorfoseColors.purpleLight.withOpacity(0.5),
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
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: MetamorfoseColors.greenNormal.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              // Planta no centro
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: MetamorfoseColors.purpleNormal
                          .withOpacity(0.2 + 0.1 * _pulseController.value),
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
    if (_plantInfo == null) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: MetamorfoseColors.purpleLight,
        ),
        child: const Icon(
          Icons.eco,
          size: 70,
          color: Colors.white,
        ),
      );
    }

    // Priorizar foto real da planta se disponível
    final plantImageUrl = _plantInfo!['plantImageUrl'] as String?;
    if (plantImageUrl != null && plantImageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          plantImageUrl,
          width: 200,
          height: 200,
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
                  color: Colors.white,
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
    if (_plantInfo == null) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: MetamorfoseColors.purpleLight,
        ),
        child: const Icon(
          Icons.eco,
          size: 50,
          color: Colors.white,
        ),
      );
    }

    // Priorizar foto real da planta se disponível
    final plantImageUrl = _plantInfo!['plantImageUrl'] as String?;
    if (plantImageUrl != null && plantImageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          plantImageUrl,
          width: 120,
          height: 120,
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
                  color: Colors.white,
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

  Widget _buildWelcomeMessage() {
    final userName = _currentUser?.name ?? _currentUser?.completeName ?? 'você';

    // Se está ouvindo, mostrar "Ouvindo..."
    if (_isListening) {
      return Text(
        'Ouvindo...',
        textAlign: TextAlign.center,
        style: AppTypography.displayMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: MetamorfoseColors.greyMedium,
        ),
      );
    }

    // Se tem status text (planta falando), mostrar com animação
    if (_currentStatusText.isNotEmpty && _currentStatusText != 'Ouvindo...') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          _currentStatusText,
          textAlign: TextAlign.center,
          style: AppTypography.displayMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: MetamorfoseColors.greyMedium,
          ),
        ),
      );
    }

    // Mensagem padrão
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: userName,
            style: AppTypography.displayMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: MetamorfoseColors.greenLight,
            ),
          ),
          TextSpan(
            text: ', vamos\nconversar?',
            style: AppTypography.displayMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: MetamorfoseColors.greyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    if (_isVoiceMode) {
      // Microfone igual ao bottom navigation
      return Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _toggleListening,
            borderRadius: BorderRadius.circular(28),
            splashColor: Colors.white.withOpacity(0.2),
            highlightColor: Colors.white.withOpacity(0.1),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: _isListening
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          MetamorfoseColors.redNormal,
                          MetamorfoseColors.redNormal.withOpacity(0.8),
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
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
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
                      size: 40,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    }

    // Input estilo referência para modo texto
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border.all(
          color: MetamorfoseColors.greyLight,
          width: 1,
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo de texto expandido
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  minHeight: 40,
                  maxHeight: 120,
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontFamily: 'DinNext',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Digite uma mensagem...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                      fontFamily: 'DinNext',
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 8,
                      bottom: 10,
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
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.mic_rounded,
                          size: 20,
                          color: MetamorfoseColors.greyMedium,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Botão de enviar com cor purple
                  BlocConsumer<TextChatBloc, TextChatState>(
                    listener: (context, state) {},
                    builder: (context, textChatState) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _sendTextMessageWithContext(context),
                          borderRadius: BorderRadius.circular(20),
                          splashColor: Colors.white.withOpacity(0.2),
                          highlightColor: Colors.white.withOpacity(0.1),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: MetamorfoseColors.purpleNormal,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.send_rounded,
                              size: 20,
                              color: Colors.white,
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

              // Quando para de gravar
              if (!state.isRecording && _isListening) {
                setState(() {
                  _isListening = false;
                  _currentStatusText = '';
                });
              }

              // Quando a planta está falando
              if (state.isSpeaking && state.currentMessage.isNotEmpty) {
                setState(() {
                  _isListening = false;
                });
                _displayPlantMessage(state.currentMessage);
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
