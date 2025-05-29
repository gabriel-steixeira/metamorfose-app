import 'package:flutter/foundation.dart';
import 'validation_state.dart';

class RegisterState {
  final String username;
  final String phone;
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool isLoading;
  final String? errorMessage;
  final ValidationState? usernameValidation;
  final ValidationState? phoneValidation;
  final ValidationState? emailValidation;
  final ValidationState? passwordValidation;

  const RegisterState({
    this.username = '',
    this.phone = '',
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.errorMessage,
    this.usernameValidation,
    this.phoneValidation,
    this.emailValidation,
    this.passwordValidation,
  });

  RegisterState copyWith({
    String? username,
    String? phone,
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? isLoading,
    String? errorMessage,
    ValidationState? usernameValidation,
    ValidationState? phoneValidation,
    ValidationState? emailValidation,
    ValidationState? passwordValidation,
  }) {
    return RegisterState(
      username: username ?? this.username,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      usernameValidation: usernameValidation ?? this.usernameValidation,
      phoneValidation: phoneValidation ?? this.phoneValidation,
      emailValidation: emailValidation ?? this.emailValidation,
      passwordValidation: passwordValidation ?? this.passwordValidation,
    );
  }
} 