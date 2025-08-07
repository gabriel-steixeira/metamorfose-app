/**
 * File: community_bloc.dart
 * Description: BLoC para gerenciamento do estado da tela de comunidade
 *
 * Responsabilidades:
 * - Gerenciar estado da aba ativa (Feed/Amigos)
 * - Gerenciar carregamento de posts da comunidade
 * - Gerenciar carregamento de lista de amigos
 * - Coordenar estados de loading e erro
 *
 * Author: Evelin Cordeiro
 * Created on: 06-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/state/community/community_state.dart';
import 'package:metamorfose_flutter/services/community_service.dart';

/// Eventos do CommunityBloc
abstract class CommunityEvent {}

/// Evento para inicializar a tela
class InitializeCommunityEvent extends CommunityEvent {}

/// Evento para trocar aba ativa
class SwitchTabEvent extends CommunityEvent {
  final int tabIndex;
  SwitchTabEvent(this.tabIndex);
}

/// Evento para carregar posts da comunidade
class LoadPostsEvent extends CommunityEvent {}

/// Evento para carregar lista de amigos
class LoadFriendsEvent extends CommunityEvent {}

/// Evento para limpar erros
class ClearErrorEvent extends CommunityEvent {}

/// BLoC para a tela de comunidade
class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final CommunityService _service;

  CommunityBloc({CommunityService? service})
      : _service = service ?? CommunityService(),
        super(const CommunityState()) {
    on<InitializeCommunityEvent>(_onInitialize);
    on<SwitchTabEvent>(_onSwitchTab);
    on<LoadPostsEvent>(_onLoadPosts);
    on<LoadFriendsEvent>(_onLoadFriends);
    on<ClearErrorEvent>(_onClearError);
  }

  /// Inicializa a tela carregando dados da aba ativa
  Future<void> _onInitialize(
    InitializeCommunityEvent event,
    Emitter<CommunityState> emit,
  ) async {
    try {
      // Carregar dados da aba ativa (Feed por padrão)
      add(LoadPostsEvent());
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Erro ao inicializar tela de comunidade',
      ));
    }
  }

  /// Troca a aba ativa
  Future<void> _onSwitchTab(
    SwitchTabEvent event,
    Emitter<CommunityState> emit,
  ) async {
    try {
      emit(state.copyWith(activeTabIndex: event.tabIndex));

      // Carregar dados da nova aba
      if (event.tabIndex == 0) {
        add(LoadPostsEvent());
      } else {
        add(LoadFriendsEvent());
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Erro ao trocar aba',
      ));
    }
  }

  /// Carrega posts da comunidade
  Future<void> _onLoadPosts(
    LoadPostsEvent event,
    Emitter<CommunityState> emit,
  ) async {
    try {
      emit(state.copyWith(
        postsLoadingState: LoadingState.loading,
        postsError: null,
      ));

      // Simular carregamento (não há posts ainda)
      await Future.delayed(const Duration(milliseconds: 1000));

      emit(state.copyWith(
        postsLoadingState: LoadingState.success,
        posts: [], // Lista vazia para simular "sem posts"
        postsError: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        postsLoadingState: LoadingState.error,
        postsError: e.toString(),
      ));
    }
  }

  /// Carrega lista de amigos
  Future<void> _onLoadFriends(
    LoadFriendsEvent event,
    Emitter<CommunityState> emit,
  ) async {
    try {
      emit(state.copyWith(
        friendsLoadingState: LoadingState.loading,
        friendsError: null,
      ));

      // Simular carregamento (não há amigos ainda)
      await Future.delayed(const Duration(milliseconds: 1000));

      emit(state.copyWith(
        friendsLoadingState: LoadingState.success,
        friends: [], // Lista vazia para simular "sem amigos"
        friendsError: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        friendsLoadingState: LoadingState.error,
        friendsError: e.toString(),
      ));
    }
  }

  /// Limpa erros do estado
  Future<void> _onClearError(
    ClearErrorEvent event,
    Emitter<CommunityState> emit,
  ) async {
    emit(state.copyWith(errorMessage: null));
  }
}
