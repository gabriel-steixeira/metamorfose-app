/**
 * File: app.dart
 * Description: Widget principal do aplicativo Metamorfose.
 *
 * Responsabilidades:
 * - Configurar o tema do aplicativo
 * - Definir as rotas do aplicativo
 * - Inicializar o aplicativo
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conversao_flutter/navigation/app_router.dart';
import 'package:conversao_flutter/theme/theme.dart';
import 'package:conversao_flutter/blocs/auth_bloc.dart';
import 'package:conversao_flutter/blocs/map_bloc.dart';
import 'package:conversao_flutter/blocs/home_bloc.dart';
import 'package:conversao_flutter/blocs/plant_config_bloc.dart';
import 'package:conversao_flutter/blocs/voice_chat_bloc.dart';
import 'package:conversao_flutter/services/auth_service.dart';
import 'package:conversao_flutter/services/map_service.dart';
import 'package:conversao_flutter/services/home_service.dart';
import 'package:conversao_flutter/services/plant_config_service.dart';
import 'package:conversao_flutter/services/voice_chat_service.dart';

/// Classe principal do aplicativo.
/// Define o tema e a navegação do aplicativo.
class MetamorfeseApp extends StatelessWidget {
  const MetamorfeseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(AuthService())),
        BlocProvider(create: (context) => MapBloc(MapService())),
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(create: (context) => PlantConfigBloc(service: PlantConfigService())),
        BlocProvider(create: (context) => VoiceChatBloc(service: VoiceChatService())),
      ],
      child: MaterialApp.router(
        title: 'Metamorfose',
        theme: MetamorfoseTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
} 