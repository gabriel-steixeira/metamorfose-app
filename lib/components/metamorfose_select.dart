/**
 * File: metamorfose_select.dart
 * Description: Componente de input de seleção do aplicativo Metamorfose.
 *
 * Responsabilidades:
 * - Fornecer um campo de seleção com estilo padronizado
 * - Manter consistência visual em todos os selects do app
 * - Suportar ícones prefix e suffix
 * - Integrar com bottom sheets para seleção
 *
 * Author: Gabriel Teixeira
 * Created on: atual
 * Last modified: atual
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:conversao_flutter/theme/colors.dart';

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
class MetamorfeseSelect<T> extends StatelessWidget {
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
  const MetamorfeseSelect({
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
      height: 56,
      decoration: ShapeDecoration(
        color: enabled 
            ? MetamorfoseColors.whiteLight 
            : MetamorfoseColors.greyExtraLight,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: enabled 
                ? MetamorfoseColors.whiteDark 
                : MetamorfoseColors.greyLightest,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: enabled ? const [
          BoxShadow(
            color: MetamorfoseColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ] : null,
      ),
      child: Material(
        color: MetamorfoseColors.transparent,
        child: InkWell(
          onTap: enabled ? () => _showSelectionModal(context) : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                if (_currentIcon != null) ...[
                  _currentIcon!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    _displayText,
                    style: TextStyle(
                      color: selectedValue == null 
                          ? MetamorfoseColors.greyLight 
                          : MetamorfoseColors.blackNormal,
                      fontSize: 16,
                      fontFamily: 'DIN Next for Duolingo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: enabled 
                      ? MetamorfoseColors.purpleNormal 
                      : MetamorfoseColors.greyLight,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 