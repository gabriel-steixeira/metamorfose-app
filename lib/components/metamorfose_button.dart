/**
 * File: metamorfose_button.dart
 * Description: Componente de botão padrão do aplicativo Metamorfose.
 *
 * Responsabilidades:
 * - Fornecer um botão com estilo padronizado
 * - Manter consistência visual em todos os botões do app
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

/// Botão padrão do aplicativo Metamorfose.
/// 
/// Este componente implementa o botão padrão usado em todo o aplicativo,
/// mantendo as características visuais consistentes:
/// - Cor de fundo roxa
/// - Borda inferior mais escura para efeito de profundidade
/// - Sombra suave
/// - Texto em maiúsculas com fonte DinNext
class MetamorfeseButton extends StatelessWidget {
  /// Texto a ser exibido no botão
  final String text;
  
  /// Ação a ser executada ao pressionar o botão
  final VoidCallback onPressed;

  /// Construtor do botão padrão Metamorfose
  const MetamorfeseButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
            onPressed: onPressed,
      backgroundColor: MetamorfoseColors.purpleLight,
      textColor: MetamorfoseColors.whiteLight,
      shadowColor: MetamorfoseColors.purpleDark,
      strokeColor: MetamorfoseColors.purpleLight,
    );
  }
} 