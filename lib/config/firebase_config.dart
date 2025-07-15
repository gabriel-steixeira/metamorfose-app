import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao inicializar Firebase: $e');
      }
    }
  }
}

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: "AIzaSyBIU8eVLfB1n7E9FeBgNzYAkHHKZsx5_wc",
        authDomain: "metamorfose-d7aa5.firebaseapp.com",
        projectId: "metamorfose-d7aa5",
        storageBucket: "metamorfose-d7aa5.firebasestorage.app",
        messagingSenderId: "163566256556",
        appId: "1:163566256556:web:32310d68653ef365dfba09"
      );
    }

    throw UnsupportedError(
      'Plataforma não suportada. Configure as opções do Firebase para ${defaultTargetPlatform.toString()}',
    );
  }
} 