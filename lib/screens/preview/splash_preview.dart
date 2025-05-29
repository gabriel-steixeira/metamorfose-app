/**
 * File: splash_preview.dart
 * Description: Tela de visualização para testar componentes de splash
 *
 * Responsabilidades:
 * - Permitir a visualização isolada da tela de splash
 * - Facilitar testes visuais sem necessidade de emulador completo
 *
 * Author: Gabriel Teixeira
 * Created on: [Data atual]
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:conversao_flutter/screens/splash/brand_splash_screen.dart';
import 'package:conversao_flutter/screens/splash/mascot_splash_screen.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_screen.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_welcome_screen.dart';
import 'package:conversao_flutter/screens/plant/plant_config_screen.dart';
import 'package:conversao_flutter/screens/auth/auth_screen.dart';
import 'package:conversao_flutter/screens/chat/voice_chat_screen.dart';

void main() {
  runApp(const SplashPreview());
}

/// Aplicativo de visualização para testar a tela de splash isoladamente.
class SplashPreview extends StatelessWidget {
  const SplashPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
} 