/// File: speech_bubble.dart
/// Description: Componente de balão de fala para conversas.
///
/// Responsabilidades:
/// - Criar balões de fala estilizados
/// - Suportar diferentes cores e tamanhos
/// - Manter padrão visual das conversas
///
/// Author: Gabriel Teixeira e Vitoria Lana
/// Created on: 29-05-2025
/// Last modified: 29-05-2025
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:metamorfose_flutter/theme/colors.dart';

/// Componente de balão de fala customizável.
/// Exibe um balão com sombra verde e texto customizável.
class SpeechBubble extends StatelessWidget {
  final Widget child;
  final double width;
  final double? height;
  final double? maxHeight;
  final bool showTriangle;
  final bool showBorder;
  final Color borderColor;
  final Color color;
  final Color triangleColor;
  final String arrowDirection; // 'left', 'right', 'bottom'
  final double? containerHeight; // Altura do container pai (para posicionar seta no meio do Ivy)
  
  const SpeechBubble({
    super.key,
    required this.child,
    this.width = 290,
    this.height,
    this.maxHeight,
    this.showTriangle = true,
    this.showBorder = true,
    this.triangleColor = MetamorfoseColors.whiteLight,
    this.color = MetamorfoseColors.whiteLight,
    this.borderColor = MetamorfoseColors.greenLight,
    this.arrowDirection = 'bottom',
    this.containerHeight,
  });

  @override
  Widget build(BuildContext context) {
    // Valores responsivos
    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 7.97,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 10.0),
      ],
    ).value;

    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final verticalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final shadowOffset = ResponsiveValue<double>(
      context,
      defaultValue: 2.50,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 2.0),
        Condition.largerThan(name: TABLET, value: 3.0),
      ],
    ).value;

    final shadowSpread = ResponsiveValue<double>(
      context,
      defaultValue: 2.50,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 2.0),
        Condition.largerThan(name: TABLET, value: 3.0),
      ],
    ).value;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Determinar altura do balão
        final double? finalHeight = height;
        final BoxConstraints? containerConstraints = finalHeight == null
            ? (maxHeight != null
                ? BoxConstraints(
                    minHeight: 60,
                    maxHeight: maxHeight!,
                  )
                : const BoxConstraints(minHeight: 60))
            : null;
        
        // Se há maxHeight e o conteúdo pode ser grande, tornar scrollável
        final bool needsScroll = maxHeight != null && finalHeight == null;
        
        // Se containerHeight foi fornecido, o Stack deve ter altura mínima igual ao container
        // para que a seta possa ser posicionada no meio do container (Ivy)
        final double? stackMinHeight = containerHeight;
        
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Container para garantir altura mínima quando containerHeight é fornecido
            if (stackMinHeight != null)
              SizedBox(
                height: stackMinHeight,
                width: width,
              ),
            
            // Balão principal - centralizado verticalmente quando containerHeight é fornecido
            stackMinHeight != null
                ? Positioned(
                    top: 0,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: width,
                        height: finalHeight,
                        constraints: containerConstraints,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          shadows: showBorder ? [
                            BoxShadow(
                              color: borderColor,
                              blurRadius: 0,
                              offset: Offset(shadowOffset, shadowOffset),
                              spreadRadius: shadowSpread,
                            ),
                          ] : [],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalPadding,
                          ),
                          child: needsScroll
                              ? SingleChildScrollView(
                                  child: child,
                                )
                              : child,
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: width,
                    height: finalHeight,
                    constraints: containerConstraints,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      shadows: showBorder ? [
                        BoxShadow(
                          color: borderColor,
                          blurRadius: 0,
                          offset: Offset(shadowOffset, shadowOffset),
                          spreadRadius: shadowSpread,
                        ),
                      ] : [],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding,
                      ),
                      child: needsScroll
                          ? SingleChildScrollView(
                              child: child,
                            )
                          : child,
                    ),
                  ),

            // Triângulo do balão - posicionamento dinâmico e responsivo
            if (showTriangle)
              // Para setas laterais (left/right), centralizar verticalmente no meio do container (Ivy)
              arrowDirection == 'left' || arrowDirection == 'right'
                  ? Positioned(
                      // Posiciona na lateral do balão
                      left: arrowDirection == 'left' ? -22.5 : null,
                      right: arrowDirection == 'right' ? -18 : null,
                      // Se containerHeight foi fornecido, posiciona a seta no meio do container (Ivy)
                      // Caso contrário, centraliza no meio do balão
                      top: stackMinHeight != null
                          ? (stackMinHeight / 2) - (18.72 / 2) // Centraliza no meio do container
                          : 0,
                      bottom: stackMinHeight != null
                          ? null
                          : 0,
                      child: stackMinHeight != null
                          ? CustomPaint(
                              size: const Size(22.47, 18.72),
                              painter: TrianglePainter(
                                borderColor: borderColor, 
                                triangleColor: triangleColor,
                                direction: arrowDirection,
                              ),
                            )
                          : Align(
                              alignment: Alignment.center,
                              child: CustomPaint(
                                size: const Size(22.47, 18.72),
                                painter: TrianglePainter(
                                  borderColor: borderColor, 
                                  triangleColor: triangleColor,
                                  direction: arrowDirection,
                                ),
                              ),
                            ),
                    )
                  // Para setas verticais (top/bottom), manter posicionamento horizontal centralizado
                  : Positioned(
                      bottom: arrowDirection == 'bottom' ? -18 : null,
                      top: arrowDirection == 'top' ? -18 : null,
                      left: width / 2 - 11.235, // Centraliza horizontalmente (22.47 / 2)
                      child: CustomPaint(
                        size: const Size(22.47, 18.72),
                        painter: TrianglePainter(
                          borderColor: borderColor, 
                          triangleColor: triangleColor,
                          direction: arrowDirection,
                        ),
                      ),
                    ),
          ],
        );
      },
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