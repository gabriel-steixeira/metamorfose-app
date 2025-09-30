/**
 * File: all_records_screen.dart
 * Description: Tela para exibir todos os registros do calendário
 *
 * Responsabilidades:
 * - Exibir lista de todos os registros
 * - Mostrar detalhes de cada registro
 * - Permitir navegação de volta
 *
 * Author: Assistant
 * Created on: 15-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/models/calendar_photo.dart';
import 'package:metamorfose_flutter/screens/calendar/photo_details_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Tela para exibir todos os registros
class AllRecordsScreen extends StatelessWidget {
  final List<CalendarPhoto> photos;

  const AllRecordsScreen({
    super.key,
    required this.photos,
  });

  /// Constrói widget da foto
  Widget _buildPhotoWidget(CalendarPhoto photo) {
    try {
      // Priorizar bytes da imagem (para web)
      if (photo.imageBytes != null) {
        return Image.memory(
          photo.imageBytes!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPhotoPlaceholder();
          },
        );
      }

      // Fallback para arquivo local (mobile)
      if (photo.localPath != null && photo.localPath!.isNotEmpty) {
        final file = File(photo.localPath!);
        if (file.existsSync()) {
          return Image.file(
            file,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPhotoPlaceholder();
            },
          );
        }
      }

      // Fallback para placeholder
      return _buildPhotoPlaceholder();
    } catch (e) {
      print('Erro ao carregar foto: $e');
      return _buildPhotoPlaceholder();
    }
  }

  /// Constrói placeholder para foto
  Widget _buildPhotoPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: MetamorfoseColors.purpleLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.photo,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: SvgPicture.asset(
            'assets/images/arrow_back.svg',
            width: 24,
            height: 24,
          ),
        ),
        title: const Text(
          'Todos os Registros',
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MetamorfoseColors.greyMedium,
          ),
        ),
        centerTitle: true,
      ),
      body: photos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 64,
                    color: MetamorfoseColors.greyLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum registro encontrado',
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      fontSize: 18,
                      color: MetamorfoseColors.greyMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adicione fotos ao seu calendário para vê-las aqui',
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      fontSize: 14,
                      color: MetamorfoseColors.greyLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                final dateFormat = DateFormat('dd/MM/yyyy');
                final timeFormat = DateFormat('HH:mm');

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PhotoDetailsScreen(photo: photo),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: MetamorfoseColors.whiteLight,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: MetamorfoseColors.defaultButtonShadow,
                          blurRadius: 0,
                          offset: const Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                      border: Border.all(
                        color: MetamorfoseColors.greyLightest2,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Foto
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildPhotoWidget(photo),
                          ),
                          const SizedBox(width: 16),

                          // Detalhes
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Data
                                Text(
                                  dateFormat.format(photo.date),
                                  style: const TextStyle(
                                    fontFamily: 'DinNext',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: MetamorfoseColors.blackLight,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // Horário
                                Text(
                                  timeFormat.format(photo.createdAt),
                                  style: const TextStyle(
                                    fontFamily: 'DinNext',
                                    fontSize: 14,
                                    color: MetamorfoseColors.greyMedium,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Descrição
                                if (photo.description != null &&
                                    photo.description!.isNotEmpty)
                                  Text(
                                    photo.description!,
                                    style: const TextStyle(
                                      fontFamily: 'DinNext',
                                      fontSize: 14,
                                      color: MetamorfoseColors.greyMedium,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),

                          // Ícone de seta
                          Icon(
                            Icons.chevron_right,
                            color: MetamorfoseColors.greyLight,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
