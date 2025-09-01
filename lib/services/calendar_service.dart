/**
 * File: calendar_service.dart
 * Description: Serviço para gerenciamento de fotos do calendário visual
 *
 * Responsabilidades:
 * - Gerenciar upload de fotos para Firebase Storage
 * - Salvar metadados das fotos no Firestore
 * - Carregar fotos por mês/ano
 * - Deletar fotos
 *
 * Author: Evelin Cordeiro
 * Created on: 31-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:metamorfose_flutter/models/calendar_photo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

/// Serviço para gerenciamento de fotos do calendário
class CalendarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Coleção de fotos do calendário
  CollectionReference<Map<String, dynamic>> get _photosCollection =>
      _firestore.collection('calendar_photos');

  /// Obter diretório para salvar fotos localmente (compatível com Web)
  Future<Directory> get _localPhotosDir async {
    if (kIsWeb) {
      // No Web, não usar diretórios locais
      throw UnsupportedError('Diretórios locais não suportados na Web');
    }

    final appDir = await getApplicationDocumentsDirectory();
    final photosPath = '${appDir.path}/calendar_photos';
    final photosDir = Directory(photosPath);
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }
    return photosDir;
  }

  /// Upload de uma foto para o calendário (salva localmente)
  Future<CalendarPhoto> uploadPhoto({
    required File imageFile,
    required DateTime date,
    String? description,
    String? plantId,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      // Salvar imagem localmente
      String localPath;
      try {
        if (kIsWeb) {
          // Na web, criar um identificador único para a imagem
          final fileName =
              '${user.uid}_${date.millisecondsSinceEpoch}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          localPath = fileName;
        } else {
          // No mobile, salvar no diretório local
          final photosDir = await _localPhotosDir;
          final fileName =
              '${user.uid}_${date.millisecondsSinceEpoch}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          localPath = '${photosDir.path}/$fileName';

          // Copiar arquivo para diretório local
          await imageFile.copy(localPath);
        }
      } catch (e) {
        // Fallback: usar um identificador único
        final fileName =
            '${user.uid}_${date.millisecondsSinceEpoch}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        localPath = fileName;
        print(
            'Aviso: Não foi possível salvar localmente, usando identificador único: $e');
      }

      // TEMPORÁRIO: Criar documento apenas localmente até resolver permissões do Firestore
      try {
        // Criar documento no Firestore
        final photoData = {
          'userId': user.uid,
          'date': Timestamp.fromDate(date),
          'imageUrl': localPath,
          'localPath': localPath,
          'description': description,
          'plantId': plantId,
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        };

        final docRef = await _photosCollection.add(photoData);
        final doc = await docRef.get();

        return CalendarPhoto.fromFirestore(doc);
      } catch (firestoreError) {
        // Se o Firestore falhar, criar um objeto local temporário
        print(
            'Aviso: Firestore falhou, usando armazenamento local temporário: $firestoreError');

        // Criar um ID único local
        final localId = 'local_${DateTime.now().millisecondsSinceEpoch}';

        // Criar objeto CalendarPhoto local
        return CalendarPhoto(
          id: localId,
          date: date,
          imageUrl: localPath,
          localPath: localPath,
          description: description,
          plantId: plantId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      throw Exception('Erro ao salvar foto: $e');
    }
  }

  /// Upload de uma foto a partir de bytes (para captura de tela)
  Future<CalendarPhoto> uploadPhotoFromBytes({
    required Uint8List imageBytes,
    required DateTime date,
    String? description,
    String? plantId,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      // Salvar imagem localmente
      String localPath;
      try {
        if (kIsWeb) {
          // Na web, criar um identificador único para a imagem
          final fileName =
              '${user.uid}_${date.millisecondsSinceEpoch}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          localPath = fileName;
        } else {
          // No mobile, salvar no diretório local
          final photosDir = await _localPhotosDir;
          final fileName =
              '${user.uid}_${date.millisecondsSinceEpoch}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          localPath = '${photosDir.path}/$fileName';

          // Salvar bytes como arquivo local
          final localFile = File(localPath);
          await localFile.writeAsBytes(imageBytes);
        }
      } catch (e) {
        // Fallback: usar um identificador único
        final fileName =
            '${user.uid}_${date.millisecondsSinceEpoch}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        localPath = fileName;
        print('Aviso: Usando identificador único para salvar imagem: $e');
      }

      // TEMPORÁRIO: Criar documento apenas localmente até resolver permissões do Firestore
      try {
        // Criar documento no Firestore
        final photoData = {
          'userId': user.uid,
          'date': Timestamp.fromDate(date),
          'imageUrl': localPath,
          'localPath': localPath,
          'description': description,
          'plantId': plantId,
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        };

        final docRef = await _photosCollection.add(photoData);
        final doc = await docRef.get();

        return CalendarPhoto.fromFirestore(doc);
      } catch (firestoreError) {
        // Se o Firestore falhar, criar um objeto local temporário
        print(
            'Aviso: Firestore falhou, usando armazenamento local temporário: $firestoreError');

        // Criar um ID único local
        final localId = 'local_${DateTime.now().millisecondsSinceEpoch}';

        // Criar objeto CalendarPhoto local
        return CalendarPhoto(
          id: localId,
          date: date,
          imageUrl: localPath,
          localPath: localPath,
          description: description,
          plantId: plantId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      throw Exception('Erro ao salvar foto: $e');
    }
  }

  /// Carregar fotos de um mês específico
  Future<List<CalendarPhoto>> loadPhotosForMonth({
    required int year,
    required int month,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0, 23, 59, 59);

      final querySnapshot = await _photosCollection
          .where('userId', isEqualTo: user.uid)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CalendarPhoto.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Erro ao carregar fotos do mês: $e');
    }
  }

  /// Carregar todas as fotos do usuário
  Future<List<CalendarPhoto>> loadAllPhotos() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      final querySnapshot = await _photosCollection
          .where('userId', isEqualTo: user.uid)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CalendarPhoto.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Erro ao carregar todas as fotos: $e');
    }
  }

  /// Carregar foto por ID
  Future<CalendarPhoto?> loadPhotoById(String photoId) async {
    try {
      final doc = await _photosCollection.doc(photoId).get();
      if (doc.exists) {
        return CalendarPhoto.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Erro ao carregar foto: $e');
    }
  }

  /// Atualizar descrição de uma foto
  Future<void> updatePhotoDescription({
    required String photoId,
    required String description,
  }) async {
    try {
      await _photosCollection.doc(photoId).update({
        'description': description,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Erro ao atualizar descrição: $e');
    }
  }

  /// Deletar uma foto
  Future<void> deletePhoto(String photoId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      // Buscar a foto para obter o caminho local
      final photo = await loadPhotoById(photoId);
      if (photo == null) {
        throw Exception('Foto não encontrada');
      }

      // Deletar do Firestore
      await _photosCollection.doc(photoId).delete();

      // Deletar do Storage (se possível)
      try {
        final imageRef = _storage.refFromURL(photo.imageUrl);
        await imageRef.delete();
      } catch (e) {
        // Se não conseguir deletar do storage, não falha a operação
        print('Aviso: Não foi possível deletar a imagem do storage: $e');
      }

      // Deletar do diretório local (apenas no mobile)
      if (!kIsWeb && photo.localPath != null) {
        final localFile = File(photo.localPath!);
        if (await localFile.exists()) {
          await localFile.delete();
        }
      }
    } catch (e) {
      throw Exception('Erro ao deletar foto: $e');
    }
  }

  /// Verificar se existe foto em uma data específica
  Future<bool> hasPhotoOnDate(DateTime date) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return false;
      }

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final querySnapshot = await _photosCollection
          .where('userId', isEqualTo: user.uid)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Obter foto de uma data específica
  Future<CalendarPhoto?> getPhotoOnDate(DateTime date) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return null;
      }

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final querySnapshot = await _photosCollection
          .where('userId', isEqualTo: user.uid)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return CalendarPhoto.fromFirestore(querySnapshot.docs.first);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
