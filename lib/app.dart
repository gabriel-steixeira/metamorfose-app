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
 * Last modified: 15-08-2025
 * Version: 1.2.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:metamorfose_flutter/blocs/auth_bloc.dart';
import 'package:metamorfose_flutter/services/hybrid_auth_service.dart';
import 'package:metamorfose_flutter/theme/theme.dart';
import 'package:metamorfose_flutter/navigation/app_router.dart';
import 'package:site24x7_flutter_plugin/site24x7_flutter_plugin.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MetamorfoseApp extends StatelessWidget {
  const MetamorfoseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authService: HybridAuthService()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Metamorfose',
        theme: MetamorfoseTheme.lightTheme,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('pt', 'BR'),
          Locale('en', 'US'),
        ],
        locale: const Locale('pt', 'BR'),
      ),
    );
  }
}
