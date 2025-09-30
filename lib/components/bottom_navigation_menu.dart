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
 * Last modified: 31-08-2025
 * 
 * Changes:
 * - UI Refatorado e Adicionado Community Icon (Evelin Cordeiro)
 * 
 * Version: 2.0.1
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/confirmation_dialog.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
  void _onNavTap(BuildContext context, int index) async {
    // Executa callback se fornecido
    onItemTapped?.call(index);

    // Navegação baseada no índice
    switch (index) {
      case 0: // Home
        context.go(Routes.home);
        break;
      case 1: // Perfil
        context.go(Routes.userProfile);
        break;
      case 2: // Voice
        context.go(Routes.chat);
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
    // Valores responsivos
    final height = ResponsiveValue<double>(
      context,
      defaultValue: 80.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 70.0),
        Condition.largerThan(name: TABLET, value: 90.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final microphoneSize = ResponsiveValue<double>(
      context,
      defaultValue: 70.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 60.0),
        Condition.largerThan(name: TABLET, value: 80.0),
      ],
    ).value;

    // Layout responsivo baseado no tamanho da tela
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: MetamorfoseColors.purpleDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
      ),
      child: Stack(
        children: [
          // Layout responsivo dos itens de navegação
          Positioned.fill(
            child: isMobile 
              ? _buildMobileLayout(context, microphoneSize)
              : _buildDesktopLayout(context, microphoneSize),
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

  /// Layout otimizado para mobile com melhor distribuição de espaço
  Widget _buildMobileLayout(BuildContext context, double microphoneSize) {
    return Row(
      children: [
        // Lado esquerdo - Home e Perfil
        Expanded(
          flex: 2,
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
        SizedBox(width: microphoneSize),

        // Lado direito - Comunidade e Sair
        Expanded(
          flex: 2,
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
    );
  }

  /// Layout otimizado para desktop/tablet com mais espaço
  Widget _buildDesktopLayout(BuildContext context, double microphoneSize) {
    return Row(
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
        SizedBox(width: microphoneSize),

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
    );
  }

  /// Constrói o item especial do microfone com destaque
  Widget _buildMicrophoneItem(BuildContext context) {

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
    
    // Valores responsivos para o item de navegação
    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 28.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 14.0),
      ],
    ).value;

    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 8.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final verticalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 12.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 4.0,
      conditionalValues: [
        Condition.smallerThan(name: MOBILE, value: 2.0),
        Condition.largerThan(name: TABLET, value: 6.0),
      ],
    ).value;

    return Flexible(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onNavTap(context, index),
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: iconSize,
                  color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                ),
                SizedBox(height: spacing),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                    fontFamily: 'DinNext',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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
