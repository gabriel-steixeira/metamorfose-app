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
<<<<<<< Updated upstream
import 'package:metamorfose_flutter/routes/routes.dart';

// Telas principais (padrão BLoC)
import 'package:metamorfose_flutter/screens/auth/auth_screen.dart';
import 'package:metamorfose_flutter/screens/home/home.dart';
import 'package:metamorfose_flutter/screens/chat/voice_chat_screen.dart';
import 'package:metamorfose_flutter/screens/map/map_screen_bloc.dart';
import 'package:metamorfose_flutter/screens/plant/plant_config_screen.dart';
import 'package:metamorfose_flutter/screens/community/community_screen.dart';
import 'package:metamorfose_flutter/screens/plant/plant_care_screen.dart';
// Adicionar imports necessários para BlocProvider e PlantConfigBloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metamorfose_flutter/blocs/plant_config_bloc.dart';
import 'package:metamorfose_flutter/blocs/home_bloc.dart';
import 'package:metamorfose_flutter/blocs/community_bloc.dart';
import 'package:metamorfose_flutter/blocs/plant_care_bloc.dart';

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
=======
import 'package:conversao_flutter/routes/routes.dart';
 import 'package:conversao_flutter/screens/auth/auth_screen.dart';
//import 'package:conversao_flutter/screens/auth/register_screen.dart';
import 'package:conversao_flutter/screens/home/home.dart';
//import 'package:conversao_flutter/screens/home/home_screen_bloc.dart';


import 'package:conversao_flutter/screens/test/live_api_test_screen.dart';
import 'package:conversao_flutter/screens/test/simple_gemini_test_screen.dart';
import 'package:conversao_flutter/screens/chat/plant_consciousness_chat_screen.dart';
import 'package:conversao_flutter/screens/chat/plant_live_chat_screen.dart';

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
>>>>>>> Stashed changes


/// Classe responsável pela configuração de rotas do aplicativo usando o GO Router.
/// Define todos os caminhos de navegação disponíveis no app.
class AppRouter {
  /// Router principal do aplicativo
  static final router = GoRouter(
    initialLocation: Routes.plantConsciousnessChat,
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
<<<<<<< Updated upstream

      // Telas principais da aplicação (BLoC)
=======
      
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
      

      
      // Tela de teste da Live API
      GoRoute(
        path: Routes.liveApiTest,
        builder: (context, state) => const LiveApiTestScreen(),
      ),
      
      // Tela de teste simples do Gemini
      GoRoute(
        path: Routes.simpleGeminiTest,
        builder: (context, state) => const SimpleGeminiTestScreen(),
      ),
      
      // Tela de chat completa com áudio
      GoRoute(
        path: Routes.plantConsciousnessChat,
        builder: (context, state) => const PlantConsciousnessChatScreen(),
      ),
      
      // Tela de chat Live API (modo streaming)
      GoRoute(
        path: Routes.plantLiveChat,
        builder: (context, state) => const PlantLiveChatScreen(),
      ),
      
      // Tela de mapa com floriculturas (agora usando BLoC como padrão)
      GoRoute(
        path: Routes.map,
        builder: (context, state) => const MapScreen(), //Bloc(),
      ),
      

      
      // === ROTAS DE DESENVOLVIMENTO/TESTE ===
      // Mantidas temporariamente para compatibilidade
      
      // Tela de autenticação original (deprecated)
>>>>>>> Stashed changes
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
        builder: (context, state) => const VoiceChatScreen(),
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
