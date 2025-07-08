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
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart'; // Import do Firebase
import 'package:conversao_flutter/app.dart';
import 'package:conversao_flutter/services/notification_service.dart';


/// Ponto de entrada do aplicativo Flutter
void main() async {
  // Inicializa o binding do Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Firebase ANTES de qualquer outro serviço que dependa dele
  await Firebase.initializeApp();
  
  // Inicializar serviço de notificações de forma segura
  try {
    // Agora o método é estático, não precisa mais instanciar
    await NotificationService.initialize();
  } catch (e) {
    debugPrint('⚠️ Erro ao inicializar NotificationService com Firebase: $e');
    debugPrint('⚠️ App continuará sem notificações');
  }
  
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
  
  // Inicia o aplicativo
  runApp(const MetamorfeseApp());
} 