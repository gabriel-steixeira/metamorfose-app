/**
 * File: community_screen.dart
 * Description: Tela de comunidade
 *
 * Responsabilidades:
 * - Exibir feed de posts da comunidade
 * - Exibir lista de amigos
 * - Permitir compartilhamento de conteúdo
 * - Usar BLoC pattern para gerenciamento de estado
 *
 * Author: Evelin Cordeiro
 * Created on: 06-08-2025
 * Last modified: 06-08-2025
 * Version: 1.0.0 (BLoC)
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/theme/text_styles.dart';
import 'package:metamorfose_flutter/components/bottom_navigation_menu.dart';
import 'package:metamorfose_flutter/components/metamorfose_primary_button.dart';
import 'package:metamorfose_flutter/blocs/community_bloc.dart';
import 'package:metamorfose_flutter/state/community/community_state.dart';
import 'package:metamorfose_flutter/theme/typography.dart';

/// Tela de comunidade com feed e lista de amigos usando BLoC.
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  void initState() {
    super.initState();
    // Inicializar o BLoC
    context.read<CommunityBloc>().add(InitializeCommunityEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocConsumer<CommunityBloc, CommunityState>(
      listener: (context, state) {
        // Tratar erros se necessário
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: MetamorfoseColors.redNormal,
            ),
          );
          // Limpar erro após mostrar
          context.read<CommunityBloc>().add(ClearErrorEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MetamorfoseColors.whiteLight,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Tabs
                _buildTabs(state),

                // Content
                Expanded(
                  child: _buildContent(state),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationMenu(
            activeIndex: 3, 
          ),
        );
      },
    );
  }

/// Header
Widget _buildHeader() {
  return Container(
    padding: const EdgeInsets.all(24),
    child: Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: MetamorfoseColors.purpleLight,
          child: ClipOval(
            child: Image.asset(
              'assets/images/onboarding/ic_butterfly_transformation.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Título
        Text(
          'Comunidade',
          style: AppTypography.headlineMedium.copyWith(
            color: MetamorfoseColors.greyDark,
            fontWeight: FontWeight.w700,
            fontFamily: 'DinNext',
          ),
        ),
      ],
    ),
  );
}


  /// Abas (Feed/Amigos)
  Widget _buildTabs(CommunityState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Tab Feed
          Expanded(
            child: _buildTab(
              title: 'Feed',
              icon: Icons.article_outlined,
              isActive: state.isFeedTab,
              onTap: () => context.read<CommunityBloc>().add(SwitchTabEvent(0)),
            ),
          ),

          // Tab Amigos
          Expanded(
            child: _buildTab(
              title: 'Amigos',
              icon: Icons.people_outline,
              isActive: state.isFriendsTab,
              onTap: () => context.read<CommunityBloc>().add(SwitchTabEvent(1)),
            ),
          ),
        ],
      ),
    );
  }

  /// Aba Individual
  Widget _buildTab({
    required String title,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive
                  ? MetamorfoseColors.purpleNormal
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive
                  ? MetamorfoseColors.purpleNormal
                  : MetamorfoseColors.greyMedium,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                color: isActive
                    ? MetamorfoseColors.purpleNormal
                    : MetamorfoseColors.greyMedium,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                fontFamily: 'DinNext',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói o conteúdo baseado na aba ativa
  Widget _buildContent(CommunityState state) {
    if (state.isFeedTab) {
      return _buildFeedContent(state);
    } else {
      return _buildFriendsContent(state);
    }
  }

  /// Constrói o conteúdo do feed
  Widget _buildFeedContent(CommunityState state) {
    if (state.isPostsLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: MetamorfoseColors.purpleNormal,
        ),
      );
    } else if (state.posts.isEmpty) {
      return _buildEmptyState(
        title: 'Ainda não há posts na comunidade!',
        message: 'Seja o primeiro a compartilhar algo interessante! 🌱',
      );
    } else {
      // TODO: Implementar lista de posts
      return const SizedBox.shrink();
    }
  }

  /// Constrói o conteúdo da lista de amigos
  Widget _buildFriendsContent(CommunityState state) {
    if (state.isFriendsLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: MetamorfoseColors.purpleNormal,
        ),
      );
    } else if (state.friends.isEmpty) {
      return _buildEmptyState(
        title: 'Você ainda não tem amigos por aqui!',
        message: 'Convide alguém para começar sua rede! 🦋',
      );
    } else {
      // TODO: Implementar grid de amigos
      return const SizedBox.shrink();
    }
  }

  /// Constrói estado vazio centralizado na tela
  Widget _buildEmptyState({
    required String title,
    required String message,
  }) {
    return SizedBox.expand(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyDark,
                  fontFamily: 'DinNext',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: MetamorfoseColors.greyMedium,
                  fontFamily: 'DinNext',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
