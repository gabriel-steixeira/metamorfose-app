/**
 * File: test_utils.dart
 * Description: Utilitários para facilitar a criação de testes.
 *
 * Responsabilidades:
 * - Fornecer funções auxiliares para testes
 * - Criar widgets de teste padronizados
 * - Facilitar setup de testes
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:metamorfose_flutter/app.dart';
import 'package:metamorfose_flutter/blocs/auth_bloc.dart';
import 'package:metamorfose_flutter/services/hybrid_auth_service.dart';
import 'mock_services.dart';

class TestUtils {
  /// Cria um widget de teste com o AuthBloc mockado
  static Widget createTestWidget({
    required Widget child,
    HybridAuthService? authService,
  }) {
    final mockAuthService = authService ?? SimpleMockAuthService();
    
    return MaterialApp(
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(authService: mockAuthService),
        child: child,
      ),
    );
  }

  /// Cria um widget de teste com o app completo
  static Widget createTestApp({
    HybridAuthService? authService,
  }) {
    final mockAuthService = authService ?? SimpleMockAuthService();
    
    return MaterialApp(
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(authService: mockAuthService),
        child: const Scaffold(
          body: Center(
            child: Text('Test App'),
          ),
        ),
      ),
    );
  }

  /// Aguarda um frame e bomba o widget
  static Future<void> pumpAndSettle(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  /// Simula um tap em um widget
  static Future<void> tapWidget(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump();
  }

  /// Simula entrada de texto em um campo
  static Future<void> enterText(WidgetTester tester, Finder finder, String text) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Verifica se um widget está visível
  static bool isWidgetVisible(WidgetTester tester, Finder finder) {
    try {
      return finder.evaluate().isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Aguarda um tempo específico
  static Future<void> wait(WidgetTester tester, Duration duration) async {
    await tester.pump(duration);
  }

  /// Verifica se um texto está presente
  static bool hasText(WidgetTester tester, String text) {
    return find.text(text).evaluate().isNotEmpty;
  }

  /// Verifica se um widget específico está presente
  static bool hasWidget(WidgetTester tester, Type widgetType) {
    return find.byType(widgetType).evaluate().isNotEmpty;
  }

  /// Simula scroll em um widget
  static Future<void> scrollWidget(WidgetTester tester, Finder finder, Offset offset) async {
    await tester.drag(finder, offset);
    await tester.pump();
  }

  /// Verifica se um botão está habilitado
  static bool isButtonEnabled(WidgetTester tester, Finder buttonFinder) {
    final button = tester.widget<GestureDetector>(buttonFinder);
    return button.onTap != null;
  }

  /// Simula um long press
  static Future<void> longPress(WidgetTester tester, Finder finder) async {
    await tester.longPress(finder);
    await tester.pump();
  }

  /// Verifica se um diálogo está aberto
  static bool isDialogOpen(WidgetTester tester) {
    return find.byType(AlertDialog).evaluate().isNotEmpty;
  }

  /// Fecha um diálogo
  static Future<void> closeDialog(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();
  }

  /// Verifica se um snackbar está visível
  static bool isSnackBarVisible(WidgetTester tester) {
    return find.byType(SnackBar).evaluate().isNotEmpty;
  }

  /// Simula navegação para trás
  static Future<void> goBack(WidgetTester tester) async {
    await tester.pageBack();
    await tester.pump();
  }
}
