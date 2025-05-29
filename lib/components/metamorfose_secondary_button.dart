/**
 * File: metamorfose_secondary_button.dart
 * Description: Componente de botão secundário do aplicativo.
 *
 * Responsabilidades:
 * - Fornecer botão secundário com estilo consistente
 * - Ações secundárias como "Cancelar", "Voltar"
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

/// Botão secundário do aplicativo Metamorfose.
/// 
/// Este componente implementa o botão secundário usado em todo o aplicativo,
/// mantendo as características visuais consistentes:
/// - Cor de fundo branca
/// - Borda inferior cinza claro para efeito de profundidade
/// - Sombra suave
/// - Texto roxo em maiúsculas com fonte DinNext
class MetamorfeseSecondaryButton extends StatelessWidget {
  /// Texto a ser exibido no botão
  final String text;
  
  /// Ação a ser executada ao pressionar o botão
  final VoidCallback onPressed;

  /// Construtor do botão secundário Metamorfose
  const MetamorfeseSecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomButton(
        text: text,
            onPressed: onPressed,
        backgroundColor: MetamorfoseColors.whiteLight,
        textColor: MetamorfoseColors.purpleNormal,
        shadowColor: MetamorfoseColors.greyLightest2,
        strokeColor: MetamorfoseColors.whiteDark,
      ),
    );
  }
} 