/**
 * File: auth_bloc.dart
 * Description: BLoC para gerenciamento do estado de autenticação.
 *
 * Responsabilidades:
 * - Gerenciar login e logout do usuário
 * - Validar credenciais simuladas
 * - Manter estado de autenticação
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conversao_flutter/state/auth/auth_state.dart';

import 'package:conversao_flutter/state/auth/validation_state.dart';
import 'package:conversao_flutter/services/auth_service.dart';

/// Eventos do AuthBloc
abstract class AuthEvent {}

/// Evento para alternar entre login e registro
class AuthToggleModeEvent extends AuthEvent {
  final AuthScreenMode mode;
  AuthToggleModeEvent(this.mode);
}

/// Evento para atualizar campos de login
class AuthUpdateLoginFieldEvent extends AuthEvent {
  final String? email;
  final String? password;
  final bool? rememberMe;
  final bool? isPasswordVisible;

  AuthUpdateLoginFieldEvent({
    this.email,
    this.password,
    this.rememberMe,
    this.isPasswordVisible,
  });
}

/// Evento para submeter login
class AuthSubmitLoginEvent extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  AuthSubmitLoginEvent({
    required this.email,
    required this.password,
    required this.rememberMe,
  });
}

/// Evento para logout
class AuthLogoutEvent extends AuthEvent {}

/// Evento para alternar visibilidade dos olhos do personagem
class AuthToggleEyesEvent extends AuthEvent {
  final bool eyesOpen;
  AuthToggleEyesEvent(this.eyesOpen);
}

/// BLoC para gerenciamento de autenticação
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthState()) {
    on<AuthToggleModeEvent>(_onToggleMode);
    on<AuthUpdateLoginFieldEvent>(_onUpdateLoginField);
    on<AuthSubmitLoginEvent>(_onSubmitLogin);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthToggleEyesEvent>(_onToggleEyes);
  }

  /// Handler para alternar entre modos
  void _onToggleMode(AuthToggleModeEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(mode: event.mode));
  }

  /// Handler para atualizar campos de login
  void _onUpdateLoginField(
    AuthUpdateLoginFieldEvent event,
    Emitter<AuthState> emit,
  ) {
    final currentLoginState = state.loginState;
    
    // Validações básicas
    ValidationState? emailValidation;
    ValidationState? passwordValidation;

    if (event.email != null) {
      emailValidation = _validateEmail(event.email!);
    }

    if (event.password != null) {
      passwordValidation = _validatePassword(event.password!);
    }

    final newLoginState = currentLoginState.copyWith(
      email: event.email,
      password: event.password,
      rememberMe: event.rememberMe,
      isPasswordVisible: event.isPasswordVisible,
      emailValidation: emailValidation,
      passwordValidation: passwordValidation,
      errorMessage: null, // Limpa erro ao editar campos
    );

    emit(state.copyWith(loginState: newLoginState));
  }

  /// Handler para submeter login
  void _onSubmitLogin(AuthSubmitLoginEvent event, Emitter<AuthState> emit) async {
    // Atualiza estado para loading
    final loadingLoginState = state.loginState.copyWith(
      isLoading: true,
      errorMessage: null,
    );
    emit(state.copyWith(loginState: loadingLoginState));

    try {
      // Valida campos
      final emailValidation = _validateEmail(event.email);
      final passwordValidation = _validatePassword(event.password);

      if (!emailValidation.isValid || !passwordValidation.isValid) {
        final errorLoginState = state.loginState.copyWith(
          isLoading: false,
          emailValidation: emailValidation,
          passwordValidation: passwordValidation,
          errorMessage: 'Por favor, corrija os campos inválidos',
        );
        emit(state.copyWith(loginState: errorLoginState));
        return;
      }

      // Tenta fazer login
      final loginResult = await _authService.login(
        email: event.email,
        password: event.password,
        rememberMe: event.rememberMe,
      );

      if (loginResult.success) {
        final successLoginState = state.loginState.copyWith(
          isLoading: false,
          errorMessage: null,
        );
        emit(state.copyWith(loginState: successLoginState));
      } else {
        final errorLoginState = state.loginState.copyWith(
          isLoading: false,
          errorMessage: loginResult.errorMessage,
        );
        emit(state.copyWith(loginState: errorLoginState));
      }
    } catch (e) {
      final errorLoginState = state.loginState.copyWith(
        isLoading: false,
        errorMessage: 'Erro inesperado: $e',
      );
      emit(state.copyWith(loginState: errorLoginState));
    }
  }

  /// Handler para logout
  void _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    await _authService.logout();
    emit(AuthState()); // Reset para estado inicial
  }

  /// Handler para alternar olhos do personagem
  void _onToggleEyes(AuthToggleEyesEvent event, Emitter<AuthState> emit) {
    emit(state.copyWith(eyesOpen: event.eyesOpen));
  }

  /// Valida email
  ValidationState _validateEmail(String email) {
    if (email.isEmpty) {
      return const ValidationState(
        isValid: false,
        errorMessage: 'E-mail é obrigatório',
      );
    }

    // Aceita email, username ou telefone para flexibilidade
    if (email.length < 3) {
      return const ValidationState(
        isValid: false,
        errorMessage: 'E-mail deve ter pelo menos 3 caracteres',
      );
    }

    return const ValidationState(isValid: true);
  }

  /// Valida senha
  ValidationState _validatePassword(String password) {
    if (password.isEmpty) {
      return const ValidationState(
        isValid: false,
        errorMessage: 'Senha é obrigatória',
      );
    }

    if (password.length < 6) {
      return const ValidationState(
        isValid: false,
        errorMessage: 'Senha deve ter pelo menos 6 caracteres',
      );
    }

    return const ValidationState(isValid: true);
  }
} 