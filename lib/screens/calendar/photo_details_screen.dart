/// File: photo_details_screen.dart
/// Description: Tela de detalhes da foto do calendário
///
/// Responsabilidades:
/// - Exibir foto em tamanho grande
/// - Permitir editar descrição
/// - Permitir deletar foto
/// - Exibir dica da planta
///
/// Author: Assistant
/// Created on: 15-08-2025
/// Version: 1.0.0
/// Squad: Metamorfose

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
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

  BoxDecoration _getCardDecoration() {
    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return BoxDecoration(
      color: MetamorfoseColors.whiteLight,
      borderRadius: BorderRadius.circular(borderRadius),
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
  }

  Widget _buildHeader() {
    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 20.0),
        Condition.largerThan(name: TABLET, value: 28.0),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 18.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: SvgPicture.asset(
            'assets/images/arrow_back.svg',
            width: iconSize,
            height: iconSize,
          ),
        ),
        Expanded(
          child: Text(
            'Detalhes da Foto',
            style: TextStyle(
              fontFamily: 'DinNext',
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: MetamorfoseColors.greyMedium,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          onPressed: _showDeleteDialog,
          icon: Icon(
            Icons.delete_outline,
            color: MetamorfoseColors.redNormal,
            size: iconSize,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoImage() {
    final imageHeight = ResponsiveValue<double>(
      context,
      defaultValue: 300.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 250.0),
        Condition.largerThan(name: TABLET, value: 350.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return Container(
      width: double.infinity,
      height: imageHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: _buildImageWidget(imageHeight),
      ),
    );
  }

  Widget _buildImageWidget(double height) {
    try {
      if (widget.photo.imageBytes != null) {
        return Image.memory(
          widget.photo.imageBytes!,
          width: double.infinity,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPhotoPlaceholder(height);
          },
        );
      }

      if (widget.photo.localPath != null &&
          widget.photo.localPath!.isNotEmpty) {
        final file = File(widget.photo.localPath!);
        if (file.existsSync()) {
          return Image.file(
            file,
            width: double.infinity,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPhotoPlaceholder(height);
            },
          );
        }
      }

      return _buildPhotoPlaceholder(height);
    } catch (e) {
      print('Erro ao carregar foto: $e');
      return _buildPhotoPlaceholder(height);
    }
  }

  Widget _buildPhotoPlaceholder(double height) {
    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 64.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 48.0),
        Condition.largerThan(name: TABLET, value: 80.0),
      ],
    ).value;

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: MetamorfoseColors.purpleLight,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(
        Icons.photo,
        color: MetamorfoseColors.whiteLight,
        size: iconSize,
      ),
    );
  }

  Widget _buildPhotoInfo() {
    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 12.0),
      ],
    ).value;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: _getCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: MetamorfoseColors.purpleLight,
                size: iconSize,
              ),
              SizedBox(width: spacing),
              Text(
                'Data',
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(height: spacing),
          Text(
            DateFormat('dd/MM/yyyy', 'pt_BR').format(widget.photo.date),
            style: TextStyle(
              fontFamily: 'DinNext',
              fontSize: fontSize,
              color: MetamorfoseColors.greyMedium,
            ),
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: spacing * 2),
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: MetamorfoseColors.purpleLight,
                size: iconSize,
              ),
              SizedBox(width: spacing),
              Text(
                'Horário',
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(height: spacing),
          Text(
            DateFormat('HH:mm', 'pt_BR').format(widget.photo.date),
            style: TextStyle(
              fontFamily: 'DinNext',
              fontSize: fontSize,
              color: MetamorfoseColors.greyMedium,
            ),
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 12.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 12.0),
      ],
    ).value;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: _getCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description,
                color: MetamorfoseColors.purpleLight,
                size: iconSize,
              ),
              SizedBox(width: spacing),
              Text(
                'Descrição',
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              if (!_isEditing)
                IconButton(
                  onPressed: () => setState(() => _isEditing = true),
                  icon: Icon(
                    Icons.edit,
                    color: MetamorfoseColors.purpleNormal,
                    size: iconSize,
                  ),
                ),
            ],
          ),
          SizedBox(height: spacing),
          if (_isEditing) ...[
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Adicione uma descrição...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(
                    color: MetamorfoseColors.greyLightest2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(
                    color: MetamorfoseColors.purpleNormal,
                  ),
                ),
              ),
            ),
            SizedBox(height: spacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() => _isEditing = false);
                    _descriptionController.text =
                        widget.photo.description ?? '';
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      color: MetamorfoseColors.greyMedium,
                      fontSize: fontSize,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: spacing),
                ElevatedButton(
                  onPressed: _saveDescription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MetamorfoseColors.purpleNormal,
                    foregroundColor: MetamorfoseColors.whiteLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                  child: Text(
                    'Salvar',
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              widget.photo.description ?? 'Nenhuma descrição',
              style: TextStyle(
                fontFamily: 'DinNext',
                fontSize: fontSize,
                color: widget.photo.description != null
                    ? MetamorfoseColors.greyMedium
                    : MetamorfoseColors.greyLight,
                fontStyle: widget.photo.description != null
                    ? FontStyle.normal
                    : FontStyle.italic,
              ),
              textAlign: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlantTip() {
    if (widget.photo.tip == null || widget.photo.tip!.isEmpty) {
      return const SizedBox.shrink();
    }

    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 12.0),
      ],
    ).value;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: _getCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.eco,
                color: MetamorfoseColors.purpleLight,
                size: iconSize,
              ),
              SizedBox(width: spacing),
              Text(
                'Mensagem da sua Planta',
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(height: spacing * 1.5),
          Text(
            widget.photo.tip!,
            style: TextStyle(
              fontFamily: 'DinNext',
              fontSize: fontSize,
              color: MetamorfoseColors.greyMedium,
              height: 1.5,
            ),
            textAlign: TextAlign.start,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _saveDescription() {
    final newDescription = _descriptionController.text.trim();
    if (newDescription != widget.photo.description) {
      final fontSize = ResponsiveValue<double>(
        context,
        defaultValue: 16.0,
        conditionalValues: const [
          Condition.smallerThan(name: MOBILE, value: 14.0),
          Condition.largerThan(name: TABLET, value: 18.0),
        ],
      ).value;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Descrição atualizada com sucesso!',
            style: TextStyle(
              fontFamily: 'DinNext',
              fontSize: fontSize,
              color: MetamorfoseColors.whiteLight,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: MetamorfoseColors.greenNormal,
        ),
      );
    }
    setState(() => _isEditing = false);
  }

  void _showDeleteDialog() {
    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 18.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final contentFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Deletar foto',
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: MetamorfoseColors.greyMedium,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        content: Text(
          'Tem certeza que deseja deletar esta foto? Esta ação não pode ser desfeita.',
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: contentFontSize,
            color: MetamorfoseColors.greyMedium,
          ),
          textAlign: TextAlign.start,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontFamily: 'DinNext',
                color: MetamorfoseColors.greyMedium,
                fontSize: contentFontSize,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deletePhoto();
            },
            child: Text(
              'Deletar',
              style: TextStyle(
                fontFamily: 'DinNext',
                color: MetamorfoseColors.redNormal,
                fontWeight: FontWeight.bold,
                fontSize: contentFontSize,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _deletePhoto() {
    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Foto deletada com sucesso!',
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: fontSize,
            color: MetamorfoseColors.whiteLight,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: MetamorfoseColors.greenNormal,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    return Scaffold(
      backgroundColor: MetamorfoseColors.whiteLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: spacing),
              _buildPhotoImage(),
              SizedBox(height: spacing),
              _buildPhotoInfo(),
              SizedBox(height: spacing),
              _buildDescription(),
              SizedBox(height: spacing),
              _buildPlantTip(),
            ],
          ),
        ),
      ),
    );
  }
}
