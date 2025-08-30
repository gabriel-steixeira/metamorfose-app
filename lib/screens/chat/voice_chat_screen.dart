/**
 * File: voice_chat_screen_bloc.dart
 * Description: Tela principal de chat por voz com BLoC.
 *
 * Responsabilidades:
 * - Exibir interface de chat usando BLoC
 * - Gerenciar gravação de áudio via BLoC
 * - Exibir respostas do personagem
 * - Preservar design original exatamente
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.1
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/speech_bubble.dart';
import 'package:metamorfose_flutter/components/bottom_navigation_menu.dart';
import 'package:metamorfose_flutter/components/plant_personality_selector.dart';
import 'package:metamorfose_flutter/components/mode_switcher.dart';
import 'package:metamorfose_flutter/blocs/voice_chat_bloc.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/services/gemini_service.dart';

/// Tela principal de chat por voz com o assistente usando BLoC.
class VoiceChatScreen extends StatefulWidget {
  /// Personalidade específica para iniciar a conversa (opcional)
  final PersonalityType? initialPersonality;
  
  const VoiceChatScreen({
    super.key,
    this.initialPersonality,
  });

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  ChatMode _currentMode = ChatMode.voice;

  @override
  void initState() {
    super.initState();
    
    debugPrint("🎭 VoiceChat - initState iniciado");
    debugPrint("🎭 VoiceChat - initialPersonality: ${widget.initialPersonality?.id}");
    
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("🎭 VoiceChat - PostFrameCallback executado");
      
      // Inicializar o BLoC
      context.read<VoiceChatBloc>().add(VoiceChatInitializeEvent());
      
      // Se houver personalidade inicial, aplicar silenciosamente (apenas para direcionar)
      if (widget.initialPersonality != null) {
        debugPrint("🎭 VoiceChat - Aplicando personalidade inicial silenciosamente: ${widget.initialPersonality!.id}");
        
        // Aplicar a personalidade inicial silenciosamente (apenas para direcionar)
        context.read<VoiceChatBloc>().add(
          VoiceChatChangePersonalityEvent(widget.initialPersonality!, silent: true),
        );
      }
      
      debugPrint("🎭 VoiceChat - BLoC inicializado com personalidade: ${widget.initialPersonality?.id ?? 'padrao'}");
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    debugPrint("🎤 Toggle listening clicked");
    context.read<VoiceChatBloc>().add(VoiceChatToggleListeningEvent());
  }

  void _onModeChanged(ChatMode mode) {
    setState(() {
      _currentMode = mode;
    });
    
    if (mode == ChatMode.text) {
      debugPrint("🔄 Mudando para modo de chat de texto");
      // Aguarda a animação do ModeSwitcher concluir antes de navegar
      Future.delayed(const Duration(milliseconds: 330), () {
        if (!mounted) return;
        context.go(Routes.textChat);
      });
    } else {
      debugPrint("🎤 Mantendo modo de voz");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final voiceChatBloc = context.read<VoiceChatBloc>();
    
    return BlocListener<VoiceChatBloc, VoiceChatState>(
      bloc: voiceChatBloc,
      listener: (context, state) {
        debugPrint("🔄 State changed - isRecording: ${state.isRecording}");
        debugPrint("💬 Current message: ${state.currentMessage}");
        debugPrint("🎭 Current personality: ${state.currentPersonality.id}");
        
        // Verificar se a personalidade foi alterada para a inicial
        if (widget.initialPersonality != null && 
            state.currentPersonality == widget.initialPersonality) {
          debugPrint("🎭 Personalidade inicial aplicada com sucesso: ${state.currentPersonality.id}");
        }
        
        if (state.hasError) {
          debugPrint("❌ Error: ${state.errorMessage}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: MetamorfoseColors.redNormal,
              action: SnackBarAction(
                label: 'OK',
                textColor: MetamorfoseColors.whiteLight,
                onPressed: () {
                  context.read<VoiceChatBloc>().add(VoiceChatClearErrorEvent());
                },
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child:                     BlocBuilder<VoiceChatBloc, VoiceChatState>(
                      buildWhen: (previous, current) =>
                          previous.currentPersonality != current.currentPersonality,
                      builder: (context, state) {
                        debugPrint("🎭 Rebuild PersonalitySelector - current: ${state.currentPersonality.id}, initial: ${widget.initialPersonality?.id}");
                        
                        return PersonalitySelector(
                          currentPersonality: state.currentPersonality,
                          // Não usar initialPersonality aqui para permitir mudanças visuais
                          onPersonalityChanged: (personality) {
                            debugPrint("🎭 Selecionando personalidade: ${personality.id}");
                            context.read<VoiceChatBloc>().add(
                              VoiceChatChangePersonalityEvent(personality, silent: false),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Seletor de modo (Voz ↔️ Chat)
                  ModeSwitcher(
                    currentMode: _currentMode,
                    onModeChanged: _onModeChanged,
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          top: -160,
                          child: Center(
                            child: SizedBox(
                              width: screenWidth,
                              height: screenHeight,
                              child: SvgPicture.asset(
                                'assets/images/chat/chat_plant.svg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        
                        // Personagem da planta
                        Positioned(
                          top: screenHeight * 0.15,
                          left: screenWidth * 0.2,
                          right: screenWidth * 0.2,
                          child: Center(
                            child: SizedBox(
                              width: screenWidth * 0.5,
                              height: screenWidth * 0.65,
                              child: SvgPicture.asset(
                                'assets/images/plantsetup/plantsetup.svg',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        
                        // Balão de fala usando SpeechBubble
                        Positioned(
                          top: screenHeight * 0.09,
                          left: screenWidth * 0.3,
                          right: screenWidth * 0.3,
                          child: BlocBuilder<VoiceChatBloc, VoiceChatState>(
                            buildWhen: (previous, current) =>
                                previous.currentMessage != current.currentMessage,
                            builder: (context, state) {
                              return SpeechBubble(
                                width: 300,
                                height: 150,
                                color: MetamorfoseColors.greenLight,
                                borderColor: MetamorfoseColors.purpleLight,
                                triangleColor: MetamorfoseColors.greenLight,
                                child: Text(
                                  state.currentMessage,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: MetamorfoseColors.whiteLight,
                                    fontFamily: 'DinNext',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Texto de convite
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 40,
                        height: 1.4,
                        fontFamily: 'DinNext',
                        fontWeight: FontWeight.w600,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sanji',
                          style: TextStyle(
                            color: MetamorfoseColors.greenLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ', vamos\nconversar?',
                          style: TextStyle(
                            color: MetamorfoseColors.greyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.2),
                ],
              ),
              
              // App bar inferior
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BlocBuilder<VoiceChatBloc, VoiceChatState>(
                  buildWhen: (previous, current) =>
                      previous.isRecording != current.isRecording,
                  builder: (context, state) {
                    return BottomNavigationMenu(
                      activeIndex: 2,
                      onItemTapped: (index) {
                        if (index == 2) {
                          debugPrint("👆 Mic button tapped - isRecording: ${state.isRecording}");
                          _toggleListening();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
