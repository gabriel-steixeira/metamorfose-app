/**
 * File: metamorfose_primary_button.dart
 * Description: Componente de botão primário do aplicativo.
 *
 * Responsabilidades:
 * - Fornecer botão primário com estilo consistente
 * - Suportar ícones opcionais
 * - Permitir personalização de cores (fundo, borda, sombra)
 * - Manter padrão visual do design system
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 17-08-2025
 * Version: 1.1.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/custom_button.dart';

/// Componente de botão primário (usado para ações principais na interface do usuário),
/// como "Entrar", "Cadastrar", "Confirmar", etc. A interação do usuário é definida pelo parâmetro `onPressed`.
class MetamorfosePrimaryButton extends StatelessWidget {
  /// O texto exibido no botão.
  final String text;
  
  /// A ação que será executada quando o botão for pressionado.
  final VoidCallback onPressed;

  /// Ícone opcional a ser exibido no lugar do texto.
  final Widget? icon;

  /// Cor de fundo personalizada (opcional)
  final Color? backgroundColor;

  /// Cor da borda personalizada (opcional)
  final Color? borderColor;

  /// Cor da sombra personalizada (opcional)
  final Color? shadowColor;

  /// Construtor do botão primário Metamorfose
  /// 
  /// @param text O texto exibido no botão.
  /// @param onPressed A ação que será executada quando o botão for pressionado.
  /// @param icon Ícone opcional a ser exibido no lugar do texto.
  /// @param backgroundColor Cor de fundo personalizada (opcional).
  /// @param borderColor Cor da borda personalizada (opcional).
  /// @param shadowColor Cor da sombra personalizada (opcional).
  const MetamorfosePrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.borderColor,
    this.shadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomButton(
        text: icon == null ? text : '',
        onPressed: onPressed,
        backgroundColor: backgroundColor ?? MetamorfoseColors.purpleNormal,
        textColor: MetamorfoseColors.whiteLight,
        shadowColor: shadowColor ?? MetamorfoseColors.purpleDark,
        strokeColor: borderColor ?? MetamorfoseColors.purpleNormal,
        child: icon,
      ),
    );
  }
} 