/**
 * File: notification_service.dart
 * Description: Serviço para gerenciar notificações locais.
 *
 * Responsabilidades:
 * - Gerenciar permissões de notificação
 * - Exibir notificações locais
 * - Simular notificações de boas-vindas
 *
 * Author: Gabriel Teixeira
 * Created on: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Inicializa o serviço de notificações
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Configurar notificações locais
      await _setupLocalNotifications();
      
      _isInitialized = true;
      debugPrint('🔔 NotificationService inicializado com sucesso');
    } catch (e) {
      debugPrint('❌ Erro ao inicializar NotificationService: $e');
    }
  }

  /// Configurar notificações locais
  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('🔔 Notificação local tocada: ${response.payload}');
      },
    );

    // Solicitar permissões no Android 13+
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  /// Exibir notificação local
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int id = 0,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'metamorfose_channel',
      'Metamorfose Notifications',
      channelDescription: 'Notificações do aplicativo Metamorfose',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF6B46C1), // Cor roxa do tema
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Simular notificação de boas-vindas
  Future<void> showWelcomeNotification() async {
    if (!_isInitialized) {
      await initialize();
    }

    // Lista de mensagens de boas-vindas aleatórias
    final welcomeMessages = [
      {
        'title': '🌱 Bem-vindo de volta!',
        'body': 'Sua jornada de transformação continua hoje. Que tal cuidar da sua plantinha?'
      },
      {
        'title': '🦋 Parabéns por começar!',
        'body': 'Cada dia é uma nova oportunidade de crescer. Vamos juntos nessa metamorfose!'
      },
      {
        'title': '✨ Hora de brilhar!',
        'body': 'Sua planta está ansiosa para te ver. Que tal começar o dia com energia positiva?'
      },
      {
        'title': '🌟 Você é incrível!',
        'body': 'Lembre-se: pequenos passos levam a grandes transformações. Continue assim!'
      },
      {
        'title': '💚 Metamorfose em ação!',
        'body': 'Cada momento que você está aqui é um passo na direção certa. Orgulhe-se!'
      },
    ];

    // Selecionar mensagem aleatória
    final random = DateTime.now().millisecondsSinceEpoch % welcomeMessages.length;
    final message = welcomeMessages[random];

    // Aguardar um pouco para simular um comportamento mais natural
    await Future.delayed(const Duration(seconds: 2));

    // Mostrar notificação
    await _showLocalNotification(
      title: message['title']!,
      body: message['body']!,
      payload: 'welcome_home',
      id: 1001, // ID específico para notificações de boas-vindas
    );

    debugPrint('🔔 Notificação de boas-vindas enviada: ${message['title']}');
  }

  /// Simular notificação de motivação
  Future<void> showMotivationNotification() async {
    if (!_isInitialized) {
      await initialize();
    }

    await _showLocalNotification(
      title: '💪 Força e determinação!',
      body: 'Você está no caminho certo. Sua planta acredita em você!',
      payload: 'motivation',
      id: 1002,
    );
  }

  /// Simular notificação de cuidado com a planta
  Future<void> showPlantCareNotification() async {
    if (!_isInitialized) {
      await initialize();
    }

    await _showLocalNotification(
      title: '🌿 Sua planta precisa de você!',
      body: 'Que tal dar uma olhada em como ela está? Talvez seja hora de regá-la.',
      payload: 'plant_care',
      id: 1003,
    );
  }

  /// Verificar se as notificações estão habilitadas
  Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final androidImplementation = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.areNotificationsEnabled() ?? false;
    }
    return true; // Para iOS, assumimos que estão habilitadas
  }

  /// Solicitar permissões de notificação
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final androidImplementation = _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await androidImplementation?.requestNotificationsPermission() ?? false;
    }
    return true; // Para iOS, assumimos que estão habilitadas
  }

  /// Cancelar notificação específica
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Cancelar todas as notificações
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Dispose do serviço
  void dispose() {
    // Cleanup se necessário
  }
} 