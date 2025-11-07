// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthState {
  AuthScreenMode get mode => throw _privateConstructorUsedError;
  bool get eyesOpen => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  UserModel? get user => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  LoginState get loginState => throw _privateConstructorUsedError;
  RegisterState get registerState => throw _privateConstructorUsedError;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  @useResult
  $Res call(
      {AuthScreenMode mode,
      bool eyesOpen,
      bool isLoading,
      UserModel? user,
      String? error,
      LoginState loginState,
      RegisterState registerState});

  $LoginStateCopyWith<$Res> get loginState;
  $RegisterStateCopyWith<$Res> get registerState;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? eyesOpen = null,
    Object? isLoading = null,
    Object? user = freezed,
    Object? error = freezed,
    Object? loginState = null,
    Object? registerState = null,
  }) {
    return _then(_value.copyWith(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as AuthScreenMode,
      eyesOpen: null == eyesOpen
          ? _value.eyesOpen
          : eyesOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      loginState: null == loginState
          ? _value.loginState
          : loginState // ignore: cast_nullable_to_non_nullable
              as LoginState,
      registerState: null == registerState
          ? _value.registerState
          : registerState // ignore: cast_nullable_to_non_nullable
              as RegisterState,
    ) as $Val);
  }

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LoginStateCopyWith<$Res> get loginState {
    return $LoginStateCopyWith<$Res>(_value.loginState, (value) {
      return _then(_value.copyWith(loginState: value) as $Val);
    });
  }

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RegisterStateCopyWith<$Res> get registerState {
    return $RegisterStateCopyWith<$Res>(_value.registerState, (value) {
      return _then(_value.copyWith(registerState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthStateImplCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthStateImplCopyWith(
          _$AuthStateImpl value, $Res Function(_$AuthStateImpl) then) =
      __$$AuthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AuthScreenMode mode,
      bool eyesOpen,
      bool isLoading,
      UserModel? user,
      String? error,
      LoginState loginState,
      RegisterState registerState});

  @override
  $LoginStateCopyWith<$Res> get loginState;
  @override
  $RegisterStateCopyWith<$Res> get registerState;
}

/// @nodoc
class __$$AuthStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateImpl>
    implements _$$AuthStateImplCopyWith<$Res> {
  __$$AuthStateImplCopyWithImpl(
      _$AuthStateImpl _value, $Res Function(_$AuthStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? eyesOpen = null,
    Object? isLoading = null,
    Object? user = freezed,
    Object? error = freezed,
    Object? loginState = null,
    Object? registerState = null,
  }) {
    return _then(_$AuthStateImpl(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as AuthScreenMode,
      eyesOpen: null == eyesOpen
          ? _value.eyesOpen
          : eyesOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      loginState: null == loginState
          ? _value.loginState
          : loginState // ignore: cast_nullable_to_non_nullable
              as LoginState,
      registerState: null == registerState
          ? _value.registerState
          : registerState // ignore: cast_nullable_to_non_nullable
              as RegisterState,
    ));
  }
}

/// @nodoc

class _$AuthStateImpl implements _AuthState {
  const _$AuthStateImpl(
      {this.mode = AuthScreenMode.login,
      this.eyesOpen = false,
      this.isLoading = false,
      this.user,
      this.error,
      this.loginState = const LoginState(),
      this.registerState = const RegisterState()});

  @override
  @JsonKey()
  final AuthScreenMode mode;
  @override
  @JsonKey()
  final bool eyesOpen;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final UserModel? user;
  @override
  final String? error;
  @override
  @JsonKey()
  final LoginState loginState;
  @override
  @JsonKey()
  final RegisterState registerState;

  @override
  String toString() {
    return 'AuthState(mode: $mode, eyesOpen: $eyesOpen, isLoading: $isLoading, user: $user, error: $error, loginState: $loginState, registerState: $registerState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.eyesOpen, eyesOpen) ||
                other.eyesOpen == eyesOpen) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.loginState, loginState) ||
                other.loginState == loginState) &&
            (identical(other.registerState, registerState) ||
                other.registerState == registerState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode, eyesOpen, isLoading, user,
      error, loginState, registerState);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      __$$AuthStateImplCopyWithImpl<_$AuthStateImpl>(this, _$identity);
}

abstract class _AuthState implements AuthState {
  const factory _AuthState(
      {final AuthScreenMode mode,
      final bool eyesOpen,
      final bool isLoading,
      final UserModel? user,
      final String? error,
      final LoginState loginState,
      final RegisterState registerState}) = _$AuthStateImpl;

  @override
  AuthScreenMode get mode;
  @override
  bool get eyesOpen;
  @override
  bool get isLoading;
  @override
  UserModel? get user;
  @override
  String? get error;
  @override
  LoginState get loginState;
  @override
  RegisterState get registerState;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
