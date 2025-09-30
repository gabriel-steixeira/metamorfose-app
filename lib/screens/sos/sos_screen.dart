/// File: sos_screen.dart
/// Description: Tela principal do Botão SOS do Metamorfose - Refatorada com Layout Responsivo
///
/// Responsabilidades:
/// - Exibir botão SOS central com animação pulsante
/// - Mostrar menu de opções de suporte responsivo
/// - Gerenciar exercícios de respiração
/// - Integrar com contatos de emergência
/// - Design responsivo baseado em ResponsiveValue
///
/// Author: Gabriel Teixeira
/// Refactored by: Assistant
/// Created on: 19-08-2025
/// Last modified: 31-08-2025
/// 
/// Changes:
/// - Ajustado Falar com a Planta. (Evelin Cordeiro)
/// 
/// Version: 3.0.0 - Layout Responsivo
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/theme/typography.dart';
import 'package:metamorfose_flutter/blocs/sos_bloc.dart';
import 'package:metamorfose_flutter/state/sos/sos_state.dart';
import 'package:metamorfose_flutter/state/sos/sos_events.dart';
import 'package:metamorfose_flutter/models/breathing_exercise.dart';
import 'package:metamorfose_flutter/models/sos_contact.dart';
import 'package:metamorfose_flutter/services/gemini_service.dart';
import 'package:metamorfose_flutter/services/sos_service.dart';
import 'package:metamorfose_flutter/components/input_field.dart';
import 'package:metamorfose_flutter/components/metamorfose_button.dart';
import 'package:metamorfose_flutter/components/secondary_button.dart';

import 'dart:async';
import 'package:url_launcher/url_launcher.dart';


class _SosLayoutConstants {
  static const double shadowBlurRadius = 16.0;
}

/// Helper simplificado usando apenas os botões padrão do projeto
class _MetamorfeseButtonHelper {
  /// Botão primário roxo - padrão do projeto
  static Widget createPrimaryButton({
    required String text,
    required VoidCallback? onPressed,
    Widget? child,
    bool isLoading = false,
  }) {
    if (isLoading) {
      return MetamorfeseButton(
        text: text,
        onPressed: () {}, // Não faz nada quando loading
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              MetamorfoseColors.whiteLight,
            ),
          ),
        ),
      );
    }

    return MetamorfeseButton(
      text: text,
      onPressed: onPressed ?? () {},
      child: child,
    );
  }

  /// Botão secundário branco - padrão do projeto
  static Widget createSecondaryButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return MetamorfeseSecondaryButton(
      text: text,
      onPressed: onPressed,
    );
  }


  /// Botão vermelho para exclusão
  static Widget createDeleteButton({
    required String text,
    required VoidCallback? onPressed,
  }) {
    final bool isDisabled = onPressed == null;

    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: isDisabled
            ? MetamorfoseColors.redNormal.withOpacity(0.5)
            : MetamorfoseColors.redNormal,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: MetamorfoseColors.redNormal,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: MetamorfoseColors.redDark,
            blurRadius: 0,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: MetamorfoseColors.whiteLight,
                fontSize: 15,
                fontFamily: 'DinNext',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  bool _showOptions = false;
  SosContact? _lastKnownContact;

  @override
  void initState() {
    super.initState();
    context.read<SosBloc>().add(InitializeSosEvent());

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);

    // Inicializar o contato conhecido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = context.read<SosBloc>().state;
      _lastKnownContact = currentState.emergencyContact;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onSosPressed() {
    setState(() {
      _showOptions = !_showOptions;
    });

    if (_showOptions) {
      _fadeController.forward();
      context.read<SosBloc>().add(ActivateSosEvent());
    } else {
      _fadeController.reverse();
      context.read<SosBloc>().add(DeactivateSosEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Valores responsivos usando ResponsiveValue
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final verticalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
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

    final maxContentWidth = ResponsiveValue<double>(
      context,
      defaultValue: 400.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: double.infinity),
        Condition.largerThan(name: TABLET, value: 500.0),
      ],
    ).value;


    return BlocConsumer<SosBloc, SosState>(
      listener: (context, state) {
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage!,
                style: AppTypography.bodyMedium.copyWith(
                  color: MetamorfoseColors.whiteLight,
                ),
                textAlign: TextAlign.center,
              ),
              backgroundColor: MetamorfoseColors.redNormal,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(horizontalPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          );
          context.read<SosBloc>().add(ClearSosErrorEvent());
        }

        final previousContact = _lastKnownContact;
        if (state.emergencyContact != previousContact) {
          _lastKnownContact = state.emergencyContact;

          if (mounted) {
            setState(() {});
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: MetamorfoseColors.purpleDark,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  MetamorfoseColors.purpleDark,
                  MetamorfoseColors.purpleNormal,
                  MetamorfoseColors.purpleLight,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Column(
                    children: [
                      _buildResponsiveHeader(context, horizontalPadding, borderRadius),

                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: Column(
                            children: [
                              SizedBox(height: verticalPadding * 2),

                              _buildResponsiveSosButton(state, context),

                              SizedBox(height: verticalPadding * 1.5),

                              if (_showOptions)
                                _buildResponsiveOptionsMenu(state, context, horizontalPadding, borderRadius),

                              SizedBox(height: verticalPadding),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResponsiveHeader(BuildContext context, double horizontalPadding, double borderRadius) {
    final headerHeight = ResponsiveValue<double>(
      context,
      defaultValue: 60.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 50.0),
        Condition.largerThan(name: TABLET, value: 70.0),
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

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    return Container(
      height: headerHeight,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: spacing * 0.5,
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.go('/home'),
              borderRadius: BorderRadius.circular(borderRadius * 0.75),
              child: Container(
                padding: EdgeInsets.all(spacing * 0.5),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: MetamorfoseColors.whiteLight,
                  size: iconSize,
                ),
              ),
            ),
          ),
          SizedBox(width: spacing),
        ],
      ),
    );
  }

  Widget _buildResponsiveSosButton(SosState state, BuildContext context) {
    final buttonSize = ResponsiveValue<double>(
      context,
      defaultValue: 200.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 160.0),
        Condition.largerThan(name: TABLET, value: 240.0),
      ],
    ).value;

    final fontSize = ResponsiveValue<double>(
      context,
      defaultValue: 32.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 28.0),
        Condition.largerThan(name: TABLET, value: 36.0),
      ],
    ).value;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onSosPressed,
        borderRadius: BorderRadius.circular(buttonSize / 2),
        splashColor: MetamorfoseColors.whiteLight.withOpacity(0.2),
        highlightColor: MetamorfoseColors.whiteLight.withOpacity(0.1),
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      MetamorfoseColors.redNormal,
                      MetamorfoseColors.pinkNormal,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: MetamorfoseColors.purpleLight.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: MetamorfoseColors.purpleLight.withOpacity(0.4),
                      offset: const Offset(0, 12),
                      blurRadius: _SosLayoutConstants.shadowBlurRadius,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: MetamorfoseColors.purpleLight.withOpacity(0.25),
                      offset: const Offset(0, 20),
                      blurRadius: _SosLayoutConstants.shadowBlurRadius * 1.5,
                      spreadRadius: 4,
                    ),
                    BoxShadow(
                      color: MetamorfoseColors.purpleLight.withOpacity(0.2),
                      offset: const Offset(0, 0),
                      blurRadius: 2,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'SOS',
                    textAlign: TextAlign.center,
                    style: AppTypography.displayLarge.copyWith(
                      color: MetamorfoseColors.whiteLight,
                      fontWeight: FontWeight.w900,
                      fontSize: fontSize,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResponsiveOptionsMenu(
      SosState state, BuildContext context, double horizontalPadding, double borderRadius) {
    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
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


    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(horizontalPadding),
            decoration: BoxDecoration(
              color: MetamorfoseColors.whiteLight.withOpacity(0.96),
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: MetamorfoseColors.shadowLight,
                  offset: const Offset(0, 4),
                  blurRadius: _SosLayoutConstants.shadowBlurRadius,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'O que você precisa?',
                  style: AppTypography.titleLarge.copyWith(
                    color: MetamorfoseColors.greyDark,
                    fontWeight: FontWeight.w700,
                    fontSize: titleFontSize,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: spacing),

                _buildVerticalOptionsLayout(state, context),

                SizedBox(height: spacing),

                _buildEmergencyContactsSection(state, context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerticalOptionsLayout(SosState state, BuildContext context) {
    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    return Column(
      children: [
        _buildResponsiveOptionCard(
          icon: Icons.chat_bubble_outline,
          title: 'Conversar com sua Planta',
          subtitle: 'Desabafe e receba apoio da sua companheira virtual',
          onTap: () => _talkToPlant(),
          color: MetamorfoseColors.greenNormal,
          context: context,
        ),
        SizedBox(height: spacing),
        _buildResponsiveOptionCard(
          icon: Icons.location_on,
          title: 'Psicólogos Próximos',
          subtitle: 'Encontre ajuda profissional',
          onTap: () =>
              context.read<SosBloc>().add(OpenNearbyPsychologistsEvent()),
          color: MetamorfoseColors.purpleNormal,
          context: context,
        ),
      ],
    );
  }


  Widget _buildResponsiveOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    required BuildContext context,
  }) {
    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final cardHeight = ResponsiveValue<double>(
      context,
      defaultValue: 80.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 70.0),
        Condition.largerThan(name: TABLET, value: 90.0),
      ],
    ).value;

    final cardPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
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

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 24.0),
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.05),
        child: Container(
          constraints: BoxConstraints(
            minHeight: cardHeight,
          ),
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing * 0.6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(borderRadius * 0.6),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: iconSize,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleSmall.copyWith(
                        color: MetamorfoseColors.greyDark,
                        fontWeight: FontWeight.w600,
                        fontSize: titleFontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: MetamorfoseColors.greyMedium,
                        fontSize: subtitleFontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color.withOpacity(0.6),
                size: iconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Navega para o chat de voz com a planta do usuário
  void _talkToPlant() {
    try {
      // Navegar para o chat com personalidade padrão (mais empática)
      context.push('/chat', extra: PersonalityType.padrao);
      debugPrint("🌱 SOS - Navegando para conversar com a planta");
    } catch (e) {
      debugPrint("🌱 SOS - Erro na navegação: $e");
      // Fallback: navegar para home e depois para chat
      context.go('/home');
      Future.delayed(Duration(milliseconds: 100), () {
        if (context.mounted) {
          context.push('/chat', extra: PersonalityType.padrao);
        }
      });
    }
  }

  Widget _buildEmergencyContactsSection(SosState state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.hasEmergencyContact && state.emergencyContact != null)
          _buildExistingContactCard(state.emergencyContact!, context)
        else
          _buildAddContactCard(context),
      ],
    );
  }

  Widget _buildAddContactCard(BuildContext context) {
    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final cardHeight = ResponsiveValue<double>(
      context,
      defaultValue: 80.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 70.0),
        Condition.largerThan(name: TABLET, value: 90.0),
      ],
    ).value;

    final cardPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
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

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 24.0),
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showAddContactModal(context),
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: MetamorfoseColors.purpleNormal.withOpacity(0.1),
        highlightColor: MetamorfoseColors.purpleNormal.withOpacity(0.05),
        child: Container(
          constraints: BoxConstraints(
            minHeight: cardHeight,
          ),
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: MetamorfoseColors.blueNormal.withOpacity(0.08),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: MetamorfoseColors.blueNormal.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing * 0.6),
                decoration: BoxDecoration(
                  color: MetamorfoseColors.blueNormal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(borderRadius * 0.6),
                ),
                child: Icon(
                  Icons.person_add,
                  color: MetamorfoseColors.blueNormal,
                  size: iconSize,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Contatos de Emergência',
                      style: AppTypography.titleSmall.copyWith(
                        color: MetamorfoseColors.greyDark,
                        fontWeight: FontWeight.w600,
                        fontSize: titleFontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      'Adicionar contato de confiança para emergências',
                      style: AppTypography.bodySmall.copyWith(
                        color: MetamorfoseColors.greyMedium,
                        fontSize: subtitleFontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: MetamorfoseColors.blueNormal.withOpacity(0.6),
                size: iconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExistingContactCard(SosContact contact, BuildContext context) {
    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    final cardHeight = ResponsiveValue<double>(
      context,
      defaultValue: 80.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 70.0),
        Condition.largerThan(name: TABLET, value: 90.0),
      ],
    ).value;

    final cardPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
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

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 24.0),
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

    return Container(
      constraints: BoxConstraints(
        minHeight: cardHeight,
      ),
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: MetamorfoseColors.greenNormal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: MetamorfoseColors.greenNormal.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing * 0.6),
                decoration: BoxDecoration(
                  color: MetamorfoseColors.greenNormal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(borderRadius * 0.6),
                ),
                child: Icon(
                  Icons.emergency,
                  color: MetamorfoseColors.greenNormal,
                  size: iconSize,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Contatos de Emergência',
                      style: AppTypography.titleSmall.copyWith(
                        color: MetamorfoseColors.greyDark,
                        fontWeight: FontWeight.w600,
                        fontSize: titleFontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: spacing * 0.25),
                    Text(
                      '${contact.name} - ${contact.phoneNumber}',
                      style: AppTypography.bodySmall.copyWith(
                        color: MetamorfoseColors.greyMedium,
                        fontSize: subtitleFontSize,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showEditContactModal(contact, context),
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Container(
                    padding: EdgeInsets.all(spacing * 0.5),
                    child: Icon(
                      Icons.edit,
                      color: MetamorfoseColors.blueNormal,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: spacing),

          _buildWhatsAppButton(contact, context),
        ],
      ),
    );
  }

  Widget _buildWhatsAppButton(SosContact contact, BuildContext context) {
    final borderRadius = ResponsiveValue<double>(
      context,
      defaultValue: 12.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 10.0),
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

    final cardHeight = ResponsiveValue<double>(
      context,
      defaultValue: 80.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 70.0),
        Condition.largerThan(name: TABLET, value: 90.0),
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
      defaultValue: 14.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: MetamorfoseColors.greenNormal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 6,
        padding: EdgeInsets.symmetric(
            vertical: spacing * 0.8,
            horizontal: spacing),
        minimumSize: Size(double.infinity, cardHeight * 0.4),
      ),
      onPressed: () => _enviarMensagemWhatsApp(contact),
      icon: Icon(Icons.chat, color: MetamorfoseColors.whiteLight, size: iconSize),
      label: Text(
        "ENVIAR MENSAGEM WHATSAPP",
        style: AppTypography.titleSmall.copyWith(
          color: MetamorfoseColors.whiteLight,
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Enviar mensagem WhatsApp usando url_launcher
  Future<void> _enviarMensagemWhatsApp(SosContact contact) async {
    // Formatar telefone para formato internacional (Brasil: 5511999999999)
    final telefone = _formatarTelefoneParaWhatsApp(contact.phoneNumber);

    final mensagem = """
Oi, ${contact.name}! Esse é um alerta SOS do aplicativo Metamorfose.
Estou em um momento difícil e preciso de ajuda agora.
Podemos conversar?
""";

    final url = Uri.parse(
      "https://wa.me/$telefone?text=${Uri.encodeComponent(mensagem)}",
    );

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);

        // Fecha o modal automaticamente após 500ms
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted && _showOptions) {
            setState(() {
              _showOptions = false;
            });
            _fadeController.reverse();
            context.read<SosBloc>().add(DeactivateSosEvent());
          }
        });
      } else {
        if (mounted) {
          final horizontalPadding = ResponsiveValue<double>(
            context,
            defaultValue: 24.0,
            conditionalValues: const [
              Condition.smallerThan(name: MOBILE, value: 16.0),
              Condition.largerThan(name: TABLET, value: 32.0),
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

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Não foi possível abrir o WhatsApp.",
                style: AppTypography.bodyMedium.copyWith(
                  color: MetamorfoseColors.whiteLight,
                ),
                textAlign: TextAlign.center,
              ),
              backgroundColor: MetamorfoseColors.redNormal,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(horizontalPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final horizontalPadding = ResponsiveValue<double>(
          context,
          defaultValue: 24.0,
          conditionalValues: const [
            Condition.smallerThan(name: MOBILE, value: 16.0),
            Condition.largerThan(name: TABLET, value: 32.0),
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Erro ao abrir WhatsApp: $e",
              style: AppTypography.bodyMedium.copyWith(
                color: MetamorfoseColors.whiteLight,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: MetamorfoseColors.redNormal,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(horizontalPadding),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        );
      }
    }
  }

  /// Formatar telefone para formato internacional do WhatsApp
  String _formatarTelefoneParaWhatsApp(String telefone) {
    // Remove todos os caracteres não numéricos
    String numeros = telefone.replaceAll(RegExp(r'[^\d]'), '');

    // Se já tem 13 dígitos (55 + DDD + 9 dígitos), retorna como está
    if (numeros.length == 13) {
      return numeros;
    }

    // Se tem 12 dígitos (DDD + 9 dígitos), adiciona 55
    if (numeros.length == 12) {
      return '55$numeros';
    }

    // Se tem 11 dígitos (DDD + 9 dígitos), adiciona 55
    if (numeros.length == 11) {
      return '55$numeros';
    }

    // Se tem 10 dígitos (DDD + 8 dígitos), adiciona 55
    if (numeros.length == 10) {
      return '55$numeros';
    }

    // Se não conseguir formatar, retorna como está
    return numeros;
  }

  void _showAddContactModal(BuildContext context) {
    final bool useCompactLayout = ResponsiveBreakpoints.of(context).isMobile;

    if (useCompactLayout) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => BlocProvider.value(
          value: context.read<SosBloc>(),
          child: _EmergencyContactModal(
            useCompactLayout: useCompactLayout,
            isEditing: false,
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        useSafeArea: true,
        builder: (_) => BlocProvider.value(
          value: context.read<SosBloc>(),
          child: _EmergencyContactModal(
            useCompactLayout: useCompactLayout,
            isEditing: false,
          ),
        ),
      );
    }
  }

  void _showEditContactModal(SosContact contact, BuildContext context) {
    final bool useCompactLayout = ResponsiveBreakpoints.of(context).isMobile;

    if (useCompactLayout) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => BlocProvider.value(
          value: context.read<SosBloc>(),
          child: _EmergencyContactModal(
            useCompactLayout: useCompactLayout,
            isEditing: true,
            contact: contact,
            onContactDeleted: _forceUIUpdateAfterContactDeletion,
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        useSafeArea: true,
        builder: (_) => BlocProvider.value(
          value: context.read<SosBloc>(),
          child: _EmergencyContactModal(
            useCompactLayout: useCompactLayout,
            isEditing: true,
            contact: contact,
            onContactDeleted: _forceUIUpdateAfterContactDeletion,
          ),
        ),
      );
    }
  }

  /// Força a atualização da UI após a exclusão de um contato.
  /// Isso é necessário porque a exclusão é assíncrona e a UI não se atualiza
  /// instantaneamente devido ao BlocConsumer.
  void _forceUIUpdateAfterContactDeletion() {
    if (mounted) {
      setState(() {});
    }
  }
}

// Modal responsivo para contatos de emergência
class _EmergencyContactModal extends StatefulWidget {
  final bool useCompactLayout;
  final bool isEditing;
  final SosContact? contact;
  final VoidCallback? onContactDeleted;

  const _EmergencyContactModal({
    required this.useCompactLayout,
    required this.isEditing,
    this.contact,
    this.onContactDeleted,
  });

  @override
  State<_EmergencyContactModal> createState() => _EmergencyContactModalState();
}

class _EmergencyContactModalState extends State<_EmergencyContactModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationshipController = TextEditingController();

  bool _isLoading = false;
  String? _nameError;
  String? _phoneError;
  String? _relationshipError;

  @override
  void initState() {
    super.initState();

    // Preencher campos se estiver editando
    if (widget.isEditing && widget.contact != null) {
      _nameController.text = widget.contact!.name;
      _phoneController.text = widget.contact!.phoneNumber;
      _relationshipController.text = widget.contact!.message ?? '';
    }

    // Adicionar listeners para validação em tempo real
    _nameController.addListener(_validateName);
    _phoneController.addListener(_validatePhone);
    _relationshipController.addListener(_validateRelationship);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  void _validateName() {
    setState(() {
      _nameError =
          _nameController.text.trim().isEmpty ? 'Nome é obrigatório' : null;
    });
  }

  void _validatePhone() {
    setState(() {
      if (_phoneController.text.trim().isEmpty) {
        _phoneError = 'Telefone é obrigatório';
      } else {
        final cleanPhone =
            _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
        if (cleanPhone.length < 10 || cleanPhone.length > 11) {
          _phoneError = 'Digite um telefone válido (10 ou 11 dígitos)';
        } else {
          _phoneError = null;
        }
      }
    });
  }

  void _validateRelationship() {
    setState(() {
      _relationshipError = null; // Relacionamento é opcional
    });
  }

  String _formatPhoneNumber(String phone) {
    // Remove todos os caracteres não numéricos
    String numbers = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Limita a 11 dígitos (DDD + 9 dígitos)
    if (numbers.length > 11) {
      numbers = numbers.substring(0, 11);
    }

    // Aplica formatação baseada no comprimento
    if (numbers.length <= 2) {
      return numbers;
    } else if (numbers.length <= 7) {
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2)}';
    } else if (numbers.length <= 11) {
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7)}';
    }

    return numbers;
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final sosBloc = context.read<SosBloc>();
      final sosService = SosService();

      final contact = SosContact(
        id: widget.contact?.id ?? sosService.generateContactId(),
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        message: _relationshipController.text.trim().isNotEmpty
            ? _relationshipController.text.trim()
            : null,
        isActive: true,
        createdAt: widget.contact?.createdAt ?? DateTime.now(),
      );

      if (widget.isEditing) {
        sosBloc.add(UpdateEmergencyContactEvent(contact));
      } else {
        sosBloc.add(SaveEmergencyContactEvent(contact));
      }

      // Fechar modal
      if (mounted) {
        Navigator.of(context).pop();

        // Mostrar feedback de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing
                  ? 'Contato atualizado com sucesso!'
                  : 'Contato salvo com sucesso!',
              style: AppTypography.bodyMedium.copyWith(
                color: MetamorfoseColors.whiteLight,
              ),
            ),
            backgroundColor: MetamorfoseColors.greenNormal,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao salvar contato: $e',
              style: AppTypography.bodyMedium.copyWith(
                color: MetamorfoseColors.whiteLight,
              ),
            ),
            backgroundColor: MetamorfoseColors.redNormal,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteContact() async {
    // Mostrar diálogo de confirmação
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MetamorfoseColors.whiteLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Limpar Contato',
          style: AppTypography.titleMedium.copyWith(
            color: MetamorfoseColors.greyDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Tem certeza que deseja limpar todos os campos deste contato? Esta ação pode ser desfeita editando novamente.',
          style: AppTypography.bodyMedium.copyWith(
            color: MetamorfoseColors.greyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'CANCELAR',
              style: AppTypography.bodyMedium.copyWith(
                color: MetamorfoseColors.greyMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              backgroundColor: MetamorfoseColors.blueNormal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'LIMPAR CAMPOS',
              style: AppTypography.bodyMedium.copyWith(
                color: MetamorfoseColors.whiteLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Limpar todos os campos
        _nameController.clear();
        _phoneController.clear();
        _relationshipController.clear();

        final sosBloc = context.read<SosBloc>();

        final emptyContact = SosContact(
          id: widget.contact!.id,
          name: '',
          phoneNumber: '',
          message: '',
          isActive: false, // Marcar como inativo
          createdAt: widget.contact!.createdAt,
        );

        // Atualizar o contato com campos vazios
        sosBloc.add(UpdateEmergencyContactEvent(emptyContact));

        // Fechar modal e atualizar tela principal
        if (mounted) {
          // Chamar callback para forçar atualização da UI na tela principal
          if (widget.onContactDeleted != null) {
            widget.onContactDeleted!();
          }

          // Fechar o modal de edição
          Navigator.of(context).pop();

          // Mostrar feedback de sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Contato limpo com sucesso!',
                style: AppTypography.bodyMedium.copyWith(
                  color: MetamorfoseColors.whiteLight,
                ),
              ),
              backgroundColor: MetamorfoseColors.blueNormal,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro ao limpar contato: $e',
                style: AppTypography.bodyMedium.copyWith(
                  color: MetamorfoseColors.whiteLight,
                ),
              ),
              backgroundColor: MetamorfoseColors.redNormal,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveValue<double>(
      context,
      defaultValue: 500.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: double.infinity),
        Condition.largerThan(name: TABLET, value: 600.0),
      ],
    ).value;

    if (widget.useCompactLayout) {
      // Modal centralizado para compact
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(32),
        child: Container(
          width: maxWidth,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: MetamorfoseColors.whiteLight,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: MetamorfoseColors.shadowLight,
                offset: const Offset(0, 8),
                blurRadius: 24,
                spreadRadius: 0,
              ),
            ],
          ),
          child: _buildModalContent(),
        ),
      );
    } else {
      // Bottom sheet para normal
      return Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: MetamorfoseColors.whiteLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: _buildModalContent(),
      );
    }
  }

  Widget _buildModalContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.useCompactLayout)
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: MetamorfoseColors.greyLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

        Padding(
          padding: EdgeInsets.all(widget.useCompactLayout ? 32 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.isEditing
                          ? 'Editar Contato de Emergência'
                          : 'Adicionar Contato de Emergência',
                      style: AppTypography.titleLarge.copyWith(
                        color: MetamorfoseColors.greyDark,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  if (widget.useCompactLayout)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.close,
                            color: MetamorfoseColors.greyMedium,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                'Configure um contato de confiança para emergências',
                style: AppTypography.bodyMedium.copyWith(
                  color: MetamorfoseColors.greyMedium,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),

        // Formulário
        Flexible(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(
                horizontal: widget.useCompactLayout ? 32 : 24,
              ),
              children: [
                // Campo Nome
                InputField(
                  hintText: 'Nome completo',
                  controller: _nameController,
                  errorText: _nameError,
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    size: 20,
                    color: MetamorfoseColors.purpleLight,
                  ),
                ),

                SizedBox(height: 16),

                // Campo Telefone
                InputField(
                  hintText: 'Telefone',
                  controller: _phoneController,
                  errorText: _phoneError,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    size: 20,
                    color: MetamorfoseColors.purpleLight,
                  ),
                  onChanged: (value) {
                    final formatted = _formatPhoneNumber(value);
                    if (formatted != value) {
                      _phoneController.value = _phoneController.value.copyWith(
                        text: formatted,
                        selection:
                            TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                  },
                ),

                SizedBox(height: 16),

                // Campo Relacionamento
                InputField(
                  hintText: 'Relacionamento (ex.: mãe, amigo, parceiro)',
                  controller: _relationshipController,
                  errorText: _relationshipError,
                  prefixIcon: const Icon(
                    Icons.favorite_outline,
                    size: 20,
                    color: MetamorfoseColors.purpleLight,
                  ),
                ),

                SizedBox(height: widget.useCompactLayout ? 32 : 24),

                // Botões de ação
                _buildActionButtons(),

                SizedBox(height: widget.useCompactLayout ? 32 : 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Botão principal
        _MetamorfeseButtonHelper.createPrimaryButton(
          text: widget.isEditing ? 'ATUALIZAR CONTATO' : 'SALVAR CONTATO',
          onPressed: _isLoading ? null : _saveContact,
          isLoading: _isLoading,
        ),

        if (widget.isEditing) ...[
          SizedBox(height: 16),

          // Botão de exclusão
          _MetamorfeseButtonHelper.createDeleteButton(
            text: 'EXCLUIR CONTATO',
            onPressed: _isLoading ? null : _deleteContact,
          ),
        ],

        SizedBox(height: 16),

        // Botão cancelar
        _MetamorfeseButtonHelper.createSecondaryButton(
          text: 'CANCELAR',
          onPressed: _isLoading ? () {} : () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

// Dialog para sessão de respiração
class _BreathingSessionDialog extends StatefulWidget {
  final BreathingExercise exercise;

  const _BreathingSessionDialog({required this.exercise});

  @override
  State<_BreathingSessionDialog> createState() =>
      _BreathingSessionDialogState();
}

class _BreathingSessionDialogState extends State<_BreathingSessionDialog>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  String _currentPhase = 'Inspire';
  int _currentCycle = 1;
  int _timeLeft = 0;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    _startBreathing();
  }

  void _startBreathing() {
    setState(() {
      _isActive = true;
      _currentPhase = 'Inspire';
      _timeLeft = widget.exercise.inhaleSeconds;
    });

    _breathingController.repeat(reverse: true);
    _startTimer();
  }

  void _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted || !_isActive) {
        timer.cancel();
        return;
      }

      setState(() {
        _timeLeft--;
      });

      if (_timeLeft <= 0) {
        _nextPhase();
      }
    });
  }

  void _nextPhase() {
    if (_currentPhase == 'Inspire') {
      setState(() {
        _currentPhase = 'Segure';
        _timeLeft = widget.exercise.holdSeconds;
      });
    } else if (_currentPhase == 'Segure') {
      setState(() {
        _currentPhase = 'Expire';
        _timeLeft = widget.exercise.exhaleSeconds;
      });
    } else {
      if (_currentCycle < widget.exercise.cycles) {
        setState(() {
          _currentCycle++;
          _currentPhase = 'Inspire';
          _timeLeft = widget.exercise.inhaleSeconds;
        });
      } else {
        _finishSession();
        return;
      }
    }
  }

  void _finishSession() {
    if (!mounted) return;

    setState(() {
      _isActive = false;
    });

    _breathingController.stop();

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
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

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
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

    final buttonSize = ResponsiveValue<double>(
      context,
      defaultValue: 200.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 160.0),
        Condition.largerThan(name: TABLET, value: 240.0),
      ],
    ).value;

    final bodyFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 14.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 16.0),
      ],
    ).value;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(horizontalPadding * 1.3),
        decoration: BoxDecoration(
          color: MetamorfoseColors.whiteLight,
          borderRadius: BorderRadius.circular(borderRadius * 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.exercise.name,
              style: AppTypography.titleLarge.copyWith(
                color: MetamorfoseColors.greyDark,
                fontWeight: FontWeight.w700,
                fontSize: titleFontSize,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing * 2),
            AnimatedBuilder(
              animation: _breathingAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _breathingAnimation.value,
                  child: Container(
                    width: buttonSize * 0.6,
                    height: buttonSize * 0.6,
                    decoration: BoxDecoration(
                      color: MetamorfoseColors.greenNormal.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.air,
                      color: MetamorfoseColors.greenNormal,
                      size: 20.0,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: spacing * 2),
            Text(
              _currentPhase,
              style: AppTypography.displayMedium.copyWith(
                color: MetamorfoseColors.greenNormal,
                fontWeight: FontWeight.w700,
                fontSize: titleFontSize * 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing),
            Text(
              '$_timeLeft',
              style: AppTypography.displayLarge.copyWith(
                color: MetamorfoseColors.greyDark,
                fontWeight: FontWeight.w200,
                fontSize: titleFontSize * 2.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing),
            Text(
              'Ciclo $_currentCycle de ${widget.exercise.cycles}',
              style: AppTypography.bodyMedium.copyWith(
                color: MetamorfoseColors.greyMedium,
                fontSize: bodyFontSize,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing * 2),
            if (_isActive)
              ElevatedButton(
                onPressed: () {
                  if (!mounted) return;

                  setState(() {
                    _isActive = false;
                  });
                  _breathingController.stop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MetamorfoseColors.redNormal,
                  foregroundColor: MetamorfoseColors.whiteLight,
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding * 1.3,
                      vertical: spacing),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
                child: Text(
                  'Parar',
                  style: AppTypography.titleMedium.copyWith(
                    color: MetamorfoseColors.whiteLight,
                    fontWeight: FontWeight.w600,
                    fontSize: bodyFontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
