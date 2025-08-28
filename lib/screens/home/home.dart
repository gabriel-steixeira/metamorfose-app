/// File: home.dart
/// Description: Tela principal do Metamorfose com design moderno e sofisticado.
///
/// Responsabilidades:
/// - Exibir cards de clima, cuidados e mensagem de inspiração
/// - Mostrar notificação de boas-vindas
/// - Exibir funcionalidades em breve organizadas em carrosseis
/// - Usar BLoC pattern para gerenciamento de estado
///
/// Author: Gabriel Teixeira e Vitoria Lana
/// Created on: 30-05-2025
/// Last modified: 19-08-2025
///
/// Changes:
/// - UI Refatorado e Adicionado Card para Cuidados (Evelin Cordeiro)
/// - Adicionadas cards de funcionalidade 'Em breve' (Evelin Cordeiro)
///
/// Version: 4.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/theme/text_styles.dart';
import 'package:metamorfose_flutter/components/speech_bubble.dart';
import 'package:metamorfose_flutter/components/bottom_navigation_menu.dart';
import 'package:metamorfose_flutter/components/carousel.dart';
import 'package:metamorfose_flutter/blocs/home_bloc.dart';
import 'package:metamorfose_flutter/state/home/home_state.dart';
import 'package:metamorfose_flutter/theme/typography.dart';
import 'package:metamorfose_flutter/services/plant_config_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  double _dragStartY = 0;
  double _dragCurrentY = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(InitializeHomeEvent());

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _heightAnimation = Tween<double>(
      begin: 0.65,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _dragCurrentY = details.globalPosition.dy;
    double dragDistance = _dragStartY - _dragCurrentY;

    double progress = (dragDistance / 200).clamp(0.0, 1.0);
    _animationController.value = progress;
  }

  void _onPanEnd(DragEndDetails details) {
    double velocity = details.velocity.pixelsPerSecond.dy;

    if (_animationController.value > 0.5 || velocity < -500) {
      // Expandir
      _animationController.forward();
      setState(() {
        _isExpanded = true;
      });
    } else {
      // Contrair
      _animationController.reverse();
      setState(() {
        _isExpanded = false;
      });
    }
  }

  Widget _buildHeaderStats() {
    final hour = DateTime.now().hour;
    String greeting = 'Boa noite';
    IconData greetingIcon = Icons.nightlight_round;

    if (hour >= 6 && hour < 12) {
      greeting = 'Bom dia';
      greetingIcon = Icons.wb_sunny_outlined;
    } else if (hour >= 12 && hour < 18) {
      greeting = 'Boa tarde';
      greetingIcon = Icons.wb_cloudy_outlined;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: MetamorfoseColors.whiteLight.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: MetamorfoseColors.shadowLight,
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: -2,
          ),
        ],
        border: Border.all(
          color: MetamorfoseColors.whiteLight.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MetamorfoseColors.purpleNormal.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              greetingIcon,
              color: MetamorfoseColors.purpleNormal,
              size: 28,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: AppTypography.titleLarge.copyWith(
                    color: MetamorfoseColors.blackLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Como você está se sentindo?',
                  style: AppTypography.bodyLarge.copyWith(
                    color: MetamorfoseColors.greyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(HomeState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: MetamorfoseGradients.darkPurpleGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: MetamorfoseColors.greenLight.withOpacity(0.3),
            offset: const Offset(0, 12),
            blurRadius: 40,
            spreadRadius: -8,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MetamorfoseColors.whiteLight.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MetamorfoseColors.whiteLight.withOpacity(0.08),
              ),
            ),
          ),

          // Conteúdo principal
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: MetamorfoseColors.whiteLight.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                MetamorfoseColors.whiteLight.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.wb_sunny_outlined,
                          color: MetamorfoseColors.whiteLight,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Clima',
                        style: AppTypography.titleLarge.copyWith(
                          color: MetamorfoseColors.whiteDark,
                        ),
                      ),
                    ],
                  ),
                  if (state.weatherLoadingState == LoadingState.success &&
                      state.weather != null)
                    Text(
                      state.weather!.getWeatherIcon(),
                      style: const TextStyle(fontSize: 36),
                    ),
                ],
              ),
              if (state.weatherLoadingState == LoadingState.loading)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          MetamorfoseColors.whiteLight),
                      strokeWidth: 2,
                    ),
                  ),
                )
              else if (state.weatherLoadingState == LoadingState.success &&
                  state.weather != null) ...[
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${state.weather!.temperature.toStringAsFixed(0)}°',
                      style: AppTypography.displayLarge.copyWith(
                        color: MetamorfoseColors.whiteLight,
                        fontWeight: FontWeight.w200,
                        fontSize: 52,
                        height: 0.9,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.weather!.location,
                            style: AppTypography.bodyLarge.copyWith(
                              color:
                                  MetamorfoseColors.whiteLight.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _buildTempIndicator('H', state.weather!.tempMax,
                                  Icons.keyboard_arrow_up),
                              const SizedBox(width: 16),
                              _buildTempIndicator('L', state.weather!.tempMin,
                                  Icons.keyboard_arrow_down),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ] else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Erro ao carregar clima',
                    style: AppTypography.bodyMedium.copyWith(
                      color: MetamorfoseColors.whiteLight.withOpacity(0.7),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTempIndicator(String label, double temp, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: MetamorfoseColors.whiteLight.withOpacity(0.8),
          size: 16,
        ),
        Text(
          '$label ${temp.toStringAsFixed(0)}°',
          style: AppTypography.bodyMedium.copyWith(
            color: MetamorfoseColors.whiteLight.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildContentCards(HomeState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Quote card
          Expanded(
            flex: 3,
            child: _buildQuoteCard(state),
          ),
          const SizedBox(width: 16),
          // Plant care card
          Expanded(
            flex: 2,
            child: _buildPlantCareCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(HomeState state) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: MetamorfoseColors.whiteLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: MetamorfoseColors.shadowLight,
            offset: const Offset(0, 4),
            blurRadius: 24,
            spreadRadius: -2,
          ),
        ],
        border: Border.all(
          color: MetamorfoseColors.greyLightest2,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MetamorfoseColors.purpleNormal.withOpacity(0.05),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: MetamorfoseColors.purpleNormal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: MetamorfoseColors.purpleNormal,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Inspiração',
                    style: AppTypography.titleLarge.copyWith(
                      color: MetamorfoseColors.blackLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Builder(
                  builder: (_) {
                    if (state.quoteLoadingState == LoadingState.loading) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              MetamorfoseColors.purpleNormal),
                          strokeWidth: 2,
                        ),
                      );
                    } else if (state.quoteLoadingState ==
                            LoadingState.success &&
                        state.quote != null) {
                      return Text(
                        '"${state.quote!.text}"',
                        style: AppTypography.bodyMedium.copyWith(
                          color: MetamorfoseColors.greyMedium,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      );
                    } else {
                      return Text(
                        'Erro ao carregar mensagem inspiradora',
                        style: AppTypography.bodyMedium.copyWith(
                          color: MetamorfoseColors.greyLight,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlantCareCard() {
    return GestureDetector(
      onTap: () async {
        final plantService = PlantConfigService();
        final hasPlant = await plantService.hasExistingPlant();
        
        if (hasPlant) {
          context.go('/plant-care');
        } else {
          context.go('/plant-config');
        }
      },
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: MetamorfoseGradients.darkGreenGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: MetamorfoseColors.greenNormal.withOpacity(0.3),
              offset: const Offset(0, 8),
              blurRadius: 32,
              spreadRadius: -4,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative plant icon background
            Positioned(
              bottom: -20,
              right: -20,
              child: Icon(
                Icons.eco,
                size: 80,
                color: MetamorfoseColors.whiteLight.withOpacity(0.1),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: MetamorfoseColors.whiteLight.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.eco,
                    color: MetamorfoseColors.whiteLight,
                    size: 20,
                  ),
                ),
                const Spacer(),
                Text(
                  'Planta',
                  style: AppTypography.titleLarge.copyWith(
                    color: MetamorfoseColors.whiteDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cuidar agora',
                  style: AppTypography.bodyMedium.copyWith(
                    color: MetamorfoseColors.whiteDark.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Ver mais',
                      style: AppTypography.bodyMedium.copyWith(
                        color: MetamorfoseColors.whiteLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      color: MetamorfoseColors.whiteLight,
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Carrossel de funcionalidades organizadas por categoria
  List<Widget> get _personalFeatures => [
        CarouselItem(
          title: 'Daily Check-in',
          image: 'assets/images/features/daily_checkin.png',
          icon: _getIconForFeature('Daily Check-in'),
          isComingSoon: true,
          onTap: null,
        ),
        CarouselItem(
          title: 'Modo Noturno',
          image: 'assets/images/features/night_mode.png',
          icon: _getIconForFeature('Modo Noturno'),
          isComingSoon: true,
          onTap: null,
        ),
        CarouselItem(
          title: 'Configurações',
          image: 'assets/images/features/settings.png',
          icon: _getIconForFeature('Configurações'),
          isComingSoon: true,
          onTap: null,
        ),
      ];

  List<Widget> get _supportFeatures => [
        CarouselItem(
          title: 'Psicólogos',
          image: 'assets/images/features/psychologists.png',
          icon: _getIconForFeature('Psicólogos'),
          isComingSoon: true,
          onTap: null,
        ),
        CarouselItem(
          title: 'Suporte de Emergência',
          image: 'assets/images/features/emergency_support.png',
          icon: _getIconForFeature('Suporte de Emergência'),
          isComingSoon: true,
          onTap: null,
        ),
        CarouselItem(
          title: 'Hub Educacional',
          image: 'assets/images/features/education_hub.png',
          icon: _getIconForFeature('Hub Educacional'),
          isComingSoon: true,
          onTap: null,
        ),
      ];

  List<Widget> get _progressFeatures => [
        CarouselItem(
          title: 'Relatórios',
          image: 'assets/images/features/progress_report.png',
          icon: _getIconForFeature('Relatórios'),
          isComingSoon: true,
          onTap: null,
        ),
        CarouselItem(
          title: 'Centro de Missões',
          image: 'assets/images/features/mission_center.png',
          icon: _getIconForFeature('Centro de Missões'),
          isComingSoon: true,
          onTap: null,
        ),
        CarouselItem(
          title: 'Conquistas',
          image: 'assets/images/features/achievements.png',
          icon: _getIconForFeature('Conquistas'),
          isComingSoon: true,
          onTap: null,
        ),
        CarouselItem(
          title: 'Feedback',
          image: 'assets/images/features/feedback.png',
          icon: _getIconForFeature('Feedback'),
          isComingSoon: true,
          onTap: null,
        ),
      ];

  LinearGradient _getGradientForFeature(String title) {
    switch (title.toLowerCase()) {
      case 'daily check-in':
      case 'modo noturno':
      case 'configurações':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MetamorfoseColors.purpleNormal,
            MetamorfoseColors.purpleDark,
          ],
        );
      case 'psicólogos':
      case 'suporte de emergência':
      case 'hub educacional':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MetamorfoseColors.greenNormal,
            MetamorfoseColors.greenDark,
          ],
        );
      default:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MetamorfoseColors.purpleLight,
            MetamorfoseColors.greenLight,
          ],
        );
    }
  }

  IconData _getIconForFeature(String title) {
    switch (title.toLowerCase()) {
      case 'daily check-in':
        return Icons.fact_check;
      case 'modo noturno':
        return Icons.dark_mode;
      case 'psicólogos':
        return Icons.person_outline;
      case 'configurações':
        return Icons.settings;
      case 'relatórios':
        return Icons.assessment;
      case 'centro de missões':
        return Icons.flag;
      case 'hub educacional':
        return Icons.school;
      case 'suporte de emergência':
        return Icons.emergency;
      case 'conquistas':
        return Icons.emoji_events;
      case 'feedback':
        return Icons.feedback;
      default:
        return Icons.circle;
    }
  }

  Color _getShadowColorForFeature(String title, bool isComingSoon) {
    if (isComingSoon) {
      return MetamorfoseColors.greyLight.withOpacity(0.3);
    }
    return MetamorfoseColors.purpleNormal.withOpacity(0.3);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: MetamorfoseColors.redNormal,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
          context.read<HomeBloc>().add(ClearErrorEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: (Color(0xFF7753CD)),
          body: Stack(
            children: [
              Positioned(
                top: -50,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/home/bg_home.png',
                  width: screenSize.width,
                  height: screenSize.height * 0.45,
                  fit: BoxFit.cover,
                ),
              ),

              // Card principal e expansível
              AnimatedBuilder(
                animation: _heightAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: screenSize.height *
                        (1 - _heightAnimation.value),
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(0.20),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: MetamorfoseColors.shadowText
                                  .withOpacity(0.15),
                              offset: const Offset(0, -8),
                              blurRadius: 32,
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color:
                                  MetamorfoseColors.whiteLight.withOpacity(0.1),
                              offset: const Offset(0, -1),
                              blurRadius: 2,
                              spreadRadius: 0,
                            ),
                          ],
                          border: Border.all(
                            color:
                                MetamorfoseColors.whiteLight.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Handle para drag
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Container(
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: MetamorfoseColors.whiteLight
                                      .withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),

                            // Conteúdo do card
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildHeaderStats(),
                                      const SizedBox(height: 28),

                                      _buildWeatherCard(state),
                                      const SizedBox(height: 24),

                                      _buildContentCards(state),
                                      const SizedBox(height: 40),

                                      Carousel(
                                        title: 'Pessoal',
                                        items: _personalFeatures,
                                        height: 200,
                                        itemExtent: 164,
                                      ),
                                      const SizedBox(height: 32),

                                      Carousel(
                                        title: 'Suporte & Cuidado',
                                        items: _supportFeatures,
                                        height: 200,
                                        itemExtent: 164,
                                      ),
                                      const SizedBox(height: 32),

                                      Carousel(
                                        title: 'Progresso & Conquistas',
                                        items: _progressFeatures,
                                        height: 200,
                                        itemExtent: 164,
                                      ),
                                      const SizedBox(height: 32),

                                      const SizedBox(height: 120),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Menu de navegação
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  child: SafeArea(
                    top: false,
                    child: BottomNavigationMenu(
                      activeIndex: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
