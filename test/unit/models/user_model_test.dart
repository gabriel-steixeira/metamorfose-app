/**
 * File: user_model_test.dart
 * Description: Testes unitários para o modelo UserModel.
 *
 * Responsabilidades:
 * - Testar serialização/deserialização JSON
 * - Testar conversão do Firestore
 * - Testar método copyWith
 * - Validar campos obrigatórios
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metamorfose_flutter/models/user_model.dart';
import '../../test_helpers/mock_services.dart';

void main() {
  group('UserModel', () {
    group('Constructor', () {
      test('deve criar instância com todos os campos obrigatórios', () {
        final user = UserModel(
          id: 'test_id',
          email: 'test@example.com',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        expect(user.id, 'test_id');
        expect(user.email, 'test@example.com');
        expect(user.name, null);
        expect(user.completeName, null);
        expect(user.photoUrl, null);
        expect(user.phoneNumber, null);
        expect(user.birthDate, null);
        expect(user.createdAt, isA<DateTime>());
        expect(user.updatedAt, isA<DateTime>());
      });

      test('deve criar instância com todos os campos', () {
        final now = DateTime.now();
        final birthDate = DateTime(1990, 1, 1);
        
        final user = UserModel(
          id: 'test_id',
          email: 'test@example.com',
          name: 'Test User',
          completeName: 'Test User Complete',
          photoUrl: 'https://example.com/photo.jpg',
          phoneNumber: '+5511999999999',
          birthDate: birthDate,
          createdAt: now,
          updatedAt: now,
        );

        expect(user.id, 'test_id');
        expect(user.email, 'test@example.com');
        expect(user.name, 'Test User');
        expect(user.completeName, 'Test User Complete');
        expect(user.photoUrl, 'https://example.com/photo.jpg');
        expect(user.phoneNumber, '+5511999999999');
        expect(user.birthDate, birthDate);
        expect(user.createdAt, now);
        expect(user.updatedAt, now);
      });
    });

    group('fromJson', () {
      test('deve criar instância a partir de JSON válido', () {
        final json = TestUserData.validUserJson;
        final user = UserModel.fromJson(json);

        expect(user.id, json['id']);
        expect(user.email, json['email']);
        expect(user.name, json['name']);
        expect(user.completeName, json['completeName']);
        expect(user.phoneNumber, json['phoneNumber']);
        expect(user.birthDate, DateTime.parse(json['birthDate']));
        expect(user.createdAt, DateTime.parse(json['createdAt']));
        expect(user.updatedAt, DateTime.parse(json['updatedAt']));
      });

      test('deve criar instância com campos opcionais nulos', () {
        final json = {
          'id': 'test_id',
          'email': 'test@example.com',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };
        
        final user = UserModel.fromJson(json);

        expect(user.id, 'test_id');
        expect(user.email, 'test@example.com');
        expect(user.name, null);
        expect(user.completeName, null);
        expect(user.photoUrl, null);
        expect(user.phoneNumber, null);
        expect(user.birthDate, null);
      });
    });

    group('toJson', () {
      test('deve converter para JSON corretamente', () {
        final user = TestUserData.validUser;
        final json = user.toJson();

        expect(json['id'], user.id);
        expect(json['email'], user.email);
        expect(json['name'], user.name);
        expect(json['completeName'], user.completeName);
        expect(json['phoneNumber'], user.phoneNumber);
        expect(json['birthDate'], user.birthDate?.toIso8601String());
        expect(json['createdAt'], user.createdAt.toIso8601String());
        expect(json['updatedAt'], user.updatedAt.toIso8601String());
      });

      test('deve converter campos nulos para null no JSON', () {
        final user = TestUserData.userWithoutOptionalFields;
        final json = user.toJson();

        expect(json['name'], null);
        expect(json['completeName'], null);
        expect(json['photoUrl'], null);
        expect(json['phoneNumber'], null);
        expect(json['birthDate'], null);
      });
    });

    group('toMap', () {
      test('deve converter para Map corretamente', () {
        final user = TestUserData.validUser;
        final map = user.toMap();

        expect(map['email'], user.email);
        expect(map['name'], user.name);
        expect(map['completeName'], user.completeName);
        expect(map['photoUrl'], user.photoUrl);
        expect(map['phoneNumber'], user.phoneNumber);
        expect(map['birthDate'], user.birthDate);
        expect(map['createdAt'], user.createdAt);
        expect(map['updatedAt'], user.updatedAt);
      });
    });

    group('copyWith', () {
      test('deve criar cópia com novos valores', () {
        final originalUser = TestUserData.validUser;
        final newName = 'New Name';
        final newEmail = 'new@example.com';
        
        final copiedUser = originalUser.copyWith(
          name: newName,
          email: newEmail,
        );

        expect(copiedUser.id, originalUser.id);
        expect(copiedUser.email, newEmail);
        expect(copiedUser.name, newName);
        expect(copiedUser.completeName, originalUser.completeName);
        expect(copiedUser.photoUrl, originalUser.photoUrl);
        expect(copiedUser.phoneNumber, originalUser.phoneNumber);
        expect(copiedUser.birthDate, originalUser.birthDate);
        expect(copiedUser.createdAt, originalUser.createdAt);
        expect(copiedUser.updatedAt, originalUser.updatedAt);
      });

      test('deve manter valores originais quando não especificados', () {
        final originalUser = TestUserData.validUser;
        final copiedUser = originalUser.copyWith();

        expect(copiedUser.id, originalUser.id);
        expect(copiedUser.email, originalUser.email);
        expect(copiedUser.name, originalUser.name);
        expect(copiedUser.completeName, originalUser.completeName);
        expect(copiedUser.photoUrl, originalUser.photoUrl);
        expect(copiedUser.phoneNumber, originalUser.phoneNumber);
        expect(copiedUser.birthDate, originalUser.birthDate);
        expect(copiedUser.createdAt, originalUser.createdAt);
        expect(copiedUser.updatedAt, originalUser.updatedAt);
      });

      test('deve permitir definir campos como null', () {
        final originalUser = TestUserData.validUser;
        final copiedUser = originalUser.copyWith(
          name: null,
          photoUrl: null,
        );

        // O copyWith não permite definir campos como null, apenas mantém os valores originais
        expect(copiedUser.name, originalUser.name);
        expect(copiedUser.photoUrl, originalUser.photoUrl);
        expect(copiedUser.email, originalUser.email);
        expect(copiedUser.completeName, originalUser.completeName);
      });

      test('deve criar cópia com todos os campos alterados', () {
        final originalUser = TestUserData.validUser;
        final newId = 'new_id';
        final newEmail = 'new@example.com';
        final newName = 'New Name';
        final newCompleteName = 'New Complete Name';
        final newPhotoUrl = 'https://new.com/photo.jpg';
        final newPhoneNumber = '+5511888888888';
        final newBirthDate = DateTime(1995, 5, 15);
        final newCreatedAt = DateTime(2024, 1, 1);
        final newUpdatedAt = DateTime(2024, 1, 2);
        
        final copiedUser = originalUser.copyWith(
          id: newId,
          email: newEmail,
          name: newName,
          completeName: newCompleteName,
          photoUrl: newPhotoUrl,
          phoneNumber: newPhoneNumber,
          birthDate: newBirthDate,
          createdAt: newCreatedAt,
          updatedAt: newUpdatedAt,
        );

        expect(copiedUser.id, newId);
        expect(copiedUser.email, newEmail);
        expect(copiedUser.name, newName);
        expect(copiedUser.completeName, newCompleteName);
        expect(copiedUser.photoUrl, newPhotoUrl);
        expect(copiedUser.phoneNumber, newPhoneNumber);
        expect(copiedUser.birthDate, newBirthDate);
        expect(copiedUser.createdAt, newCreatedAt);
        expect(copiedUser.updatedAt, newUpdatedAt);
      });
    });

    group('fromFirestore', () {
      test('deve criar instância a partir de DocumentSnapshot do Firestore', () {
        final mockDoc = MockDocumentSnapshot();
        final user = UserModel.fromFirestore(mockDoc);

        expect(user.id, 'test_doc_id');
        expect(user.email, 'test@example.com');
        expect(user.name, 'Test User');
        expect(user.completeName, 'Test User Complete');
        expect(user.photoUrl, 'https://example.com/photo.jpg');
        expect(user.phoneNumber, '+5511999999999');
        expect(user.birthDate, DateTime(1990, 1, 1));
        expect(user.createdAt, DateTime(2023, 1, 1));
        expect(user.updatedAt, DateTime(2023, 1, 2));
      });

      test('deve criar instância com campos opcionais nulos do Firestore', () {
        final mockDoc = MockDocumentSnapshot.withNulls();
        final user = UserModel.fromFirestore(mockDoc);

        expect(user.id, 'test_doc_id');
        expect(user.email, 'test@example.com');
        expect(user.name, null);
        expect(user.completeName, null);
        expect(user.photoUrl, null);
        expect(user.phoneNumber, null);
        expect(user.birthDate, null);
        expect(user.createdAt, DateTime(2023, 1, 1));
        expect(user.updatedAt, DateTime(2023, 1, 2));
      });
    });

    group('Equality', () {
      test('deve ser igual quando todos os campos são iguais', () {
        final user1 = TestUserData.validUser;
        final user2 = TestUserData.validUser;

        expect(user1.id, user2.id);
        expect(user1.email, user2.email);
        expect(user1.name, user2.name);
        expect(user1.completeName, user2.completeName);
        expect(user1.photoUrl, user2.photoUrl);
        expect(user1.phoneNumber, user2.phoneNumber);
        expect(user1.birthDate, user2.birthDate);
        expect(user1.createdAt, user2.createdAt);
        expect(user1.updatedAt, user2.updatedAt);
      });

      test('deve ser diferente quando IDs são diferentes', () {
        final user1 = TestUserData.validUser;
        final user2 = user1.copyWith(id: 'different_id');

        expect(user1.id, isNot(user2.id));
      });
    });
  });
}
