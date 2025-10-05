/**
 * File: test_config.dart
 * Description: Configurações e constantes para os testes.
 *
 * Responsabilidades:
 * - Definir configurações de teste
 * - Centralizar constantes de teste
 * - Configurar timeouts e delays
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter_test/flutter_test.dart';

class TestConfig {
  // Timeouts para testes
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 5);
  static const Duration longTimeout = Duration(minutes: 2);

  // Delays para animações e carregamento
  static const Duration animationDelay = Duration(milliseconds: 300);
  static const Duration loadingDelay = Duration(seconds: 1);
  static const Duration networkDelay = Duration(seconds: 2);

  // Configurações de teste
  static const double testDeviceWidth = 400.0;
  static const double testDeviceHeight = 800.0;
  static const double testTabletWidth = 800.0;
  static const double testTabletHeight = 600.0;

  // Configurações de responsividade
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  // Configurações de texto
  static const String testFontFamily = 'DinNext';
  static const double testFontSize = 16.0;
  static const double testLargeFontSize = 20.0;
  static const double testSmallFontSize = 12.0;

  // Configurações de cores de teste
  static const int testPrimaryColor = 0xFFB18EF2;
  static const int testSecondaryColor = 0xFF6C5CE7;
  static const int testErrorColor = 0xFFE74C3C;
  static const int testSuccessColor = 0xFF27AE60;
  static const int testWarningColor = 0xFFF39C12;

  // Configurações de validação
  static const String validEmailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String validPhoneRegex = r'^\+?[1-9]\d{1,14}$';
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;

  // Configurações de mock
  static const String mockUserId = 'test_user_123';
  static const String mockUserEmail = 'test@example.com';
  static const String mockUserName = 'Test User';
  static const String mockUserPhone = '+5511999999999';

  // Configurações de API
  static const String mockApiBaseUrl = 'https://api.example.com';
  static const Duration mockApiTimeout = Duration(seconds: 10);
  static const int mockApiRetryCount = 3;

  // Configurações de Firebase
  static const String mockFirebaseProjectId = 'test-project';
  static const String mockFirebaseApiKey = 'test-api-key';

  // Configurações de teste de performance
  static const Duration maxRenderTime = Duration(milliseconds: 16); // 60 FPS
  static const Duration maxAnimationTime = Duration(milliseconds: 300);
  static const int maxMemoryUsageMB = 100;

  // Configurações de acessibilidade
  static const double minTouchTargetSize = 44.0;
  static const double minContrastRatio = 4.5;
  static const int maxFontScale = 2;

  // Configurações de internacionalização
  static const String defaultLocale = 'pt_BR';
  static const List<String> supportedLocales = ['pt_BR', 'en_US', 'es_ES'];

  // Configurações de teste de integração
  static const Duration integrationTestTimeout = Duration(minutes: 5);
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Configurações de cobertura
  static const double minCoveragePercentage = 80.0;
  static const List<String> coverageExclusions = [
    '**/*.g.dart',
    '**/*.freezed.dart',
    '**/generated/**',
    '**/test/**',
  ];

  // Configurações de relatórios
  static const String testReportPath = 'test_reports';
  static const String coverageReportPath = 'coverage';
  static const String performanceReportPath = 'performance_reports';

  // Configurações de CI/CD
  static const String ciTestCommand = 'flutter test --coverage';
  static const String ciIntegrationTestCommand = 'flutter test integration_test/';
  static const String ciBuildCommand = 'flutter build apk --release';

  // Configurações de debug
  static const bool enableTestLogs = true;
  static const bool enablePerformanceLogs = false;
  static const bool enableNetworkLogs = false;
  static const bool enableBlocLogs = true;

  // Configurações de dispositivo de teste
  static const Map<String, dynamic> testDeviceConfig = {
    'name': 'Test Device',
    'platform': 'android',
    'version': '11.0',
    'screenSize': [400, 800],
    'pixelRatio': 2.0,
  };

  // Configurações de dados de teste
  static const Map<String, dynamic> testDataConfig = {
    'users': 100,
    'plants': 50,
    'records': 1000,
    'photos': 500,
  };

  // Configurações de ambiente de teste
  static const Map<String, String> testEnvironment = {
    'FLAVOR': 'test',
    'ENVIRONMENT': 'testing',
    'DEBUG': 'true',
    'MOCK_API': 'true',
  };
}
