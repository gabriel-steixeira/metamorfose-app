/**
 * File: app_router.dart
 * Description: Configuração de rotas do aplicativo Metamorfose.
 *
 * Responsabilidades:
 * - Definir a estrutura de navegação entre as telas
 * - Gerenciar a navegação entre todas as telas do aplicativo
 * - Controlar a navegação utilizando o GoRouter
 *
 * Author: Gabriel Teixeira
 * Created on: atual
 * Last modified: atual
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:conversao_flutter/routes/routes.dart';
import 'package:conversao_flutter/screens/auth/auth_screen.dart';
//import 'package:conversao_flutter/screens/auth/register_screen.dart';
import 'package:conversao_flutter/screens/chat/voice_chat_screen.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_butterfly_screen.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_carousel_screen.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_egg_screen.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_final_screen.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_plant_screen.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_screen.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_welcome_screen.dart';
import 'package:conversao_flutter/screens/plant/plant_config_screen.dart';
import 'package:conversao_flutter/screens/splash/brand_splash_screen.dart';
import 'package:conversao_flutter/screens/splash/mascot_splash_screen.dart';

/// Classe responsável pela configuração de rotas do aplicativo usando o GO Router.
/// Define todos os caminhos de navegação disponíveis no app.
class AppRouter {
  /// Router principal do aplicativo
  static final router = GoRouter(
    initialLocation: Routes.brandSplash,
    debugLogDiagnostics: true,
    routes: [
      // Tela de splash da marca
      GoRoute(
        path: Routes.brandSplash,
        builder: (context, state) => const BrandSplashScreen(),
      ),
      
      // Tela de splash do mascote
      GoRoute(
        path: Routes.mascotSplash,
        builder: (context, state) => const MascotSplashScreen(),
      ),
      
      // Primeira tela de onboarding
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Nova tela de onboarding com carrossel
      GoRoute(
        path: Routes.onboardingCarousel,
        builder: (context, state) => const OnboardingCarouselScreen(),
      ),
      
      // Tela de boas-vindas do onboarding
      GoRoute(
        path: Routes.onboardingWelcome,
        builder: (context, state) => const OnboardingWelcomeScreen(),
      ),
      
      // Tela da planta no onboarding
      GoRoute(
        path: Routes.onboardingPlant,
        builder: (context, state) => const OnboardingPlantScreen(),
      ),
      
      // Tela do casulo no onboarding
      GoRoute(
        path: Routes.onboardingEgg,
        builder: (context, state) => const OnboardingEggScreen(),
      ),
      
      // Tela da borboleta no onboarding
      GoRoute(
        path: Routes.onboardingButterfly,
        builder: (context, state) => const OnboardingButterflyScreen(),
      ),
      
      // Tela final do onboarding
      GoRoute(
        path: Routes.onboardingFinal,
        builder: (context, state) => const OnboardingFinalScreen(),
      ),
      
      // Tela de autenticação
      GoRoute(
        path: Routes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      
      // Tela de registro
      // GoRoute(
      //   path: Routes.register,
      //   builder: (context, state) => const RegisterScreen(),
      // ),
      
      // Tela de configuração da planta
      GoRoute(
        path: Routes.plantConfig,
        builder: (context, state) => const PlantConfigScreen(),
      ),
      
      // Tela de chat por voz
      GoRoute(
        path: Routes.voiceChat,
        builder: (context, state) => const VoiceChatScreen(),
      ),
    ],
  );
} 