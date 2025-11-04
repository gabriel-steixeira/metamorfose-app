/// File: community_screen.dart
/// Description: Tela de comunidade
///
/// Responsabilidades:
/// - Exibir feed de posts da comunidade
/// - Exibir lista de amigos
/// - Permitir compartilhamento de conteúdo
/// - Usar BLoC pattern para gerenciamento de estado
///
/// Author: Ester Santos
///
/// Changes:
/// - UI Ajustada. (Evelin Cordeiro)
///
/// Version: 1.0.0 (BLoC)
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/bottom_navigation_menu.dart';
import 'package:metamorfose_flutter/blocs/community_bloc.dart';
import 'package:metamorfose_flutter/state/community/community_state.dart';
import 'package:metamorfose_flutter/theme/typography.dart';
import 'package:metamorfose_flutter/services/user_progress_service.dart';
import 'package:metamorfose_flutter/models/community_models.dart';

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
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;

    return BlocConsumer<CommunityBloc, CommunityState>(
      listener: (context, state) {
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: MetamorfoseColors.redNormal,
            ),
          );
          context.read<CommunityBloc>().add(ClearErrorEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MetamorfoseColors.whiteLight,
          body: SafeArea(
            child: _buildResponsiveLayout(
                context, state, isMobile, isTablet, isDesktop),
          ),
          bottomNavigationBar: const BottomNavigationMenu(
            activeIndex: 3,
          ),
        );
      },
    );
  }

  /// Constrói o layout responsivo baseado no tipo de dispositivo
  Widget _buildResponsiveLayout(
    BuildContext context,
    CommunityState state,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
  ) {
    if (isMobile) {
      return _buildMobileLayout(context, state);
    } else if (isTablet) {
      return _buildTabletLayout(context, state);
    } else {
      return _buildDesktopLayout(context, state);
    }
  }

  /// Layout para dispositivos móveis
  Widget _buildMobileLayout(BuildContext context, CommunityState state) {
    return Column(
      children: [
        _buildHeader(),
        _buildTabs(state),
        Expanded(
          child: _buildContent(state),
        ),
      ],
    );
  }

  /// Layout para tablets
  Widget _buildTabletLayout(BuildContext context, CommunityState state) {
    return Column(
      children: [
        _buildHeader(),
        _buildTabs(state),
        Expanded(
          child: _buildContent(state),
        ),
      ],
    );
  }

  /// Layout para desktop
  Widget _buildDesktopLayout(BuildContext context, CommunityState state) {
    return Column(
      children: [
        _buildHeader(),
        _buildTabs(state),
        Expanded(
          child: _buildContent(state),
        ),
      ],
    );
  }

  /// Header
  Widget _buildHeader() {
    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 8.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 20.0),
        Condition.largerThan(name: TABLET, value: 28.0),
      ],
    ).value;

    return Container(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          _buildUserProgressAvatar(),
          SizedBox(width: spacing),
          Text(
            'Comunidade',
            style: AppTypography.headlineMedium.copyWith(
              color: MetamorfoseColors.greyDark,
              fontWeight: FontWeight.w700,
              fontFamily: 'DinNext',
              fontSize: titleFontSize,
            ),
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Abas (Feed/Amigos)
  Widget _buildTabs(CommunityState state) {
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              title: 'Feed',
              icon: Icons.article_outlined,
              isActive: state.isFeedTab,
              onTap: () => context.read<CommunityBloc>().add(SwitchTabEvent(0)),
            ),
          ),
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
    final verticalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 5.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 4.0),
        Condition.largerThan(name: TABLET, value: 8.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 12.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
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
              size: iconSize,
              color: isActive
                  ? MetamorfoseColors.purpleNormal
                  : MetamorfoseColors.greyMedium,
            ),
            SizedBox(width: spacing),
            Text(
              title,
              style: AppTypography.titleMedium.copyWith(
                color: isActive
                    ? MetamorfoseColors.purpleNormal
                    : MetamorfoseColors.greyMedium,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                fontFamily: 'DinNext',
                fontSize: fontSize,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
      return ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveValue<double>(
            context,
            defaultValue: 24.0,
            conditionalValues: const [
              Condition.smallerThan(name: MOBILE, value: 16.0),
              Condition.largerThan(name: TABLET, value: 32.0),
            ],
          ).value,
          vertical: 16.0,
        ),
        itemCount: state.posts.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final post = state.posts[index];
          return _buildPostCard(post);
        },
      );
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
      final spacing = ResponsiveValue<double>(
        context,
        defaultValue: 16.0,
        conditionalValues: const [
          Condition.smallerThan(name: MOBILE, value: 12.0),
          Condition.largerThan(name: TABLET, value: 24.0),
        ],
      ).value;

      return GridView.builder(
        padding: EdgeInsets.all(spacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemCount: state.friends.length,
        itemBuilder: (context, index) {
          final friend = state.friends[index];
          return _buildFriendCard(friend);
        },
      );
    }
  }

  /// Constrói um card de post
  Widget _buildPostCard(CommunityPost post) {
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 8.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MetamorfoseColors.greyLightest2,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: MetamorfoseColors.defaultButtonShadow,
            blurRadius: 0,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with author info
          Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(post.authorAvatar),
                  radius: 20,
                ),
                SizedBox(width: spacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(
                          fontFamily: 'DinNext',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: MetamorfoseColors.greyDark,
                        ),
                      ),
                      Text(
                        '2h atrás',
                        style: TextStyle(
                          fontFamily: 'DinNext',
                          fontSize: 12,
                          color: MetamorfoseColors.greyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content text
          if (post.content.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                post.content,
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: 15,
                  color: MetamorfoseColors.greyDark,
                  height: 1.5,
                ),
              ),
            ),

          // Image if exists
          if (post.image != null) ...[
            SizedBox(height: spacing),
            Image.asset(
              post.image!,
              fit: BoxFit.cover,
            ),
          ],

          // Engagement info
          Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: Row(
              children: [
                _buildEngagementButton(
                  icon: Icons.favorite,
                  count: post.likes,
                  isActive: post.isLiked,
                  onTap: () {},
                ),
                SizedBox(width: spacing * 2),
                _buildEngagementButton(
                  icon: Icons.chat_bubble_outline,
                  count: post.comments,
                  isActive: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói um botão de engajamento (like/comment)
  Widget _buildEngagementButton({
    required IconData icon,
    required int count,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color =
        isActive ? MetamorfoseColors.redNormal : MetamorfoseColors.greyMedium;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontFamily: 'DinNext',
              fontSize: 14,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói um card de amigo
  Widget _buildFriendCard(CommunityFriend friend) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MetamorfoseColors.greyLightest2,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: MetamorfoseColors.defaultButtonShadow,
            blurRadius: 0,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: MetamorfoseColors.whiteLight,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: MetamorfoseColors.purpleLight.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundImage: AssetImage(friend.avatar),
                  radius: 36,
                ),
              ),
              if (friend.isOnline)
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: MetamorfoseColors.greenNormal,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            friend.name,
            style: const TextStyle(
              fontFamily: 'DinNext',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MetamorfoseColors.greyDark,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: MetamorfoseColors.purpleLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              friend.phase ?? 'Novo',
              style: TextStyle(
                fontFamily: 'DinNext',
                fontSize: 12,
                color: MetamorfoseColors.purpleNormal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói estado vazio centralizado na tela
  Widget _buildEmptyState({
    required String title,
    required String message,
  }) {
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final verticalSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final titleSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 8.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 18.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final messageFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return SizedBox.expand(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: verticalSpacing),
              Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyDark,
                  fontFamily: 'DinNext',
                  fontSize: titleFontSize,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: titleSpacing),
              Text(
                message,
                style: AppTypography.bodyMedium.copyWith(
                  color: MetamorfoseColors.greyMedium,
                  fontFamily: 'DinNext',
                  fontSize: messageFontSize,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o avatar com a foto de perfil do progresso do usuário
  Widget _buildUserProgressAvatar() {
    final avatarRadius = ResponsiveValue<double>(
      context,
      defaultValue: 28.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final imageSize = ResponsiveValue<double>(
      context,
      defaultValue: 40.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 36.0),
        Condition.largerThan(name: TABLET, value: 44.0),
      ],
    ).value;

    return FutureBuilder<int>(
      future: UserProgressService.getUserProgress(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            radius: avatarRadius,
            backgroundColor: MetamorfoseColors.purpleLight,
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        }

        final progress = snapshot.data ?? 10;
        final phase = UserProgressService.getPhaseByProgress(progress);
        final imagePath = UserProgressService.getPhaseImagePath(phase);

        return CircleAvatar(
          radius: avatarRadius,
          backgroundColor: MetamorfoseColors.purpleLight,
          child: ClipOval(
            child: Image.asset(
              imagePath,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
