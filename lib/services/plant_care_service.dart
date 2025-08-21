/**
 * File: plant_care_service.dart
 * Description: Serviço para gerenciamento de dados de cuidados da planta
 *
 * Responsabilidades:
 * - Carregar informações da planta
 * - Carregar tarefas do dia
 * - Gerenciar compartilhamento
 *
 * Author: Evelin Cordeiro
 * Created on: 06-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/theme/colors.dart';

/// Serviço para gerenciamento de dados de cuidados da planta
class PlantCareService {
  /// Carrega informações da planta do Firestore
  Future<Map<String, dynamic>> loadPlantInfo() async {
    try {
      // Obter usuário atual
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      final firestore = FirebaseFirestore.instance;
      
      // Buscar a primeira planta do usuário
      final querySnapshot = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('plant_info')
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Nenhuma planta encontrada');
      }

      final plantDoc = querySnapshot.docs.first;
      final plantData = plantDoc.data();
      
      // Converter timestamp para string formatada
      String startDate = 'N/A';
      if (plantData['start_date'] != null) {
        final timestamp = plantData['start_date'] as Timestamp;
        final date = timestamp.toDate();
        startDate = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      }

      // Mapear cor do vaso para nome
      String potColorName = 'Padrão';
      if (plantData['pot_color'] != null) {
        final colorValue = plantData['pot_color'];
        if (colorValue == MetamorfoseColors.purpleNormal.value) {
          potColorName = 'Roxo';
        } else if (colorValue == MetamorfoseColors.greenNormal.value) {
          potColorName = 'Verde';
        } else if (colorValue == MetamorfoseColors.blueNormal.value) {
          potColorName = 'Azul';
        } else if (colorValue == MetamorfoseColors.redNormal.value) {
          potColorName = 'Vermelho';
        }
      }

      // Mapear espécie para informações de cuidado
      final species = plantData['species'] ?? 'suculenta';
      Map<String, String> careInfo = _getCareInfoForSpecies(species);

      return {
        'name': plantData['name'] ?? 'Minha Planta',
        'species': _getSpeciesDisplayName(species),
        'startDate': startDate,
        'potColor': potColorName,
        'potColorValue': plantData['pot_color'], // Valor da cor para o SVG
        'icon': _getIconForSpecies(species),
        'location': careInfo['location'] ?? 'Ambiente interno',
        'sunlight': careInfo['sunlight'] ?? 'Luz indireta',
        'difficulty': careInfo['difficulty'] ?? 'Fácil',
        'humidity': careInfo['humidity'] ?? 'Moderada',
      };
    } catch (e) {
      debugPrint('Erro ao carregar informações da planta: $e');
      rethrow;
    }
  }

  /// Retorna informações de cuidado baseadas na espécie
  Map<String, String> _getCareInfoForSpecies(String species) {
    switch (species) {
      case 'suculenta':
        return {
          'location': 'Ambiente interno',
          'sunlight': 'Luz direta',
          'difficulty': 'Fácil',
          'humidity': 'Baixa',
        };
      case 'samambaia':
        return {
          'location': 'Ambiente úmido',
          'sunlight': 'Luz indireta',
          'difficulty': 'Médio',
          'humidity': 'Alta',
        };
      case 'cacto':
        return {
          'location': 'Ambiente seco',
          'sunlight': 'Luz direta',
          'difficulty': 'Fácil',
          'humidity': 'Muito baixa',
        };
      default:
        return {
          'location': 'Ambiente interno',
          'sunlight': 'Luz indireta',
          'difficulty': 'Fácil',
          'humidity': 'Moderada',
        };
    }
  }

  /// Retorna o nome de exibição da espécie
  String _getSpeciesDisplayName(String species) {
    switch (species) {
      case 'suculenta':
        return 'Suculenta';
      case 'samambaia':
        return 'Samambaia';
      case 'cacto':
        return 'Cacto';
      default:
        return 'Planta';
    }
  }

  /// Retorna o ícone para a espécie
  IconData _getIconForSpecies(String species) {
    switch (species) {
      case 'suculenta':
        return Icons.spa;
      case 'samambaia':
        return Icons.eco;
      case 'cacto':
        return Icons.park;
      default:
        return Icons.local_florist;
    }
  }

  /// Carrega tarefas do dia
  Future<List<dynamic>> loadTodayTasks() async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 1000));

    // Retorna tarefas mockadas
    return [
      {
        'type': 'water',
        'name': 'Regar',
        'icon': 'watering_can',
      },
      {
        'type': 'fertilize',
        'name': 'Fertilizar',
        'icon': 'fertilizer',
      },
    ];
  }

  /// Compartilha progresso
  Future<bool> shareProgress() async {
    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 1500));

    // Simular sucesso
    return true;
  }
}
