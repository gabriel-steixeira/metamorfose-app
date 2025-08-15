// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthScreenMode mode) toggleMode,
    required TResult Function(bool isVisible) toggleEyes,
    required TResult Function(String? email, String? password, bool? rememberMe)
        updateLoginField,
    required TResult Function(String email, String password, bool rememberMe)
        submitLogin,
    required TResult Function() signInWithGoogle,
    required TResult Function() signInWithFacebook,
    required TResult Function(
            String email, String password, String username, String phone)
        submitRegister,
    required TResult Function(
            String? email, String? password, String? username, String? phone)
        updateRegisterField,
    required TResult Function() signOut,
    required TResult Function(String email) resetPassword,
    required TResult Function() quickLogin,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthScreenMode mode)? toggleMode,
    TResult? Function(bool isVisible)? toggleEyes,
    TResult? Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult? Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signInWithFacebook,
    TResult? Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult? Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult? Function()? signOut,
    TResult? Function(String email)? resetPassword,
    TResult? Function()? quickLogin,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthScreenMode mode)? toggleMode,
    TResult Function(bool isVisible)? toggleEyes,
    TResult Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult Function()? signInWithGoogle,
    TResult Function()? signInWithFacebook,
    TResult Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult Function()? signOut,
    TResult Function(String email)? resetPassword,
    TResult Function()? quickLogin,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthToggleModeEvent value) toggleMode,
    required TResult Function(AuthToggleEyesEvent value) toggleEyes,
    required TResult Function(AuthUpdateLoginFieldEvent value) updateLoginField,
    required TResult Function(AuthSubmitLoginEvent value) submitLogin,
    required TResult Function(AuthSignInWithGoogleEvent value) signInWithGoogle,
    required TResult Function(AuthSignInWithFacebookEvent value)
        signInWithFacebook,
    required TResult Function(AuthSubmitRegisterEvent value) submitRegister,
    required TResult Function(AuthUpdateRegisterFieldEvent value)
        updateRegisterField,
    required TResult Function(AuthSignOutEvent value) signOut,
    required TResult Function(AuthResetPasswordEvent value) resetPassword,
    required TResult Function(AuthQuickLoginEvent value) quickLogin,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthToggleModeEvent value)? toggleMode,
    TResult? Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult? Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult? Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult? Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult? Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult? Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult? Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult? Function(AuthSignOutEvent value)? signOut,
    TResult? Function(AuthResetPasswordEvent value)? resetPassword,
    TResult? Function(AuthQuickLoginEvent value)? quickLogin,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthToggleModeEvent value)? toggleMode,
    TResult Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult Function(AuthSignOutEvent value)? signOut,
    TResult Function(AuthResetPasswordEvent value)? resetPassword,
    TResult Function(AuthQuickLoginEvent value)? quickLogin,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthEventCopyWith<$Res> {
  factory $AuthEventCopyWith(AuthEvent value, $Res Function(AuthEvent) then) =
      _$AuthEventCopyWithImpl<$Res, AuthEvent>;
}

/// @nodoc
class _$AuthEventCopyWithImpl<$Res, $Val extends AuthEvent>
    implements $AuthEventCopyWith<$Res> {
  _$AuthEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AuthToggleModeEventImplCopyWith<$Res> {
  factory _$$AuthToggleModeEventImplCopyWith(_$AuthToggleModeEventImpl value,
          $Res Function(_$AuthToggleModeEventImpl) then) =
      __$$AuthToggleModeEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AuthScreenMode mode});
}

/// @nodoc
class __$$AuthToggleModeEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthToggleModeEventImpl>
    implements _$$AuthToggleModeEventImplCopyWith<$Res> {
  __$$AuthToggleModeEventImplCopyWithImpl(_$AuthToggleModeEventImpl _value,
      $Res Function(_$AuthToggleModeEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
  }) {
    return _then(_$AuthToggleModeEventImpl(
      null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as AuthScreenMode,
    ));
  }
}

/// @nodoc

class _$AuthToggleModeEventImpl implements AuthToggleModeEvent {
  const _$AuthToggleModeEventImpl(this.mode);

  @override
  final AuthScreenMode mode;

  @override
  String toString() {
    return 'AuthEvent.toggleMode(mode: $mode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthToggleModeEventImpl &&
            (identical(other.mode, mode) || other.mode == mode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthToggleModeEventImplCopyWith<_$AuthToggleModeEventImpl> get copyWith =>
      __$$AuthToggleModeEventImplCopyWithImpl<_$AuthToggleModeEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthScreenMode mode) toggleMode,
    required TResult Function(bool isVisible) toggleEyes,
    required TResult Function(String? email, String? password, bool? rememberMe)
        updateLoginField,
    required TResult Function(String email, String password, bool rememberMe)
        submitLogin,
    required TResult Function() signInWithGoogle,
    required TResult Function() signInWithFacebook,
    required TResult Function(
            String email, String password, String username, String phone)
        submitRegister,
    required TResult Function(
            String? email, String? password, String? username, String? phone)
        updateRegisterField,
    required TResult Function() signOut,
    required TResult Function(String email) resetPassword,
    required TResult Function() quickLogin,
  }) {
    return toggleMode(mode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthScreenMode mode)? toggleMode,
    TResult? Function(bool isVisible)? toggleEyes,
    TResult? Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult? Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signInWithFacebook,
    TResult? Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult? Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult? Function()? signOut,
    TResult? Function(String email)? resetPassword,
    TResult? Function()? quickLogin,
  }) {
    return toggleMode?.call(mode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthScreenMode mode)? toggleMode,
    TResult Function(bool isVisible)? toggleEyes,
    TResult Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult Function()? signInWithGoogle,
    TResult Function()? signInWithFacebook,
    TResult Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult Function()? signOut,
    TResult Function(String email)? resetPassword,
    TResult Function()? quickLogin,
    required TResult orElse(),
  }) {
    if (toggleMode != null) {
      return toggleMode(mode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthToggleModeEvent value) toggleMode,
    required TResult Function(AuthToggleEyesEvent value) toggleEyes,
    required TResult Function(AuthUpdateLoginFieldEvent value) updateLoginField,
    required TResult Function(AuthSubmitLoginEvent value) submitLogin,
    required TResult Function(AuthSignInWithGoogleEvent value) signInWithGoogle,
    required TResult Function(AuthSignInWithFacebookEvent value)
        signInWithFacebook,
    required TResult Function(AuthSubmitRegisterEvent value) submitRegister,
    required TResult Function(AuthUpdateRegisterFieldEvent value)
        updateRegisterField,
    required TResult Function(AuthSignOutEvent value) signOut,
    required TResult Function(AuthResetPasswordEvent value) resetPassword,
    required TResult Function(AuthQuickLoginEvent value) quickLogin,
  }) {
    return toggleMode(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthToggleModeEvent value)? toggleMode,
    TResult? Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult? Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult? Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult? Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult? Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult? Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult? Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult? Function(AuthSignOutEvent value)? signOut,
    TResult? Function(AuthResetPasswordEvent value)? resetPassword,
    TResult? Function(AuthQuickLoginEvent value)? quickLogin,
  }) {
    return toggleMode?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthToggleModeEvent value)? toggleMode,
    TResult Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult Function(AuthSignOutEvent value)? signOut,
    TResult Function(AuthResetPasswordEvent value)? resetPassword,
    TResult Function(AuthQuickLoginEvent value)? quickLogin,
    required TResult orElse(),
  }) {
    if (toggleMode != null) {
      return toggleMode(this);
    }
    return orElse();
  }
}

abstract class AuthToggleModeEvent implements AuthEvent {
  const factory AuthToggleModeEvent(final AuthScreenMode mode) =
      _$AuthToggleModeEventImpl;

  AuthScreenMode get mode;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthToggleModeEventImplCopyWith<_$AuthToggleModeEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthToggleEyesEventImplCopyWith<$Res> {
  factory _$$AuthToggleEyesEventImplCopyWith(_$AuthToggleEyesEventImpl value,
          $Res Function(_$AuthToggleEyesEventImpl) then) =
      __$$AuthToggleEyesEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isVisible});
}

/// @nodoc
class __$$AuthToggleEyesEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthToggleEyesEventImpl>
    implements _$$AuthToggleEyesEventImplCopyWith<$Res> {
  __$$AuthToggleEyesEventImplCopyWithImpl(_$AuthToggleEyesEventImpl _value,
      $Res Function(_$AuthToggleEyesEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isVisible = null,
  }) {
    return _then(_$AuthToggleEyesEventImpl(
      null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AuthToggleEyesEventImpl implements AuthToggleEyesEvent {
  const _$AuthToggleEyesEventImpl(this.isVisible);

  @override
  final bool isVisible;

  @override
  String toString() {
    return 'AuthEvent.toggleEyes(isVisible: $isVisible)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthToggleEyesEventImpl &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isVisible);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthToggleEyesEventImplCopyWith<_$AuthToggleEyesEventImpl> get copyWith =>
      __$$AuthToggleEyesEventImplCopyWithImpl<_$AuthToggleEyesEventImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthScreenMode mode) toggleMode,
    required TResult Function(bool isVisible) toggleEyes,
    required TResult Function(String? email, String? password, bool? rememberMe)
        updateLoginField,
    required TResult Function(String email, String password, bool rememberMe)
        submitLogin,
    required TResult Function() signInWithGoogle,
    required TResult Function() signInWithFacebook,
    required TResult Function(
            String email, String password, String username, String phone)
        submitRegister,
    required TResult Function(
            String? email, String? password, String? username, String? phone)
        updateRegisterField,
    required TResult Function() signOut,
    required TResult Function(String email) resetPassword,
    required TResult Function() quickLogin,
  }) {
    return toggleEyes(isVisible);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthScreenMode mode)? toggleMode,
    TResult? Function(bool isVisible)? toggleEyes,
    TResult? Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult? Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signInWithFacebook,
    TResult? Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult? Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult? Function()? signOut,
    TResult? Function(String email)? resetPassword,
    TResult? Function()? quickLogin,
  }) {
    return toggleEyes?.call(isVisible);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthScreenMode mode)? toggleMode,
    TResult Function(bool isVisible)? toggleEyes,
    TResult Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult Function()? signInWithGoogle,
    TResult Function()? signInWithFacebook,
    TResult Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult Function()? signOut,
    TResult Function(String email)? resetPassword,
    TResult Function()? quickLogin,
    required TResult orElse(),
  }) {
    if (toggleEyes != null) {
      return toggleEyes(isVisible);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthToggleModeEvent value) toggleMode,
    required TResult Function(AuthToggleEyesEvent value) toggleEyes,
    required TResult Function(AuthUpdateLoginFieldEvent value) updateLoginField,
    required TResult Function(AuthSubmitLoginEvent value) submitLogin,
    required TResult Function(AuthSignInWithGoogleEvent value) signInWithGoogle,
    required TResult Function(AuthSignInWithFacebookEvent value)
        signInWithFacebook,
    required TResult Function(AuthSubmitRegisterEvent value) submitRegister,
    required TResult Function(AuthUpdateRegisterFieldEvent value)
        updateRegisterField,
    required TResult Function(AuthSignOutEvent value) signOut,
    required TResult Function(AuthResetPasswordEvent value) resetPassword,
    required TResult Function(AuthQuickLoginEvent value) quickLogin,
  }) {
    return toggleEyes(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthToggleModeEvent value)? toggleMode,
    TResult? Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult? Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult? Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult? Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult? Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult? Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult? Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult? Function(AuthSignOutEvent value)? signOut,
    TResult? Function(AuthResetPasswordEvent value)? resetPassword,
    TResult? Function(AuthQuickLoginEvent value)? quickLogin,
  }) {
    return toggleEyes?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthToggleModeEvent value)? toggleMode,
    TResult Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult Function(AuthSignOutEvent value)? signOut,
    TResult Function(AuthResetPasswordEvent value)? resetPassword,
    TResult Function(AuthQuickLoginEvent value)? quickLogin,
    required TResult orElse(),
  }) {
    if (toggleEyes != null) {
      return toggleEyes(this);
    }
    return orElse();
  }
}

abstract class AuthToggleEyesEvent implements AuthEvent {
  const factory AuthToggleEyesEvent(final bool isVisible) =
      _$AuthToggleEyesEventImpl;

  bool get isVisible;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthToggleEyesEventImplCopyWith<_$AuthToggleEyesEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthUpdateLoginFieldEventImplCopyWith<$Res> {
  factory _$$AuthUpdateLoginFieldEventImplCopyWith(
          _$AuthUpdateLoginFieldEventImpl value,
          $Res Function(_$AuthUpdateLoginFieldEventImpl) then) =
      __$$AuthUpdateLoginFieldEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? email, String? password, bool? rememberMe});
}

/// @nodoc
class __$$AuthUpdateLoginFieldEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthUpdateLoginFieldEventImpl>
    implements _$$AuthUpdateLoginFieldEventImplCopyWith<$Res> {
  __$$AuthUpdateLoginFieldEventImplCopyWithImpl(
      _$AuthUpdateLoginFieldEventImpl _value,
      $Res Function(_$AuthUpdateLoginFieldEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? password = freezed,
    Object? rememberMe = freezed,
  }) {
    return _then(_$AuthUpdateLoginFieldEventImpl(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      rememberMe: freezed == rememberMe
          ? _value.rememberMe
          : rememberMe // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$AuthUpdateLoginFieldEventImpl implements AuthUpdateLoginFieldEvent {
  const _$AuthUpdateLoginFieldEventImpl(
      {this.email, this.password, this.rememberMe});

  @override
  final String? email;
  @override
  final String? password;
  @override
  final bool? rememberMe;

  @override
  String toString() {
    return 'AuthEvent.updateLoginField(email: $email, password: $password, rememberMe: $rememberMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUpdateLoginFieldEventImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.rememberMe, rememberMe) ||
                other.rememberMe == rememberMe));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password, rememberMe);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUpdateLoginFieldEventImplCopyWith<_$AuthUpdateLoginFieldEventImpl>
      get copyWith => __$$AuthUpdateLoginFieldEventImplCopyWithImpl<
          _$AuthUpdateLoginFieldEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthScreenMode mode) toggleMode,
    required TResult Function(bool isVisible) toggleEyes,
    required TResult Function(String? email, String? password, bool? rememberMe)
        updateLoginField,
    required TResult Function(String email, String password, bool rememberMe)
        submitLogin,
    required TResult Function() signInWithGoogle,
    required TResult Function() signInWithFacebook,
    required TResult Function(
            String email, String password, String username, String phone)
        submitRegister,
    required TResult Function(
            String? email, String? password, String? username, String? phone)
        updateRegisterField,
    required TResult Function() signOut,
    required TResult Function(String email) resetPassword,
    required TResult Function() quickLogin,
  }) {
    return updateLoginField(email, password, rememberMe);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthScreenMode mode)? toggleMode,
    TResult? Function(bool isVisible)? toggleEyes,
    TResult? Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult? Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signInWithFacebook,
    TResult? Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult? Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult? Function()? signOut,
    TResult? Function(String email)? resetPassword,
    TResult? Function()? quickLogin,
  }) {
    return updateLoginField?.call(email, password, rememberMe);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthScreenMode mode)? toggleMode,
    TResult Function(bool isVisible)? toggleEyes,
    TResult Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult Function()? signInWithGoogle,
    TResult Function()? signInWithFacebook,
    TResult Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult Function()? signOut,
    TResult Function(String email)? resetPassword,
    TResult Function()? quickLogin,
    required TResult orElse(),
  }) {
    if (updateLoginField != null) {
      return updateLoginField(email, password, rememberMe);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthToggleModeEvent value) toggleMode,
    required TResult Function(AuthToggleEyesEvent value) toggleEyes,
    required TResult Function(AuthUpdateLoginFieldEvent value) updateLoginField,
    required TResult Function(AuthSubmitLoginEvent value) submitLogin,
    required TResult Function(AuthSignInWithGoogleEvent value) signInWithGoogle,
    required TResult Function(AuthSignInWithFacebookEvent value)
        signInWithFacebook,
    required TResult Function(AuthSubmitRegisterEvent value) submitRegister,
    required TResult Function(AuthUpdateRegisterFieldEvent value)
        updateRegisterField,
    required TResult Function(AuthSignOutEvent value) signOut,
    required TResult Function(AuthResetPasswordEvent value) resetPassword,
    required TResult Function(AuthQuickLoginEvent value) quickLogin,
  }) {
    return updateLoginField(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthToggleModeEvent value)? toggleMode,
    TResult? Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult? Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult? Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult? Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult? Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult? Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult? Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult? Function(AuthSignOutEvent value)? signOut,
    TResult? Function(AuthResetPasswordEvent value)? resetPassword,
    TResult? Function(AuthQuickLoginEvent value)? quickLogin,
  }) {
    return updateLoginField?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthToggleModeEvent value)? toggleMode,
    TResult Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult Function(AuthSignOutEvent value)? signOut,
    TResult Function(AuthResetPasswordEvent value)? resetPassword,
    TResult Function(AuthQuickLoginEvent value)? quickLogin,
    required TResult orElse(),
  }) {
    if (updateLoginField != null) {
      return updateLoginField(this);
    }
    return orElse();
  }
}

abstract class AuthUpdateLoginFieldEvent implements AuthEvent {
  const factory AuthUpdateLoginFieldEvent(
      {final String? email,
      final String? password,
      final bool? rememberMe}) = _$AuthUpdateLoginFieldEventImpl;

  String? get email;
  String? get password;
  bool? get rememberMe;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUpdateLoginFieldEventImplCopyWith<_$AuthUpdateLoginFieldEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthSubmitLoginEventImplCopyWith<$Res> {
  factory _$$AuthSubmitLoginEventImplCopyWith(_$AuthSubmitLoginEventImpl value,
          $Res Function(_$AuthSubmitLoginEventImpl) then) =
      __$$AuthSubmitLoginEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String password, bool rememberMe});
}

/// @nodoc
class __$$AuthSubmitLoginEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthSubmitLoginEventImpl>
    implements _$$AuthSubmitLoginEventImplCopyWith<$Res> {
  __$$AuthSubmitLoginEventImplCopyWithImpl(_$AuthSubmitLoginEventImpl _value,
      $Res Function(_$AuthSubmitLoginEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? rememberMe = null,
  }) {
    return _then(_$AuthSubmitLoginEventImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      rememberMe: null == rememberMe
          ? _value.rememberMe
          : rememberMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AuthSubmitLoginEventImpl implements AuthSubmitLoginEvent {
  const _$AuthSubmitLoginEventImpl(
      {required this.email, required this.password, required this.rememberMe});

  @override
  final String email;
  @override
  final String password;
  @override
  final bool rememberMe;

  @override
  String toString() {
    return 'AuthEvent.submitLogin(email: $email, password: $password, rememberMe: $rememberMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSubmitLoginEventImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.rememberMe, rememberMe) ||
                other.rememberMe == rememberMe));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password, rememberMe);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthSubmitLoginEventImplCopyWith<_$AuthSubmitLoginEventImpl>
      get copyWith =>
          __$$AuthSubmitLoginEventImplCopyWithImpl<_$AuthSubmitLoginEventImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthScreenMode mode) toggleMode,
    required TResult Function(bool isVisible) toggleEyes,
    required TResult Function(String? email, String? password, bool? rememberMe)
        updateLoginField,
    required TResult Function(String email, String password, bool rememberMe)
        submitLogin,
    required TResult Function() signInWithGoogle,
    required TResult Function() signInWithFacebook,
    required TResult Function(
            String email, String password, String username, String phone)
        submitRegister,
    required TResult Function(
            String? email, String? password, String? username, String? phone)
        updateRegisterField,
    required TResult Function() signOut,
    required TResult Function(String email) resetPassword,
    required TResult Function() quickLogin,
  }) {
    return submitLogin(email, password, rememberMe);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthScreenMode mode)? toggleMode,
    TResult? Function(bool isVisible)? toggleEyes,
    TResult? Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult? Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signInWithFacebook,
    TResult? Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult? Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult? Function()? signOut,
    TResult? Function(String email)? resetPassword,
    TResult? Function()? quickLogin,
  }) {
    return submitLogin?.call(email, password, rememberMe);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthScreenMode mode)? toggleMode,
    TResult Function(bool isVisible)? toggleEyes,
    TResult Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult Function()? signInWithGoogle,
    TResult Function()? signInWithFacebook,
    TResult Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult Function()? signOut,
    TResult Function(String email)? resetPassword,
    TResult Function()? quickLogin,
    required TResult orElse(),
  }) {
    if (submitLogin != null) {
      return submitLogin(email, password, rememberMe);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthToggleModeEvent value) toggleMode,
    required TResult Function(AuthToggleEyesEvent value) toggleEyes,
    required TResult Function(AuthUpdateLoginFieldEvent value) updateLoginField,
    required TResult Function(AuthSubmitLoginEvent value) submitLogin,
    required TResult Function(AuthSignInWithGoogleEvent value) signInWithGoogle,
    required TResult Function(AuthSignInWithFacebookEvent value)
        signInWithFacebook,
    required TResult Function(AuthSubmitRegisterEvent value) submitRegister,
    required TResult Function(AuthUpdateRegisterFieldEvent value)
        updateRegisterField,
    required TResult Function(AuthSignOutEvent value) signOut,
    required TResult Function(AuthResetPasswordEvent value) resetPassword,
    required TResult Function(AuthQuickLoginEvent value) quickLogin,
  }) {
    return submitLogin(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthToggleModeEvent value)? toggleMode,
    TResult? Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult? Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult? Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult? Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult? Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult? Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult? Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult? Function(AuthSignOutEvent value)? signOut,
    TResult? Function(AuthResetPasswordEvent value)? resetPassword,
    TResult? Function(AuthQuickLoginEvent value)? quickLogin,
  }) {
    return submitLogin?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthToggleModeEvent value)? toggleMode,
    TResult Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult Function(AuthSignOutEvent value)? signOut,
    TResult Function(AuthResetPasswordEvent value)? resetPassword,
    TResult Function(AuthQuickLoginEvent value)? quickLogin,
    required TResult orElse(),
  }) {
    if (submitLogin != null) {
      return submitLogin(this);
    }
    return orElse();
  }
}

abstract class AuthSubmitLoginEvent implements AuthEvent {
  const factory AuthSubmitLoginEvent(
      {required final String email,
      required final String password,
      required final bool rememberMe}) = _$AuthSubmitLoginEventImpl;

  String get email;
  String get password;
  bool get rememberMe;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthSubmitLoginEventImplCopyWith<_$AuthSubmitLoginEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthSignInWithGoogleEventImplCopyWith<$Res> {
  factory _$$AuthSignInWithGoogleEventImplCopyWith(
          _$AuthSignInWithGoogleEventImpl value,
          $Res Function(_$AuthSignInWithGoogleEventImpl) then) =
      __$$AuthSignInWithGoogleEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthSignInWithGoogleEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthSignInWithGoogleEventImpl>
    implements _$$AuthSignInWithGoogleEventImplCopyWith<$Res> {
  __$$AuthSignInWithGoogleEventImplCopyWithImpl(
      _$AuthSignInWithGoogleEventImpl _value,
      $Res Function(_$AuthSignInWithGoogleEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthSignInWithGoogleEventImpl implements AuthSignInWithGoogleEvent {
  const _$AuthSignInWithGoogleEventImpl();

  @override
  String toString() {
    return 'AuthEvent.signInWithGoogle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSignInWithGoogleEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthScreenMode mode) toggleMode,
    required TResult Function(bool isVisible) toggleEyes,
    required TResult Function(String? email, String? password, bool? rememberMe)
        updateLoginField,
    required TResult Function(String email, String password, bool rememberMe)
        submitLogin,
    required TResult Function() signInWithGoogle,
    required TResult Function() signInWithFacebook,
    required TResult Function(
            String email, String password, String username, String phone)
        submitRegister,
    required TResult Function(
            String? email, String? password, String? username, String? phone)
        updateRegisterField,
    required TResult Function() signOut,
    required TResult Function(String email) resetPassword,
    required TResult Function() quickLogin,
  }) {
    return signInWithGoogle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthScreenMode mode)? toggleMode,
    TResult? Function(bool isVisible)? toggleEyes,
    TResult? Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult? Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signInWithFacebook,
    TResult? Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult? Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult? Function()? signOut,
    TResult? Function(String email)? resetPassword,
    TResult? Function()? quickLogin,
  }) {
    return signInWithGoogle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthScreenMode mode)? toggleMode,
    TResult Function(bool isVisible)? toggleEyes,
    TResult Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult Function()? signInWithGoogle,
    TResult Function()? signInWithFacebook,
    TResult Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult Function()? signOut,
    TResult Function(String email)? resetPassword,
    TResult Function()? quickLogin,
    required TResult orElse(),
  }) {
    if (signInWithGoogle != null) {
      return signInWithGoogle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthToggleModeEvent value) toggleMode,
    required TResult Function(AuthToggleEyesEvent value) toggleEyes,
    required TResult Function(AuthUpdateLoginFieldEvent value) updateLoginField,
    required TResult Function(AuthSubmitLoginEvent value) submitLogin,
    required TResult Function(AuthSignInWithGoogleEvent value) signInWithGoogle,
    required TResult Function(AuthSignInWithFacebookEvent value)
        signInWithFacebook,
    required TResult Function(AuthSubmitRegisterEvent value) submitRegister,
    required TResult Function(AuthUpdateRegisterFieldEvent value)
        updateRegisterField,
    required TResult Function(AuthSignOutEvent value) signOut,
    required TResult Function(AuthResetPasswordEvent value) resetPassword,
    required TResult Function(AuthQuickLoginEvent value) quickLogin,
  }) {
    return signInWithGoogle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthToggleModeEvent value)? toggleMode,
    TResult? Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult? Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult? Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult? Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult? Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult? Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult? Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult? Function(AuthSignOutEvent value)? signOut,
    TResult? Function(AuthResetPasswordEvent value)? resetPassword,
    TResult? Function(AuthQuickLoginEvent value)? quickLogin,
  }) {
    return signInWithGoogle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthToggleModeEvent value)? toggleMode,
    TResult Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult Function(AuthSignOutEvent value)? signOut,
    TResult Function(AuthResetPasswordEvent value)? resetPassword,
    TResult Function(AuthQuickLoginEvent value)? quickLogin,
    required TResult orElse(),
  }) {
    if (signInWithGoogle != null) {
      return signInWithGoogle(this);
    }
    return orElse();
  }
}

abstract class AuthSignInWithGoogleEvent implements AuthEvent {
  const factory AuthSignInWithGoogleEvent() = _$AuthSignInWithGoogleEventImpl;
}

/// @nodoc
abstract class _$$AuthSignInWithFacebookEventImplCopyWith<$Res> {
  factory _$$AuthSignInWithFacebookEventImplCopyWith(
          _$AuthSignInWithFacebookEventImpl value,
          $Res Function(_$AuthSignInWithFacebookEventImpl) then) =
      __$$AuthSignInWithFacebookEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthSignInWithFacebookEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthSignInWithFacebookEventImpl>
    implements _$$AuthSignInWithFacebookEventImplCopyWith<$Res> {
  __$$AuthSignInWithFacebookEventImplCopyWithImpl(
      _$AuthSignInWithFacebookEventImpl _value,
      $Res Function(_$AuthSignInWithFacebookEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthSignInWithFacebookEventImpl implements AuthSignInWithFacebookEvent {
  const _$AuthSignInWithFacebookEventImpl();

  @override
  String toString() {
    return 'AuthEvent.signInWithFacebook()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSignInWithFacebookEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthScreenMode mode) toggleMode,
    required TResult Function(bool isVisible) toggleEyes,
    required TResult Function(String? email, String? password, bool? rememberMe)
        updateLoginField,
    required TResult Function(String email, String password, bool rememberMe)
        submitLogin,
    required TResult Function() signInWithGoogle,
    required TResult Function() signInWithFacebook,
    required TResult Function(
            String email, String password, String username, String phone)
        submitRegister,
    required TResult Function(
            String? email, String? password, String? username, String? phone)
        updateRegisterField,
    required TResult Function() signOut,
    required TResult Function(String email) resetPassword,
    required TResult Function() quickLogin,
  }) {
    return signInWithFacebook();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthScreenMode mode)? toggleMode,
    TResult? Function(bool isVisible)? toggleEyes,
    TResult? Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult? Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signInWithFacebook,
    TResult? Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult? Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult? Function()? signOut,
    TResult? Function(String email)? resetPassword,
    TResult? Function()? quickLogin,
  }) {
    return signInWithFacebook?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthScreenMode mode)? toggleMode,
    TResult Function(bool isVisible)? toggleEyes,
    TResult Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult Function()? signInWithGoogle,
    TResult Function()? signInWithFacebook,
    TResult Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult Function()? signOut,
    TResult Function(String email)? resetPassword,
    TResult Function()? quickLogin,
    required TResult orElse(),
  }) {
    if (signInWithFacebook != null) {
      return signInWithFacebook();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthToggleModeEvent value) toggleMode,
    required TResult Function(AuthToggleEyesEvent value) toggleEyes,
    required TResult Function(AuthUpdateLoginFieldEvent value) updateLoginField,
    required TResult Function(AuthSubmitLoginEvent value) submitLogin,
    required TResult Function(AuthSignInWithGoogleEvent value) signInWithGoogle,
    required TResult Function(AuthSignInWithFacebookEvent value)
        signInWithFacebook,
    required TResult Function(AuthSubmitRegisterEvent value) submitRegister,
    required TResult Function(AuthUpdateRegisterFieldEvent value)
        updateRegisterField,
    required TResult Function(AuthSignOutEvent value) signOut,
    required TResult Function(AuthResetPasswordEvent value) resetPassword,
    required TResult Function(AuthQuickLoginEvent value) quickLogin,
  }) {
    return signInWithFacebook(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthToggleModeEvent value)? toggleMode,
    TResult? Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult? Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult? Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult? Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult? Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult? Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult? Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult? Function(AuthSignOutEvent value)? signOut,
    TResult? Function(AuthResetPasswordEvent value)? resetPassword,
    TResult? Function(AuthQuickLoginEvent value)? quickLogin,
  }) {
    return signInWithFacebook?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthToggleModeEvent value)? toggleMode,
    TResult Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult Function(AuthSignOutEvent value)? signOut,
    TResult Function(AuthResetPasswordEvent value)? resetPassword,
    TResult Function(AuthQuickLoginEvent value)? quickLogin,
    required TResult orElse(),
  }) {
    if (signInWithFacebook != null) {
      return signInWithFacebook(this);
    }
    return orElse();
  }
}

abstract class AuthSignInWithFacebookEvent implements AuthEvent {
  const factory AuthSignInWithFacebookEvent() =
      _$AuthSignInWithFacebookEventImpl;
}

/// @nodoc
abstract class _$$AuthSubmitRegisterEventImplCopyWith<$Res> {
  factory _$$AuthSubmitRegisterEventImplCopyWith(
          _$AuthSubmitRegisterEventImpl value,
          $Res Function(_$AuthSubmitRegisterEventImpl) then) =
      __$$AuthSubmitRegisterEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, String password, String username, String phone});
}

/// @nodoc
class __$$AuthSubmitRegisterEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthSubmitRegisterEventImpl>
    implements _$$AuthSubmitRegisterEventImplCopyWith<$Res> {
  __$$AuthSubmitRegisterEventImplCopyWithImpl(
      _$AuthSubmitRegisterEventImpl _value,
      $Res Function(_$AuthSubmitRegisterEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? username = null,
    Object? phone = null,
  }) {
    return _then(_$AuthSubmitRegisterEventImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthSubmitRegisterEventImpl implements AuthSubmitRegisterEvent {
  const _$AuthSubmitRegisterEventImpl(
      {required this.email,
      required this.password,
      required this.username,
      required this.phone});

  @override
  final String email;
  @override
  final String password;
  @override
  final String username;
  @override
  final String phone;

  @override
  String toString() {
    return 'AuthEvent.submitRegister(email: $email, password: $password, username: $username, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSubmitRegisterEventImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, email, password, username, phone);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthSubmitRegisterEventImplCopyWith<_$AuthSubmitRegisterEventImpl>
      get copyWith => __$$AuthSubmitRegisterEventImplCopyWithImpl<
          _$AuthSubmitRegisterEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthScreenMode mode) toggleMode,
    required TResult Function(bool isVisible) toggleEyes,
    required TResult Function(String? email, String? password, bool? rememberMe)
        updateLoginField,
    required TResult Function(String email, String password, bool rememberMe)
        submitLogin,
    required TResult Function() signInWithGoogle,
    required TResult Function() signInWithFacebook,
    required TResult Function(
            String email, String password, String username, String phone)
        submitRegister,
    required TResult Function(
            String? email, String? password, String? username, String? phone)
        updateRegisterField,
    required TResult Function() signOut,
    required TResult Function(String email) resetPassword,
    required TResult Function() quickLogin,
  }) {
    return submitRegister(email, password, username, phone);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthScreenMode mode)? toggleMode,
    TResult? Function(bool isVisible)? toggleEyes,
    TResult? Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult? Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signInWithFacebook,
    TResult? Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult? Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult? Function()? signOut,
    TResult? Function(String email)? resetPassword,
    TResult? Function()? quickLogin,
  }) {
    return submitRegister?.call(email, password, username, phone);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthScreenMode mode)? toggleMode,
    TResult Function(bool isVisible)? toggleEyes,
    TResult Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult Function()? signInWithGoogle,
    TResult Function()? signInWithFacebook,
    TResult Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult Function()? signOut,
    TResult Function(String email)? resetPassword,
    TResult Function()? quickLogin,
    required TResult orElse(),
  }) {
    if (submitRegister != null) {
      return submitRegister(email, password, username, phone);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthToggleModeEvent value) toggleMode,
    required TResult Function(AuthToggleEyesEvent value) toggleEyes,
    required TResult Function(AuthUpdateLoginFieldEvent value) updateLoginField,
    required TResult Function(AuthSubmitLoginEvent value) submitLogin,
    required TResult Function(AuthSignInWithGoogleEvent value) signInWithGoogle,
    required TResult Function(AuthSignInWithFacebookEvent value)
        signInWithFacebook,
    required TResult Function(AuthSubmitRegisterEvent value) submitRegister,
    required TResult Function(AuthUpdateRegisterFieldEvent value)
        updateRegisterField,
    required TResult Function(AuthSignOutEvent value) signOut,
    required TResult Function(AuthResetPasswordEvent value) resetPassword,
    required TResult Function(AuthQuickLoginEvent value) quickLogin,
  }) {
    return submitRegister(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthToggleModeEvent value)? toggleMode,
    TResult? Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult? Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult? Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult? Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult? Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult? Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult? Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult? Function(AuthSignOutEvent value)? signOut,
    TResult? Function(AuthResetPasswordEvent value)? resetPassword,
    TResult? Function(AuthQuickLoginEvent value)? quickLogin,
  }) {
    return submitRegister?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthToggleModeEvent value)? toggleMode,
    TResult Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult Function(AuthSignOutEvent value)? signOut,
    TResult Function(AuthResetPasswordEvent value)? resetPassword,
    TResult Function(AuthQuickLoginEvent value)? quickLogin,
    required TResult orElse(),
  }) {
    if (submitRegister != null) {
      return submitRegister(this);
    }
    return orElse();
  }
}

abstract class AuthSubmitRegisterEvent implements AuthEvent {
  const factory AuthSubmitRegisterEvent(
      {required final String email,
      required final String password,
      required final String username,
      required final String phone}) = _$AuthSubmitRegisterEventImpl;

  String get email;
  String get password;
  String get username;
  String get phone;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthSubmitRegisterEventImplCopyWith<_$AuthSubmitRegisterEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthUpdateRegisterFieldEventImplCopyWith<$Res> {
  factory _$$AuthUpdateRegisterFieldEventImplCopyWith(
          _$AuthUpdateRegisterFieldEventImpl value,
          $Res Function(_$AuthUpdateRegisterFieldEventImpl) then) =
      __$$AuthUpdateRegisterFieldEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? email, String? password, String? username, String? phone});
}

/// @nodoc
class __$$AuthUpdateRegisterFieldEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthUpdateRegisterFieldEventImpl>
    implements _$$AuthUpdateRegisterFieldEventImplCopyWith<$Res> {
  __$$AuthUpdateRegisterFieldEventImplCopyWithImpl(
      _$AuthUpdateRegisterFieldEventImpl _value,
      $Res Function(_$AuthUpdateRegisterFieldEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = freezed,
    Object? password = freezed,
    Object? username = freezed,
    Object? phone = freezed,
  }) {
    return _then(_$AuthUpdateRegisterFieldEventImpl(
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AuthUpdateRegisterFieldEventImpl
    implements AuthUpdateRegisterFieldEvent {
  const _$AuthUpdateRegisterFieldEventImpl(
      {this.email, this.password, this.username, this.phone});

  @override
  final String? email;
  @override
  final String? password;
  @override
  final String? username;
  @override
  final String? phone;

  @override
  String toString() {
    return 'AuthEvent.updateRegisterField(email: $email, password: $password, username: $username, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUpdateRegisterFieldEventImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, email, password, username, phone);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUpdateRegisterFieldEventImplCopyWith<
          _$AuthUpdateRegisterFieldEventImpl>
      get copyWith => __$$AuthUpdateRegisterFieldEventImplCopyWithImpl<
          _$AuthUpdateRegisterFieldEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthScreenMode mode) toggleMode,
    required TResult Function(bool isVisible) toggleEyes,
    required TResult Function(String? email, String? password, bool? rememberMe)
        updateLoginField,
    required TResult Function(String email, String password, bool rememberMe)
        submitLogin,
    required TResult Function() signInWithGoogle,
    required TResult Function() signInWithFacebook,
    required TResult Function(
            String email, String password, String username, String phone)
        submitRegister,
    required TResult Function(
            String? email, String? password, String? username, String? phone)
        updateRegisterField,
    required TResult Function() signOut,
    required TResult Function(String email) resetPassword,
    required TResult Function() quickLogin,
  }) {
    return updateRegisterField(email, password, username, phone);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthScreenMode mode)? toggleMode,
    TResult? Function(bool isVisible)? toggleEyes,
    TResult? Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult? Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signInWithFacebook,
    TResult? Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult? Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult? Function()? signOut,
    TResult? Function(String email)? resetPassword,
    TResult? Function()? quickLogin,
  }) {
    return updateRegisterField?.call(email, password, username, phone);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthScreenMode mode)? toggleMode,
    TResult Function(bool isVisible)? toggleEyes,
    TResult Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult Function()? signInWithGoogle,
    TResult Function()? signInWithFacebook,
    TResult Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult Function()? signOut,
    TResult Function(String email)? resetPassword,
    TResult Function()? quickLogin,
    required TResult orElse(),
  }) {
    if (updateRegisterField != null) {
      return updateRegisterField(email, password, username, phone);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthToggleModeEvent value) toggleMode,
    required TResult Function(AuthToggleEyesEvent value) toggleEyes,
    required TResult Function(AuthUpdateLoginFieldEvent value) updateLoginField,
    required TResult Function(AuthSubmitLoginEvent value) submitLogin,
    required TResult Function(AuthSignInWithGoogleEvent value) signInWithGoogle,
    required TResult Function(AuthSignInWithFacebookEvent value)
        signInWithFacebook,
    required TResult Function(AuthSubmitRegisterEvent value) submitRegister,
    required TResult Function(AuthUpdateRegisterFieldEvent value)
        updateRegisterField,
    required TResult Function(AuthSignOutEvent value) signOut,
    required TResult Function(AuthResetPasswordEvent value) resetPassword,
    required TResult Function(AuthQuickLoginEvent value) quickLogin,
  }) {
    return updateRegisterField(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthToggleModeEvent value)? toggleMode,
    TResult? Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult? Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult? Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult? Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult? Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult? Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult? Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult? Function(AuthSignOutEvent value)? signOut,
    TResult? Function(AuthResetPasswordEvent value)? resetPassword,
    TResult? Function(AuthQuickLoginEvent value)? quickLogin,
  }) {
    return updateRegisterField?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthToggleModeEvent value)? toggleMode,
    TResult Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult Function(AuthSignOutEvent value)? signOut,
    TResult Function(AuthResetPasswordEvent value)? resetPassword,
    TResult Function(AuthQuickLoginEvent value)? quickLogin,
    required TResult orElse(),
  }) {
    if (updateRegisterField != null) {
      return updateRegisterField(this);
    }
    return orElse();
  }
}

abstract class AuthUpdateRegisterFieldEvent implements AuthEvent {
  const factory AuthUpdateRegisterFieldEvent(
      {final String? email,
      final String? password,
      final String? username,
      final String? phone}) = _$AuthUpdateRegisterFieldEventImpl;

  String? get email;
  String? get password;
  String? get username;
  String? get phone;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUpdateRegisterFieldEventImplCopyWith<
          _$AuthUpdateRegisterFieldEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthSignOutEventImplCopyWith<$Res> {
  factory _$$AuthSignOutEventImplCopyWith(_$AuthSignOutEventImpl value,
          $Res Function(_$AuthSignOutEventImpl) then) =
      __$$AuthSignOutEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthSignOutEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthSignOutEventImpl>
    implements _$$AuthSignOutEventImplCopyWith<$Res> {
  __$$AuthSignOutEventImplCopyWithImpl(_$AuthSignOutEventImpl _value,
      $Res Function(_$AuthSignOutEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthSignOutEventImpl implements AuthSignOutEvent {
  const _$AuthSignOutEventImpl();

  @override
  String toString() {
    return 'AuthEvent.signOut()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthSignOutEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthScreenMode mode) toggleMode,
    required TResult Function(bool isVisible) toggleEyes,
    required TResult Function(String? email, String? password, bool? rememberMe)
        updateLoginField,
    required TResult Function(String email, String password, bool rememberMe)
        submitLogin,
    required TResult Function() signInWithGoogle,
    required TResult Function() signInWithFacebook,
    required TResult Function(
            String email, String password, String username, String phone)
        submitRegister,
    required TResult Function(
            String? email, String? password, String? username, String? phone)
        updateRegisterField,
    required TResult Function() signOut,
    required TResult Function(String email) resetPassword,
    required TResult Function() quickLogin,
  }) {
    return signOut();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthScreenMode mode)? toggleMode,
    TResult? Function(bool isVisible)? toggleEyes,
    TResult? Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult? Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signInWithFacebook,
    TResult? Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult? Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult? Function()? signOut,
    TResult? Function(String email)? resetPassword,
    TResult? Function()? quickLogin,
  }) {
    return signOut?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthScreenMode mode)? toggleMode,
    TResult Function(bool isVisible)? toggleEyes,
    TResult Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult Function()? signInWithGoogle,
    TResult Function()? signInWithFacebook,
    TResult Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult Function()? signOut,
    TResult Function(String email)? resetPassword,
    TResult Function()? quickLogin,
    required TResult orElse(),
  }) {
    if (signOut != null) {
      return signOut();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthToggleModeEvent value) toggleMode,
    required TResult Function(AuthToggleEyesEvent value) toggleEyes,
    required TResult Function(AuthUpdateLoginFieldEvent value) updateLoginField,
    required TResult Function(AuthSubmitLoginEvent value) submitLogin,
    required TResult Function(AuthSignInWithGoogleEvent value) signInWithGoogle,
    required TResult Function(AuthSignInWithFacebookEvent value)
        signInWithFacebook,
    required TResult Function(AuthSubmitRegisterEvent value) submitRegister,
    required TResult Function(AuthUpdateRegisterFieldEvent value)
        updateRegisterField,
    required TResult Function(AuthSignOutEvent value) signOut,
    required TResult Function(AuthResetPasswordEvent value) resetPassword,
    required TResult Function(AuthQuickLoginEvent value) quickLogin,
  }) {
    return signOut(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthToggleModeEvent value)? toggleMode,
    TResult? Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult? Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult? Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult? Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult? Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult? Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult? Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult? Function(AuthSignOutEvent value)? signOut,
    TResult? Function(AuthResetPasswordEvent value)? resetPassword,
    TResult? Function(AuthQuickLoginEvent value)? quickLogin,
  }) {
    return signOut?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthToggleModeEvent value)? toggleMode,
    TResult Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult Function(AuthSignOutEvent value)? signOut,
    TResult Function(AuthResetPasswordEvent value)? resetPassword,
    TResult Function(AuthQuickLoginEvent value)? quickLogin,
    required TResult orElse(),
  }) {
    if (signOut != null) {
      return signOut(this);
    }
    return orElse();
  }
}

abstract class AuthSignOutEvent implements AuthEvent {
  const factory AuthSignOutEvent() = _$AuthSignOutEventImpl;
}

/// @nodoc
abstract class _$$AuthResetPasswordEventImplCopyWith<$Res> {
  factory _$$AuthResetPasswordEventImplCopyWith(
          _$AuthResetPasswordEventImpl value,
          $Res Function(_$AuthResetPasswordEventImpl) then) =
      __$$AuthResetPasswordEventImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email});
}

/// @nodoc
class __$$AuthResetPasswordEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthResetPasswordEventImpl>
    implements _$$AuthResetPasswordEventImplCopyWith<$Res> {
  __$$AuthResetPasswordEventImplCopyWithImpl(
      _$AuthResetPasswordEventImpl _value,
      $Res Function(_$AuthResetPasswordEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_$AuthResetPasswordEventImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthResetPasswordEventImpl implements AuthResetPasswordEvent {
  const _$AuthResetPasswordEventImpl({required this.email});

  @override
  final String email;

  @override
  String toString() {
    return 'AuthEvent.resetPassword(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResetPasswordEventImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResetPasswordEventImplCopyWith<_$AuthResetPasswordEventImpl>
      get copyWith => __$$AuthResetPasswordEventImplCopyWithImpl<
          _$AuthResetPasswordEventImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthScreenMode mode) toggleMode,
    required TResult Function(bool isVisible) toggleEyes,
    required TResult Function(String? email, String? password, bool? rememberMe)
        updateLoginField,
    required TResult Function(String email, String password, bool rememberMe)
        submitLogin,
    required TResult Function() signInWithGoogle,
    required TResult Function() signInWithFacebook,
    required TResult Function(
            String email, String password, String username, String phone)
        submitRegister,
    required TResult Function(
            String? email, String? password, String? username, String? phone)
        updateRegisterField,
    required TResult Function() signOut,
    required TResult Function(String email) resetPassword,
    required TResult Function() quickLogin,
  }) {
    return resetPassword(email);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthScreenMode mode)? toggleMode,
    TResult? Function(bool isVisible)? toggleEyes,
    TResult? Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult? Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signInWithFacebook,
    TResult? Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult? Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult? Function()? signOut,
    TResult? Function(String email)? resetPassword,
    TResult? Function()? quickLogin,
  }) {
    return resetPassword?.call(email);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthScreenMode mode)? toggleMode,
    TResult Function(bool isVisible)? toggleEyes,
    TResult Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult Function()? signInWithGoogle,
    TResult Function()? signInWithFacebook,
    TResult Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult Function()? signOut,
    TResult Function(String email)? resetPassword,
    TResult Function()? quickLogin,
    required TResult orElse(),
  }) {
    if (resetPassword != null) {
      return resetPassword(email);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthToggleModeEvent value) toggleMode,
    required TResult Function(AuthToggleEyesEvent value) toggleEyes,
    required TResult Function(AuthUpdateLoginFieldEvent value) updateLoginField,
    required TResult Function(AuthSubmitLoginEvent value) submitLogin,
    required TResult Function(AuthSignInWithGoogleEvent value) signInWithGoogle,
    required TResult Function(AuthSignInWithFacebookEvent value)
        signInWithFacebook,
    required TResult Function(AuthSubmitRegisterEvent value) submitRegister,
    required TResult Function(AuthUpdateRegisterFieldEvent value)
        updateRegisterField,
    required TResult Function(AuthSignOutEvent value) signOut,
    required TResult Function(AuthResetPasswordEvent value) resetPassword,
    required TResult Function(AuthQuickLoginEvent value) quickLogin,
  }) {
    return resetPassword(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthToggleModeEvent value)? toggleMode,
    TResult? Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult? Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult? Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult? Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult? Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult? Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult? Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult? Function(AuthSignOutEvent value)? signOut,
    TResult? Function(AuthResetPasswordEvent value)? resetPassword,
    TResult? Function(AuthQuickLoginEvent value)? quickLogin,
  }) {
    return resetPassword?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthToggleModeEvent value)? toggleMode,
    TResult Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult Function(AuthSignOutEvent value)? signOut,
    TResult Function(AuthResetPasswordEvent value)? resetPassword,
    TResult Function(AuthQuickLoginEvent value)? quickLogin,
    required TResult orElse(),
  }) {
    if (resetPassword != null) {
      return resetPassword(this);
    }
    return orElse();
  }
}

abstract class AuthResetPasswordEvent implements AuthEvent {
  const factory AuthResetPasswordEvent({required final String email}) =
      _$AuthResetPasswordEventImpl;

  String get email;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthResetPasswordEventImplCopyWith<_$AuthResetPasswordEventImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthQuickLoginEventImplCopyWith<$Res> {
  factory _$$AuthQuickLoginEventImplCopyWith(_$AuthQuickLoginEventImpl value,
          $Res Function(_$AuthQuickLoginEventImpl) then) =
      __$$AuthQuickLoginEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthQuickLoginEventImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthQuickLoginEventImpl>
    implements _$$AuthQuickLoginEventImplCopyWith<$Res> {
  __$$AuthQuickLoginEventImplCopyWithImpl(_$AuthQuickLoginEventImpl _value,
      $Res Function(_$AuthQuickLoginEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AuthQuickLoginEventImpl implements AuthQuickLoginEvent {
  const _$AuthQuickLoginEventImpl();

  @override
  String toString() {
    return 'AuthEvent.quickLogin()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthQuickLoginEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(AuthScreenMode mode) toggleMode,
    required TResult Function(bool isVisible) toggleEyes,
    required TResult Function(String? email, String? password, bool? rememberMe)
        updateLoginField,
    required TResult Function(String email, String password, bool rememberMe)
        submitLogin,
    required TResult Function() signInWithGoogle,
    required TResult Function() signInWithFacebook,
    required TResult Function(
            String email, String password, String username, String phone)
        submitRegister,
    required TResult Function(
            String? email, String? password, String? username, String? phone)
        updateRegisterField,
    required TResult Function() signOut,
    required TResult Function(String email) resetPassword,
    required TResult Function() quickLogin,
  }) {
    return quickLogin();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(AuthScreenMode mode)? toggleMode,
    TResult? Function(bool isVisible)? toggleEyes,
    TResult? Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult? Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult? Function()? signInWithGoogle,
    TResult? Function()? signInWithFacebook,
    TResult? Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult? Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult? Function()? signOut,
    TResult? Function(String email)? resetPassword,
    TResult? Function()? quickLogin,
  }) {
    return quickLogin?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(AuthScreenMode mode)? toggleMode,
    TResult Function(bool isVisible)? toggleEyes,
    TResult Function(String? email, String? password, bool? rememberMe)?
        updateLoginField,
    TResult Function(String email, String password, bool rememberMe)?
        submitLogin,
    TResult Function()? signInWithGoogle,
    TResult Function()? signInWithFacebook,
    TResult Function(
            String email, String password, String username, String phone)?
        submitRegister,
    TResult Function(
            String? email, String? password, String? username, String? phone)?
        updateRegisterField,
    TResult Function()? signOut,
    TResult Function(String email)? resetPassword,
    TResult Function()? quickLogin,
    required TResult orElse(),
  }) {
    if (quickLogin != null) {
      return quickLogin();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthToggleModeEvent value) toggleMode,
    required TResult Function(AuthToggleEyesEvent value) toggleEyes,
    required TResult Function(AuthUpdateLoginFieldEvent value) updateLoginField,
    required TResult Function(AuthSubmitLoginEvent value) submitLogin,
    required TResult Function(AuthSignInWithGoogleEvent value) signInWithGoogle,
    required TResult Function(AuthSignInWithFacebookEvent value)
        signInWithFacebook,
    required TResult Function(AuthSubmitRegisterEvent value) submitRegister,
    required TResult Function(AuthUpdateRegisterFieldEvent value)
        updateRegisterField,
    required TResult Function(AuthSignOutEvent value) signOut,
    required TResult Function(AuthResetPasswordEvent value) resetPassword,
    required TResult Function(AuthQuickLoginEvent value) quickLogin,
  }) {
    return quickLogin(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthToggleModeEvent value)? toggleMode,
    TResult? Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult? Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult? Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult? Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult? Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult? Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult? Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult? Function(AuthSignOutEvent value)? signOut,
    TResult? Function(AuthResetPasswordEvent value)? resetPassword,
    TResult? Function(AuthQuickLoginEvent value)? quickLogin,
  }) {
    return quickLogin?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthToggleModeEvent value)? toggleMode,
    TResult Function(AuthToggleEyesEvent value)? toggleEyes,
    TResult Function(AuthUpdateLoginFieldEvent value)? updateLoginField,
    TResult Function(AuthSubmitLoginEvent value)? submitLogin,
    TResult Function(AuthSignInWithGoogleEvent value)? signInWithGoogle,
    TResult Function(AuthSignInWithFacebookEvent value)? signInWithFacebook,
    TResult Function(AuthSubmitRegisterEvent value)? submitRegister,
    TResult Function(AuthUpdateRegisterFieldEvent value)? updateRegisterField,
    TResult Function(AuthSignOutEvent value)? signOut,
    TResult Function(AuthResetPasswordEvent value)? resetPassword,
    TResult Function(AuthQuickLoginEvent value)? quickLogin,
    required TResult orElse(),
  }) {
    if (quickLogin != null) {
      return quickLogin(this);
    }
    return orElse();
  }
}

abstract class AuthQuickLoginEvent implements AuthEvent {
  const factory AuthQuickLoginEvent() = _$AuthQuickLoginEventImpl;
}
