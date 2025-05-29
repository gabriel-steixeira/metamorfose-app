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
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:conversao_flutter/components/speech_bubble.dart';
import 'package:conversao_flutter/components/confirmation_dialog.dart';

/// Tela principal de chat por voz com o assistente.
/// Permite ao usuário interagir por voz com o aplicativo.
class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({super.key});

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> with TickerProviderStateMixin {
  bool _isListening = false;
  int _activeNavIndex = 1; // Voice icon ativo por padrão
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

  void _onNavTap(int index) {
    setState(() {
      _activeNavIndex = index;
      if (index == 1) { // Voice icon
        _toggleListening();
      }
    });
  }

  /// Exibe diálogo de confirmação para sair do app
  void _showExitConfirmation() {
    ConfirmationDialog.show(
      context,
      title: 'Sair do App',
      content: 'Deseja realmente sair do aplicativo?',
      confirmText: 'Sair',
      cancelText: 'Cancelar',
      onConfirm: () {
        SystemNavigator.pop(); // Fecha o app
      },
    );
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
              child: _buildBottomAppBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: MetamorfoseColors.whiteLight,
        border: Border(
          top: BorderSide(
            color: MetamorfoseColors.greenLight,
            width: 3,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Ícones centralizados
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNavIcon(
                  'assets/images/chat/home_icon.svg',
                  0,
                ),
                const SizedBox(width: 32),
                _buildNavIcon(
                  'assets/images/chat/voice_icon.svg',
                  1,
                ),
                const SizedBox(width: 32),
                _buildNavIcon(
                  'assets/images/chat/account_circle_icon.svg',
                  2,
                ),
              ],
            ),
          ),
          
          // Botão Sair à direita
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // Ação de sair - fechar o app
                  _showExitConfirmation();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Sair',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MetamorfoseColors.purpleLight,
                        fontFamily: 'DinNext',
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/images/chat/exit_icon.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        MetamorfoseColors.purpleLight,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(String iconPath, int index) {
    final isActive = _activeNavIndex == index;
    final baseSize = 48.0;
    final activeSize = baseSize * 1.25; // Aumenta 25% quando ativo
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // Transição suave de 300ms
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(
        0, 
        isActive ? -40 : 0, // Move para cima quando ativo
        0
      ),
      child: GestureDetector(
        onTap: () => _onNavTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300), // Transição suave para o tamanho
          curve: Curves.easeInOut,
          width: isActive ? activeSize : baseSize,
          height: isActive ? activeSize : baseSize,
          decoration: BoxDecoration(
            color: isActive ? MetamorfoseColors.purpleLight : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: isActive 
            ? CustomPaint(
                painter: _ActiveIconBorderPainter(),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: SvgPicture.asset(
                      iconPath,
                      width: 24 * (isActive ? 1.25 : 1.0),
                      height: 24 * (isActive ? 1.25 : 1.0),
                      colorFilter: ColorFilter.mode(
                        MetamorfoseColors.whiteLight,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    MetamorfoseColors.purpleLight,
                    BlendMode.srcIn,
                  ),
                ),
              ),
        ),
      ),
    );
  }
}

/// Painter customizado para desenhar a borda verde específica do ícone ativo
class _ActiveIconBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = MetamorfoseColors.greenLight
      ..strokeWidth = 4.0 // Aumentei a grossura da borda
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final path = Path();
    
    // Desenha a borda apenas embaixo e nas laterais de baixo para cima até a metade
    // Começa do lado direito na metade (0 graus), vai para baixo e sobe até o lado esquerdo na metade
    path.addArc(
      Rect.fromCircle(center: center, radius: radius),
      0, // 0 graus (lado direito na metade)
      3.14159, // 180 graus de arco (vai para baixo passando pelo fundo e sobe até o lado esquerdo na metade)
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 