/**
 * File: metamorfose_password_input.dart
 * Description: Componente de input de senha personalizado.
 *
 * Responsabilidades:
 * - Fornecer campo de senha com funcionalidade de mostrar/ocultar
 * - Manter segurança na entrada de senhas
 * - Seguir padrões visuais do design system
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
import 'package:metamorfose_flutter/utils/responsive_utils.dart';

/// Input de senha do aplicativo Metamorfose.
///
/// Este componente implementa o campo de entrada de senha usado em todo o aplicativo,
/// mantendo as características visuais consistentes com o MetamorfeseInput:
/// - Cor de fundo branca
/// - Borda cinza clara
/// - Sombra suave
/// - Toggle de visibilidade da senha
/// - Ícones SVG para mostrar/ocultar senha
/// - Fonte DinNext padronizada
class PasswordInputField extends StatefulWidget {
  /// Texto de placeholder do input
  final String hintText;

  /// Controller para gerenciar o texto do input
  final TextEditingController? controller;

  /// Ícone a ser exibido no início do input
  final Widget? prefixIcon;

  /// Callback executado quando o input é tocado
  final VoidCallback? onTap;

  /// Se o input deve ser somente leitura
  final bool readOnly;

  /// Ação do botão de ação do teclado
  final TextInputAction? textInputAction;

  /// Callback executado quando o texto é alterado
  final ValueChanged<String>? onChanged;

  /// Callback executado quando o usuário submete o texto
  final ValueChanged<String>? onSubmitted;

  /// Estado inicial da visibilidade da senha
  final bool initiallyVisible;

  /// Callback executado quando a visibilidade da senha muda
  final ValueChanged<bool>? onVisibilityChanged;

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

  /// Construtor do input de senha Metamorfose
  const PasswordInputField({
    super.key,
    required this.hintText,
    this.controller,
    this.prefixIcon,
    this.onTap,
    this.readOnly = false,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.initiallyVisible = false,
    this.onVisibilityChanged,
    this.backgroundColor,
    this.borderRadius,
    this.showShadow = true,
    this.borderColor,
    this.errorText,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.initiallyVisible;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });

    // Notifica a mudança de visibilidade se o callback foi fornecido
    widget.onVisibilityChanged?.call(_isPasswordVisible);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: double.infinity,
            height: 43,
            decoration: ShapeDecoration(
              color: MetamorfoseColors.greyExtraLight,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: hasError
                      ? MetamorfoseColors.redNormal
                      : MetamorfoseColors.whiteDark,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: [],
            ),
            child: RepaintBoundary(
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  controller: widget.controller,
                  readOnly: widget.readOnly,
                  onTap: widget.onTap,
                  obscureText: !_isPasswordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: widget.textInputAction,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  autocorrect: false,
                  enableSuggestions: false,
                  smartDashesType: SmartDashesType.disabled,
                  smartQuotesType: SmartQuotesType.disabled,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      color: MetamorfoseColors.greyMedium,
                      fontSize: 16,
                      fontFamily: 'DIN Next for Duolingo',
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: widget.prefixIcon != null
                        ? Container(
                            width: 40,
                            height: 43,
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            child: Center(
                              child: widget.prefixIcon!,
                            ),
                          )
                        : null,
                    suffixIcon: GestureDetector(
                      onTap: _togglePasswordVisibility,
                      child: Container(
                        width: 40,
                        height: 43,
                        padding: const EdgeInsets.only(right: 16, left: 8),
                        child: Center(
                          child: SvgPicture.asset(
                            _isPasswordVisible
                                ? 'assets/images/auth/ic_visibility_on.svg'
                                : 'assets/images/auth/ic_visibility_off.svg',
                            fit: BoxFit.contain,
                            colorFilter: const ColorFilter.mode(
                              MetamorfoseColors.purpleLight,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            )),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 16),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: MetamorfoseColors.redNormal,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
