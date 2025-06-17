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
import 'package:conversao_flutter/theme/colors.dart';

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
            bottom: -18,
            left: 0,
            right: 0,
            child: Center(
              child: CustomPaint(
                size: const Size(22.47, 18.72),
                painter: TrianglePainter(borderColor: borderColor, triangleColor: triangleColor),
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
  TrianglePainter({required this.borderColor, required this.triangleColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = triangleColor
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    // Desenha a sombra
    final shadowPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;

    final shadowPath = Path()
      ..moveTo(size.width / 2 + 2.5, size.height + 2.5)
      ..lineTo(2.5, 2.5)
      ..lineTo(size.width + 2.5, 2.5)
      ..close();

    canvas.drawPath(shadowPath, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 