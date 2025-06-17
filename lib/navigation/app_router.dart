/**
 * File: app_router.dart
 * Description: Configuração de rotas do aplicativo Metamorfose.
 *
 * Responsabilidades:
 * - Definir a estrutura de navegação entre as telas
 * - Gerenciar a navegação entre todas as telas do aplicativo
 * - Controlar a navegação utilizando o GoRouter
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:go_router/go_router.dart';
import 'package:conversao_flutter/routes/routes.dart';
 import 'package:conversao_flutter/screens/auth/auth_screen.dart';
//import 'package:conversao_flutter/screens/auth/register_screen.dart';
import 'package:conversao_flutter/screens/home/home.dart';
//import 'package:conversao_flutter/screens/home/home_screen_bloc.dart';
import 'package:conversao_flutter/screens/chat/voice_chat_screen.dart';
import 'package:conversao_flutter/screens/map/map_screen.dart';
//import 'package:conversao_flutter/screens/map/map_screen_bloc.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_butterfly_screen.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_carousel_screen.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_egg_screen.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_final_screen.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_plant_screen.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_screen.dart';
import 'package:conversao_flutter/screens/onboarding/onboarding_welcome_screen.dart';
import 'package:conversao_flutter/screens/plant/plant_config_screen.dart';
//import 'package:conversao_flutter/screens/plant/plant_config_screen_bloc.dart';
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
      
      // Tela de autenticação (agora usando BLoC como padrão)
      // GoRoute(
      //   path: Routes.auth,
      //   builder: (context, state) => const AuthScreenBloc(),
      // ),
      
      // Tela de registro
      // GoRoute(
      //   path: Routes.register,
      //   builder: (context, state) => const RegisterScreen(),
      // ),
      
      // Tela de configuração da planta (agora usando BLoC como padrão)
      GoRoute(
        path: Routes.plantConfig,
        builder: (context, state) => const PlantConfigScreen(),
      ),
      
      // Tela inicial/home (agora usando BLoC como padrão)
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      
      // Tela de chat por voz
      GoRoute(
        path: Routes.voiceChat,
        builder: (context, state) => const VoiceChatScreen(),
      ),
      
      // Tela de mapa com floriculturas (agora usando BLoC como padrão)
      GoRoute(
        path: Routes.map,
        builder: (context, state) => const MapScreen(), //Bloc(),
      ),
      
      // === ROTAS DE DESENVOLVIMENTO/TESTE ===
      // Mantidas temporariamente para compatibilidade
      
      // Tela de autenticação original (deprecated)
      GoRoute(
        path: Routes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      
      // Tela de configuração da planta original (deprecated)
      GoRoute(
        path: Routes.plantConfigBloc,
        builder: (context, state) => const PlantConfigScreen(),
      ),
      
      // Tela inicial original (deprecated)
      GoRoute(
        path: Routes.homeBloc,
        builder: (context, state) => const HomeScreen(),
      ),
      
      // Tela de mapa original (deprecated)  
      GoRoute(
        path: Routes.mapBloc,
        builder: (context, state) => const MapScreen(),
      ),
    ],
  );
} 