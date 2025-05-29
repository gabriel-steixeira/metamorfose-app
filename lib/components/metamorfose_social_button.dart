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
import 'package:conversao_flutter/theme/colors.dart';

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
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),//16, vertical: 12),
        decoration: ShapeDecoration(
          color: MetamorfoseColors.whiteLight,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 2,
              color: MetamorfoseColors.whiteDark,
            ),
            borderRadius: BorderRadius.circular(16),
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
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 16),
            Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
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