/**
 * File: bottom_navigation_menu.dart
 * Description: Componente de menu de navegação inferior reutilizável.
 *
 * Responsabilidades:
 * - Fornecer menu de navegação inferior padronizado
 * - Gerenciar estados ativos dos ícones
 * - Realizar navegação entre telas
 * - Exibir modal "Em desenvolvimento" para funcionalidades não implementadas
 * - Design simples e centralizado com microfone no centro absoluto
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 30-05-2025
 * Last modified: 06-08-2025
 * 
 * Changes:
 * - UI Refatorado e Adicionado Community Icon (Evelin Cordeiro)
 * 
 * Version: 2.0.1
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/confirmation_dialog.dart';
import 'package:metamorfose_flutter/routes/routes.dart';

class BottomNavigationMenu extends StatelessWidget {
  final int activeIndex;

  final ValueChanged<int>? onItemTapped;

  /// Construtor do menu de navegação inferior
  const BottomNavigationMenu({
    super.key,
    required this.activeIndex,
    this.onItemTapped,
  });

  /// Lida com o toque nos itens de navegação
  void _onNavTap(BuildContext context, int index) {
    // Executa callback se fornecido
    onItemTapped?.call(index);

    // Navegação baseada no índice
    switch (index) {
      case 0: // Home
        context.go(Routes.home);
        break;
<<<<<<< Updated upstream
      case 1: // Perfil
        context.go(Routes.plantConfig);
        break;
      case 2: // Voice
        context.go(Routes.voiceChat);
=======
      case 1: // Voice icon - navegar para chat por texto
        context.go(Routes.plantConsciousnessChat);
>>>>>>> Stashed changes
        break;
      case 3: // Comunidade
        context.go(Routes.community);
        break;
      case 4: // Sair
        _showExitConfirmation(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: const BoxDecoration(
        color: MetamorfoseColors.purpleDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Stack(
        children: [
          // Layout dos itens laterais com alinhamento centralizado
          Positioned.fill(
            child: Row(
              children: [
                // Lado esquerdo - Home e Perfil
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildNavItem(
                        context,
                        icon: Icons.home_rounded,
                        index: 0,
                        label: 'Home',
                      ),
                      _buildNavItem(
                        context,
                        icon: Icons.person_rounded,
                        index: 1,
                        label: 'Perfil',
                      ),
                    ],
                  ),
                ),

                // Espaço para o microfone central
                const SizedBox(width: 70),

                // Lado direito - Comunidade e Sair
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildNavItem(
                        context,
                        icon: Icons.groups_rounded,
                        index: 3,
                        label: 'Comunidade',
                      ),
                      _buildNavItem(
                        context,
                        icon: Icons.exit_to_app_rounded,
                        index: 4,
                        label: 'Sair',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Microfone posicionado no centro absoluto
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: _buildMicrophoneItem(context),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o item especial do microfone com destaque
  Widget _buildMicrophoneItem(BuildContext context) {
    final isActive = activeIndex == 2;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onNavTap(context, 2),
        borderRadius: BorderRadius.circular(28),
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                MetamorfoseColors.purpleLight,
                MetamorfoseColors.greenLight,
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mic_rounded,
                size: 32,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói um item de navegação padrão
  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required int index,
    required String label,
  }) {
    final isActive = activeIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onNavTap(context, index),
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white.withOpacity(0.1),
        highlightColor: Colors.white.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color:
                      isActive ? Colors.white : Colors.white.withOpacity(0.7),
                  fontFamily: 'DinNext',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Exibe diálogo de confirmação para sair do app
void _showExitConfirmation(BuildContext context) {
  ConfirmationDialog.show(
    context,
    title: 'Sair do App',
    content: 'Deseja realmente sair do aplicativo?',
    confirmText: 'Sair',
    cancelText: 'Cancelar',
    onConfirm: () {
      SystemNavigator.pop(); // Fecha o app
    },
  );
}
