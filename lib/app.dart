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
import 'package:metamorfose_flutter/blocs/auth_bloc.dart';
import 'package:metamorfose_flutter/services/auth_service.dart';
import 'package:metamorfose_flutter/theme/theme.dart';
import 'package:metamorfose_flutter/navigation/app_router.dart';

class MetamorfoseApp extends StatelessWidget {
  const MetamorfoseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authService: AuthService()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Metamorfose',
        theme: MetamorfoseTheme.lightTheme,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
} 