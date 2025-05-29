/**
 * File: main.dart
 * Description: Ponto de entrada do aplicativo Metamorfose.
 *
 * Responsabilidades:
 * - Inicializar o aplicativo
 * - Configurar recursos globais
 * - Iniciar o widget raiz
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:conversao_flutter/app.dart';

/// Ponto de entrada do aplicativo Flutter
void main() async {
  // Inicializa o binding do Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Define a orientação do aplicativo como apenas retrato
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Define a cor da barra de status
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Inicia o aplicativo
  runApp(const MetamorfeseApp());
} 