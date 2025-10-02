/// File: new_record_modal.dart
/// Description: Modal para criar novo registro com foto e sentimentos
///
/// Responsabilidades:
/// - Permitir upload de foto
/// - Seleção de sentimentos
/// - Seleção de motivos
/// - Validação antes de salvar
///
/// Author: Assistant
/// Created on: 15-08-2025
/// Version: 1.0.0
/// Squad: Metamorfose

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metamorfose_flutter/theme/colors.dart';

/// Modal para criar novo registro
class NewRecordModal extends StatefulWidget {
  final DateTime selectedDate;
  final Function(
          Uint8List? imageBytes, File? imageFile, String feeling, String reason)
      onSave;

  const NewRecordModal({
    super.key,
    required this.selectedDate,
    required this.onSave,
  });

  @override
  State<NewRecordModal> createState() => _NewRecordModalState();
}

class _NewRecordModalState extends State<NewRecordModal> {
  File? _selectedImage;
  Uint8List? _selectedImageBytes;
  String _selectedFeeling = '';
  String _selectedReason = '';
  final ImagePicker _picker = ImagePicker();

  bool _showImageError = false;
  bool _showFeelingError = false;
  bool _showReasonError = false;

  final List<Map<String, String>> _feelings = [
    {'emoji': '😊', 'label': 'Feliz e contente'},
    {'emoji': '😌', 'label': 'Calmo e tranquilo'},
    {'emoji': '🤩', 'label': 'Empolgado e animado'},
    {'emoji': '😕', 'label': 'Confuso e indeciso'},
    {'emoji': '😢', 'label': 'Triste e melancólico'},
    {'emoji': '😟', 'label': 'Ansioso e preocupado'},
    {'emoji': '💪', 'label': 'Energético e motivado'},
    {'emoji': '🙏', 'label': 'Grato e agradecido'},
  ];

  final List<String> _reasons = [
    'Trabalho',
    'Saúde',
    'Finanças',
    'Relacionamentos',
    'Futuro',
    'Prazos',
    'Mudanças',
  ];

  /// Seleciona imagem da galeria
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _selectedImageBytes = bytes;
            _selectedImage = null;
            _showImageError = false;
          });
        } else {
          setState(() {
            _selectedImage = File(image.path);
            _selectedImageBytes = null;
            _showImageError = false;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao selecionar imagem: $e'),
          backgroundColor: MetamorfoseColors.redNormal,
        ),
      );
    }
  }

  /// Seleciona sentimento
  void _selectFeeling(String feeling) {
    setState(() {
      _selectedFeeling = feeling;
      _showFeelingError = false;
    });
  }

  /// Seleciona motivo
  void _selectReason(String reason) {
    setState(() {
      _selectedReason = reason;
      _showReasonError = false;
    });
  }

  /// Constrói widget de imagem
  Widget _buildImageWidget() {
    if (_selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo,
            size: 32,
            color: MetamorfoseColors.greyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Toque para selecionar uma foto',
            style: TextStyle(
              fontFamily: 'DinNext',
              fontSize: 14,
              color: MetamorfoseColors.greyMedium,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }
  }

  /// Salva o registro
  void _saveRecord() {
    bool hasError = false;

    if (_selectedImage == null && _selectedImageBytes == null) {
      setState(() {
        _showImageError = true;
      });
      hasError = true;
    }

    if (_selectedFeeling.isEmpty) {
      setState(() {
        _showFeelingError = true;
      });
      hasError = true;
    }

    if (_selectedReason.isEmpty) {
      setState(() {
        _showReasonError = true;
      });
      hasError = true;
    }

    if (hasError) {
      return;
    }

    widget.onSave(
        _selectedImageBytes, _selectedImage, _selectedFeeling, _selectedReason);

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

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
      ],
    ).value;

    final sectionFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
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

    final imageHeight = ResponsiveValue<double>(
      context,
      defaultValue: 120.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 100.0),
        Condition.largerThan(name: TABLET, value: 140.0),
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

    final smallIconSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final feelingFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 10.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 9.0),
        Condition.largerThan(name: TABLET, value: 12.0),
      ],
    ).value;

    final reasonFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final errorFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 14.0),
      ],
    ).value;

    final buttonFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 15.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final emojiSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final feelingsCrossAxisCount = ResponsiveValue<int>(
      context,
      defaultValue: 4,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 3),
        Condition.largerThan(name: TABLET, value: 5),
      ],
    ).value;

    final reasonsCrossAxisCount = ResponsiveValue<int>(
      context,
      defaultValue: 2,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 1),
        Condition.largerThan(name: TABLET, value: 3),
      ],
    ).value;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
            decoration: BoxDecoration(
              color: MetamorfoseColors.whiteLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius * 2),
                topRight: Radius.circular(borderRadius * 2),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: MetamorfoseColors.greyLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(padding),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MetamorfoseColors.purpleLight,
                          borderRadius: BorderRadius.circular(borderRadius * 0.67),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: MetamorfoseColors.whiteLight,
                          size: iconSize,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Novo Registro',
                          style: TextStyle(
                            fontFamily: 'DinNext',
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: MetamorfoseColors.greyMedium,
                          ),
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.close,
                          color: MetamorfoseColors.greyMedium,
                          size: iconSize,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Foto da sua planta',
                              style: TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: sectionFontSize,
                                fontWeight: FontWeight.bold,
                                color: MetamorfoseColors.greyMedium,
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '*',
                              style: TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: sectionFontSize,
                                fontWeight: FontWeight.bold,
                                color: MetamorfoseColors.redNormal,
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: double.infinity,
                            height: imageHeight,
                            decoration: BoxDecoration(
                              color: MetamorfoseColors.greyLightest2,
                              borderRadius: BorderRadius.circular(borderRadius),
                              border: Border.all(
                                color: _showImageError
                                    ? MetamorfoseColors.redNormal
                                    : MetamorfoseColors.greyLightest2,
                                width: _showImageError ? 2 : 1,
                              ),
                            ),
                            child: _buildImageWidget(),
                          ),
                        ),

                        if (_showImageError) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: smallIconSize,
                                color: MetamorfoseColors.redNormal,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Selecione uma foto primeiro',
                                style: TextStyle(
                                  fontFamily: 'DinNext',
                                  fontSize: errorFontSize,
                                  color: MetamorfoseColors.redNormal,
                                ),
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Text(
                              'Como você está se sentindo hoje?',
                              style: TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: sectionFontSize,
                                fontWeight: FontWeight.bold,
                                color: MetamorfoseColors.greyMedium,
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '*',
                              style: TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: sectionFontSize,
                                fontWeight: FontWeight.bold,
                                color: MetamorfoseColors.redNormal,
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: feelingsCrossAxisCount,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          itemCount: _feelings.length,
                          itemBuilder: (context, index) {
                            final feeling = _feelings[index];
                            final isSelected =
                                _selectedFeeling == feeling['label'];

                            return GestureDetector(
                              onTap: () => _selectFeeling(feeling['label']!),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? MetamorfoseColors.purpleNormal
                                      : MetamorfoseColors.whiteLight,
                                  borderRadius: BorderRadius.circular(borderRadius * 0.67),
                                  border: Border.all(
                                    color: _showFeelingError && !isSelected
                                        ? MetamorfoseColors.redNormal
                                        : isSelected
                                            ? MetamorfoseColors.purpleNormal
                                            : MetamorfoseColors.greyLightest2,
                                    width: _showFeelingError && !isSelected
                                        ? 2
                                        : 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      feeling['emoji']!,
                                      style: TextStyle(fontSize: emojiSize),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      feeling['label']!,
                                      style: TextStyle(
                                        fontFamily: 'DinNext',
                                        fontSize: feelingFontSize,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? MetamorfoseColors.whiteLight
                                            : MetamorfoseColors.greyMedium,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        if (_showFeelingError) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: smallIconSize,
                                color: MetamorfoseColors.redNormal,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Selecione como você está se sentindo',
                                style: TextStyle(
                                  fontFamily: 'DinNext',
                                  fontSize: errorFontSize,
                                  color: MetamorfoseColors.redNormal,
                                ),
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Text(
                              'Por que você está se sentindo assim?',
                              style: TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: sectionFontSize,
                                fontWeight: FontWeight.bold,
                                color: MetamorfoseColors.greyMedium,
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '*',
                              style: TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: sectionFontSize,
                                fontWeight: FontWeight.bold,
                                color: MetamorfoseColors.redNormal,
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: reasonsCrossAxisCount,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 3,
                          ),
                          itemCount: _reasons.length,
                          itemBuilder: (context, index) {
                            final reason = _reasons[index];
                            final isSelected = _selectedReason == reason;

                            return GestureDetector(
                              onTap: () => _selectReason(reason),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? MetamorfoseColors.purpleNormal
                                      : MetamorfoseColors.whiteLight,
                                  borderRadius: BorderRadius.circular(borderRadius * 0.67),
                                  border: Border.all(
                                    color: _showReasonError && !isSelected
                                        ? MetamorfoseColors.redNormal
                                        : isSelected
                                            ? MetamorfoseColors.purpleNormal
                                            : MetamorfoseColors.greyLightest2,
                                    width:
                                        _showReasonError && !isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    reason,
                                    style: TextStyle(
                                      fontFamily: 'DinNext',
                                      fontSize: reasonFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? MetamorfoseColors.whiteLight
                                          : MetamorfoseColors.greyMedium,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        if (_showReasonError) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: smallIconSize,
                                color: MetamorfoseColors.redNormal,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Selecione o motivo do seu sentimento',
                                style: TextStyle(
                                  fontFamily: 'DinNext',
                                  fontSize: errorFontSize,
                                  color: MetamorfoseColors.redNormal,
                                ),
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    color: MetamorfoseColors.whiteLight,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: _saveRecord,
                    child: Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: ShapeDecoration(
                        color: MetamorfoseColors.purpleNormal,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: MetamorfoseColors.purpleNormal,
                          ),
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        shadows: [
                          BoxShadow(
                            color: MetamorfoseColors.purpleDark,
                            blurRadius: 0,
                            offset: const Offset(0, 4),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'SALVAR REGISTRO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: MetamorfoseColors.whiteLight,
                            fontSize: buttonFontSize,
                            fontFamily: 'DinNext',
                            fontWeight: FontWeight.w700,
                            height: 1.27,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 1),
                                blurRadius: 15,
                                color: MetamorfoseColors.shadowText,
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
