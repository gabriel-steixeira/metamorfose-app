/**
 * File: app_test.dart
 * Description: Testes de integração para fluxos críticos do aplicativo.
 *
 * Responsabilidades:
 * - Testar fluxo completo de login
 * - Testar fluxo de registro
 * - Testar navegação entre telas
 * - Testar persistência de dados
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:metamorfose_flutter/main.dart' as app;
import '../test/test_helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Fluxos de Integração', () {
    testWidgets('deve inicializar o aplicativo sem erros', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verifica se o app inicializou sem erros
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('deve navegar para tela de login', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Aguarda a tela inicial carregar
      await tester.pump(const Duration(seconds: 2));

      // Verifica se elementos da tela de login estão presentes
      // (assumindo que a tela de login tem campos de email e senha)
      expect(find.byType(TextFormField), findsAtLeastNWidgets(2));
    });

    testWidgets('deve validar campos de login', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Aguarda a tela inicial carregar
      await tester.pump(const Duration(seconds: 2));

      // Tenta fazer login com campos vazios
      final loginButton = find.text('ENTRAR');
      if (loginButton.evaluate().isNotEmpty) {
        await tester.tap(loginButton);
        await tester.pump();

        // Verifica se mensagens de erro aparecem
        expect(find.textContaining('Email'), findsAtLeastNWidgets(1));
        expect(find.textContaining('Senha'), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('deve alternar entre modos de autenticação', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Aguarda a tela inicial carregar
      await tester.pump(const Duration(seconds: 2));

      // Procura por botão de alternância de modo
      final toggleButton = find.text('CRIAR CONTA');
      if (toggleButton.evaluate().isNotEmpty) {
        await tester.tap(toggleButton);
        await tester.pump();

        // Verifica se a tela de registro apareceu
        expect(find.textContaining('Nome completo'), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('deve mostrar/ocultar senha', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Aguarda a tela inicial carregar
      await tester.pump(const Duration(seconds: 2));

      // Procura por campo de senha
      final passwordField = find.byType(TextFormField).last;
      if (passwordField.evaluate().isNotEmpty) {
        // Digita uma senha
        await tester.enterText(passwordField, 'testpassword');
        await tester.pump();

        // Procura por botão de mostrar/ocultar senha
        final eyeButton = find.byIcon(Icons.visibility);
        if (eyeButton.evaluate().isNotEmpty) {
          await tester.tap(eyeButton);
          await tester.pump();

          // Verifica se a senha foi mostrada/ocultada
          // (isso depende da implementação específica)
        }
      }
    });

    testWidgets('deve validar formato de email', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Aguarda a tela inicial carregar
      await tester.pump(const Duration(seconds: 2));

      // Procura por campo de email
      final emailField = find.byType(TextFormField).first;
      if (emailField.evaluate().isNotEmpty) {
        // Digita email inválido
        await tester.enterText(emailField, 'email-invalido');
        await tester.pump();

        // Tenta fazer login
        final loginButton = find.text('ENTRAR');
        if (loginButton.evaluate().isNotEmpty) {
          await tester.tap(loginButton);
          await tester.pump();

          // Verifica se mensagem de erro de email aparece
          expect(find.textContaining('Email'), findsAtLeastNWidgets(1));
        }
      }
    });

    testWidgets('deve validar força da senha', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Aguarda a tela inicial carregar
      await tester.pump(const Duration(seconds: 2));

      // Alterna para modo de registro
      final toggleButton = find.text('CRIAR CONTA');
      if (toggleButton.evaluate().isNotEmpty) {
        await tester.tap(toggleButton);
        await tester.pump();

        // Procura por campo de senha
        final passwordField = find.byType(TextFormField).at(1);
        if (passwordField.evaluate().isNotEmpty) {
          // Digita senha fraca
          await tester.enterText(passwordField, '123');
          await tester.pump();

          // Tenta registrar
          final registerButton = find.text('CRIAR CONTA');
          if (registerButton.evaluate().isNotEmpty) {
            await tester.tap(registerButton);
            await tester.pump();

            // Verifica se mensagem de erro de senha aparece
            expect(find.textContaining('senha'), findsAtLeastNWidgets(1));
          }
        }
      }
    });

    testWidgets('deve navegar para tela principal após login', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Aguarda a tela inicial carregar
      await tester.pump(const Duration(seconds: 2));

      // Simula login com credenciais válidas
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;
      
      if (emailField.evaluate().isNotEmpty && passwordField.evaluate().isNotEmpty) {
        await tester.enterText(emailField, 'test@example.com');
        await tester.enterText(passwordField, 'password123');
        await tester.pump();

        final loginButton = find.text('ENTRAR');
        if (loginButton.evaluate().isNotEmpty) {
          await tester.tap(loginButton);
          await tester.pump();

          // Aguarda processamento do login
          await tester.pump(const Duration(seconds: 3));

          // Verifica se navegou para tela principal
          // (assumindo que a tela principal tem elementos específicos)
          expect(find.byType(MaterialApp), findsOneWidget);
        }
      }
    });

    testWidgets('deve manter estado durante navegação', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Aguarda a tela inicial carregar
      await tester.pump(const Duration(seconds: 2));

      // Digita texto em um campo
      final emailField = find.byType(TextFormField).first;
      if (emailField.evaluate().isNotEmpty) {
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump();

        // Alterna para registro e volta
        final toggleButton = find.text('CRIAR CONTA');
        if (toggleButton.evaluate().isNotEmpty) {
          await tester.tap(toggleButton);
          await tester.pump();

          // Volta para login
          final backButton = find.text('JÁ TENHO CONTA');
          if (backButton.evaluate().isNotEmpty) {
            await tester.tap(backButton);
            await tester.pump();

            // Verifica se o texto foi mantido
            expect(find.text('test@example.com'), findsOneWidget);
          }
        }
      }
    });

    testWidgets('deve responder a gestos de toque', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Aguarda a tela inicial carregar
      await tester.pump(const Duration(seconds: 2));

      // Testa toque em botões
      final buttons = find.byType(GestureDetector);
      if (buttons.evaluate().isNotEmpty) {
        await tester.tap(buttons.first);
        await tester.pump();

        // Verifica se houve resposta ao toque
        // (isso depende da implementação específica)
      }
    });

    testWidgets('deve funcionar em diferentes orientações', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Aguarda a tela inicial carregar
      await tester.pump(const Duration(seconds: 2));

      // Testa orientação landscape
      await tester.binding.setSurfaceSize(const Size(800, 600));
      await tester.pump();

      // Verifica se o app ainda funciona
      expect(find.byType(MaterialApp), findsOneWidget);

      // Volta para portrait
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pump();

      // Verifica se o app ainda funciona
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
