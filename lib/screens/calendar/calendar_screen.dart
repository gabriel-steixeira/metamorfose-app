/// File: calendar_screen.dart
/// Description: Tela principal do calendário visual
///
/// Responsabilidades:
/// - Exibir calendário mensal com fotos
/// - Permitir navegação entre meses
/// - Permitir tirar fotos
/// - Exibir detalhes das fotos
/// - Usar BLoC pattern para gerenciamento de estado
///
/// Author: Assistant
/// Created on: 15-08-2025
/// Version: 1.0.0
/// Squad: Metamorfose

import 'dart:io';
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
    context.read<CalendarBloc>().add(InitializeCalendarEvent());
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  /// Constrói o header estilo referência com foto de perfil e estatísticas
  Widget _buildProfileHeader(CalendarState state) {
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
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
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

    final avatarSize = ResponsiveValue<double>(
      context,
      defaultValue: 80.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 70.0),
        Condition.largerThan(name: TABLET, value: 90.0),
      ],
    ).value;

    final nameFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
      ],
    ).value;

    return Container(
      width: double.infinity,
      color: MetamorfoseColors.whiteLight,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    context.go('/plant-care');
                  },
                  child: SvgPicture.asset(
                    'assets/images/arrow_back.svg',
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
              ),
              SizedBox(height: spacing),

              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MetamorfoseColors.purpleLight.withValues(alpha: 0.1),
                  border: Border.all(
                    color: MetamorfoseColors.purpleLight,
                    width: 2,
                  ),
                ),
                child: _buildUserPhoto(avatarSize),
              ),
              const SizedBox(height: 16),

              Text(
                _getUserName(),
                style: TextStyle(
                  fontFamily: 'DinNext',
                  fontSize: nameFontSize,
                  fontWeight: FontWeight.w600,
                  color: MetamorfoseColors.blackLight,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing),

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
    final valueFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 20.0),
        Condition.largerThan(name: TABLET, value: 28.0),
      ],
    ).value;

    final labelFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: valueFontSize,
            fontWeight: FontWeight.w600,
            color: MetamorfoseColors.blackLight,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'DinNext',
            fontSize: labelFontSize,
            color: MetamorfoseColors.greyMedium,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
  Widget _buildUserPhoto(double size) {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user?.photoURL != null && user!.photoURL!.isNotEmpty) {
        return ClipOval(
          child: Image.network(
            user.photoURL!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildUserInitials(size);
            },
          ),
        );
      }
      return _buildUserInitials(size);
    } catch (e) {
      return _buildUserInitials(size);
    }
  }

  /// Constrói o widget com as iniciais do usuário
  Widget _buildUserInitials(double size) {
    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 28.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    return Center(
      child: Text(
        _getUserInitials(),
        style: TextStyle(
          fontFamily: 'DinNext',
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: MetamorfoseColors.whiteLight,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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
    final photoSize = ResponsiveValue<double>(
      context,
      defaultValue: 52.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 44.0),
        Condition.largerThan(name: TABLET, value: 60.0),
      ],
    ).value;

    try {
      if (photo.imageBytes != null) {
        return Image.memory(
          photo.imageBytes!,
          width: photoSize,
          height: photoSize,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPhotoPlaceholder(photoSize);
          },
        );
      }

      if (photo.localPath != null && photo.localPath!.isNotEmpty) {
        final file = File(photo.localPath!);
        if (file.existsSync()) {
          return Image.file(
            file,
            width: photoSize,
            height: photoSize,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPhotoPlaceholder(photoSize);
            },
          );
        }
      }

      return _buildPhotoPlaceholder(photoSize);
    } catch (e) {
      debugPrint('Erro ao carregar foto: $e');
      return _buildPhotoPlaceholder(photoSize);
    }
  }

  /// Constrói placeholder para foto
  Widget _buildPhotoPlaceholder(double size) {
    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 28.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: MetamorfoseColors.purpleLight,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Icon(
        Icons.photo,
        color: MetamorfoseColors.whiteLight,
        size: iconSize,
      ),
    );
  }

  /// Retorna o caminho do SVG baseado na cor da planta
  String _getPlantSvgAsset(int? colorValue) {
    if (colorValue == MetamorfoseColors.blueNormal.toARGB32()) {
      return 'assets/images/plantsetup/plantsetup_blue.svg';
    }
    if (colorValue == MetamorfoseColors.greenNormal.toARGB32()) {
      return 'assets/images/plantsetup/plantsetup_green.svg';
    }
    if (colorValue == MetamorfoseColors.pinkNormal.toARGB32()) {
      return 'assets/images/plantsetup/plantsetup_pink.svg';
    }
    return 'assets/images/plantsetup/plantsetup.svg';
  }

  /// Constrói o widget SVG da planta com a cor correta
  Widget _buildPlantSvgWidget(int? potColorValue) {
    final svgPath = _getPlantSvgAsset(potColorValue);
    final svgSize = ResponsiveValue<double>(
      context,
      defaultValue: 46.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 40.0),
        Condition.largerThan(name: TABLET, value: 52.0),
      ],
    ).value;

    return Container(
      width: svgSize,
      height: svgSize,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: MetamorfoseColors.transparent,
      ),
      child: SvgPicture.asset(
        svgPath,
        width: svgSize,
        height: svgSize,
        fit: BoxFit.contain,
      ),
    );
  }

  /// Constrói o calendário usando TableCalendar
  Widget _buildCalendar(CalendarState state) {
    final currentDate = state.currentDate;
    final year = currentDate.year;
    final month = currentDate.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstDayOfMonth = DateTime(year, month, 1);
    final daysFromPreviousMonth = firstDayOfMonth.weekday % 7;
    final daysInPreviousMonth = DateTime(year, month, 0).day;

    final horizontalMargin = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final verticalMargin = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: verticalMargin),
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
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(horizontalMargin),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () =>
                      context.read<CalendarBloc>().add(PreviousMonthEvent()),
                  child: Icon(
                    Icons.chevron_left,
                    color: MetamorfoseColors.greyMedium,
                    size: ResponsiveValue<double>(
                      context,
                      defaultValue: 28.0,
                      conditionalValues: const [
                        Condition.smallerThan(name: MOBILE, value: 24.0),
                        Condition.largerThan(name: TABLET, value: 32.0),
                      ],
                    ).value,
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
                  style: TextStyle(
                    fontFamily: 'DinNext',
                    fontSize: ResponsiveValue<double>(
                      context,
                      defaultValue: 20.0,
                      conditionalValues: const [
                        Condition.smallerThan(name: MOBILE, value: 18.0),
                        Condition.largerThan(name: TABLET, value: 22.0),
                      ],
                    ).value,
                    fontWeight: FontWeight.w600,
                    color: MetamorfoseColors.blackLight,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                GestureDetector(
                  onTap: () =>
                      context.read<CalendarBloc>().add(NextMonthEvent()),
                  child: Icon(
                    Icons.chevron_right,
                    color: MetamorfoseColors.greyMedium,
                    size: ResponsiveValue<double>(
                      context,
                      defaultValue: 28.0,
                      conditionalValues: const [
                        Condition.smallerThan(name: MOBILE, value: 24.0),
                        Condition.largerThan(name: TABLET, value: 32.0),
                      ],
                    ).value,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(horizontalMargin),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveValue<double>(
                      context,
                      defaultValue: 16.0,
                      conditionalValues: const [
                        Condition.smallerThan(name: MOBILE, value: 12.0),
                        Condition.largerThan(name: TABLET, value: 20.0),
                      ],
                    ).value,
                  ),
                  margin: EdgeInsets.only(
                    bottom: ResponsiveValue<double>(
                      context,
                      defaultValue: 12.0,
                      conditionalValues: const [
                        Condition.smallerThan(name: MOBILE, value: 8.0),
                        Condition.largerThan(name: TABLET, value: 16.0),
                      ],
                    ).value,
                  ),
                  decoration: BoxDecoration(
                    color: MetamorfoseColors.purpleNormal.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(
                      ResponsiveValue<double>(
                        context,
                        defaultValue: 16.0,
                        conditionalValues: const [
                          Condition.smallerThan(name: MOBILE, value: 12.0),
                          Condition.largerThan(name: TABLET, value: 20.0),
                        ],
                      ).value,
                    ),
                  ),
                  child: Row(
                    children: ['DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SAB']
                        .map((day) => Expanded(
                              child: Center(
                                child: Text(
                                  day,
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
                                    fontWeight: FontWeight.bold,
                                    color: MetamorfoseColors.purpleNormal,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),

                ...List.generate(
                    ((daysInMonth + daysFromPreviousMonth + 6) ~/ 7),
                    (weekIndex) {
                  final dayHeight = ResponsiveValue<double>(
                    context,
                    defaultValue: 40.0,
                    conditionalValues: const [
                      Condition.smallerThan(name: MOBILE, value: 36.0),
                      Condition.largerThan(name: TABLET, value: 48.0),
                    ],
                  ).value;

                  final dayMargin = ResponsiveValue<double>(
                    context,
                    defaultValue: 2.0,
                    conditionalValues: const [
                      Condition.smallerThan(name: MOBILE, value: 1.0),
                      Condition.largerThan(name: TABLET, value: 3.0),
                    ],
                  ).value;

                  final dayFontSize = ResponsiveValue<double>(
                    context,
                    defaultValue: 14.0,
                    conditionalValues: const [
                      Condition.smallerThan(name: MOBILE, value: 12.0),
                      Condition.largerThan(name: TABLET, value: 16.0),
                    ],
                  ).value;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: ResponsiveValue<double>(
                        context,
                        defaultValue: 8.0,
                        conditionalValues: const [
                          Condition.smallerThan(name: MOBILE, value: 6.0),
                          Condition.largerThan(name: TABLET, value: 10.0),
                        ],
                      ).value,
                    ),
                    child: Row(
                      children: List.generate(7, (dayIndex) {
                        final dayOfWeek = weekIndex * 7 + dayIndex;
                        final dayNumber = dayOfWeek - daysFromPreviousMonth + 1;

                        if (dayOfWeek < daysFromPreviousMonth) {
                          final previousDay = daysInPreviousMonth -
                              daysFromPreviousMonth +
                              dayOfWeek +
                              1;
                          return Expanded(
                            child: Container(
                              height: dayHeight,
                              margin: EdgeInsets.all(dayMargin),
                              child: Center(
                                child: Text(
                                  previousDay.toString(),
                                  style: TextStyle(
                                    fontFamily: 'DinNext',
                                    fontSize: dayFontSize,
                                    color: MetamorfoseColors.greyLight,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          );
                        }

                        if (dayNumber > daysInMonth) {
                          final nextDay = dayNumber - daysInMonth;
                          return Expanded(
                            child: Container(
                              height: dayHeight,
                              margin: EdgeInsets.all(dayMargin),
                              child: Center(
                                child: Text(
                                  nextDay.toString(),
                                  style: TextStyle(
                                    fontFamily: 'DinNext',
                                    fontSize: dayFontSize,
                                    color: MetamorfoseColors.greyLight,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          );
                        }

                        final currentDate = DateTime(year, month, dayNumber);
                        final hasPhoto = state.hasPhotoOnDate(currentDate);
                        final isToday = currentDate.day == DateTime.now().day &&
                            currentDate.month == DateTime.now().month &&
                            currentDate.year == DateTime.now().year;

                        final currentDayHeight = ResponsiveValue<double>(
                          context,
                          defaultValue: 44.0,
                          conditionalValues: const [
                            Condition.smallerThan(name: MOBILE, value: 40.0),
                            Condition.largerThan(name: TABLET, value: 52.0),
                          ],
                        ).value;

                        final currentDayMargin = ResponsiveValue<double>(
                          context,
                          defaultValue: 2.0,
                          conditionalValues: const [
                            Condition.smallerThan(name: MOBILE, value: 1.0),
                            Condition.largerThan(name: TABLET, value: 3.0),
                          ],
                        ).value;

                        final currentDayBorderRadius = ResponsiveValue<double>(
                          context,
                          defaultValue: 8.0,
                          conditionalValues: const [
                            Condition.smallerThan(name: MOBILE, value: 6.0),
                            Condition.largerThan(name: TABLET, value: 10.0),
                          ],
                        ).value;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () => _onDayTap(currentDate, state),
                            child: Container(
                              height: currentDayHeight,
                              margin: EdgeInsets.all(currentDayMargin),
                              decoration: BoxDecoration(
                                color: hasPhoto
                                    ? MetamorfoseColors.purpleNormal
                                        .withValues(alpha: 0.1)
                                    : isToday
                                        ? MetamorfoseColors.purpleNormal
                                        : MetamorfoseColors.transparent,
                                borderRadius: BorderRadius.circular(currentDayBorderRadius),
                                boxShadow: null,
                              ),
                              child: Center(
                                child: hasPhoto
                                    ? Stack(
                                        children: [
                                          Container(
                                            width: ResponsiveValue<double>(
                                              context,
                                              defaultValue: 36.0,
                                              conditionalValues: const [
                                                Condition.smallerThan(name: MOBILE, value: 32.0),
                                                Condition.largerThan(name: TABLET, value: 40.0),
                                              ],
                                            ).value,
                                            height: ResponsiveValue<double>(
                                              context,
                                              defaultValue: 36.0,
                                              conditionalValues: const [
                                                Condition.smallerThan(name: MOBILE, value: 32.0),
                                                Condition.largerThan(name: TABLET, value: 40.0),
                                              ],
                                            ).value,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(currentDayBorderRadius),
                                              border: Border.all(
                                                color: MetamorfoseColors.purpleNormal,
                                                width: 3,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: MetamorfoseColors.purpleNormal.withValues(alpha: 0.3),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(currentDayBorderRadius - 2),
                                              child: _buildPhotoWidget(
                                                  state.getPhotoOnDate(currentDate)!),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: -2,
                                            right: -2,
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: MetamorfoseColors.purpleNormal,
                                                borderRadius: BorderRadius.circular(currentDayBorderRadius),
                                                border: Border.all(
                                                  color: MetamorfoseColors.whiteLight,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                dayNumber.toString(),
                                                style: TextStyle(
                                                  fontFamily: 'DinNext',
                                                  fontSize: ResponsiveValue<double>(
                                                    context,
                                                    defaultValue: 10.0,
                                                    conditionalValues: const [
                                                      Condition.smallerThan(name: MOBILE, value: 8.0),
                                                      Condition.largerThan(name: TABLET, value: 12.0),
                                                    ],
                                                  ).value,
                                                  fontWeight: FontWeight.w600,
                                                  color: MetamorfoseColors.whiteLight,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        dayNumber.toString(),
                                        style: TextStyle(
                                          fontFamily: 'DinNext',
                                          fontSize: ResponsiveValue<double>(
                                            context,
                                            defaultValue: 16.0,
                                            conditionalValues: const [
                                              Condition.smallerThan(name: MOBILE, value: 14.0),
                                              Condition.largerThan(name: TABLET, value: 18.0),
                                            ],
                                          ).value,
                                          fontWeight: isToday
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          color: isToday
                                              ? MetamorfoseColors.whiteLight
                                              : MetamorfoseColors.blackLight,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
    final horizontalMargin = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final verticalMargin = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
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

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: verticalMargin),
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
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
          decoration: ShapeDecoration(
            color: MetamorfoseColors.whiteLight,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: MetamorfoseColors.greyLightest2,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            shadows: const [
              BoxShadow(
                color: MetamorfoseColors.defaultButtonShadow,
                blurRadius: 0,
                offset: Offset(0, 4),
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
                fontSize: fontSize,
                fontFamily: 'DinNext',
                fontWeight: FontWeight.w700,
                height: 1.27,
                shadows: const [
                  Shadow(
                    offset: Offset(0, 1),
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
    );
  }

  /// Constrói o botão flutuante de câmera
  Widget _buildFloatingCameraButton(CalendarState state) {
    final buttonSize = ResponsiveValue<double>(
      context,
      defaultValue: 60.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 52.0),
        Condition.largerThan(name: TABLET, value: 68.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 28.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 32.0),
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

    final bottomPosition = ResponsiveValue<double>(
      context,
      defaultValue: 100.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 80.0),
        Condition.largerThan(name: TABLET, value: 120.0),
      ],
    ).value;

    final rightPosition = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    return Positioned(
      bottom: bottomPosition,
      right: rightPosition,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: MetamorfoseColors.purpleLight,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: MetamorfoseColors.purpleLight.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IconButton(
          onPressed: state.isUploading
              ? null
              : () => _showNewRecordModal(state.currentDate),
          icon: Icon(
            Icons.camera_alt,
            color: MetamorfoseColors.whiteLight,
            size: iconSize,
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
    final plantCareService = PlantCareService();
    final plantData = await plantCareService.loadPlantInfo();
    debugPrint('🌱 Dicas: Dados da planta carregados: $plantData');
    final plantName = plantData['name'] ?? 'Plantinha';
    final plantImage = plantData['plantImageUrl'];

    if (!mounted) return;

    final dialogBorderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final plantImageSize = ResponsiveValue<double>(
      context,
      defaultValue: 50.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 44.0),
        Condition.largerThan(name: TABLET, value: 56.0),
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

    final contentFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final buttonFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final padding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogBorderRadius),
        ),
        title: Row(
          children: [
            Container(
              width: plantImageSize,
              height: plantImageSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MetamorfoseColors.purpleLight.withValues(alpha: 0.2),
                border: Border.all(
                  color: MetamorfoseColors.purpleNormal,
                  width: 2,
                ),
              ),
              child: plantImage != null && plantImage.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        plantImage,
                        width: plantImageSize - 4,
                        height: plantImageSize - 4,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlantSvgWidget(plantData['potColorValue']);
                        },
                      ),
                    )
                  : _buildPlantSvgWidget(plantData['potColorValue']),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$plantName',
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
            ),
          ],
        ),
        content: Container(
          padding: EdgeInsets.all(padding),
          child: Text(
            tip,
            style: TextStyle(
              fontFamily: 'DinNext',
              fontSize: contentFontSize,
              color: MetamorfoseColors.blackLight,
              height: 1.5,
            ),
            textAlign: TextAlign.start,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Entendi, $plantName! 💚',
              style: TextStyle(
                fontFamily: 'DinNext',
                fontSize: buttonFontSize,
                fontWeight: FontWeight.w600,
                color: MetamorfoseColors.purpleNormal,
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
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: MetamorfoseColors.redNormal,
            ),
          );
          context.read<CalendarBloc>().add(ClearErrorEvent());
        }

        if (state.hasSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: MetamorfoseColors.greenNormal,
            ),
          );

          if (state.successMessage!.contains('Registro salvo')) {
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
        final bottomSpacing = ResponsiveValue<double>(
          context,
          defaultValue: 100.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 80.0),
            Condition.largerThan(name: TABLET, value: 120.0),
          ],
        ).value;

        return Scaffold(
          backgroundColor: MetamorfoseColors.whiteLight,
          body: Stack(
            children: [
              Column(
                children: [
                  _buildProfileHeader(state),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildCalendar(state),
                          _buildViewAllRecordsButton(state),
                          SizedBox(height: bottomSpacing),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _buildFloatingCameraButton(state),
            ],
          ),
          bottomNavigationBar: const BottomNavigationMenu(
            activeIndex: 2,
          ),
        );
      },
    );
  }
}
