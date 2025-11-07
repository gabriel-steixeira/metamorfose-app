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
 * Last modified: 31-08-2025
 * 
 * Changes:
 * - Adicionado Site24x7NavigatorObserver para o GoRouter. (Evelin Cordeiro)
 * - Adicionado Comunidade e Cuidados para o GoRouter. (Evelin Cordeiro)
 * 
 * Version: 2.1.0
 * Squad: Metamorfose
 */

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/routes/routes.dart';

// Telas principais (padrão BLoC)
import 'package:metamorfose_flutter/screens/auth/auth_screen.dart';
import 'package:metamorfose_flutter/screens/home/home.dart';
import 'package:metamorfose_flutter/screens/chat/chat_screen.dart';

import 'package:metamorfose_flutter/screens/map/map_screen_bloc.dart';
import 'package:metamorfose_flutter/screens/plant/plant_config_screen.dart';
import 'package:metamorfose_flutter/screens/community/community_screen.dart';
import 'package:metamorfose_flutter/screens/plant/plant_care_screen.dart';
import 'package:metamorfose_flutter/screens/profile/user_profile_screen.dart';
import 'package:metamorfose_flutter/screens/profile/update_profile_form.dart';
import 'package:metamorfose_flutter/screens/profile/change_password_screen.dart';
import 'package:metamorfose_flutter/screens/sos/sos_screen.dart';
import 'package:metamorfose_flutter/screens/calendar/calendar_screen.dart';
// Adicionar imports necessários para BlocProvider e BLoCs
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metamorfose_flutter/blocs/plant_config_bloc.dart';
import 'package:metamorfose_flutter/blocs/home_bloc.dart';
import 'package:metamorfose_flutter/blocs/community_bloc.dart';
import 'package:metamorfose_flutter/blocs/plant_care_bloc.dart';
import 'package:metamorfose_flutter/blocs/voice_chat_bloc.dart';
import 'package:metamorfose_flutter/blocs/sos_bloc.dart';
import 'package:metamorfose_flutter/blocs/calendar_bloc.dart';
import 'package:metamorfose_flutter/services/gemini_service.dart'
    show PersonalityType;
import 'package:metamorfose_flutter/blocs/psychologist_bloc.dart';
import 'package:metamorfose_flutter/screens/psychologist/psychologists_screen.dart';
import 'package:metamorfose_flutter/screens/psychologist/psychologist_profile_screen.dart';

// Telas de Onboarding
import 'package:metamorfose_flutter/screens/onboarding/onboarding_butterfly_screen.dart';
import 'package:metamorfose_flutter/screens/onboarding/onboarding_egg_screen.dart';
import 'package:metamorfose_flutter/screens/onboarding/onboarding_final_screen.dart';
import 'package:metamorfose_flutter/screens/onboarding/onboarding_plant_screen.dart';
import 'package:metamorfose_flutter/screens/onboarding/onboarding_screen.dart';
import 'package:metamorfose_flutter/screens/onboarding/onboarding_welcome_screen.dart';

// Telas de SelectionActivity
import 'package:metamorfose_flutter/screens/selectionactivity/selectionactivity_welcome_screen.dart';
import 'package:metamorfose_flutter/screens/selectionactivity/selectionactivity_questions_screen.dart';

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
      GoRoute(
        path: Routes.selectionActivityWelcome,
        builder: (context, state) => const SelectionActivityWelcomeScreen(),
      ),
      GoRoute(
        path: Routes.selectionActivityQuestions,
        builder: (context, state) => const SelectionActivityQuestionsScreen(),
      ),

      // Telas principais da aplicação (BLoC)
      GoRoute(
        path: Routes.auth,
        builder: (context, state) {
          final mode = state.uri.queryParameters['mode'];
          return AuthScreen(initialMode: mode);
        },
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
        path: Routes.chat,
        builder: (context, state) {
          // Extrair personalidade dos argumentos extras (não da URL)
          final personalityType = state.extra as PersonalityType?;

          debugPrint(
              "🎭 GoRouter - Argumentos extras recebidos: $personalityType");

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    VoiceChatBloc(initialPersonality: personalityType),
              ),
              BlocProvider(
                create: (context) => PlantCareBloc(),
              ),
            ],
            child: ChatScreen(initialPersonality: personalityType),
          );
        },
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

      // Telas de Perfil
      GoRoute(
        path: Routes.userProfile,
        builder: (context, state) => const UserProfileScreen(),
      ),
      GoRoute(
        path: Routes.updateProfile,
        builder: (context, state) => const UpdateProfileForm(),
      ),
      GoRoute(
        path: Routes.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: Routes.sos,
        builder: (context, state) => BlocProvider(
          create: (_) => SosBloc(),
          child: const SosScreen(),
        ),
      ),
      GoRoute(
        path: Routes.psychologists,
        builder: (context, state) {
          final from = state.uri.queryParameters['from'];
          return BlocProvider(
            create: (_) => PsychologistBloc(),
            child: PsychologistsScreen(from: from),
          );
        },
      ),
      GoRoute(
        path: '${Routes.psychologists}/:id',
        builder: (context, state) {
          // Get the id from path segments
          final segments = state.uri.pathSegments;
          final id = segments.isNotEmpty ? segments.last : '';

          // Get the from parameter
          final from = state.uri.queryParameters['from'];

          return PsychologistProfileScreen(id: id, from: from);
        },
      ),
      GoRoute(
        path: Routes.calendar,
        builder: (context, state) => BlocProvider(
          create: (_) => CalendarBloc(),
          child: const CalendarScreen(),
        ),
      ),
    ],
  );
}
