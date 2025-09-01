/**
 * File: user_progress_service.dart
 * Description: Serviço para obter o progresso e fase atual do usuário
 *
 * Responsabilidades:
 * - Calcular progresso do usuário baseado em dados do Firestore
 * - Determinar fase atual da metamorfose
 * - Fornecer imagem da fase atual
 *
 * Author: Evelin Cordeiro
 * Created on: 31-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Fases da metamorfose
enum MetamorphosisPhase { egg, caterpillar, chrysalis, butterfly }

/// Serviço para progresso do usuário
class UserProgressService {
  /// Calcula o progresso do usuário baseado em dados do Firestore
  static Future<int> getUserProgress() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return 0;

      final firestore = FirebaseFirestore.instance;

      // Buscar dados do usuário
      final userDoc = await firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) return 0;

      final userData = userDoc.data()!;

      // Calcular progresso baseado em diferentes fatores
      int progress = 0;

      // Progresso baseado em dias desde o início (máximo 30%)
      if (userData['created_at'] != null) {
        final createdAt = (userData['created_at'] as Timestamp).toDate();
        final daysSinceCreation = DateTime.now().difference(createdAt).inDays;
        final daysProgress = (daysSinceCreation / 365 * 30).clamp(0, 30);
        progress += daysProgress.toInt();
      }

      // Progresso baseado em check-ins no calendário (máximo 40%)
      final calendarPhotos = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('calendar_photos')
          .get();

      final checkInsProgress =
          (calendarPhotos.docs.length / 100 * 40).clamp(0, 40);
      progress += checkInsProgress.toInt();

      // Progresso baseado em conversas no chat (máximo 30%)
      final chatMessages = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('chat_history')
          .get();

      final chatProgress = (chatMessages.docs.length / 50 * 30).clamp(0, 30);
      progress += chatProgress.toInt();

      return progress.clamp(0, 100);
    } catch (e) {
      debugPrint('Erro ao calcular progresso do usuário: $e');
      return 10; // Progresso padrão
    }
  }

  /// Determina a fase atual baseada no progresso
  static MetamorphosisPhase getPhaseByProgress(int progress) {
    if (progress < 25) {
      return MetamorphosisPhase.egg;
    } else if (progress < 50) {
      return MetamorphosisPhase.caterpillar;
    } else if (progress < 75) {
      return MetamorphosisPhase.chrysalis;
    } else {
      return MetamorphosisPhase.butterfly;
    }
  }

  /// Retorna a imagem da fase atual
  static String getPhaseImagePath(MetamorphosisPhase phase) {
    switch (phase) {
      case MetamorphosisPhase.egg:
        return 'assets/images/onboarding/ic_egg.png';
      case MetamorphosisPhase.caterpillar:
        return 'assets/images/onboarding/ic_caterpillar.png';
      case MetamorphosisPhase.chrysalis:
        return 'assets/images/onboarding/ic_chrysalis.png';
      case MetamorphosisPhase.butterfly:
        return 'assets/images/onboarding/ic_butterfly_transformation.png';
    }
  }

  /// Retorna o título da fase
  static String getPhaseTitle(MetamorphosisPhase phase) {
    switch (phase) {
      case MetamorphosisPhase.egg:
        return 'Ovo';
      case MetamorphosisPhase.caterpillar:
        return 'Lagarta';
      case MetamorphosisPhase.chrysalis:
        return 'Crisálida';
      case MetamorphosisPhase.butterfly:
        return 'Borboleta';
    }
  }
}
