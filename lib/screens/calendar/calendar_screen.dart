/**
 * File: calendar_screen.dart
 * Description: Tela principal do calendário visual
 *
 * Responsabilidades:
 * - Exibir calendário mensal com fotos
 * - Permitir navegação entre meses
 * - Permitir tirar fotos
 * - Exibir detalhes das fotos
 * - Usar BLoC pattern para gerenciamento de estado
 *
 * Author: Assistant
 * Created on: 15-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/bottom_navigation_menu.dart';
import 'package:metamorfose_flutter/blocs/calendar_bloc.dart';
import 'package:metamorfose_flutter/state/calendar/calendar_state.dart';
import 'package:metamorfose_flutter/screens/calendar/photo_details_screen.dart';
import 'package:metamorfose_flutter/screens/calendar/new_record_modal.dart';
import 'package:metamorfose_flutter/screens/calendar/all_records_screen.dart';
import 'package:metamorfose_flutter/services/plant_tips_service.dart';
import 'package:metamorfose_flutter/services/plant_care_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:metamorfose_flutter/models/index.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Tela principal do calendário visual
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<CalendarPhoto>> _selectedEvents;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    // Inicializar o BLoC
    context.read<CalendarBloc>().add(InitializeCalendarEvent());
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  /// Constrói o header estilo referência com foto de perfil e estatísticas
  Widget _buildProfileHeader(CalendarState state) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Seta de voltar
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    context.go('/plant-care');
                  },
                  child: SvgPicture.asset(
                    'assets/images/arrow_back.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Foto de perfil do usuário
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MetamorfoseColors.purpleLight.withOpacity(0.1),
                  border: Border.all(
                    color: MetamorfoseColors.purpleLight,
                    width: 2,
                  ),
                ),
                child: _buildUserPhoto(),
              ),
              const SizedBox(height: 16),

              // Nome do usuário
              Text(
                _getUserName(),
                style: const TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: MetamorfoseColors.blackLight,
                ),
              ),
              const SizedBox(height: 24),

              // Estatísticas em linha (apenas 2 colunas)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatisticColumn(
                      state.photos.length.toString(), 'Check-ins'),
                  _buildStatisticColumn(
                      _getActiveDaysCount(state).toString(), 'Dias ativos'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói uma coluna de estatística suavizada
  Widget _buildStatisticColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'DinNext',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: MetamorfoseColors.blackLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'DinNext',
            fontSize: 14,
            color: MetamorfoseColors.greyMedium,
          ),
        ),
      ],
    );
  }

  /// Calcula o número de dias ativos (dias com fotos)
  int _getActiveDaysCount(CalendarState state) {
    final uniqueDates = <String>{};
    for (final photo in state.photos) {
      final dateKey =
          '${photo.date.year}-${photo.date.month}-${photo.date.day}';
      uniqueDates.add(dateKey);
    }
    return uniqueDates.length;
  }

  /// Obtém o nome do usuário atual
  String _getUserName() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null &&
          user.displayName != null &&
          user.displayName!.isNotEmpty) {
        return user.displayName!;
      }
      return 'Eve';
    } catch (e) {
      return 'Eve';
    }
  }

  /// Obtém as iniciais do usuário
  String _getUserInitials() {
    final name = _getUserName();
    if (name.length >= 2) {
      return name.substring(0, 2).toUpperCase();
    }
    return name.toUpperCase();
  }

  /// Constrói a foto do usuário ou iniciais como fallback
  Widget _buildUserPhoto() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user?.photoURL != null && user!.photoURL!.isNotEmpty) {
        return ClipOval(
          child: Image.network(
            user.photoURL!,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildUserInitials();
            },
          ),
        );
      }
      return _buildUserInitials();
    } catch (e) {
      return _buildUserInitials();
    }
  }

  /// Constrói o widget com as iniciais do usuário
  Widget _buildUserInitials() {
    return Center(
      child: Text(
        _getUserInitials(),
        style: const TextStyle(
          fontFamily: 'DinNext',
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Pega fotos de um dia específico
  List<CalendarPhoto> _getEventsForDay(DateTime day) {
    final photos = context.read<CalendarBloc>().state.photos;
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return photos.where((photo) {
      final photoDate =
          DateTime(photo.date.year, photo.date.month, photo.date.day);
      return photoDate == normalizedDay;
    }).toList();
  }

  /// Constrói o widget da foto para o calendário
  Widget _buildPhotoWidget(CalendarPhoto photo) {
    try {
      // Priorizar bytes da imagem (para web)
      if (photo.imageBytes != null) {
        return Image.memory(
          photo.imageBytes!,
          width: 52,
          height: 52,
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
            width: 52,
            height: 52,
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
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: MetamorfoseColors.purpleLight,
        borderRadius: BorderRadius.circular(26),
      ),
      child: const Icon(
        Icons.photo,
        color: Colors.white,
        size: 28,
      ),
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
    return 'assets/images/plantsetup/plantsetup.svg'; // Roxo padrão
  }

  /// Constrói o widget SVG da planta com a cor correta
  Widget _buildPlantSvgWidget(int? potColorValue) {
    final svgPath = _getPlantSvgAsset(potColorValue);

    return Container(
      width: 46,
      height: 46,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: SvgPicture.asset(
        svgPath,
        width: 46,
        height: 46,
        fit: BoxFit.contain,
      ),
    );
  }

  /// Constrói o calendário usando TableCalendar
  Widget _buildCalendar(CalendarState state) {
    // Calcular dados do calendário
    final currentDate = state.currentDate;
    final year = currentDate.year;
    final month = currentDate.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysFromPreviousMonth = firstDayOfMonth.weekday % 7;
    final daysInPreviousMonth = DateTime(year, month, 0).day;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: MetamorfoseColors.whiteLight,
        borderRadius: BorderRadius.circular(20),
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
      child: Column(
        children: [
          // Header do mês com navegação - estilo limpo
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () =>
                      context.read<CalendarBloc>().add(PreviousMonthEvent()),
                  child: Icon(
                    Icons.chevron_left,
                    color: Colors.grey.shade600,
                    size: 28,
                  ),
                ),
                Text(
                  DateFormat('MMMM yyyy', 'pt_BR')
                      .format(state.currentDate)
                      .replaceFirst(
                          DateFormat('MMMM yyyy', 'pt_BR')
                              .format(state.currentDate)[0],
                          DateFormat('MMMM yyyy', 'pt_BR')
                              .format(state.currentDate)[0]
                              .toUpperCase()),
                  style: const TextStyle(
                    fontFamily: 'DinNext',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: MetamorfoseColors.blackLight,
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      context.read<CalendarBloc>().add(NextMonthEvent()),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade600,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          // Calendário
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Dias da semana
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: MetamorfoseColors.purpleNormal.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: ['DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SAB']
                        .map((day) => Expanded(
                              child: Center(
                                child: Text(
                                  day,
                                  style: const TextStyle(
                                    fontFamily: 'DinNext',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: MetamorfoseColors.purpleNormal,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),

                // Grid do calendário
                ...List.generate(
                    ((daysInMonth + daysFromPreviousMonth + 6) ~/ 7),
                    (weekIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: List.generate(7, (dayIndex) {
                        final dayOfWeek = weekIndex * 7 + dayIndex;
                        final dayNumber = dayOfWeek - daysFromPreviousMonth + 1;

                        // Dias do mês anterior
                        if (dayOfWeek < daysFromPreviousMonth) {
                          final previousDay = daysInPreviousMonth -
                              daysFromPreviousMonth +
                              dayOfWeek +
                              1;
                          return Expanded(
                            child: Container(
                              height: 40,
                              margin: const EdgeInsets.all(2),
                              child: Center(
                                child: Text(
                                  previousDay.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'DinNext',
                                    fontSize: 14,
                                    color: MetamorfoseColors.greyLight,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        // Dias do próximo mês
                        if (dayNumber > daysInMonth) {
                          final nextDay = dayNumber - daysInMonth;
                          return Expanded(
                            child: Container(
                              height: 40,
                              margin: const EdgeInsets.all(2),
                              child: Center(
                                child: Text(
                                  nextDay.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'DinNext',
                                    fontSize: 14,
                                    color: MetamorfoseColors.greyLight,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        // Dias do mês atual
                        final currentDate = DateTime(year, month, dayNumber);
                        final hasPhoto = state.hasPhotoOnDate(currentDate);
                        final isToday = currentDate.day == DateTime.now().day &&
                            currentDate.month == DateTime.now().month &&
                            currentDate.year == DateTime.now().year;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _onDayTap(currentDate, state),
                            child: Container(
                              height: 44,
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: hasPhoto
                                    ? MetamorfoseColors.purpleNormal
                                        .withOpacity(0.1)
                                    : isToday
                                        ? MetamorfoseColors.purpleNormal
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: null,
                              ),
                              child: Center(
                                child: hasPhoto
                                    ? Stack(
                                        children: [
                                          // Foto com borda
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: MetamorfoseColors
                                                    .purpleNormal,
                                                width: 3,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: MetamorfoseColors
                                                      .purpleNormal
                                                      .withOpacity(0.3),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: _buildPhotoWidget(
                                                  state.getPhotoOnDate(
                                                      currentDate)!),
                                            ),
                                          ),
                                          // Número do dia sobreposto
                                          Positioned(
                                            bottom: -2,
                                            right: -2,
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: MetamorfoseColors
                                                    .purpleNormal,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                dayNumber.toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'DinNext',
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        dayNumber.toString(),
                                        style: TextStyle(
                                          fontFamily: 'DinNext',
                                          fontSize: 16,
                                          fontWeight: isToday
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          color: isToday
                                              ? Colors.white
                                              : MetamorfoseColors.blackLight,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o botão "Ver tudo" estilo padrão
  Widget _buildViewAllRecordsButton(CalendarState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AllRecordsScreen(photos: state.photos),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: ShapeDecoration(
            color: MetamorfoseColors.whiteLight,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: MetamorfoseColors.greyLightest2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            shadows: [
              BoxShadow(
                color: MetamorfoseColors.defaultButtonShadow,
                blurRadius: 0,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'VER TUDO',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MetamorfoseColors.purpleNormal,
                fontSize: 16,
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
    );
  }

  /// Constrói o botão flutuante de câmera
  Widget _buildFloatingCameraButton(CalendarState state) {
    return Positioned(
      bottom: 100,
      right: 24,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: MetamorfoseColors.purpleLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: MetamorfoseColors.purpleLight.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          onPressed: state.isUploading
              ? null
              : () => _showNewRecordModal(state.currentDate),
          icon: const Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  /// Trata o tap em um dia do calendário
  void _onDayTap(DateTime date, CalendarState state) {
    final photo = state.getPhotoOnDate(date);
    if (photo != null) {
      _showPhotoDetails(photo);
    } else {
      _showNewRecordModal(date);
    }
  }

  /// Mostra modal para criar novo registro
  void _showNewRecordModal(DateTime date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewRecordModal(
        selectedDate: date,
        onSave: (imageBytes, imageFile, feeling, reason) {
          _savePhotoWithDetails(date, imageBytes, imageFile, feeling, reason);
        },
      ),
    );
  }

  /// Salva foto com detalhes do modal
  Future<void> _savePhotoWithDetails(DateTime date, Uint8List? imageBytes,
      File? imageFile, String feeling, String reason) async {
    try {
      context.read<CalendarBloc>().add(SavePhotoTemporarilyEvent(
            imageBytes: imageBytes,
            imageFile: imageFile,
            date: date,
            feeling: feeling,
            reason: reason,
          ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar foto: $e'),
          backgroundColor: MetamorfoseColors.redNormal,
        ),
      );
    }
  }

  /// Mostra pop-up com dica da planta
  void _showPlantTipDialog(String feeling, String reason) async {
    final tip = PlantTipsService.generateTip(feeling);
    // Usar PlantCareService diretamente (mesma lógica do plant-care)
    final plantCareService = PlantCareService();
    final plantData = await plantCareService.loadPlantInfo();
    debugPrint('🌱 Dicas: Dados da planta carregados: $plantData');
    final plantName = plantData['name'] ?? 'Plantinha';
    final plantImage = plantData['plantImageUrl'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            // Imagem da planta do usuário
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MetamorfoseColors.purpleLight.withOpacity(0.2),
                border: Border.all(
                  color: MetamorfoseColors.purpleNormal,
                  width: 2,
                ),
              ),
              child: plantImage != null && plantImage.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        plantImage,
                        width: 46,
                        height: 46,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback para SVG da planta com cor correta
                          return _buildPlantSvgWidget(
                              plantData['potColorValue']);
                        },
                      ),
                    )
                  : _buildPlantSvgWidget(plantData['potColorValue']),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$plantName',
                style: const TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MetamorfoseColors.blackLight,
                ),
              ),
            ),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            tip,
            style: const TextStyle(
              fontFamily: 'DinNext',
              fontSize: 16,
              color: MetamorfoseColors.blackLight,
              height: 1.5,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Entendi, $plantName! 💚',
              style: TextStyle(
                fontFamily: 'DinNext',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: MetamorfoseColors.purpleNormal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra detalhes da foto
  void _showPhotoDetails(CalendarPhoto photo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoDetailsScreen(photo: photo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarBloc, CalendarState>(
      listener: (context, state) {
        // Tratar erros
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: MetamorfoseColors.redNormal,
            ),
          );
          context.read<CalendarBloc>().add(ClearErrorEvent());
        }

        // Tratar sucessos
        if (state.hasSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: MetamorfoseColors.greenNormal,
            ),
          );

          // Mostrar pop-up com dica se foi um registro novo
          if (state.successMessage!.contains('Registro salvo')) {
            // Extrair sentimento da última foto salva
            final lastPhoto = state.photos.last;
            if (lastPhoto.description != null) {
              final parts = lastPhoto.description!.split(' - ');
              if (parts.length == 2) {
                final feeling = parts[0];
                final reason = parts[1];
                _showPlantTipDialog(feeling, reason);
              }
            }
          }

          context.read<CalendarBloc>().add(ClearSuccessEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Column(
                children: [
                  // Header roxo com perfil
                  _buildProfileHeader(state),

                  // Calendário
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildCalendar(state),
                          _buildViewAllRecordsButton(state),
                          const SizedBox(
                              height: 100), // Espaço para o botão flutuante
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Botão flutuante de câmera
              _buildFloatingCameraButton(state),
            ],
          ),
          bottomNavigationBar: BottomNavigationMenu(
            activeIndex: 2, // Assumindo que é a terceira aba
          ),
        );
      },
    );
  }
}
