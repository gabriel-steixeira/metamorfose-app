import 'package:flutter/foundation.dart';
import 'validation_state.dart';

class LoginState {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool rememberMe;
  final bool isLoading;
  final String? errorMessage;
  final ValidationState? emailValidation;
  final ValidationState? passwordValidation;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.rememberMe = false,
    this.isLoading = false,
    this.errorMessage,
    this.emailValidation,
    this.passwordValidation,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? rememberMe,
    bool? isLoading,
    String? errorMessage,
    ValidationState? emailValidation,
    ValidationState? passwordValidation,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      emailValidation: emailValidation ?? this.emailValidation,
      passwordValidation: passwordValidation ?? this.passwordValidation,
    );
  }
} 