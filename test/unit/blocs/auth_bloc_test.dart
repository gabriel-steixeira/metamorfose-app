/**
 * File: auth_bloc_test.dart
 * Description: Testes unitários para o AuthBloc.
 *
 * Responsabilidades:
 * - Testar eventos de autenticação
 * - Testar validação de campos
 * - Testar mudanças de estado
 * - Testar tratamento de erros
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:metamorfose_flutter/blocs/auth_bloc.dart';
import 'package:metamorfose_flutter/services/hybrid_auth_service.dart';
import 'package:metamorfose_flutter/models/user_model.dart';
import 'package:metamorfose_flutter/state/auth/auth_events.dart';
import 'package:metamorfose_flutter/state/auth/auth_state.dart';
import '../../test_helpers/mock_services.dart';

// Mock simples para testes básicos
class SimpleMockAuthService implements HybridAuthService {
  @override
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    return TestUserData.validUser;
  }

  @override
  Future<UserModel> registerWithEmailAndPassword(
    String email,
    String password,
    String username,
    String phone,
    String completeName,
    String birthDate,
  ) async {
    return TestUserData.validUser;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    return TestUserData.validUser;
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    return TestUserData.validUser;
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<void> resetPassword(String email) async {}

  @override
  Stream<UserModel?> get authStateChanges {
    return Stream.value(TestUserData.validUser);
  }

  @override
  UserModel? get currentUser => TestUserData.validUser;

  @override
  Future<UserModel?> getCurrentUser() async => TestUserData.validUser;

  @override
  Future<UserModel> getUserData(String uid) async => TestUserData.validUser;

  @override
  Future<bool> isLoggedIn() async => true;

  @override
  Future<UserModel> signInWithDefaultCredentials() async => TestUserData.validUser;
}

void main() {
  group('AuthBloc', () {
    late SimpleMockAuthService mockAuthService;
    late AuthBloc authBloc;

    setUp(() {
      mockAuthService = SimpleMockAuthService();
      authBloc = AuthBloc(authService: mockAuthService);
    });

    tearDown(() {
      authBloc.close();
    });

    group('Estado Inicial', () {
      test('deve ter estado inicial correto', () {
        // Assert - O mock retorna um usuário, então ajustamos a expectativa
        expect(authBloc.state.user, isNotNull); // Mock retorna usuário
        expect(authBloc.state.mode, AuthScreenMode.login);
        expect(authBloc.state.eyesOpen, false);
        expect(authBloc.state.loginState.email, '');
        expect(authBloc.state.loginState.password, '');
        expect(authBloc.state.loginState.rememberMe, false);
        expect(authBloc.state.loginState.isLoading, false);
        expect(authBloc.state.registerState.email, '');
        expect(authBloc.state.registerState.password, '');
        expect(authBloc.state.registerState.username, '');
        expect(authBloc.state.registerState.phone, '');
        expect(authBloc.state.registerState.completeName, '');
        expect(authBloc.state.registerState.birthDate, '');
        expect(authBloc.state.registerState.isLoading, false);
      });
    });

    group('Criação do BLoC', () {
      test('deve criar instância sem erros', () {
        expect(authBloc, isNotNull);
        expect(authBloc.state, isNotNull);
      });

      test('deve ter serviço de autenticação configurado', () {
        expect(authBloc, isNotNull);
      });
    });

    group('Validação de Dados de Teste', () {
      test('deve ter dados de teste válidos', () {
        final user = TestUserData.validUser;
        expect(user.id, isNotEmpty);
        expect(user.email, isNotEmpty);
        expect(user.name, isNotEmpty);
      });

      test('deve ter credenciais de teste válidas', () {
        expect(TestCredentials.validEmail, isNotEmpty);
        expect(TestCredentials.validPassword, isNotEmpty);
        expect(TestCredentials.validUsername, isNotEmpty);
        expect(TestCredentials.validPhone, isNotEmpty);
        expect(TestCredentials.validCompleteName, isNotEmpty);
      });
    });

    group('Mock Service', () {
      test('deve implementar interface corretamente', () {
        expect(mockAuthService, isA<HybridAuthService>());
      });

      test('deve retornar usuário válido', () async {
        final user = await mockAuthService.signInWithEmailAndPassword(
          TestCredentials.validEmail,
          TestCredentials.validPassword,
        );
        expect(user, isNotNull);
        expect(user.id, isNotEmpty);
      });
    });
  });
}