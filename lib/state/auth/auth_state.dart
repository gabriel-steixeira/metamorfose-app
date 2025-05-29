import 'package:flutter/foundation.dart';
import 'login_state.dart';
import 'register_state.dart';

enum AuthScreenMode {
  login,
  register,
}

class AuthState {
  final AuthScreenMode mode;
  final LoginState loginState;
  final RegisterState registerState;
  final bool eyesOpen;

  AuthState({
    this.mode = AuthScreenMode.login,
    this.loginState = const LoginState(),
    this.registerState = const RegisterState(),
    this.eyesOpen = true,
  });

  AuthState copyWith({
    AuthScreenMode? mode,
    LoginState? loginState,
    RegisterState? registerState,
    bool? eyesOpen,
  }) {
    return AuthState(
      mode: mode ?? this.mode,
      loginState: loginState ?? this.loginState,
      registerState: registerState ?? this.registerState,
      eyesOpen: eyesOpen ?? this.eyesOpen,
    );
  }
} 