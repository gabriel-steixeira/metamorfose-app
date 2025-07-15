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

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../state/auth/auth_state.dart';
import '../state/auth/auth_events.dart';
import '../state/auth/login_state.dart';
import '../state/auth/register_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  StreamSubscription<User?>? _authStateSubscription;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(const AuthState()) {
    _setupAuthStateListener();

    on<AuthToggleModeEvent>((event, emit) {
      emit(state.copyWith(mode: event.mode));
    });

    on<AuthToggleEyesEvent>((event, emit) {
      emit(state.copyWith(eyesOpen: event.isVisible));
    });

    on<AuthUpdateLoginFieldEvent>((event, emit) {
      final currentLogin = state.loginState;
      emit(state.copyWith(
        loginState: LoginState(
          email: event.email ?? currentLogin.email,
          password: event.password ?? currentLogin.password,
          rememberMe: event.rememberMe ?? currentLogin.rememberMe,
          emailError: '',
          passwordError: '',
          errorMessage: null,
        ),
      ));
    });

    on<AuthSubmitLoginEvent>((event, emit) async {
      try {
        emit(state.copyWith(
          loginState: state.loginState.copyWith(isLoading: true, errorMessage: null),
        ));

        if (event.email.isEmpty) {
          emit(state.copyWith(
            loginState: state.loginState.copyWith(
              emailError: 'Email é obrigatório',
              isLoading: false,
            ),
          ));
          return;
        }

        if (event.password.isEmpty) {
          emit(state.copyWith(
            loginState: state.loginState.copyWith(
              passwordError: 'Senha é obrigatória',
              isLoading: false,
            ),
          ));
          return;
        }

        final user = await _authService.signInWithEmailAndPassword(
          event.email,
          event.password,
        );

        emit(state.copyWith(
          user: user,
          loginState: state.loginState.copyWith(isLoading: false),
        ));
      } catch (e) {
        emit(state.copyWith(
          loginState: state.loginState.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ));
      }
    });

    on<AuthSubmitRegisterEvent>((event, emit) async {
      try {
        emit(state.copyWith(
          registerState: state.registerState.copyWith(isLoading: true, errorMessage: null),
        ));

        // Basic validation
        if (event.username.isEmpty) {
          emit(state.copyWith(
              registerState: state.registerState
                  .copyWith(usernameError: 'Nome de usuário é obrigatório', isLoading: false)));
          return;
        }
        if (event.phone.isEmpty) {
          emit(state.copyWith(
              registerState:
                  state.registerState.copyWith(phoneError: 'Telefone é obrigatório', isLoading: false)));
          return;
        }
        if (event.email.isEmpty) {
          emit(state.copyWith(
              registerState:
                  state.registerState.copyWith(emailError: 'Email é obrigatório', isLoading: false)));
          return;
        }
        if (event.password.isEmpty) {
          emit(state.copyWith(
              registerState:
                  state.registerState.copyWith(passwordError: 'Senha é obrigatória', isLoading: false)));
          return;
        }

        final user = await _authService.registerWithEmailAndPassword(
          event.email,
          event.password,
          event.username,
          event.phone,
        );

        emit(state.copyWith(
          user: user,
          registerState: state.registerState.copyWith(isLoading: false),
        ));
      } catch (e) {
        emit(state.copyWith(
          registerState: state.registerState.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ));
      }
    });

    on<AuthSignInWithGoogleEvent>((event, emit) async {
      try {
        emit(state.copyWith(
          loginState: state.loginState.copyWith(isLoading: true, errorMessage: null),
        ));

        final user = await _authService.signInWithGoogle();
        emit(state.copyWith(
          user: user,
          loginState: state.loginState.copyWith(isLoading: false),
        ));
      } catch (e) {
        emit(state.copyWith(
          loginState: state.loginState.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ));
      }
    });

    on<AuthSignInWithFacebookEvent>((event, emit) async {
      try {
        emit(state.copyWith(
          loginState: state.loginState.copyWith(isLoading: true, errorMessage: null),
        ));

        final user = await _authService.signInWithFacebook();
        emit(state.copyWith(
          user: user,
          loginState: state.loginState.copyWith(isLoading: false),
        ));
      } catch (e) {
        emit(state.copyWith(
          loginState: state.loginState.copyWith(
            isLoading: false,
            errorMessage: e.toString(),
          ),
        ));
      }
    });
  }

  void _setupAuthStateListener() {
    _authStateSubscription?.cancel();
    _authStateSubscription = _authService.authStateChanges.listen(
      (user) async {
        if (user == null) {
          emit(state.copyWith(user: null));
        } else {
          try {
            final userModel = await _authService.getUserData(user.uid);
            emit(state.copyWith(user: userModel));
          } catch (e) {
            emit(state.copyWith(
              loginState: state.loginState.copyWith(
                errorMessage: e.toString(),
              ),
            ));
          }
        }
      },
    );
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
} 