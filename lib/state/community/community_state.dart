/**
 * File: community_state.dart
 * Description: Estado da tela de comunidade
 *
 * Responsabilidades:
 * - Gerenciar estado da aba ativa (Feed/Amigos)
 * - Gerenciar carregamento de posts
 * - Gerenciar carregamento de lista de amigos
 * - Controlar carregamento e erros
 *
 * Author: Evelin Cordeiro
 * Created on: 06-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

/// Estado de carregamento
enum LoadingState { idle, loading, success, error }

/// Estado da tela de comunidade
class CommunityState {
  final int activeTabIndex; // 0 = Feed, 1 = Amigos
  final LoadingState postsLoadingState;
  final LoadingState friendsLoadingState;
  final List<dynamic> posts; // Lista de posts (vazia por enquanto)
  final List<dynamic> friends; // Lista de amigos (vazia por enquanto)
  final String? postsError;
  final String? friendsError;
  final String? errorMessage;

  const CommunityState({
    this.activeTabIndex = 0,
    this.postsLoadingState = LoadingState.idle,
    this.friendsLoadingState = LoadingState.idle,
    this.posts = const [],
    this.friends = const [],
    this.postsError,
    this.friendsError,
    this.errorMessage,
  });

  /// Copia o estado com novos valores
  CommunityState copyWith({
    int? activeTabIndex,
    LoadingState? postsLoadingState,
    LoadingState? friendsLoadingState,
    List<dynamic>? posts,
    List<dynamic>? friends,
    String? postsError,
    String? friendsError,
    String? errorMessage,
  }) {
    return CommunityState(
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      postsLoadingState: postsLoadingState ?? this.postsLoadingState,
      friendsLoadingState: friendsLoadingState ?? this.friendsLoadingState,
      posts: posts ?? this.posts,
      friends: friends ?? this.friends,
      postsError: postsError ?? this.postsError,
      friendsError: friendsError ?? this.friendsError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Getters de conveniência
  bool get hasError => errorMessage != null;
  bool get isPostsLoading => postsLoadingState == LoadingState.loading;
  bool get isFriendsLoading => friendsLoadingState == LoadingState.loading;
  bool get isLoading => isPostsLoading || isFriendsLoading;
  bool get isFeedTab => activeTabIndex == 0;
  bool get isFriendsTab => activeTabIndex == 1;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommunityState &&
        other.activeTabIndex == activeTabIndex &&
        other.postsLoadingState == postsLoadingState &&
        other.friendsLoadingState == friendsLoadingState &&
        other.posts == posts &&
        other.friends == friends &&
        other.postsError == postsError &&
        other.friendsError == friendsError &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return activeTabIndex.hashCode ^
        postsLoadingState.hashCode ^
        friendsLoadingState.hashCode ^
        posts.hashCode ^
        friends.hashCode ^
        postsError.hashCode ^
        friendsError.hashCode ^
        errorMessage.hashCode;
  }

  @override
  String toString() {
    return 'CommunityState(activeTabIndex: $activeTabIndex, postsState: $postsLoadingState, friendsState: $friendsLoadingState, posts: $posts, friends: $friends, postsError: $postsError, friendsError: $friendsError, error: $errorMessage)';
  }
}
