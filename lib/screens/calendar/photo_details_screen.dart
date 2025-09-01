/**
 * File: photo_details_screen.dart
 * Description: Tela de detalhes da foto do calendário
 *
 * Responsabilidades:
 * - Exibir foto em tamanho grande
 * - Permitir editar descrição
 * - Permitir deletar foto
 * - Exibir dica da planta
 *
 * Author: Assistant
 * Created on: 15-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/models/calendar_photo.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Tela de detalhes da foto
class PhotoDetailsScreen extends StatefulWidget {
  final CalendarPhoto photo;

  const PhotoDetailsScreen({
    super.key,
    required this.photo,
  });

  @override
  State<PhotoDetailsScreen> createState() => _PhotoDetailsScreenState();
}

class _PhotoDetailsScreenState extends State<PhotoDetailsScreen> {
  late TextEditingController _descriptionController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.photo.description ?? '',
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  /// Retorna o BoxDecoration padrão com shadow para os cards
  BoxDecoration get _cardDecoration => BoxDecoration(
        color: MetamorfoseColors.whiteLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: MetamorfoseColors.greyLightest2,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: MetamorfoseColors.defaultButtonShadow,
            blurRadius: 0,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      );

  /// Constrói o header da tela
  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: SvgPicture.asset(
            'assets/images/arrow_back.svg',
            width: 24,
            height: 24,
          ),
        ),
        Expanded(
          child: Text(
            'Detalhes da Foto',
            style: const TextStyle(
              fontFamily: 'DinNext',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MetamorfoseColors.greyMedium,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          onPressed: _showDeleteDialog,
          icon: const Icon(
            Icons.delete_outline,
            color: MetamorfoseColors.redNormal,
            size: 24,
          ),
        ),
      ],
    );
  }

  /// Constrói a imagem da foto
  Widget _buildPhotoImage() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _buildImageWidget(),
      ),
    );
  }

  /// Constrói o widget da imagem baseado na plataforma
  Widget _buildImageWidget() {
    try {
      // Priorizar bytes da imagem (para web)
      if (widget.photo.imageBytes != null) {
        return Image.memory(
          widget.photo.imageBytes!,
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPhotoPlaceholder();
          },
        );
      }

      // Fallback para arquivo local (mobile)
      if (widget.photo.localPath != null &&
          widget.photo.localPath!.isNotEmpty) {
        final file = File(widget.photo.localPath!);
        if (file.existsSync()) {
          return Image.file(
            file,
            width: double.infinity,
            height: 300,
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
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: MetamorfoseColors.purpleLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.photo,
        color: Colors.white,
        size: 64,
      ),
    );
  }

  /// Constrói informações da foto
  Widget _buildPhotoInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: MetamorfoseColors.purpleLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Data',
                style: const TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('dd/MM/yyyy', 'pt_BR').format(widget.photo.date),
            style: const TextStyle(
              fontFamily: 'DinNext',
              fontSize: 16,
              color: MetamorfoseColors.greyMedium,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: MetamorfoseColors.purpleLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Horário',
                style: const TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('HH:mm', 'pt_BR').format(widget.photo.date),
            style: const TextStyle(
              fontFamily: 'DinNext',
              fontSize: 16,
              color: MetamorfoseColors.greyMedium,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói seção de descrição
  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description,
                color: MetamorfoseColors.purpleLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Descrição',
                style: const TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
              ),
              const Spacer(),
              if (!_isEditing)
                IconButton(
                  onPressed: () => setState(() => _isEditing = true),
                  icon: const Icon(
                    Icons.edit,
                    color: MetamorfoseColors.purpleNormal,
                    size: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (_isEditing) ...[
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Adicione uma descrição...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: MetamorfoseColors.greyLightest2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: MetamorfoseColors.purpleNormal,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() => _isEditing = false);
                    _descriptionController.text =
                        widget.photo.description ?? '';
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      color: MetamorfoseColors.greyMedium,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveDescription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MetamorfoseColors.purpleNormal,
                    foregroundColor: MetamorfoseColors.whiteLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Salvar',
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              widget.photo.description ?? 'Nenhuma descrição',
              style: TextStyle(
                fontFamily: 'DinNext',
                fontSize: 16,
                color: widget.photo.description != null
                    ? MetamorfoseColors.greyMedium
                    : MetamorfoseColors.greyLight,
                fontStyle: widget.photo.description != null
                    ? FontStyle.normal
                    : FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Constrói seção de mensagem da planta
  Widget _buildPlantTip() {
    if (widget.photo.tip == null || widget.photo.tip!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.eco,
                color: MetamorfoseColors.purpleLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Mensagem da sua Planta',
                style: const TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.photo.tip!,
            style: const TextStyle(
              fontFamily: 'DinNext',
              fontSize: 16,
              color: MetamorfoseColors.greyMedium,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Salva a descrição
  void _saveDescription() {
    final newDescription = _descriptionController.text.trim();
    if (newDescription != widget.photo.description) {
      // TODO: Implementar atualização da descrição
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Descrição atualizada com sucesso!'),
          backgroundColor: MetamorfoseColors.greenNormal,
        ),
      );
    }
    setState(() => _isEditing = false);
  }

  /// Mostra diálogo de confirmação para deletar
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Deletar foto',
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MetamorfoseColors.greyMedium,
          ),
        ),
        content: const Text(
          'Tem certeza que deseja deletar esta foto? Esta ação não pode ser desfeita.',
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: 16,
            color: MetamorfoseColors.greyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                fontFamily: 'DinNext',
                color: MetamorfoseColors.greyMedium,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deletePhoto();
            },
            child: const Text(
              'Deletar',
              style: TextStyle(
                fontFamily: 'DinNext',
                color: MetamorfoseColors.redNormal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Deleta a foto
  void _deletePhoto() {
    // TODO: Implementar deleção da foto
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Foto deletada com sucesso!'),
        backgroundColor: MetamorfoseColors.greenNormal,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MetamorfoseColors.whiteLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 16),

              // Imagem da foto
              _buildPhotoImage(),

              const SizedBox(height: 16),

              // Informações da foto
              _buildPhotoInfo(),

              const SizedBox(height: 16),

              // Descrição
              _buildDescription(),

              const SizedBox(height: 16),

              // Dica da planta
              _buildPlantTip(),
            ],
          ),
        ),
      ),
    );
  }
}
