/**
 * File: bottom_navigation_menu.dart
 * Description: Componente de menu de navegação inferior reutilizável.
 *
 * Responsabilidades:
 * - Fornecer menu de navegação inferior padronizado
 * - Gerenciar estados ativos dos ícones
 * - Realizar navegação entre telas
 * - Exibir modal "Em desenvolvimento" para funcionalidades não implementadas
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 30-05-2025
 * Last modified: 30-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/confirmation_dialog.dart';
import 'package:metamorfose_flutter/routes/routes.dart';

/// Componente de menu de navegação inferior do aplicativo.
/// 
/// Este componente implementa o menu de navegação usado em todas as telas principais,
/// mantendo as características visuais consistentes:
/// - Borda superior verde
/// - Ícones com animação de subida quando ativos
/// - Efeito de aumento e mudança de cor para ícone ativo
/// - Borda personalizada para ícone ativo
/// - Botão de sair à direita
class BottomNavigationMenu extends StatelessWidget {
  /// Índice do ícone ativo (0 = Home, 1 = Voice, 2 = Account)
  final int activeIndex;
  
  /// Callback executado quando um item é selecionado
  final ValueChanged<int>? onItemTapped;

  /// Construtor do menu de navegação inferior
  const BottomNavigationMenu({
    super.key,
    required this.activeIndex,
    this.onItemTapped,
  });

  /// Exibe modal informando que a funcionalidade está em desenvolvimento
  void _showDevelopmentModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 280,
              minWidth: 250,
            ),
            decoration: ShapeDecoration(
              color: MetamorfoseColors.whiteLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              shadows: [
                BoxShadow(
                  color: MetamorfoseColors.greenLight,
                  blurRadius: 0,
                  offset: const Offset(3, 3),
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícone de informação
                  Icon(
                    Icons.info_outline,
                    size: 48,
                    color: MetamorfoseColors.purpleLight,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Título
                  Text(
                    'Em Desenvolvimento',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: MetamorfoseColors.greyMedium,
                      fontFamily: 'DinNext',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Conteúdo
                  Text(
                    'Esta funcionalidade está sendo desenvolvida e estará disponível em breve.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: MetamorfoseColors.greyMedium,
                      fontFamily: 'DinNext',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botão OK
                  SizedBox(
                    width: double.infinity,
                    child: _buildModalButton(
                      text: 'OK',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Constrói um botão para o modal
  Widget _buildModalButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 44,
      decoration: ShapeDecoration(
        color: MetamorfoseColors.purpleLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shadows: [
          const BoxShadow(
            color: MetamorfoseColors.greenLight,
            blurRadius: 0,
            offset: Offset(2, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: MetamorfoseColors.whiteLight,
                fontFamily: 'DinNext',
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Exibe diálogo de confirmação para sair do app
  void _showExitConfirmation(BuildContext context) {
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

  /// Lida com o toque nos itens de navegação
  void _onNavTap(BuildContext context, int index) {
    // Executa callback se fornecido
    onItemTapped?.call(index);
    
    // Navegação baseada no índice
    switch (index) {
      case 0: // Home icon - navegar para home
        context.go(Routes.home);
        break;
      case 1: // Voice icon - navegar para voice chat
        context.go(Routes.voiceChat);
        break;
      case 2: // Account icon - navegar para configuração da planta
        context.go(Routes.plantConfig);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  context,
                  'assets/images/chat/home_icon.svg',
                  0,
                ),
                const SizedBox(width: 32),
                _buildNavIcon(
                  context,
                  'assets/images/chat/voice_icon.svg',
                  1,
                ),
                const SizedBox(width: 32),
                _buildNavIcon(
                  context,
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
                onTap: () => _showExitConfirmation(context),
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

  /// Constrói um ícone de navegação
  Widget _buildNavIcon(BuildContext context, String iconPath, int index) {
    final isActive = activeIndex == index;
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
        onTap: () => _onNavTap(context, index),
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