import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default('') String email,
    @Default('') String password,
    @Default('') String emailError,
    @Default('') String passwordError,
    @Default(false) bool isLoading,
    @Default(false) bool rememberMe,
    String? errorMessage,
  }) = _LoginState;
} 