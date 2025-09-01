/**
 * File: local_photo_storage.dart
 * Description: Serviço para armazenamento local de fotos do calendário
 *
 * Responsabilidades:
 * - Armazenar fotos em memória
 * - Persistir dados básicos das fotos
 * - Gerenciar acesso às fotos salvas
 *
 * Author: Evelin Cordeiro
 * Created on: 31-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:metamorfose_flutter/models/calendar_photo.dart';

/// Serviço para armazenamento local de fotos
class LocalPhotoStorage {
  static const String _storageKey = 'calendar_photos';
  static final Map<String, CalendarPhoto> _photosInMemory = {};

  /// Adiciona uma foto ao armazenamento local
  static Future<void> addPhoto(CalendarPhoto photo) async {
    _photosInMemory[photo.id] = photo;
    await _persistPhotos();
  }

  /// Remove uma foto do armazenamento local
  static Future<void> removePhoto(String photoId) async {
    _photosInMemory.remove(photoId);
    await _persistPhotos();
  }

  /// Obtém todas as fotos
  static List<CalendarPhoto> getAllPhotos() {
    return _photosInMemory.values.toList();
  }

  /// Obtém fotos de um mês específico
  static List<CalendarPhoto> getPhotosForMonth(int year, int month) {
    return _photosInMemory.values.where((photo) {
      return photo.date.year == year && photo.date.month == month;
    }).toList();
  }

  /// Verifica se há foto em uma data específica
  static bool hasPhotoOnDate(DateTime date) {
    return _photosInMemory.values.any((photo) {
      return photo.date.year == date.year &&
          photo.date.month == date.month &&
          photo.date.day == date.day;
    });
  }

  /// Obtém foto de uma data específica
  static CalendarPhoto? getPhotoOnDate(DateTime date) {
    try {
      return _photosInMemory.values.firstWhere((photo) {
        return photo.date.year == date.year &&
            photo.date.month == date.month &&
            photo.date.day == date.day;
      });
    } catch (e) {
      return null;
    }
  }

  /// Obtém foto por ID
  static CalendarPhoto? getPhotoById(String photoId) {
    return _photosInMemory[photoId];
  }

  /// Carrega fotos do armazenamento persistente
  static Future<void> loadPhotos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final photosJson = prefs.getString(_storageKey);

      if (photosJson != null) {
        final List<dynamic> photosList = json.decode(photosJson);

        for (final photoData in photosList) {
          try {
            final photo = CalendarPhoto(
              id: photoData['id'],
              date: DateTime.parse(photoData['date']),
              imageUrl: photoData['imageUrl'],
              localPath: photoData['localPath'],
              description: photoData['description'],
              plantId: photoData['plantId'],
              createdAt: DateTime.parse(photoData['createdAt']),
              updatedAt: DateTime.parse(photoData['updatedAt']),
            );
            _photosInMemory[photo.id] = photo;
          } catch (e) {
            print('Erro ao carregar foto: $e');
          }
        }
      }
    } catch (e) {
      print('Erro ao carregar fotos do armazenamento local: $e');
    }
  }

  /// Persiste fotos no armazenamento local
  static Future<void> _persistPhotos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final photosList = _photosInMemory.values
          .map((photo) => {
                'id': photo.id,
                'date': photo.date.toIso8601String(),
                'imageUrl': photo.imageUrl,
                'localPath': photo.localPath,
                'description': photo.description,
                'plantId': photo.plantId,
                'createdAt': photo.createdAt.toIso8601String(),
                'updatedAt': photo.updatedAt.toIso8601String(),
              })
          .toList();

      final photosJson = json.encode(photosList);
      await prefs.setString(_storageKey, photosJson);
    } catch (e) {
      print('Erro ao persistir fotos: $e');
    }
  }

  /// Limpa todas as fotos
  static Future<void> clearAllPhotos() async {
    _photosInMemory.clear();
    await _persistPhotos();
  }

  /// Obtém estatísticas das fotos
  static Map<String, int> getPhotoStats() {
    final totalPhotos = _photosInMemory.length;
    final today = DateTime.now();
    final todayPhotos = _photosInMemory.values.where((photo) {
      return photo.date.year == today.year &&
          photo.date.month == today.month &&
          photo.date.day == today.day;
    }).length;

    return {
      'total': totalPhotos,
      'today': todayPhotos,
    };
  }
}
