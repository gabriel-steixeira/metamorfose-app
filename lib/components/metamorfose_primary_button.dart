/**
 * File: metamorfose_primary_button.dart
 * Description: Componente de botão primário do aplicativo.
 *
 * Responsabilidades:
 * - Fornecer botão primário com estilo consistente
 * - Suportar ícones opcionais
 * - Manter padrão visual do design system
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:conversao_flutter/components/custom_button.dart';

/// Componente de botão primário (usado para ações principais na interface do usuário),
/// como "Entrar", "Cadastrar", "Confirmar", etc. A interação do usuário é definida pelo parâmetro `onPressed`.
class MetamorfosePrimaryButton extends StatelessWidget {
  /// O texto exibido no botão.
  final String text;
  
  /// A ação que será executada quando o botão for pressionado.
  final VoidCallback onPressed;

  /// Ícone opcional a ser exibido no lugar do texto.
  final Widget? icon;

  /// Construtor do botão primário Metamorfose
  /// 
  /// @param text O texto exibido no botão.
  /// @param onPressed A ação que será executada quando o botão for pressionado.
  /// @param icon Ícone opcional a ser exibido no lugar do texto.
  const MetamorfosePrimaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomButton(
        text: icon == null ? text : '',
        onPressed: onPressed,
        backgroundColor: MetamorfoseColors.purpleNormal, // 0xFF9C68FF
        textColor: MetamorfoseColors.whiteLight,
        shadowColor: MetamorfoseColors.purpleDark, // 0xFF662FCB
        strokeColor: MetamorfoseColors.purpleNormal, // 0xFF9C68FF
        child: icon,
      ),
    );
  }
} 