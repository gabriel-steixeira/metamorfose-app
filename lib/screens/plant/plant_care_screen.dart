/// File: plant_care_screen.dart
/// Description: Tela de cuidados da planta
///
/// Responsabilidades:
/// - Exibir informações da planta
/// - Exibir diário visual
/// - Exibir tarefas do dia
/// - Permitir tirar fotos e compartilhar progresso
/// - Usar BLoC pattern para gerenciamento de estado
///
/// Author: Evelin Cordeiro
/// Created on: 06-08-2025
/// Last modified: 31-08-2025
/// 
/// Changes:
/// - UI Ajustada. (Evelin Cordeiro)
/// 
/// 
/// Version: 1.0.0 (BLoC)
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/theme/text_styles.dart';
import 'package:metamorfose_flutter/components/bottom_navigation_menu.dart';
import 'package:metamorfose_flutter/components/custom_button.dart';
import 'package:metamorfose_flutter/blocs/plant_care_bloc.dart';
import 'package:metamorfose_flutter/state/plant_care/plant_care_state.dart';

/// Tela de cuidados da planta usando BLoC.
class PlantCareScreen extends StatefulWidget {
  const PlantCareScreen({super.key});

  @override
  State<PlantCareScreen> createState() => _PlantCareScreenState();
}

class _PlantCareScreenState extends State<PlantCareScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PlantCareBloc>().add(InitializePlantCareEvent());
  }

  /// Retorna o BoxDecoration padrão com shadow para os cards
  BoxDecoration _getCardDecoration(BuildContext context) {
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

  /// Retorna o caminho do SVG baseado na cor da planta
  String _getPlantSvgAsset(int? colorValue) {
    if (colorValue == MetamorfoseColors.blueNormal.value) {
      return 'assets/images/plantsetup/plantsetup_blue.svg';
    }
    if (colorValue == MetamorfoseColors.greenNormal.value) {
      return 'assets/images/plantsetup/plantsetup_green.svg';
    }
    if (colorValue == MetamorfoseColors.pinkNormal.value) {
      return 'assets/images/plantsetup/plantsetup_pink.svg';
    }
    return 'assets/images/plantsetup/plantsetup.svg';
  }

  /// Header
  Widget _buildPlantInfo(PlantCareState state) {
    if (state.isPlantInfoLoading) {
      return _buildLoadingCard();
    }

    if (state.plantInfoError != null) {
      return _buildErrorCard(state.plantInfoError!);
    }

    final plantInfo = state.plantInfo;
    if (plantInfo == null) {
      return _buildErrorCard('Nenhuma planta encontrada');
    }

    final cardPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final plantIconSize = ResponsiveValue<double>(
      context,
      defaultValue: 56.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 48.0),
        Condition.largerThan(name: TABLET, value: 64.0),
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

    final subtitleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
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

    final largeSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: _getCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: plantIconSize,
                height: plantIconSize,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  _getPlantSvgAsset(plantInfo['potColorValue']),
                  width: plantIconSize,
                  height: plantIconSize,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plantInfo['name'] ?? 'Minha Planta',
                      style: TextStyle(
                        fontFamily: 'DinNext',
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: MetamorfoseColors.greyMedium,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: smallSpacing),
                    Text(
                      plantInfo['species'] ?? 'Planta',
                      style: TextStyle(
                        fontFamily: 'DinNext',
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.normal,
                        color: MetamorfoseColors.greyMedium,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: largeSpacing),
          Container(
            height: 1,
            color: MetamorfoseColors.greyLightest2,
          ),
          SizedBox(height: spacing),
          Column(
            children: [
              _buildInfoRow(
                icon: Icons.calendar_today,
                label: 'Data de início',
                value: plantInfo['startDate'] ?? 'N/A',
              ),
              SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.palette,
                label: 'Cor do vaso',
                value: plantInfo['potColor'] ?? 'N/A',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Informações de cuidados
  Widget _buildCareInfo(PlantCareState state) {
    final plantInfo = state.plantInfo;
    if (plantInfo == null) {
      return const SizedBox.shrink();
    }

    final cardPadding = ResponsiveValue<double>(
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
        Condition.largerThan(name: TABLET, value: 22.0),
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
        Condition.largerThan(name: TABLET, value: 10.0),
      ],
    ).value;

    final verticalSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 8.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final horizontalSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: _getCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite,
                color: MetamorfoseColors.purpleLight,
                size: iconSize,
              ),
              SizedBox(width: spacing),
              Text(
                'Cuidados',
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: verticalSpacing),
          Row(
            children: [
              Expanded(
                child: _buildCareItem(
                  icon: Icons.location_on,
                  label: 'Localização',
                  value: plantInfo['location'] ?? 'N/A',
                ),
              ),
              SizedBox(width: horizontalSpacing),
              Expanded(
                child: _buildCareItem(
                  icon: Icons.wb_sunny,
                  label: 'Luz',
                  value: plantInfo['sunlight'] ?? 'N/A',
                ),
              ),
            ],
          ),
          SizedBox(height: verticalSpacing),
          Row(
            children: [
              Expanded(
                child: _buildCareItem(
                  icon: Icons.check_circle,
                  label: 'Dificuldade',
                  value: plantInfo['difficulty'] ?? 'N/A',
                ),
              ),
              SizedBox(width: horizontalSpacing),
              Expanded(
                child: _buildCareItem(
                  icon: Icons.water_drop,
                  label: 'Umidade',
                  value: plantInfo['humidity'] ?? 'N/A',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Diário visual
  Widget _buildVisualDiary(PlantCareState state) {
    final cardPadding = ResponsiveValue<double>(
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
        Condition.largerThan(name: TABLET, value: 22.0),
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

    final smallFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 10.0),
      ],
    ).value;

    final verticalSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 8.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final buttonPadding = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 10.0),
      ],
    ).value;

    final buttonIconSize = ResponsiveValue<double>(
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

    final emptyIconSize = ResponsiveValue<double>(
      context,
      defaultValue: 48.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 40.0),
        Condition.largerThan(name: TABLET, value: 56.0),
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

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: _getCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.camera_alt,
                color: MetamorfoseColors.purpleLight,
                size: iconSize,
              ),
              SizedBox(width: spacing),
              Text(
                'Diário Visual',
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => context.go('/calendar'),
                child: Container(
                  padding: EdgeInsets.all(buttonPadding),
                  decoration: BoxDecoration(
                    color: MetamorfoseColors.purpleLight,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: MetamorfoseColors.whiteLight,
                    size: buttonIconSize,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: verticalSpacing),
          Center(
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: emptyIconSize,
                    color: MetamorfoseColors.greyLight,
                  ),
                  SizedBox(height: spacing),
                  Text(
                    'Nenhuma foto ainda!',
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: MetamorfoseColors.greyMedium,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: smallSpacing),
                  Text(
                    'Tire a primeira foto do seu progresso! 📸🌱',
                    style: TextStyle(
                      fontFamily: 'DinNext',
                      fontSize: smallFontSize,
                      fontWeight: FontWeight.normal,
                      color: MetamorfoseColors.greyMedium,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Tarefas do dia
  Widget _buildTodayTasks(PlantCareState state) {
    final cardPadding = ResponsiveValue<double>(
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
        Condition.largerThan(name: TABLET, value: 22.0),
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
        Condition.largerThan(name: TABLET, value: 10.0),
      ],
    ).value;

    final verticalSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 8.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: _getCardDecoration(context),
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
                'Tarefa de hoje',
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.greyMedium,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ],
          ),
          SizedBox(height: verticalSpacing),
          if (state.isTodayTasksLoading)
            const Center(
              child: CircularProgressIndicator(
                color: MetamorfoseColors.purpleNormal,
              ),
            )
          else if (state.hasTodayTasks)
            _buildTasksList(state.todayTasks)
          else
            _buildEmptyTasks(),
        ],
      ),
    );
  }

  /// Linha de informação
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
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
        Condition.largerThan(name: TABLET, value: 10.0),
      ],
    ).value;

    return Row(
      children: [
        Icon(
          icon,
          color: MetamorfoseColors.purpleLight,
          size: iconSize,
        ),
        SizedBox(width: spacing),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: MetamorfoseColors.greyMedium,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: fontSize,
            fontWeight: FontWeight.normal,
            color: MetamorfoseColors.greyMedium,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
        ),
      ],
    );
  }

  /// Item de cuidado
  Widget _buildCareItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
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

    final smallFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 14.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 4.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 2.0),
        Condition.largerThan(name: TABLET, value: 6.0),
      ],
    ).value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: MetamorfoseColors.purpleLight,
              size: iconSize,
            ),
            SizedBox(width: spacing),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: MetamorfoseColors.greyMedium,
                fontFamily: 'DinNext',
                fontSize: smallFontSize,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ],
        ),
        SizedBox(height: spacing),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: fontSize,
            fontWeight: FontWeight.normal,
            color: MetamorfoseColors.greyMedium,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  /// Constrói lista de tarefas
  Widget _buildTasksList(List<dynamic> tasks) {
    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
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
        Condition.largerThan(name: TABLET, value: 10.0),
      ],
    ).value;

    return Row(
      children: tasks.asMap().entries.map((entry) {
        final task = entry.value;

        return Expanded(
          child: Row(
            children: [
              Icon(
                task['type'] == 'water' ? Icons.water_drop : Icons.eco,
                color: MetamorfoseColors.purpleLight,
                size: iconSize,
              ),
              SizedBox(width: spacing),
              Text(
                task['name'] ?? 'Tarefa',
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: fontSize,
                  fontWeight: FontWeight.normal,
                  color: MetamorfoseColors.greyMedium,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Constrói estado vazio de tarefas
  Widget _buildEmptyTasks() {
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
      defaultValue: 48.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 40.0),
        Condition.largerThan(name: TABLET, value: 56.0),
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

    final smallFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 10.0),
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

    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            Icon(
              Icons.task_alt,
              size: iconSize,
              color: MetamorfoseColors.greyLight,
            ),
            SizedBox(height: spacing),
            Text(
              'Nenhuma tarefa hoje!',
              style: TextStyle(
                fontFamily: 'DinNext',
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: MetamorfoseColors.greyMedium,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: smallSpacing),
            Text(
              'Sua planta está bem cuidada! 🌿✨',
              style: TextStyle(
                fontFamily: 'DinNext',
                fontSize: smallFontSize,
                fontWeight: FontWeight.normal,
                color: MetamorfoseColors.greyMedium,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Valores responsivos globais
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final cardSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final bottomSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 20.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    return BlocConsumer<PlantCareBloc, PlantCareState>(
      listener: (context, state) {
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: MetamorfoseColors.redNormal,
            ),
          );
          context.read<PlantCareBloc>().add(ClearErrorEvent());
        }

        if (state.hasSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: MetamorfoseColors.greenNormal,
            ),
          );
          context.read<PlantCareBloc>().add(ClearErrorEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MetamorfoseColors.whiteLight,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlantInfo(state),
                  SizedBox(height: cardSpacing),
                  _buildCareInfo(state),
                  SizedBox(height: cardSpacing),
                  _buildVisualDiary(state),
                  SizedBox(height: cardSpacing),
                  _buildTodayTasks(state),
                  SizedBox(height: bottomSpacing),
                  Container(
                    width: double.infinity,
                    child: CustomButton(
                      text: '+ COMPARTILHAR PROGRESSO',
                      onPressed: state.isSharingProgress
                          ? () {}
                          : () => context
                              .read<PlantCareBloc>()
                              .add(ShareProgressEvent()),
                      backgroundColor: MetamorfoseColors.greenNormal,
                      textColor: MetamorfoseColors.whiteLight,
                      shadowColor: MetamorfoseColors.greenDarken,
                      strokeColor: MetamorfoseColors.greenNormal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationMenu(
            activeIndex: 2,
          ),
        );
      },
    );
  }

  /// Constrói card de loading
  Widget _buildLoadingCard() {
    final cardPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: _getCardDecoration(context),
      child: const Center(
        child: CircularProgressIndicator(
          color: MetamorfoseColors.purpleNormal,
        ),
      ),
    );
  }

  /// Constrói card de erro
  Widget _buildErrorCard(String message) {
    final cardPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: _getCardDecoration(context).copyWith(
        border: Border.all(
          color: MetamorfoseColors.redLight,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: MetamorfoseColors.redNormal,
            fontFamily: 'DinNext',
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
