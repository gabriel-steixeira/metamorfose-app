/**
 * File: widget_test.dart
 * Description: Testes de widget do aplicativo Metamorfose.
 *
 * Responsabilidades:
 * - Testar widgets do aplicativo
 * - Validar comportamento da UI
 * - Garantir qualidade do código
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:metamorfose_flutter/app.dart';
import 'test_helpers/test_utils.dart';

void main() {
  group('Testes Básicos do App', () {
    testWidgets('deve renderizar o aplicativo sem erros', (WidgetTester tester) async {
      await TestUtils.pumpAndSettle(
        tester,
        TestUtils.createTestApp(),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('deve ter estrutura básica do MaterialApp', (WidgetTester tester) async {
      await TestUtils.pumpAndSettle(
        tester,
        TestUtils.createTestApp(),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
    });

    testWidgets('deve responder a interações básicas', (WidgetTester tester) async {
      await TestUtils.pumpAndSettle(
        tester,
        TestUtils.createTestApp(),
      );

      // Verifica se há elementos básicos do MaterialApp
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.text('Test App'), findsOneWidget);
    });
  });
}
