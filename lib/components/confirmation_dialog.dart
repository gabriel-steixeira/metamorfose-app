/**
 * File: confirmation_dialog.dart
 * Description: Componente de diálogo de confirmação personalizado.
 *
 * Responsabilidades:
 * - Exibir diálogos de confirmação padronizados
 * - Gerenciar ações de confirmação e cancelamento
 * - Manter consistência visual nos diálogos
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/theme/colors.dart';

/// Componente de diálogo de confirmação customizado.
/// Mantém consistência visual com os balões de fala do app.
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color backgroundColor;
  final Color borderColor;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    this.onCancel,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.backgroundColor = MetamorfoseColors.whiteLight,
    this.borderColor = MetamorfoseColors.greenLight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 320,
          minWidth: 280,
        ),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: [
            BoxShadow(
              color: borderColor,
              blurRadius: 0,
              offset: const Offset(3, 3),
              spreadRadius: 3,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: MetamorfoseColors.greyMedium,
                  fontFamily: 'DinNext',
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Conteúdo
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  color: MetamorfoseColors.greyMedium,
                  fontFamily: 'DinNext',
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Botões
              Row(
                children: [
                  // Botão Cancelar
                  Expanded(
                    child: _buildButton(
                      text: cancelText,
                      onPressed: onCancel ?? () => Navigator.of(context).pop(),
                      isPrimary: false,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Botão Confirmar
                  Expanded(
                    child: _buildButton(
                      text: confirmText,
                      onPressed: onConfirm,
                      isPrimary: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Container(
      height: 44,
      decoration: ShapeDecoration(
        color: isPrimary ? MetamorfoseColors.purpleLight : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isPrimary 
            ? BorderSide.none
            : const BorderSide(
                color: MetamorfoseColors.greyMedium,
                width: 1.5,
              ),
        ),
        shadows: isPrimary ? [
          const BoxShadow(
            color: MetamorfoseColors.greenLight,
            blurRadius: 0,
            offset: Offset(2, 2),
            spreadRadius: 1,
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isPrimary 
                  ? MetamorfoseColors.whiteLight
                  : MetamorfoseColors.greyMedium,
                fontFamily: 'DinNext',
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Método estático para exibir o diálogo
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: title,
          content: content,
          onConfirm: () {
            Navigator.of(context).pop(true);
            onConfirm();
          },
          onCancel: onCancel ?? () => Navigator.of(context).pop(false),
          confirmText: confirmText,
          cancelText: cancelText,
        );
      },
    );
  }
} 