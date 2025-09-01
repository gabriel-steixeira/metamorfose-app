/**
 * File: metamorfose_select.dart
 * Description: Componente de seleção dropdown personalizado.
 *
 * Responsabilidades:
 * - Fornecer seleção dropdown estilizada
 * - Suportar opções com ícones e textos
 * - Manter consistência visual do design system
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/theme/colors.dart';

/// Modelo para opções do select
class SelectOption<T> {
  final T value;
  final String label;
  final Widget? icon;

  const SelectOption({
    required this.value,
    required this.label,
    this.icon,
  });
}

/// Input de seleção do aplicativo Metamorfose.
///
/// Este componente implementa o campo de seleção usado em todo o aplicativo,
/// mantendo as características visuais consistentes:
/// - Cor de fundo branca
/// - Borda cinza clara
/// - Sombra suave
/// - Bottom sheet para seleção de opções
/// - Fonte DinNext padronizada
class SelectField<T> extends StatelessWidget {
  /// Texto de placeholder do select
  final String hintText;

  /// Valor atualmente selecionado
  final T? selectedValue;

  /// Lista de opções disponíveis
  final List<SelectOption<T>> options;

  /// Callback executado quando uma opção é selecionada
  final ValueChanged<T>? onChanged;

  /// Ícone a ser exibido no início do select
  final Widget? prefixIcon;

  /// Título do bottom sheet de seleção
  final String? modalTitle;

  /// Se o select está desabilitado
  final bool enabled;

  /// Construtor do select Metamorfose
  const SelectField({
    super.key,
    required this.hintText,
    required this.options,
    this.selectedValue,
    this.onChanged,
    this.prefixIcon,
    this.modalTitle,
    this.enabled = true,
  });

  void _showSelectionModal(BuildContext context) {
    if (!enabled || onChanged == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: MetamorfoseColors.whiteLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (modalTitle != null) ...[
              Text(
                modalTitle!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.blackNormal,
                  fontFamily: 'DIN Next for Duolingo',
                ),
              ),
              const SizedBox(height: 16),
            ],
            ...options.map((option) {
              final isSelected = selectedValue == option.value;
              return ListTile(
                leading: option.icon ??
                    Icon(
                      Icons.radio_button_unchecked,
                      color: isSelected
                          ? MetamorfoseColors.purpleNormal
                          : MetamorfoseColors.greyLight,
                    ),
                title: Text(
                  option.label,
                  style: const TextStyle(
                    fontFamily: 'DIN Next for Duolingo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check,
                        color: MetamorfoseColors.purpleNormal,
                      )
                    : null,
                onTap: () {
                  onChanged?.call(option.value);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String get _displayText {
    if (selectedValue == null) return hintText;

    final selectedOption = options.firstWhere(
      (option) => option.value == selectedValue,
      orElse: () => SelectOption(value: selectedValue as T, label: hintText),
    );

    return selectedOption.label;
  }

  Widget? get _currentIcon {
    if (selectedValue == null) return prefixIcon;

    final selectedOption = options.firstWhere(
      (option) => option.value == selectedValue,
      orElse: () => SelectOption(value: selectedValue as T, label: hintText),
    );

    return selectedOption.icon ?? prefixIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 43,
      decoration: ShapeDecoration(
        color: MetamorfoseColors.greyExtraLight,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: MetamorfoseColors.whiteDark,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [],
      ),
      child: Material(
        color: MetamorfoseColors.transparent,
        child: InkWell(
          onTap: enabled ? () => _showSelectionModal(context) : null,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              if (_currentIcon != null) ...[
                Container(
                  width: 40,
                  height: 43,
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: Center(child: _currentIcon!),
                ),
              ],
              Expanded(
                child: Container(
                  height: 43,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _displayText,
                    style: const TextStyle(
                      color: MetamorfoseColors.greyMedium,
                      fontSize: 16,
                      fontFamily: 'DIN Next for Duolingo',
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 43,
                padding: const EdgeInsets.only(right: 16, left: 8),
                child: const Center(
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: MetamorfoseColors.purpleLight,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
