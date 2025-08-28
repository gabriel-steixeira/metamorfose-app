import 'package:freezed_annotation/freezed_annotation.dart';
import 'auth_state.dart';

part 'auth_events.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.toggleMode(AuthScreenMode mode) = AuthToggleModeEvent;
  const factory AuthEvent.toggleEyes(bool isVisible) = AuthToggleEyesEvent;
  const factory AuthEvent.updateLoginField({
    String? email,
    String? password,
    bool? rememberMe,
  }) = AuthUpdateLoginFieldEvent;
  const factory AuthEvent.submitLogin({
    required String email,
    required String password,
    required bool rememberMe,
  }) = AuthSubmitLoginEvent;
  const factory AuthEvent.signInWithGoogle() = AuthSignInWithGoogleEvent;
  const factory AuthEvent.signInWithFacebook() = AuthSignInWithFacebookEvent;
  const factory AuthEvent.submitRegister({
    required String email,
    required String password,
    required String username,
    required String phone,
    required String completeName,
    required String birthDate,
  }) = AuthSubmitRegisterEvent;
  const factory AuthEvent.updateRegisterField({
    String? email,
    String? password,
    String? username,
    String? phone,
    String? completeName,
    String? birthDate,
  }) = AuthUpdateRegisterFieldEvent;
  const factory AuthEvent.signOut() = AuthSignOutEvent;
  const factory AuthEvent.resetPassword({
    required String email,
  }) = AuthResetPasswordEvent;
  const factory AuthEvent.quickLogin() = AuthQuickLoginEvent;
}