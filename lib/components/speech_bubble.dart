/**
 * File: speech_bubble.dart
 * Description: Componente de balão de fala para conversas.
 *
 * Responsabilidades:
 * - Criar balões de fala estilizados
 * - Suportar diferentes cores e tamanhos
 * - Manter padrão visual das conversas
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/theme/colors.dart';

/// Componente de balão de fala customizável.
/// Exibe um balão com sombra verde e texto customizável.
class SpeechBubble extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final bool showTriangle;
  final bool showBorder;
  final Color borderColor;
  final Color color;
  final Color triangleColor;
  final String arrowDirection; // 'left', 'right', 'bottom'
  
  const SpeechBubble({
    Key? key,
    required this.child,
    this.width = 290,
    this.height = 125,
    this.showTriangle = true,
    this.showBorder = true,
    this.triangleColor = MetamorfoseColors.whiteLight,
    this.color = MetamorfoseColors.whiteLight,
    this.borderColor = MetamorfoseColors.greenLight,
    this.arrowDirection = 'bottom', // padrão apontando para baixo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Balão principal
        Container(
          width: width,
          height: height,
          //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.97),
            ),
            shadows: showBorder ? [
              BoxShadow(
                color: borderColor,
                blurRadius: 0,
                offset: const Offset(2.50, 2.50),
                spreadRadius: 2.50,
              ),
            ] : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: child),
            ],
          ),
        ),

        // Triângulo do balão
        if (showTriangle)
          Positioned(
            bottom: arrowDirection == 'bottom' ? -18 : null,
            top: arrowDirection == 'top' ? -18 : null,
            left: arrowDirection == 'left' ? -22.5 : null,
            right: arrowDirection == 'right' ? -18 : null,
            child: arrowDirection == 'left' || arrowDirection == 'right'
                ? Transform.translate(
                    offset: Offset(0, height / 2 - 9.36), // Centraliza verticalmente (18.72 / 2)
                    child: CustomPaint(
                      size: const Size(22.47, 18.72),
                      painter: TrianglePainter(
                        borderColor: borderColor, 
                        triangleColor: triangleColor,
                        direction: arrowDirection,
                      ),
                    ),
                  )
                : Transform.translate(
                    offset: Offset(width / 2 - 11.235, 0), // Centraliza horizontalmente (22.47 / 2)
                    child: CustomPaint(
                      size: const Size(22.47, 18.72),
                      painter: TrianglePainter(
                        borderColor: borderColor, 
                        triangleColor: triangleColor,
                        direction: arrowDirection,
                      ),
                    ),
                  ),
          ),
      ],
    );
  }
}

/// Painter customizado para desenhar o triângulo do balão
class TrianglePainter extends CustomPainter {
  final Color borderColor;
  final Color triangleColor;
  final String direction; // 'left', 'right', 'bottom'
  
  TrianglePainter({required this.borderColor, required this.triangleColor, required this.direction});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = triangleColor
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;

    Path path;
    Path shadowPath;

    switch (direction) {
      case 'left':
        // Triângulo apontando para a esquerda (em direção ao Ivy)
        path = Path()
          ..moveTo(0, size.height / 2)
          ..lineTo(size.width, size.height / 2 - 10)
          ..lineTo(size.width, size.height / 2 + 10)
          ..close();
        
        // Contorno apenas ao redor, sem embaixo
        shadowPath = Path()
          ..moveTo(0, size.height / 2)
          ..lineTo(size.width, size.height / 2 - 10)
          ..lineTo(size.width + 2.5, size.height / 2 - 10)
          ..lineTo(2.5, size.height / 2)
          ..lineTo(size.width + 2.5, size.height / 2 + 10)
          ..lineTo(size.width, size.height / 2 + 10)
          ..close();
        break;
        
      case 'right':
        // Triângulo apontando para a direita
        path = Path()
          ..moveTo(size.width, size.height / 2)
          ..lineTo(0, size.height / 2 - 10)
          ..lineTo(0, size.height / 2 + 10)
          ..close();
        
        shadowPath = Path()
          ..moveTo(size.width + 2.5, size.height / 2)
          ..lineTo(2.5, size.height / 2 - 10)
          ..lineTo(2.5, size.height / 2 + 10)
          ..close();
        break;
        
      case 'top':
        // Triângulo apontando para cima
        path = Path()
          ..moveTo(size.width / 2, size.height)
          ..lineTo(size.width / 2 - 10, 0)
          ..lineTo(size.width / 2 + 10, 0)
          ..close();
        
        shadowPath = Path()
          ..moveTo(size.width / 2 + 2.5, size.height + 2.5)
          ..lineTo(size.width / 2 - 10, 2.5)
          ..lineTo(size.width / 2 + 10, 2.5)
          ..close();
        break;
        
      default: // 'bottom'
        // Triângulo apontando para baixo (padrão)
        path = Path()
          ..moveTo(size.width / 2, size.height)
          ..lineTo(0, 0)
          ..lineTo(size.width, 0)
          ..close();
        
        shadowPath = Path()
          ..moveTo(size.width / 2 + 2.5, size.height + 2.5)
          ..lineTo(2.5, 2.5)
          ..lineTo(size.width + 2.5, 2.5)
          ..close();
        break;
    }

    // Desenha a sombra primeiro
    canvas.drawPath(shadowPath, shadowPaint);
    // Desenha o triângulo principal
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 