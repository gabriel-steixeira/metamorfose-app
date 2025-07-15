import 'package:freezed_annotation/freezed_annotation.dart';
import '../../models/user_model.dart';
import 'login_state.dart';
import 'register_state.dart';

part 'auth_state.freezed.dart';

enum AuthScreenMode { login, register }

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthScreenMode.login) AuthScreenMode mode,
    @Default(false) bool eyesOpen,
    @Default(false) bool isLoading,
    UserModel? user,
    String? error,
    @Default(LoginState()) LoginState loginState,
    @Default(RegisterState()) RegisterState registerState,
  }) = _AuthState;
} 