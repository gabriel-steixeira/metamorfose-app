/**
 * File: main.dart
 * Description: Ponto de entrada do aplicativo Metamorfose.
 *
 * Responsabilidades:
 * - Inicializar o aplicativo
 * - Configurar recursos globais
 * - Iniciar o widget raiz
 * - Inicializar notificações
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 15-07-2025
 * 
 * Changes:
 * - Adicionado Inicialização do Site24x7 APM. (Evelin Cordeiro)
 * 
 * Version: 1.1.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart'; // Import do Firebase
import 'package:metamorfose_flutter/app.dart';
import 'package:metamorfose_flutter/config/firebase_config.dart';
import 'package:metamorfose_flutter/services/notification_service.dart';
import 'package:site24x7_flutter_plugin/site24x7_flutter_plugin.dart';
import 'dart:ui';


/// Ponto de entrada do aplicativo Flutter
void main() async {
  // Inicializa o binding do Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Firebase
  await FirebaseConfig.initialize();
  
  // Define a orientação do aplicativo como apenas retrato
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Define a cor da barra de status e otimizações
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Inicializa o Site24x7 APM
  FlutterError.onError = ApmMobileapmFlutterPlugin.instance.captureFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    ApmMobileapmFlutterPlugin.instance.captureException(error, stack);
    return true;
  };
  ApmMobileapmFlutterPlugin.instance.startMonitoring("US_300058d81ed3d79b702f7391fe0979d2", 20);
  
  // Inicia o aplicativo
  runApp(const MetamorfoseApp());
} 