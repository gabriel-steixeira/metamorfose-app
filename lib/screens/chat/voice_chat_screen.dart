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
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/speech_bubble.dart';
import 'package:metamorfose_flutter/components/bottom_navigation_menu.dart';
import 'package:metamorfose_flutter/blocs/voice_chat_bloc.dart';
import 'package:metamorfose_flutter/state/voice_chat/voice_chat_state.dart';

/// Tela principal de chat por voz com o assistente usando BLoC.
/// Permite ao usuário interagir por voz com o aplicativo.
class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({super.key});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    
    // Inicializa controladores de animação (exatamente como na original)
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Inicializa o BLoC
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VoiceChatBloc>().add(VoiceChatInitializeEvent());
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    context.read<VoiceChatBloc>().add(VoiceChatToggleListeningEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return BlocListener<VoiceChatBloc, VoiceChatState>(
      listener: (context, state) {
        // Mostra erro se houver
        if (state.hasError) {
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
              // Conteúdo principal (exatamente igual ao original)
            Column(
              children: [
                // Espaçamento superior
                SizedBox(height: screenHeight * 0.02),
                
                // Área do personagem com balão de fala e decorações
                Expanded(
                  child: Stack(
                    children: [
                      // Círculos decorativos de fundo (chat_plant.svg)
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
                      
                      // Personagem da planta (plantsetup.svg)
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
                      
                        // Balão de fala usando SpeechBubble (reativo ao estado do BLoC)
                      Positioned(
                        top: screenHeight * 0.09,
                        left: screenWidth * 0.3,
                        right: screenWidth * 0.3,
                          child: BlocBuilder<VoiceChatBloc, VoiceChatState>(
                            buildWhen: (previous, current) => 
                                previous.currentMessage != current.currentMessage,
                            builder: (context, state) {
                              return SpeechBubble(
                          width: 250,
                          height: 38,
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
                
                  // Texto de convite (exatamente igual ao original)
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
                
                // Espaçamento inferior
                SizedBox(height: screenHeight * 0.2),
              ],
            ),
            
              // App bar inferior (com callback reativo ao BLoC)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
                child: BlocBuilder<VoiceChatBloc, VoiceChatState>(
                  buildWhen: (previous, current) => 
                      previous.isListening != current.isListening,
                  builder: (context, state) {
                    return BottomNavigationMenu(
                activeIndex: 1, // Voice icon ativo por padrão
                onItemTapped: (index) {
                  if (index == 1) {
                          // Se clicou no ícone de voice, toggle listening via BLoC
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