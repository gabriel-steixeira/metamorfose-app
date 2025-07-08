/**
 * File: notification_service.dart
 * Description: Serviço para gerenciamento de push notifications com Firebase.
 *
 * Responsabilidades:
 * - Inicializar o Firebase Cloud Messaging (FCM)
 * - Solicitar permissões de notificação (iOS e Android)
 * - Lidar com notificações recebidas (foreground, background, terminated)
 * - Exibir notificações locais para mensagens em foreground
 * - Obter o token FCM do dispositivo
 *
 * Author: Gabriel Teixeira
 * Created on: 31-05-2025
 * Last modified: 31-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Lida com mensagens em background/terminated.
/// Deve ser uma função top-level (fora de qualquer classe).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Se você precisar fazer algo com a mensagem aqui (ex: salvar em storage),
  // certifique-se de inicializar os serviços necessários.
  // Ex: await Firebase.initializeApp();
  log('Handling a background message: ${message.messageId}');
}


class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  /// Canal para notificações Android.
  static const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'Notificações Importantes', // title
    description: 'Este canal é usado para notificações importantes.', // description
    importance: Importance.max,
  );


  /// Inicializa o serviço de notificações.
  static Future<void> initialize() async {
    try {
      // Configura o handler para mensagens em background
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Solicita permissões
      await _requestPermission();
      
      // Cria o canal Android e inicializa o plugin de notificações locais
      if (!kIsWeb) {
        await _localNotifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(_androidChannel);
        
        await _initializeLocalNotifications();
      }

      // Configura o handler para mensagens em foreground
      _configureForegroundHandler();

      // Configura o handler para quando o app é aberto a partir de uma notificação
      _configureOpenedAppHandler();

      // Obtém e imprime o token FCM para testes
      final token = await getToken();
      log('==============================================');
      log('FCM TOKEN: $token');
      log('==============================================');

    } catch (e) {
      log('Erro ao inicializar NotificationService: $e');
    }
  }

  /// Solicita permissão do usuário para receber notificações.
  static Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('Permissão de notificação concedida.');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      log('Permissão de notificação concedida provisoriamente.');
    } else {
      log('Permissão de notificação negada.');
    }
  }

  /// Inicializa o plugin de notificações locais.
  static Future<void> _initializeLocalNotifications() async {
    // Configurações para Android e iOS
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) async {
      // handler para iOS < 10
    });

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _localNotifications.initialize(initializationSettings);
  }

  /// Configura o listener para mensagens recebidas com o app em foreground.
  static void _configureForegroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Recebida mensagem em foreground: ${message.notification?.title}');
      
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // Se for uma notificação e tivermos detalhes para Android, exibe.
      if (notification != null && android != null && !kIsWeb) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: 'launch_background', // ou o nome do seu ícone
            ),
          ),
        );
      }
    });
  }

  /// Configura o listener para quando o app é aberto a partir de uma notificação.
  static void _configureOpenedAppHandler() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('App aberto a partir de uma notificação: ${message.messageId}');
      // Aqui você pode adicionar lógica para navegar para uma tela específica
      // com base no conteúdo da notificação.
      // Ex: navigatorKey.currentState?.pushNamed('/minha-rota', arguments: message.data);
    });
  }


  /// Obtém o token FCM do dispositivo.
  static Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      log('Erro ao obter token FCM: $e');
      return null;
    }
  }
} 