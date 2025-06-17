/// File: voice_chat_screen.dart
/// Description: Tela principal de chat por voz.
///
/// Responsabilidades:
/// - Exibir interface de chat
/// - Gerenciar gravação de áudio
/// - Exibir respostas do personagem
///
/// Author: Gabriel Teixeira e Vitoria Lana
/// Created on: 29-05-2025
/// Last modified: 29-05-2025
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:conversao_flutter/components/speech_bubble.dart';
import 'package:conversao_flutter/components/bottom_navigation_menu.dart';

/// Tela principal de chat por voz com o assistente.
/// Permite ao usuário interagir por voz com o aplicativo.
class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({super.key});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> with TickerProviderStateMixin {
  bool _isListening = false;
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Conteúdo principal
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
                      
                      // Balão de fala usando SpeechBubble
                      Positioned(
                        top: screenHeight * 0.09,
                        left: screenWidth * 0.3,
                        right: screenWidth * 0.3,
                        child: SpeechBubble(
                          width: 250,
                          height: 38,
                          color: MetamorfoseColors.greenLight,
                          borderColor: MetamorfoseColors.purpleLight,
                          triangleColor: MetamorfoseColors.greenLight,
                          child: const Text(
                            'Oi, eu sou Perona',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: MetamorfoseColors.whiteLight,
                              fontFamily: 'DinNext',
                            ),
                            textAlign: TextAlign.center,
                          ),
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
                
                // Espaçamento inferior
                SizedBox(height: screenHeight * 0.2),
              ],
            ),
            
            // App bar inferior
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomNavigationMenu(
                activeIndex: 1, // Voice icon ativo por padrão
                onItemTapped: (index) {
                  if (index == 1) {
                    // Se clicou no ícone de voice, toggle listening
                    _toggleListening();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

} 