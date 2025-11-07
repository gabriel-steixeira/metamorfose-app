/**
 * File: metamorfose_social_button.dart
 * Description: Componente de botão para autenticação social.
 *
 * Responsabilidades:
 * - Fornecer botões para login social (Google, Facebook, etc.)
 * - Manter consistência visual nos botões de redes sociais
 * - Suportar ícones das redes sociais
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Botão social do aplicativo Metamorfose.
/// 
/// Este componente implementa o botão social usado para login com provedores externos,
/// mantendo as características visuais consistentes:
/// - Cor de fundo branca
/// - Borda cinza clara
/// - Sombra com efeito de profundidade
/// - Ícone SVG do provedor social
/// - Texto em maiúsculas com fonte DinNext
class MetamorfoseSocialButton extends StatelessWidget {
  /// Texto a ser exibido no botão
  final String text;
  
  /// Caminho do ícone SVG do provedor social
  final String iconPath;
  
  /// Ação a ser executada ao pressionar o botão
  final VoidCallback onPressed;

  /// Cor do texto do botão
  final Color? textColor;

  /// Construtor do botão social Metamorfose
  const MetamorfoseSocialButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onPressed,
    this.textColor = MetamorfoseColors.blackLight
  });

  @override
  Widget build(BuildContext context) {
    // Valores responsivos
    final height = ResponsiveValue<double>(
      context,
      defaultValue: 56.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 50.0),
        Condition.largerThan(name: TABLET, value: 64.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 18.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 20.0),
        Condition.largerThan(name: TABLET, value: 28.0),
      ],
    ).value;

    final horizontalSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: ShapeDecoration(
          color: MetamorfoseColors.whiteLight,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 2,
              color: MetamorfoseColors.whiteDark,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          shadows: const [
            BoxShadow(
              color: MetamorfoseColors.greyLightest2,
              blurRadius: 0,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: iconSize,
              height: iconSize,
            ),
            SizedBox(width: horizontalSpacing),
            Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontFamily: 'DIN Next for Duolingo',
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 15,
                    color: MetamorfoseColors.shadowText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 