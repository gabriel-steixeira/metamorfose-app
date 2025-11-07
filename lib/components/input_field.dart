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
import 'package:metamorfose_flutter/utils/responsive_utils.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Input de texto do aplicativo Metamorfose.
///
/// Este componente implementa o campo de entrada de texto usado em todo o aplicativo,
/// mantendo as características visuais consistentes:
/// - Cor de fundo branca
/// - Borda cinza clara
/// - Sombra suave
/// - Suporte a ícones prefix e suffix
/// - Fonte DinNext padronizada
class InputField extends StatelessWidget {
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
  const InputField({
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

    // Valores responsivos
    final height = ResponsiveValue<double>(
      context,
      defaultValue: 43.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 40.0),
        Condition.largerThan(name: TABLET, value: 52.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final verticalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return RepaintBoundary(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: double.infinity,
              height: height,
              decoration: ShapeDecoration(
                color: MetamorfoseColors.greyExtraLight,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: hasError
                        ? MetamorfoseColors.redNormal
                        : MetamorfoseColors.whiteDark,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                shadows: [],
              ),
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  controller: controller,
                  readOnly: readOnly,
                  onTap: onTap,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  autocorrect: false,
                  enableSuggestions: false,
                  smartDashesType: SmartDashesType.disabled,
                  smartQuotesType: SmartQuotesType.disabled,
                  enableInteractiveSelection: true,
                  enableIMEPersonalizedLearning: false,
                  scribbleEnabled: false,
                  maxLines: 1,
                  expands: false,
                  style: TextStyle(
                    color: MetamorfoseColors.greyMedium,
                    fontSize: fontSize,
                    fontFamily: 'DIN Next for Duolingo',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: MetamorfoseColors.greyMedium,
                      fontSize: fontSize,
                      fontFamily: 'DIN Next for Duolingo',
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: prefixIcon != null
                        ? Container(
                            width: 40,
                            height: height,
                            padding: EdgeInsets.only(
                              left: horizontalPadding,
                              right: 8,
                            ),
                            child: Center(
                              child: prefixIcon!,
                            ),
                          )
                        : null,
                    suffixIcon: suffixIcon != null
                        ? Container(
                            width: 40,
                            height: height,
                            padding: EdgeInsets.only(
                              right: horizontalPadding,
                              left: 8,
                            ),
                            child: Center(
                              child: suffixIcon!,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    isCollapsed: false,
                    isDense: false,
                  ),
                ),
              )),
          if (hasError)
            Padding(
              padding: EdgeInsets.only(top: 4, left: horizontalPadding),
              child: Text(
                errorText!,
                style: TextStyle(
                  color: MetamorfoseColors.redNormal,
                  fontSize: fontSize * 0.75,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
