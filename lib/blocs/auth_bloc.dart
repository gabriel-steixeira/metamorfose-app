/**
 * File: auth_bloc.dart
 * Description: BLoC para gerenciamento do estado de autenticação.
 *
 * Responsabilidades:
 * - Gerenciar login e logout do usuário
 * - Validar credenciais (Firebase + Local)
 * - Manter estado de autenticação
 * - Validar campos de entrada
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.2.0
 * Squad: Metamorfose
 */

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/hybrid_auth_service.dart';
import '../state/auth/auth_state.dart';
import '../state/auth/auth_events.dart';
import '../state/auth/login_state.dart';
import '../state/auth/register_state.dart';
import '../utils/auth_validators.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final HybridAuthService _authService;
  StreamSubscription<UserModel?>? _authStateSubscription;

  AuthBloc({required HybridAuthService authService})
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
      
      // Validar campos apenas se foram fornecidos
      String emailError = currentLogin.emailError;
      String passwordError = currentLogin.passwordError;
      
      if (event.email != null) {
        final validation = AuthValidators.validateEmail(event.email!);
        emailError = validation ?? '';
      }
      
      if (event.password != null) {
        final validation = AuthValidators.validatePassword(event.password!);
        passwordError = validation ?? '';
      }
      
      emit(state.copyWith(
        loginState: LoginState(
          email: event.email ?? currentLogin.email,
          password: event.password ?? currentLogin.password,
          rememberMe: event.rememberMe ?? currentLogin.rememberMe,
          emailError: emailError,
          passwordError: passwordError,
          errorMessage: currentLogin.errorMessage,
          isLoading: currentLogin.isLoading,
        ),
      ));
    });

    on<AuthSubmitLoginEvent>((event, emit) async {
      try {
        emit(state.copyWith(
          loginState: state.loginState.copyWith(isLoading: true, errorMessage: null),
        ));

        // Validar email
        final emailError = AuthValidators.validateEmail(event.email);
        if (emailError != null) {
          emit(state.copyWith(
            loginState: state.loginState.copyWith(
              emailError: emailError,
              isLoading: false,
            ),
          ));
          return;
        }

        // Validar senha
        final passwordError = AuthValidators.validatePassword(event.password);
        if (passwordError != null) {
          emit(state.copyWith(
            loginState: state.loginState.copyWith(
              passwordError: passwordError,
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
        String errorMessage = _getFirebaseErrorMessage(e);
        emit(state.copyWith(
          loginState: state.loginState.copyWith(
            isLoading: false,
            errorMessage: errorMessage,
          ),
        ));
      }
    });

    on<AuthSubmitRegisterEvent>((event, emit) async {
      try {
        emit(state.copyWith(
          registerState: state.registerState.copyWith(isLoading: true, errorMessage: null),
        ));

        // Validar todos os campos
        final emailError = AuthValidators.validateEmail(event.email);
        final passwordError = AuthValidators.validatePassword(event.password);
        final usernameError = AuthValidators.validateUsername(event.username);
        final phoneError = AuthValidators.validatePhone(event.phone);
        final completeNameError = AuthValidators.validateCompleteName(event.completeName);
        final birthDateError = AuthValidators.validateBirthDate(event.birthDate);
        
        if (emailError != null || passwordError != null || usernameError != null || phoneError != null || completeNameError != null || birthDateError != null) {
          emit(state.copyWith(
            registerState: state.registerState.copyWith(
              emailError: emailError ?? '',
              passwordError: passwordError ?? '',
              usernameError: usernameError ?? '',
              phoneError: phoneError ?? '',
              completeNameError: completeNameError ?? '',
              birthDateError: birthDateError ?? '',
              isLoading: false,
            ),
          ));
          return;
        }

        final user = await _authService.registerWithEmailAndPassword(
          event.email,
          event.password,
          event.username,
          AuthValidators.cleanPhone(event.phone), // Limpa formatação do telefone
          event.completeName,
          event.birthDate,
        );

        emit(state.copyWith(
          user: user,
          registerState: state.registerState.copyWith(isLoading: false),
        ));
      } catch (e) {
        String errorMessage = _getFirebaseErrorMessage(e);
        emit(state.copyWith(
          registerState: state.registerState.copyWith(
            isLoading: false,
            errorMessage: errorMessage,
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
        String errorMessage = _getFirebaseErrorMessage(e);
        emit(state.copyWith(
          loginState: state.loginState.copyWith(
            isLoading: false,
            errorMessage: errorMessage,
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
        String errorMessage = _getFirebaseErrorMessage(e);
        emit(state.copyWith(
          loginState: state.loginState.copyWith(
            isLoading: false,
            errorMessage: errorMessage,
          ),
        ));
      }
    });

    on<AuthSignOutEvent>((event, emit) async {
      try {
        await _authService.signOut();
        emit(state.copyWith(user: null));
      } catch (e) {
        // Ignora erros no logout
        emit(state.copyWith(user: null));
      }
    });

    on<AuthUpdateRegisterFieldEvent>((event, emit) {
      final currentRegister = state.registerState;
      
      // Validar campos apenas se foram fornecidos
      String emailError = currentRegister.emailError;
      String passwordError = currentRegister.passwordError;
      String usernameError = currentRegister.usernameError;
      String phoneError = currentRegister.phoneError;
      String completeNameError = currentRegister.completeNameError;
      String birthDateError = currentRegister.birthDateError;
      
      if (event.email != null) {
        final validation = AuthValidators.validateEmail(event.email!);
        emailError = validation ?? '';
      }
      
      if (event.password != null) {
        final validation = AuthValidators.validatePassword(event.password!);
        passwordError = validation ?? '';
      }
      
      if (event.username != null) {
        final validation = AuthValidators.validateUsername(event.username!);
        usernameError = validation ?? '';
      }
      
      if (event.phone != null) {
        final validation = AuthValidators.validatePhone(event.phone!);
        phoneError = validation ?? '';
      }
      
      if (event.completeName != null) {
        final validation = AuthValidators.validateCompleteName(event.completeName!);
        completeNameError = validation ?? '';
      }
      
      if (event.birthDate != null) {
        final validation = AuthValidators.validateBirthDate(event.birthDate!);
        birthDateError = validation ?? '';
      }
      
      emit(state.copyWith(
        registerState: RegisterState(
          email: event.email ?? currentRegister.email,
          password: event.password ?? currentRegister.password,
          username: event.username ?? currentRegister.username,
          phone: event.phone ?? currentRegister.phone,
          completeName: event.completeName ?? currentRegister.completeName,
          birthDate: event.birthDate ?? currentRegister.birthDate,
          emailError: emailError,
          passwordError: passwordError,
          usernameError: usernameError,
          phoneError: phoneError,
          completeNameError: completeNameError,
          birthDateError: birthDateError,
          isLoading: currentRegister.isLoading,
          errorMessage: currentRegister.errorMessage,
        ),
      ));
    });

    on<AuthResetPasswordEvent>((event, emit) async {
      try {
        await _authService.resetPassword(event.email);
        // Pode emitir um estado de sucesso se necessário
      } catch (e) {
        // Pode emitir um estado de erro se necessário
      }
    });
  }

  void _setupAuthStateListener() {
    _authStateSubscription = _authService.authStateChanges.listen((user) {
      if (user != null) {
        emit(state.copyWith(user: user));
      } else {
        emit(state.copyWith(user: null));
      }
    });
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }

  /// Converte erros do Firebase em mensagens amigáveis ao usuário
  String _getFirebaseErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'Usuário não encontrado. Verifique o email digitado.';
        case 'wrong-password':
          return 'Senha incorreta. Tente novamente.';
        case 'email-already-in-use':
          return 'Este email já está sendo usado por outra conta.';
        case 'weak-password':
          return 'A senha é muito fraca. Use pelo menos 6 caracteres.';
        case 'invalid-email':
          return 'Email inválido. Verifique o formato digitado.';
        case 'user-disabled':
          return 'Esta conta foi desabilitada. Entre em contato com o suporte.';
        case 'too-many-requests':
          return 'Muitas tentativas de login. Tente novamente mais tarde.';
        case 'operation-not-allowed':
          return 'Operação não permitida. Entre em contato com o suporte.';
        case 'invalid-credential':
          return 'Credenciais inválidas. Verifique email e senha.';
        case 'network-request-failed':
          return 'Erro de conexão. Verifique sua internet e tente novamente.';
        case 'requires-recent-login':
          return 'Por segurança, faça login novamente para continuar.';
        default:
          return 'Erro de autenticação: ${error.message ?? 'Erro desconhecido'}';
      }
    }
    
    // Para outros tipos de erro
    String errorString = error.toString();
    
    // Verifica se é erro de credenciais padrão (do serviço local)
    if (errorString.contains('Use: ')) {
      return errorString;
    }
    
    // Erro genérico
    return 'Erro inesperado. Tente novamente.';
  }
}