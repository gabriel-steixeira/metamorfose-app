import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default('') String username,
    @Default('') String phone,
    @Default('') String email,
    @Default('') String password,
    @Default('') String usernameError,
    @Default('') String phoneError,
    @Default('') String emailError,
    @Default('') String passwordError,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _RegisterState;
} 