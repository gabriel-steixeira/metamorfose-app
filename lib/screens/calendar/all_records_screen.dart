/// File: all_records_screen.dart
/// Description: Tela para exibir todos os registros do calendário
///
/// Responsabilidades:
/// - Exibir lista de todos os registros
/// - Mostrar detalhes de cada registro
/// - Permitir navegação de volta
///
/// Author: Ester Santos
/// Version: 1.0.0
/// Squad: Metamorfose

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
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

  /// Constrói widget da foto responsivo
  Widget _buildResponsivePhotoWidget(CalendarPhoto photo, double size) {
    try {
      // Priorizar bytes da imagem (para web)
      if (photo.imageBytes != null) {
        return Image.memory(
          photo.imageBytes!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildResponsivePhotoPlaceholder(size);
          },
        );
      }

      // Fallback para arquivo local (mobile)
      if (photo.localPath != null && photo.localPath!.isNotEmpty) {
        final file = File(photo.localPath!);
        if (file.existsSync()) {
          return Image.file(
            file,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildResponsivePhotoPlaceholder(size);
            },
          );
        }
      }

      // Fallback para placeholder
      return _buildResponsivePhotoPlaceholder(size);
    } catch (e) {
      // Log error in debug mode only
      if (kDebugMode) {
        print('Erro ao carregar foto: $e');
      }
      return _buildResponsivePhotoPlaceholder(size);
    }
  }

  /// Constrói placeholder responsivo para foto
  Widget _buildResponsivePhotoPlaceholder(double size) {
    final iconSize = size * 0.4; // 40% do tamanho da imagem
    final borderRadius = size * 0.15; // 15% do tamanho da imagem

    return Container(
      width: size,
      height: size,
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

  @override
  Widget build(BuildContext context) {
    // Valores responsivos
    final appBarFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 20.0),
        Condition.largerThan(name: TABLET, value: 28.0),
      ],
    ).value;

    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;


    return Scaffold(
      backgroundColor: MetamorfoseColors.whiteLight,
      appBar: AppBar(
        backgroundColor: MetamorfoseColors.whiteLight,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: SvgPicture.asset(
            'assets/images/arrow_back.svg',
            width: iconSize,
            height: iconSize,
          ),
        ),
        title: Text(
          'Todos os Registros',
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: appBarFontSize,
            fontWeight: FontWeight.bold,
            color: MetamorfoseColors.greyMedium,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
                    size: ResponsiveValue<double>(
                      context,
                      defaultValue: 64.0,
                      conditionalValues: const [
                        Condition.smallerThan(name: MOBILE, value: 48.0),
                        Condition.largerThan(name: TABLET, value: 80.0),
                      ],
                    ).value,
                    color: MetamorfoseColors.greyLight,
                  ),
                  SizedBox(height: ResponsiveValue<double>(
                    context,
                    defaultValue: 16.0,
                    conditionalValues: const [
                      Condition.smallerThan(name: MOBILE, value: 12.0),
                      Condition.largerThan(name: TABLET, value: 20.0),
                    ],
                  ).value),
                  Text(
                    'Nenhum registro encontrado',
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      fontSize: ResponsiveValue<double>(
                        context,
                        defaultValue: 18.0,
                        conditionalValues: const [
                          Condition.smallerThan(name: MOBILE, value: 16.0),
                          Condition.largerThan(name: TABLET, value: 20.0),
                        ],
                      ).value,
                      color: MetamorfoseColors.greyMedium,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveValue<double>(
                    context,
                    defaultValue: 8.0,
                    conditionalValues: const [
                      Condition.smallerThan(name: MOBILE, value: 6.0),
                      Condition.largerThan(name: TABLET, value: 10.0),
                    ],
                  ).value),
                  Text(
                    'Adicione fotos ao seu calendário para vê-las aqui',
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      fontSize: ResponsiveValue<double>(
                        context,
                        defaultValue: 14.0,
                        conditionalValues: const [
                          Condition.smallerThan(name: MOBILE, value: 12.0),
                          Condition.largerThan(name: TABLET, value: 16.0),
                        ],
                      ).value,
                      color: MetamorfoseColors.greyLight,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(horizontalPadding),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                final dateFormat = DateFormat('dd/MM/yyyy');
                final timeFormat = DateFormat('HH:mm');

                // Valores responsivos para os itens da lista
                final itemPadding = ResponsiveValue<double>(
                  context,
                  defaultValue: 16.0,
                  conditionalValues: const [
                    Condition.smallerThan(name: MOBILE, value: 12.0),
                    Condition.largerThan(name: TABLET, value: 20.0),
                  ],
                ).value;

                final itemMargin = ResponsiveValue<double>(
                  context,
                  defaultValue: 16.0,
                  conditionalValues: const [
                    Condition.smallerThan(name: MOBILE, value: 12.0),
                    Condition.largerThan(name: TABLET, value: 20.0),
                  ],
                ).value;

                final borderRadius = ResponsiveValue<double>(
                  context,
                  defaultValue: 16.0,
                  conditionalValues: const [
                    Condition.smallerThan(name: MOBILE, value: 12.0),
                    Condition.largerThan(name: TABLET, value: 20.0),
                  ],
                ).value;

                final imageBorderRadius = ResponsiveValue<double>(
                  context,
                  defaultValue: 12.0,
                  conditionalValues: const [
                    Condition.smallerThan(name: MOBILE, value: 8.0),
                    Condition.largerThan(name: TABLET, value: 16.0),
                  ],
                ).value;

                final imageSize = ResponsiveValue<double>(
                  context,
                  defaultValue: 80.0,
                  conditionalValues: const [
                    Condition.smallerThan(name: MOBILE, value: 60.0),
                    Condition.largerThan(name: TABLET, value: 100.0),
                  ],
                ).value;

                final titleFontSize = ResponsiveValue<double>(
                  context,
                  defaultValue: 16.0,
                  conditionalValues: const [
                    Condition.smallerThan(name: MOBILE, value: 14.0),
                    Condition.largerThan(name: TABLET, value: 18.0),
                  ],
                ).value;

                final subtitleFontSize = ResponsiveValue<double>(
                  context,
                  defaultValue: 14.0,
                  conditionalValues: const [
                    Condition.smallerThan(name: MOBILE, value: 12.0),
                    Condition.largerThan(name: TABLET, value: 16.0),
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

                final smallSpacing = ResponsiveValue<double>(
                  context,
                  defaultValue: 4.0,
                  conditionalValues: const [
                    Condition.smallerThan(name: MOBILE, value: 2.0),
                    Condition.largerThan(name: TABLET, value: 6.0),
                  ],
                ).value;

                final mediumSpacing = ResponsiveValue<double>(
                  context,
                  defaultValue: 8.0,
                  conditionalValues: const [
                    Condition.smallerThan(name: MOBILE, value: 6.0),
                    Condition.largerThan(name: TABLET, value: 10.0),
                  ],
                ).value;

                final iconSize = ResponsiveValue<double>(
                  context,
                  defaultValue: 24.0,
                  conditionalValues: const [
                    Condition.smallerThan(name: MOBILE, value: 20.0),
                    Condition.largerThan(name: TABLET, value: 28.0),
                  ],
                ).value;

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PhotoDetailsScreen(photo: photo),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: itemMargin),
                    decoration: BoxDecoration(
                      color: MetamorfoseColors.whiteLight,
                      borderRadius: BorderRadius.circular(borderRadius),
                      boxShadow: const [
                        BoxShadow(
                          color: MetamorfoseColors.defaultButtonShadow,
                          blurRadius: 0,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        ),
                      ],
                      border: Border.all(
                        color: MetamorfoseColors.greyLightest2,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(itemPadding),
                      child: Row(
                        children: [
                          // Foto
                          ClipRRect(
                            borderRadius: BorderRadius.circular(imageBorderRadius),
                            child: _buildResponsivePhotoWidget(photo, imageSize),
                          ),
                          SizedBox(width: spacing),

                          // Detalhes
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Data
                                Text(
                                  dateFormat.format(photo.date),
                                  style: TextStyle(
                                    fontFamily: 'DinNext',
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: MetamorfoseColors.blackLight,
                                  ),
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: smallSpacing),

                                // Horário
                                Text(
                                  timeFormat.format(photo.createdAt),
                                  style: TextStyle(
                                    fontFamily: 'DinNext',
                                    fontSize: subtitleFontSize,
                                    color: MetamorfoseColors.greyMedium,
                                  ),
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: mediumSpacing),

                                // Descrição
                                if (photo.description != null &&
                                    photo.description!.isNotEmpty)
                                  Text(
                                    photo.description!,
                                    style: TextStyle(
                                      fontFamily: 'DinNext',
                                      fontSize: subtitleFontSize,
                                      color: MetamorfoseColors.greyMedium,
                                    ),
                                    textAlign: TextAlign.start,
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
                            size: iconSize,
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
