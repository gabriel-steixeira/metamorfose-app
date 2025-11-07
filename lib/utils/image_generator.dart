/**
 * File: image_generator.dart
 * Description: Utilitário para geração automática de imagens de placeholder com texto e emoji.
 *
 * Responsabilidades:
 * - Gerar imagens locais personalizadas para uso como avatares ou posts.
 * - Criar diretórios e salvar arquivos PNG automaticamente na pasta do projeto.
 * - Fornecer função para geração em massa de imagens de exemplo (mass data).
 *
 * Author: Evelin Cordeiro
 * Created on: 03-11-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as path;

/// Gera uma imagem de placeholder com texto e emoji
Future<String> generatePlaceholderImage(
  String fileName,
  String text,
  String emoji, {
  Color backgroundColor = Colors.blue,
  double width = 400,
  double height = 400,
}) async {
  // Criar um PictureRecorder para desenhar
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  // Configurar o fundo
  final paint = Paint()..color = backgroundColor;
  canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

  // Configurar o texto
  final textPainter = TextPainter(
    text: TextSpan(
      text: emoji + '\n' + text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 48,
        fontWeight: FontWeight.bold,
      ),
    ),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );

  textPainter.layout(maxWidth: width);

  // Desenhar o texto centralizado
  textPainter.paint(
    canvas,
    Offset(
      (width - textPainter.width) / 2,
      (height - textPainter.height) / 2,
    ),
  );

  // Finalizar a gravação
  final picture = recorder.endRecording();
  final image = await picture.toImage(width.toInt(), height.toInt());
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();

  // Salvar a imagem no diretório do projeto
  final directory = Directory.current;
  final imagesDir =
      Directory(path.join(directory.path, 'assets', 'images', 'massdata'));
  await imagesDir.create(recursive: true);

  final file = File(path.join(imagesDir.path, fileName));
  await file.writeAsBytes(pngBytes);

  return file.path;
}

/// Gera todas as imagens necessárias para o app
Future<void> generateSampleImages() async {
  final List<Map<String, dynamic>> imageConfigs = [
    {
      'fileName': 'post-1.jpg',
      'text': 'Progresso na terapia',
      'emoji': '🌱',
      'color': Colors.green[700],
    },
    {
      'fileName': 'user-2.jpg',
      'text': 'João',
      'emoji': '🧘‍♂️',
      'color': Colors.blue[700],
    },
    {
      'fileName': 'user-3.jpg',
      'text': 'Ana',
      'emoji': '🌿',
      'color': Colors.purple[700],
    },
    {
      'fileName': 'user-4.jpg',
      'text': 'Carla',
      'emoji': '🦋',
      'color': Colors.orange[700],
    },
    {
      'fileName': 'user-5.jpg',
      'text': 'Pedro',
      'emoji': '🐛',
      'color': Colors.pink[700],
    },
    {
      'fileName': 'user-6.jpg',
      'text': 'Amanda',
      'emoji': '🪺',
      'color': Colors.teal[700],
    },
    {
      'fileName': 'user-7.jpg',
      'text': 'Lucas',
      'emoji': '🥚',
      'color': Colors.indigo[700],
    },
    {
      'fileName': 'plant-progress.jpg',
      'text': 'Crescendo',
      'emoji': '🌿',
      'color': Colors.lightGreen[700],
    },
  ];

  for (var config in imageConfigs) {
    await generatePlaceholderImage(
      config['fileName'],
      config['text'],
      config['emoji'],
      backgroundColor: config['color'] ?? Colors.blue,
    );
  }
}
