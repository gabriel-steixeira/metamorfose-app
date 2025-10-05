/**
 * File: mock_services.dart
 * Description: Mocks para serviços utilizados nos testes.
 *
 * Responsabilidades:
 * - Criar mocks para serviços externos
 * - Facilitar testes unitários e de integração
 * - Simular comportamentos de APIs e Firebase
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:metamorfose_flutter/services/hybrid_auth_service.dart';
import 'package:metamorfose_flutter/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

// Dados de teste para UserModel
class TestUserData {
  static UserModel get validUser => UserModel(
        id: 'test_user_id',
        email: 'test@example.com',
        name: 'Test User',
        completeName: 'Test User Complete',
        phoneNumber: '+5511999999999',
        birthDate: DateTime(1990, 1, 1),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  static UserModel get userWithoutOptionalFields => UserModel(
        id: 'test_user_id_2',
        email: 'test2@example.com',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  static Map<String, dynamic> get validUserJson => {
        'id': 'test_user_id',
        'email': 'test@example.com',
        'name': 'Test User',
        'completeName': 'Test User Complete',
        'phoneNumber': '+5511999999999',
        'birthDate': '1990-01-01T00:00:00.000Z',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };
}

// Mock para DocumentSnapshot do Firestore
class MockDocumentSnapshot implements DocumentSnapshot {
  final Map<String, dynamic>? _data;

  MockDocumentSnapshot() : _data = {
        'email': 'test@example.com',
        'name': 'Test User',
        'completeName': 'Test User Complete',
        'photoUrl': 'https://example.com/photo.jpg',
        'phoneNumber': '+5511999999999',
        'birthDate': Timestamp.fromDate(DateTime(1990, 1, 1)),
        'createdAt': Timestamp.fromDate(DateTime(2023, 1, 1)),
        'updatedAt': Timestamp.fromDate(DateTime(2023, 1, 2)),
      };

  MockDocumentSnapshot.withNulls() : _data = {
        'email': 'test@example.com',
        'name': null,
        'completeName': null,
        'photoUrl': null,
        'phoneNumber': null,
        'birthDate': null,
        'createdAt': Timestamp.fromDate(DateTime(2023, 1, 1)),
        'updatedAt': Timestamp.fromDate(DateTime(2023, 1, 2)),
      };

  @override
  String get id => 'test_doc_id';

  @override
  Map<String, dynamic>? data() => _data;

  @override
  bool get exists => true;

  @override
  SnapshotMetadata get metadata => throw UnimplementedError();

  @override
  DocumentReference get reference => throw UnimplementedError();

  @override
  dynamic operator [](Object field) => _data?[field];

  @override
  dynamic get(Object field) => _data?[field];
}

// Dados de teste para credenciais
class TestCredentials {
  static const String validEmail = 'test@example.com';
  static const String validPassword = 'password123';
  static const String invalidEmail = 'invalid-email';
  static const String weakPassword = '123';
  static const String validUsername = 'testuser';
  static const String validPhone = '+5511999999999';
  static const String validCompleteName = 'Test User Complete';
  static final DateTime validBirthDate = DateTime(1990, 1, 1);
}