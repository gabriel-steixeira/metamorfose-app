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
import 'package:conversao_flutter/navigation/app_router.dart';
import 'package:conversao_flutter/theme/theme.dart';

/// Classe principal do aplicativo.
/// Define o tema e a navegação do aplicativo.
class MetamorfeseApp extends StatelessWidget {
  const MetamorfeseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Metamorfose',
      theme: MetamorfoseTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
} 