/**
 * File: metamorfose_input.dart
 * Description: Componente de input de texto do aplicativo Metamorfose.
 *
 * Responsabilidades:
 * - Fornecer um campo de entrada de texto com estilo padronizado
 * - Manter consistência visual em todos os inputs do app
 * - Suportar ícones prefix e suffix
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metamorfose_flutter/theme/colors.dart';

/// Input de texto do aplicativo Metamorfose.
/// 
/// Este componente implementa o campo de entrada de texto usado em todo o aplicativo,
/// mantendo as características visuais consistentes:
/// - Cor de fundo branca
/// - Borda cinza clara
/// - Sombra suave
/// - Suporte a ícones prefix e suffix
/// - Fonte DinNext padronizada
class MetamorfeseInput extends StatelessWidget {
  /// Texto de placeholder do input
  final String hintText;
  
  /// Controller para gerenciar o texto do input
  final TextEditingController? controller;
  
  /// Ícone a ser exibido no início do input
  final Widget? prefixIcon;
  
  /// Ícone a ser exibido no final do input
  final Widget? suffixIcon;
  
  /// Callback executado quando o input é tocado
  final VoidCallback? onTap;
  
  /// Se o input deve ser somente leitura
  final bool readOnly;
  
  /// Tipo de teclado a ser exibido
  final TextInputType? keyboardType;
  
  /// Ação do botão de ação do teclado
  final TextInputAction? textInputAction;
  
  /// Callback executado quando o texto é alterado
  final ValueChanged<String>? onChanged;
  
  /// Callback executado quando o usuário submete o texto
  final ValueChanged<String>? onSubmitted;
  
  /// Cor de fundo do input (opcional, padrão é branco)
  final Color? backgroundColor;
  
  /// Raio das bordas (opcional, padrão é 16)
  final double? borderRadius;
  
  /// Se deve exibir sombra (opcional, padrão é true)
  final bool showShadow;
  
  /// Cor da borda (opcional, padrão é whiteDark)
  final Color? borderColor;

  /// Texto de erro a ser exibido abaixo do input
  final String? errorText;

  /// Construtor do input de texto Metamorfose
  const MetamorfeseInput({
    super.key,
    required this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.backgroundColor,
    this.borderRadius,
    this.showShadow = true,
    this.borderColor,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 56,
            decoration: ShapeDecoration(
              color: backgroundColor ?? MetamorfoseColors.whiteLight,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: hasError
                      ? MetamorfoseColors.redNormal
                      : borderColor ?? MetamorfoseColors.whiteDark,
                ),
                borderRadius: BorderRadius.circular(borderRadius ?? 16),
              ),
              shadows: showShadow
                  ? const [
                      BoxShadow(
                        color: MetamorfoseColors.shadowLight,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                        spreadRadius: 0,
                      ),
                    ]
                  : [],
            ),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              // Otimizações de performance mantendo o design
              autocorrect: false,
              enableSuggestions: false,
              smartDashesType: SmartDashesType.disabled,
              smartQuotesType: SmartQuotesType.disabled,
              enableInteractiveSelection: true,
              // Reduzir rebuilds desnecessários
              enableIMEPersonalizedLearning: false,
              scribbleEnabled: false,
              // Otimizar renderização
              maxLines: 1,
              expands: false,
              style: const TextStyle(
                color: MetamorfoseColors.greyDark,
                fontSize: 16,
                fontFamily: 'DIN Next for Duolingo',
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: MetamorfoseColors.greyLight,
                  fontSize: 16,
                  fontFamily: 'DIN Next for Duolingo',
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                // Otimizar comportamento do cursor
                isCollapsed: false,
                isDense: false,
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 16),
              child: Text(
                errorText!,
                style: const TextStyle(
                  color: MetamorfoseColors.redNormal,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
} 