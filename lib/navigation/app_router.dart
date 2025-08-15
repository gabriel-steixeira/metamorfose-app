/**
 * File: app_router.dart
 * Description: Configuração central de rotas do aplicativo Metamorfose.
 *
 * Responsabilidades:
 * - Definir a estrutura de navegação com GoRouter.
 * - Mapear todas as rotas para as telas correspondentes.
 * - Garantir que todas as rotas principais usem as implementações com BLoC.
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 06-08-2025
 * 
 * Changes:
 * - Adicionado Site24x7NavigatorObserver para o GoRouter. (Evelin Cordeiro)
 * - Adicionado Comunidade e Cuidados para o GoRouter. (Evelin Cordeiro)
 * 
 * Version: 2.1.0
 * Squad: Metamorfose
 */

import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/routes/routes.dart';

// Telas principais (padrão BLoC)
import 'package:metamorfose_flutter/screens/auth/auth_screen.dart';
import 'package:metamorfose_flutter/screens/home/home.dart';
import 'package:metamorfose_flutter/screens/chat/voice_chat_screen.dart';
import 'package:metamorfose_flutter/screens/chat/text_chat_screen.dart';
import 'package:metamorfose_flutter/screens/map/map_screen_bloc.dart';
import 'package:metamorfose_flutter/screens/plant/plant_config_screen.dart';
import 'package:metamorfose_flutter/screens/community/community_screen.dart';
import 'package:metamorfose_flutter/screens/plant/plant_care_screen.dart';
// Adicionar imports necessários para BlocProvider e BLoCs
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metamorfose_flutter/blocs/plant_config_bloc.dart';
import 'package:metamorfose_flutter/blocs/home_bloc.dart';
import 'package:metamorfose_flutter/blocs/community_bloc.dart';
import 'package:metamorfose_flutter/blocs/plant_care_bloc.dart';
import 'package:metamorfose_flutter/blocs/text_chat_bloc.dart';
import 'package:metamorfose_flutter/blocs/voice_chat_bloc.dart';
import 'package:metamorfose_flutter/services/gemini_service.dart';

// Telas de Onboarding
import 'package:metamorfose_flutter/screens/onboarding/onboarding_butterfly_screen.dart';
import 'package:metamorfose_flutter/screens/onboarding/onboarding_carousel_screen.dart';
import 'package:metamorfose_flutter/screens/onboarding/onboarding_egg_screen.dart';
import 'package:metamorfose_flutter/screens/onboarding/onboarding_final_screen.dart';
import 'package:metamorfose_flutter/screens/onboarding/onboarding_plant_screen.dart';
import 'package:metamorfose_flutter/screens/onboarding/onboarding_screen.dart';
import 'package:metamorfose_flutter/screens/onboarding/onboarding_welcome_screen.dart';

// Telas de Splash
import 'package:metamorfose_flutter/screens/splash/brand_splash_screen.dart';
import 'package:metamorfose_flutter/screens/splash/mascot_splash_screen.dart';
import 'package:site24x7_flutter_plugin/site24x7_flutter_plugin.dart';

/// Classe responsável pela configuração de rotas do aplicativo usando o GO Router.
/// Define todos os caminhos de navegação disponíveis no app.
class AppRouter {
  /// Router principal do aplicativo
  static final router = GoRouter(
    initialLocation: Routes.brandSplash,
    debugLogDiagnostics: true,
    observers: [
      Site24x7NavigatorObserver(),
    ],
    routes: [
      // Telas de Splash
      GoRoute(
        path: Routes.brandSplash,
        builder: (context, state) => const BrandSplashScreen(),
      ),
      GoRoute(
        path: Routes.mascotSplash,
        builder: (context, state) => const MascotSplashScreen(),
      ),

      // Telas de Onboarding
      GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.onboardingCarousel,
        builder: (context, state) => const OnboardingCarouselScreen(),
      ),
      GoRoute(
        path: Routes.onboardingWelcome,
        builder: (context, state) => const OnboardingWelcomeScreen(),
      ),
      GoRoute(
        path: Routes.onboardingPlant,
        builder: (context, state) => const OnboardingPlantScreen(),
      ),
      GoRoute(
        path: Routes.onboardingEgg,
        builder: (context, state) => const OnboardingEggScreen(),
      ),
      GoRoute(
        path: Routes.onboardingButterfly,
        builder: (context, state) => const OnboardingButterflyScreen(),
      ),
      GoRoute(
        path: Routes.onboardingFinal,
        builder: (context, state) => const OnboardingFinalScreen(),
      ),

      // Telas principais da aplicação (BLoC)
      GoRoute(
        path: Routes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: Routes.plantConfig,
        builder: (context, state) => BlocProvider(
          create: (_) => PlantConfigBloc(),
          child: const PlantConfigScreen(),
        ),
      ),
      GoRoute(
        path: Routes.home,
        builder: (context, state) => BlocProvider(
          create: (_) => HomeBloc(),
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: Routes.voiceChat,
        builder: (context, state) => BlocProvider(
          create: (context) => VoiceChatBloc(),
          child: const VoiceChatScreen(),
        ),
      ),
      GoRoute(
        path: Routes.textChat,
        builder: (context, state) => BlocProvider(
          create: (context) => TextChatBloc(GeminiService()),
          child: const TextChatScreen(),
        ),
      ),
      GoRoute(
        path: Routes.map,
        builder: (context, state) => const MapScreenBloc(),
      ),
      GoRoute(
        path: Routes.community,
        builder: (context, state) => BlocProvider(
          create: (_) => CommunityBloc(),
          child: const CommunityScreen(),
        ),
      ),
      GoRoute(
        path: Routes.plantCare,
        builder: (context, state) => BlocProvider(
          create: (_) => PlantCareBloc(),
          child: const PlantCareScreen(),
        ),
      ),
    ],
  );
}
