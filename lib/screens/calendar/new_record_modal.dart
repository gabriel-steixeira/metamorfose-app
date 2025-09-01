/**
 * File: new_record_modal.dart
 * Description: Modal para criar novo registro com foto e sentimentos
 *
 * Responsabilidades:
 * - Permitir upload de foto
 * - Seleção de sentimentos
 * - Seleção de motivos
 * - Validação antes de salvar
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
  Uint8List? _selectedImageBytes; // Para web
  String _selectedFeeling = '';
  String _selectedReason = '';
  final ImagePicker _picker = ImagePicker();

  // Estados de validação
  bool _showImageError = false;
  bool _showFeelingError = false;
  bool _showReasonError = false;

  // Opções de sentimentos
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

  // Opções de motivos
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
          // Na web, ler os bytes da imagem
          final bytes = await image.readAsBytes();
          setState(() {
            _selectedImageBytes = bytes;
            _selectedImage = null;
            _showImageError =
                false; // Limpar erro quando imagem for selecionada
          });
        } else {
          // No mobile, usar File
          setState(() {
            _selectedImage = File(image.path);
            _selectedImageBytes = null;
            _showImageError =
                false; // Limpar erro quando imagem for selecionada
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
      _showFeelingError =
          false; // Limpar erro quando sentimento for selecionado
    });
  }

  /// Seleciona motivo
  void _selectReason(String reason) {
    setState(() {
      _selectedReason = reason;
      _showReasonError = false; // Limpar erro quando motivo for selecionado
    });
  }

  /// Constrói widget de imagem
  Widget _buildImageWidget() {
    if (_selectedImageBytes != null) {
      // Na web, usar Image.memory
      return Image.memory(
        _selectedImageBytes!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (_selectedImage != null) {
      // No mobile, usar Image.file
      return Image.file(
        _selectedImage!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      // Placeholder
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
          ),
        ],
      );
    }
  }

  /// Salva o registro
  void _saveRecord() {
    bool hasError = false;

    // Validar imagem
    if (_selectedImage == null && _selectedImageBytes == null) {
      setState(() {
        _showImageError = true;
      });
      hasError = true;
    }

    // Validar sentimento
    if (_selectedFeeling.isEmpty) {
      setState(() {
        _showFeelingError = true;
      });
      hasError = true;
    }

    // Validar motivo
    if (_selectedReason.isEmpty) {
      setState(() {
        _showReasonError = true;
      });
      hasError = true;
    }

    if (hasError) {
      return;
    }

    // Chamar callback com os dados corretos
    widget.onSave(
        _selectedImageBytes, _selectedImage, _selectedFeeling, _selectedReason);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Barra de arrastar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: MetamorfoseColors.greyLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header com título
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      // Ícone da câmera
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: MetamorfoseColors.purpleLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Título
                      const Expanded(
                        child: Text(
                          'Novo Registro',
                          style: TextStyle(
                            fontFamily: 'DinNext',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: MetamorfoseColors.greyMedium,
                          ),
                        ),
                      ),
                      // Botão fechar
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: MetamorfoseColors.greyMedium,
                        ),
                      ),
                    ],
                  ),
                ),

                // Conteúdo
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Seção de foto
                        Row(
                          children: [
                            const Text(
                              'Foto da sua planta',
                              style: TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MetamorfoseColors.greyMedium,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '*',
                              style: TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MetamorfoseColors.redNormal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Área de upload
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              color: MetamorfoseColors.greyLightest2,
                              borderRadius: BorderRadius.circular(12),
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

                        // Mensagem de erro da imagem
                        if (_showImageError) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 16,
                                color: MetamorfoseColors.redNormal,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Selecione uma foto primeiro',
                                style: TextStyle(
                                  fontFamily: 'DinNext',
                                  fontSize: 12,
                                  color: MetamorfoseColors.redNormal,
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Seção de sentimentos
                        Row(
                          children: [
                            const Text(
                              'Como você está se sentindo hoje?',
                              style: TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MetamorfoseColors.greyMedium,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '*',
                              style: TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MetamorfoseColors.redNormal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Grid de sentimentos
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
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
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
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
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      feeling['label']!,
                                      style: TextStyle(
                                        fontFamily: 'DinNext',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Colors.white
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

                        // Mensagem de erro do sentimento
                        if (_showFeelingError) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 16,
                                color: MetamorfoseColors.redNormal,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Selecione como você está se sentindo',
                                style: TextStyle(
                                  fontFamily: 'DinNext',
                                  fontSize: 12,
                                  color: MetamorfoseColors.redNormal,
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 24),

                        // Seção de motivos
                        Row(
                          children: [
                            const Text(
                              'Por que você está se sentindo assim?',
                              style: TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MetamorfoseColors.greyMedium,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '*',
                              style: TextStyle(
                                fontFamily: 'DinNext',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MetamorfoseColors.redNormal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Grid de motivos
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
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
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : MetamorfoseColors.greyMedium,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Mensagem de erro do motivo
                        if (_showReasonError) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 16,
                                color: MetamorfoseColors.redNormal,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Selecione o motivo do seu sentimento',
                                style: TextStyle(
                                  fontFamily: 'DinNext',
                                  fontSize: 12,
                                  color: MetamorfoseColors.redNormal,
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // Botão salvar
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                          borderRadius: BorderRadius.circular(12),
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
                            fontSize: 15,
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
