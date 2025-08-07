/**
 * File: plant_care_screen.dart
 * Description: Tela de cuidados da planta
 *
 * Responsabilidades:
 * - Exibir informações da planta
 * - Exibir diário visual
 * - Exibir tarefas do dia
 * - Permitir tirar fotos e compartilhar progresso
 * - Usar BLoC pattern para gerenciamento de estado
 *
 * Author: Evelin Cordeiro
 * Created on: 06-08-2025
 * Last modified: 06-08-2025
 * Version: 1.0.0 (BLoC)
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/theme/text_styles.dart';
import 'package:metamorfose_flutter/components/bottom_navigation_menu.dart';
import 'package:metamorfose_flutter/components/metamorfose_primary_button.dart';
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
    // Inicializar o BLoC
    context.read<PlantCareBloc>().add(InitializePlantCareEvent());
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

  /// Header
  Widget _buildPlantInfo(PlantCareState state) {
    if (state.isPlantInfoLoading) {
      return _buildLoadingCard();
    }

    // Dados mockados para teste
    final plantInfo = state.plantInfo ??
        {
          'name': 'Minha Planta',
          'species': 'Monstera Deliciosa',
          'startDate': '15/07/2025',
          'location': 'Sala',
          'sunlight': 'Luz indireta',
          'difficulty': 'Fácil',
          'humidity': '60-70%',
        };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Seção superior: Foto + Botão
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: MetamorfoseColors.purpleDark,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/images/plantsetup/plantsetup.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Botão de tirar nova foto
              Expanded(
                child: MetamorfosePrimaryButton(
                  text: '+ TIRAR NOVA FOTO',
                  onPressed: state.isTakingPhoto
                      ? () {}
                      : () => context
                          .read<PlantCareBloc>()
                          .add(TakeNewPhotoEvent()),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Separador
          Container(
            height: 1,
            color: MetamorfoseColors.greyLightest2,
          ),

          const SizedBox(height: 16),

          // Seção inferior: Informações detalhadas
          Column(
            children: [
              _buildInfoRow(
                icon: Icons.eco,
                label: 'Nome da Planta',
                value: plantInfo['name'] ?? 'N/A',
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.category,
                label: 'Espécie',
                value: plantInfo['species'] ?? 'N/A',
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.calendar_today,
                label: 'Data de início',
                value: plantInfo['startDate'] ?? 'N/A',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Informações de cuidados
  Widget _buildCareInfo(PlantCareState state) {
    // Dados mockados para teste
    final plantInfo = state.plantInfo ??
        {
          'location': 'Sala',
          'sunlight': 'Luz indireta',
          'difficulty': 'Fácil',
          'humidity': '60-70%',
        };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite,
                color: MetamorfoseColors.purpleLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Cuidados',
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
          Row(
            children: [
              Expanded(
                child: _buildCareItem(
                  icon: Icons.location_on,
                  label: 'Localização',
                  value: plantInfo['location'] ?? 'N/A',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCareItem(
                  icon: Icons.wb_sunny,
                  label: 'Luz',
                  value: plantInfo['sunlight'] ?? 'N/A',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildCareItem(
                  icon: Icons.check_circle,
                  label: 'Dificuldade',
                  value: plantInfo['difficulty'] ?? 'N/A',
                ),
              ),
              const SizedBox(width: 16),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.camera_alt,
                color: MetamorfoseColors.purpleLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Diário Visual',
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
          if (state.isVisualDiaryLoading)
            const Center(
              child: CircularProgressIndicator(
                color: MetamorfoseColors.purpleNormal,
              ),
            )
          else if (!state.hasVisualDiaryPhotos)
            _buildEmptyDiary()
          else
            // TODO: Implementar grid de fotos
            const SizedBox.shrink(),
        ],
      ),
    );
  }

  /// Tarefas do dia
  Widget _buildTodayTasks(PlantCareState state) {
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
                'Tarefa de hoje',
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
    return Row(
      children: [
        Icon(
          icon,
          color: MetamorfoseColors.purpleLight,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'DinNext',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MetamorfoseColors.greyMedium,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'DinNext',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: MetamorfoseColors.greyMedium,
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: MetamorfoseColors.purpleLight,
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: MetamorfoseColors.greyMedium,
                fontFamily: 'DinNext',
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'DinNext',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: MetamorfoseColors.greyMedium,
          ),
        ),
      ],
    );
  }

  /// Estado vazio do diário
  Widget _buildEmptyDiary() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 48,
              color: MetamorfoseColors.greyLight,
            ),
            const SizedBox(height: 8),
            Text(
              'Nenhuma foto ainda!',
              style: const TextStyle(
                fontFamily: 'DinNext',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MetamorfoseColors.greyMedium,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Tire a primeira foto do seu progresso! 📸🌱',
              style: const TextStyle(
                fontFamily: 'DinNext',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: MetamorfoseColors.greyMedium,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Constrói lista de tarefas
  Widget _buildTasksList(List<dynamic> tasks) {
    return Row(
      children: tasks.asMap().entries.map((entry) {
        final index = entry.key;
        final task = entry.value;

        return Expanded(
          child: Row(
            children: [
              Icon(
                task['type'] == 'water' ? Icons.water_drop : Icons.eco,
                color: MetamorfoseColors.purpleLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                task['name'] ?? 'Tarefa',
                style: const TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: MetamorfoseColors.greyMedium,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Constrói estado vazio de tarefas
  Widget _buildEmptyTasks() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.task_alt,
              size: 48,
              color: MetamorfoseColors.greyLight,
            ),
            const SizedBox(height: 8),
            Text(
              'Nenhuma tarefa hoje!',
              style: const TextStyle(
                fontFamily: 'DinNext',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MetamorfoseColors.greyMedium,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Sua planta está bem cuidada! 🌿✨',
              style: const TextStyle(
                fontFamily: 'DinNext',
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: MetamorfoseColors.greyMedium,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlantCareBloc, PlantCareState>(
      listener: (context, state) {
        // Tratar erros se necessário
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: MetamorfoseColors.redNormal,
            ),
          );
          // Limpar erro após mostrar
          context.read<PlantCareBloc>().add(ClearErrorEvent());
        }

        // Tratar sucessos
        if (state.hasSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: MetamorfoseColors.greenNormal,
            ),
          );
          // Limpar sucesso após mostrar
          context.read<PlantCareBloc>().add(ClearErrorEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MetamorfoseColors.whiteLight,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informações da planta
                  _buildPlantInfo(state),

                  const SizedBox(height: 16),

                  // Cuidados
                  _buildCareInfo(state),

                  const SizedBox(height: 16),

                  // Diário visual
                  _buildVisualDiary(state),

                  const SizedBox(height: 16),

                  // Tarefas do dia
                  _buildTodayTasks(state),

                  const SizedBox(height: 24),

                  // Botão de compartilhar progresso
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: const Center(
        child: CircularProgressIndicator(
          color: MetamorfoseColors.purpleNormal,
        ),
      ),
    );
  }

  /// Constrói card de erro
  Widget _buildErrorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration.copyWith(
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
        ),
      ),
    );
  }
}
