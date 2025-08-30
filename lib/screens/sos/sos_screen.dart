/**
 * File: sos_screen.dart
 * Description: Tela principal do Botão SOS do Metamorfose - Refatorada com Layout Responsivo
 *
 * Responsabilidades:
 * - Exibir botão SOS central com animação pulsante
 * - Mostrar menu de opções de suporte responsivo
 * - Gerenciar exercícios de respiração
 * - Integrar com contatos de emergência
 * - Design responsivo baseado em porcentagens da tela
 *
 * Author: Gabriel Teixeira
 * Refactored by: Assistant
 * Created on: 19-08-2025
 * Last modified: 22-08-2025
 * Version: 3.0.0 - Layout Responsivo
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
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
import 'package:metamorfose_flutter/components/metamorfose_input.dart';
import 'package:metamorfose_flutter/components/metamorfose_button.dart';
import 'package:metamorfose_flutter/components/metamorfose_secondary_button.dart';
import 'package:metamorfose_flutter/components/custom_button.dart';

import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

/// Sistema de Layout Responsivo baseado em porcentagens da tela
class ResponsiveLayout {
  static ResponsiveLayout of(BuildContext context) {
    return ResponsiveLayout._(context);
  }

  ResponsiveLayout._(this._context);
  
  final BuildContext _context;
  late final MediaQueryData _mediaQuery = MediaQuery.of(_context);
  late final Size _screenSize = _mediaQuery.size;
  late final double _screenWidth = _screenSize.width;
  late final double _screenHeight = _screenSize.height;
  late final double _pixelRatio = _mediaQuery.devicePixelRatio;
  
  /// Dimensões responsivas baseadas em porcentagens
  double get width => _screenWidth;
  double get height => _screenHeight;
  
  /// Padding e margens responsivos
  double get horizontalPadding => _screenWidth * 0.06; // 6% da largura
  double get verticalPadding => _screenHeight * 0.02; // 2% da altura
  double get cardSpacing => _screenHeight * 0.025; // 2.5% da altura (reduzido)
  double get sectionSpacing => _screenHeight * 0.035; // 3.5% da altura (reduzido)
  
  /// Tamanhos de elementos responsivos
  double get headerHeight => _screenHeight * 0.12; // 12% da altura
  double get buttonSize => (_screenWidth * 0.45).clamp(160.0, 220.0); // 45% da largura
  double get iconSize => buttonSize * 0.25;
  double get fontSize => buttonSize * 0.15;
  
  /// Tamanhos de cards responsivos
  double get cardHeight => _screenHeight * 0.12; // 12% da altura
  double get cardPadding => _screenWidth * 0.04; // 4% da largura
  double get borderRadius => _screenWidth * 0.04; // 4% da largura
  
  /// Tamanhos de texto responsivos
  double get titleFontSize => _screenHeight * 0.025; // 2.5% da altura (reduzido)
  double get subtitleFontSize => _screenHeight * 0.018; // 1.8% da altura (reduzido)
  double get bodyFontSize => _screenHeight * 0.015; // 1.5% da altura (reduzido)
  
  /// Breakpoints responsivos baseados em porcentagens
  bool get isSmallScreen => _screenWidth < _screenHeight * 0.8; // Largura < 80% da altura
  bool get isMediumScreen => _screenWidth >= _screenHeight * 0.8 && _screenWidth < _screenHeight * 1.2;
  bool get isLargeScreen => _screenWidth >= _screenHeight * 1.2;
  
  /// Layout adaptativo baseado no tamanho da tela
  bool get useHorizontalLayout => _screenWidth > _screenHeight * 1.1;
  bool get useCompactLayout => _screenHeight < 600;
  
  /// Espaçamentos dinâmicos
  double get dynamicSpacing => _screenHeight * 0.015; // 1.5% da altura
  double get largeSpacing => _screenHeight * 0.03; // 3% da altura
  double get extraLargeSpacing => _screenHeight * 0.05; // 5% da altura
}

/// Constantes de layout responsivo (mantidas para compatibilidade)
class _SosLayoutConstants {
  static const double minButtonSize = 160.0;
  static const double maxButtonSize = 220.0;
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

  /// Botão verde especial para WhatsApp
  static Widget createWhatsAppButton({
    required String text,
    required VoidCallback onPressed,
    Widget? child,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      backgroundColor: MetamorfoseColors.greenNormal,
      textColor: MetamorfoseColors.whiteLight,
      shadowColor: MetamorfoseColors.greenDarken,
      strokeColor: MetamorfoseColors.greenNormal,
      child: child,
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
        color: isDisabled ? MetamorfoseColors.redNormal.withOpacity(0.5) : MetamorfoseColors.redNormal,
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
    final ResponsiveLayout responsive = ResponsiveLayout.of(context);
    final double maxContentWidth = responsive.width * 0.9; // 90% da largura da tela
    
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
              ),
              backgroundColor: MetamorfoseColors.redNormal,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(responsive.horizontalPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(responsive.borderRadius),
              ),
            ),
          );
          context.read<SosBloc>().add(ClearSosErrorEvent());
        }
        
        // Detectar mudanças específicas no contato de emergência
        final previousContact = _lastKnownContact;
        if (state.emergencyContact != previousContact) {
          _lastKnownContact = state.emergencyContact;

          // Forçar rebuild apenas se necessário
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
                      // Header responsivo
                      _buildResponsiveHeader(context),
                      
                      // Conteúdo central com scroll
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.horizontalPadding,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: responsive.height * 0.08),
                              
                              // Botão SOS responsivo
                              _buildResponsiveSosButton(state, responsive),
                              
                              SizedBox(height: responsive.height * 0.06),
                              
                              // Menu de opções responsivo
                              if (_showOptions) 
                                _buildResponsiveOptionsMenu(state, responsive),
                              
                              SizedBox(height: responsive.sectionSpacing),
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

  Widget _buildResponsiveHeader(BuildContext context) {
    final ResponsiveLayout responsive = ResponsiveLayout.of(context);
    return Container(
      height: responsive.headerHeight,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.horizontalPadding,
        vertical: responsive.verticalPadding,
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.go('/home'),
              borderRadius: BorderRadius.circular(responsive.borderRadius * 0.75),
              child: Container(
                padding: EdgeInsets.all(responsive.dynamicSpacing),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: MetamorfoseColors.whiteLight,
                  size: responsive.titleFontSize,
                ),
              ),
            ),
          ),
          SizedBox(width: responsive.dynamicSpacing),

        ],
      ),
    );
  }

  Widget _buildResponsiveSosButton(SosState state, ResponsiveLayout responsive) {
    final double buttonSize = responsive.buttonSize;
    final double iconSize = responsive.iconSize;
    final double fontSize = responsive.fontSize;
    
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
                    // Sombra interna para profundidade
                    BoxShadow(
                      color: MetamorfoseColors.purpleLight.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                    // Sombra externa principal
                    BoxShadow(
                      color: MetamorfoseColors.purpleLight.withOpacity(0.4),
                      offset: const Offset(0, 12),
                      blurRadius: _SosLayoutConstants.shadowBlurRadius,
                      spreadRadius: 2,
                    ),
                    // Sombra externa secundária para efeito de brilho
                    BoxShadow(
                      color: MetamorfoseColors.purpleLight.withOpacity(0.25),
                      offset: const Offset(0, 20),
                      blurRadius: _SosLayoutConstants.shadowBlurRadius * 1.5,
                      spreadRadius: 4,
                    ),
                    // Sombra de borda para definição
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
                      fontSize: fontSize * 1.4,
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

  Widget _buildResponsiveOptionsMenu(SosState state, ResponsiveLayout responsive) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(responsive.horizontalPadding),
            decoration: BoxDecoration(
              color: MetamorfoseColors.whiteLight.withOpacity(0.96),
              borderRadius: BorderRadius.circular(responsive.borderRadius),
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
                    fontSize: responsive.titleFontSize,
                  ),
                ),
                SizedBox(height: responsive.dynamicSpacing),
                
                                 // Layout responsivo para as opções baseado no tamanho da tela
                 if (responsive.useHorizontalLayout)
                   _buildHorizontalOptionsLayout(state, responsive)
                 else
                   _buildVerticalOptionsLayout(state, responsive),
                 
                 SizedBox(height: responsive.cardSpacing),
                 
                 // Seção de Contatos de Emergência
                 _buildEmergencyContactsSection(state, responsive),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildVerticalOptionsLayout(SosState state, ResponsiveLayout responsive) {
    return Column(
      children: [
        _buildResponsiveOptionCard(
          icon: Icons.psychology,
          title: 'Técnicas de Enfrentamento',
          subtitle: 'Estratégias baseadas em TCC, ACT e Entrevista Motivacional',
          onTap: () => _showCopingTechniques(state, responsive),
          color: MetamorfoseColors.greenNormal,
          responsive: responsive,
        ),
        
        SizedBox(height: responsive.cardSpacing),
        
        _buildResponsiveOptionCard(
          icon: Icons.location_on,
          title: 'Psicólogos Próximos',
          subtitle: 'Encontre ajuda profissional',
          onTap: () => context.read<SosBloc>().add(OpenNearbyPsychologistsEvent()),
          color: MetamorfoseColors.purpleNormal,
          responsive: responsive,
        ),
      ],
    );
  }
  
  Widget _buildHorizontalOptionsLayout(SosState state, ResponsiveLayout responsive) {
    return Row(
      children: [
        Expanded(
          child: _buildResponsiveOptionCard(
            icon: Icons.psychology,
            title: 'Técnicas de Enfrentamento',
            subtitle: 'Estratégias TCC, ACT e EM',
            onTap: () => _showCopingTechniques(state, responsive),
            color: MetamorfoseColors.greenNormal,
            responsive: responsive,
          ),
        ),
        SizedBox(width: responsive.cardSpacing),
        Expanded(
          child: _buildResponsiveOptionCard(
            icon: Icons.location_on,
            title: 'Psicólogos Próximos',
            subtitle: 'Ajuda profissional',
            onTap: () => context.read<SosBloc>().add(OpenNearbyPsychologistsEvent()),
            color: MetamorfoseColors.purpleNormal,
            responsive: responsive,
          ),
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
    required ResponsiveLayout responsive,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.borderRadius),
        splashColor: color.withOpacity(0.1),
        highlightColor: color.withOpacity(0.05),
        child: Container(
          constraints: BoxConstraints(
            minHeight: responsive.cardHeight,
          ),
          padding: EdgeInsets.all(responsive.cardPadding),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(responsive.borderRadius),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(responsive.dynamicSpacing * 0.6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(responsive.borderRadius * 0.6),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: responsive.subtitleFontSize,
                ),
              ),
              SizedBox(width: responsive.dynamicSpacing),
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
                        fontSize: responsive.subtitleFontSize,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: responsive.dynamicSpacing * 0.25),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: MetamorfoseColors.greyMedium,
                        fontSize: responsive.bodyFontSize,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color.withOpacity(0.6),
                size: responsive.bodyFontSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCopingTechniques(SosState state, ResponsiveLayout responsive) {
    final sosBloc = context.read<SosBloc>();
    final bool useCompactLayout = responsive.useCompactLayout;
    
    if (useCompactLayout) {
      // Para telas compactas, usa showDialog centralizado
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => BlocProvider.value(
          value: sosBloc,
          child: _ResponsiveCopingTechniquesSheet(useCompactLayout: useCompactLayout),
        ),
      );
    } else {
      // Para telas normais, usa showModalBottomSheet
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        useSafeArea: true,
        builder: (_) => BlocProvider.value(
          value: sosBloc,
          child: _ResponsiveCopingTechniquesSheet(useCompactLayout: useCompactLayout),
        ),
      );
    }
  }

  /// Seção de Contatos de Emergência
  Widget _buildEmergencyContactsSection(SosState state, ResponsiveLayout responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card de contato existente ou card para adicionar
        if (state.hasEmergencyContact && state.emergencyContact != null)
          _buildExistingContactCard(state.emergencyContact!, responsive)
        else
          _buildAddContactCard(responsive),
      ],
    );
  }

  /// Card para adicionar novo contato
  Widget _buildAddContactCard(ResponsiveLayout responsive) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showAddContactModal(responsive),
        borderRadius: BorderRadius.circular(responsive.borderRadius),
        splashColor: MetamorfoseColors.purpleNormal.withOpacity(0.1),
        highlightColor: MetamorfoseColors.purpleNormal.withOpacity(0.05),
        child: Container(
          constraints: BoxConstraints(
            minHeight: responsive.cardHeight,
          ),
          padding: EdgeInsets.all(responsive.cardPadding),
                     decoration: BoxDecoration(
             color: MetamorfoseColors.blueNormal.withOpacity(0.08),
             borderRadius: BorderRadius.circular(responsive.borderRadius),
             border: Border.all(
               color: MetamorfoseColors.blueNormal.withOpacity(0.2),
               width: 1,
             ),
           ),
           child: Row(
             children: [
               Container(
                 padding: EdgeInsets.all(responsive.dynamicSpacing * 0.6),
                 decoration: BoxDecoration(
                   color: MetamorfoseColors.blueNormal.withOpacity(0.15),
                   borderRadius: BorderRadius.circular(responsive.borderRadius * 0.6),
                 ),
                 child: Icon(
                   Icons.person_add,
                   color: MetamorfoseColors.blueNormal,
                   size: responsive.subtitleFontSize,
                 ),
               ),
              SizedBox(width: responsive.dynamicSpacing),
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
                        fontSize: responsive.subtitleFontSize,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: responsive.dynamicSpacing * 0.25),
                    Text(
                      'Adicionar contato de confiança para emergências',
                      style: AppTypography.bodySmall.copyWith(
                        color: MetamorfoseColors.greyMedium,
                        fontSize: responsive.bodyFontSize,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
                             Icon(
                 Icons.arrow_forward_ios,
                 color: MetamorfoseColors.blueNormal.withOpacity(0.6),
                 size: responsive.bodyFontSize,
               ),
            ],
          ),
        ),
      ),
    );
  }

  /// Card de contato existente
  Widget _buildExistingContactCard(SosContact contact, ResponsiveLayout responsive) {
    return Container(
      constraints: BoxConstraints(
        minHeight: responsive.cardHeight,
      ),
      padding: EdgeInsets.all(responsive.cardPadding),
      decoration: BoxDecoration(
        color: MetamorfoseColors.greenNormal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(responsive.borderRadius),
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
                padding: EdgeInsets.all(responsive.dynamicSpacing * 0.6),
                decoration: BoxDecoration(
                  color: MetamorfoseColors.greenNormal.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(responsive.borderRadius * 0.6),
                ),
                child: Icon(
                  Icons.emergency,
                  color: MetamorfoseColors.greenNormal,
                  size: responsive.subtitleFontSize,
                ),
              ),
              SizedBox(width: responsive.dynamicSpacing),
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
                        fontSize: responsive.subtitleFontSize,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: responsive.dynamicSpacing * 0.25),
                    Text(
                      '${contact.name} - ${contact.phoneNumber}',
                      style: AppTypography.bodySmall.copyWith(
                        color: MetamorfoseColors.greyMedium,
                        fontSize: responsive.bodyFontSize,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Botão de edição
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showEditContactModal(contact, responsive),
                  borderRadius: BorderRadius.circular(responsive.borderRadius),
                  child: Container(
                    padding: EdgeInsets.all(responsive.dynamicSpacing * 0.5),
                    child: Icon(
                      Icons.edit,
                      color: MetamorfoseColors.blueNormal,
                      size: responsive.subtitleFontSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: responsive.dynamicSpacing),
          
          // Botão WhatsApp integrado ao card
          _buildWhatsAppButton(contact, responsive),
        ],
      ),
    );
  }

  /// Botão WhatsApp
  Widget _buildWhatsAppButton(SosContact contact, ResponsiveLayout responsive) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF25D366), // Verde WhatsApp/Metamorfose
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.borderRadius),
        ),
        elevation: 6,
        padding: EdgeInsets.symmetric(
          vertical: responsive.dynamicSpacing * 0.8, 
          horizontal: responsive.dynamicSpacing
        ),
        minimumSize: Size(double.infinity, responsive.cardHeight * 0.4),
      ),
      onPressed: () => _enviarMensagemWhatsApp(contact),
      icon: Icon(
        Icons.chat, 
        color: Colors.white, 
        size: responsive.subtitleFontSize
      ),
      label: Text(
        "ENVIAR MENSAGEM WHATSAPP",
        style: AppTypography.titleSmall.copyWith(
          color: MetamorfoseColors.whiteLight,
          fontWeight: FontWeight.w600,
          fontSize: responsive.bodyFontSize,
        ),
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
          final responsive = ResponsiveLayout.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Não foi possível abrir o WhatsApp.",
                style: AppTypography.bodyMedium.copyWith(
                  color: MetamorfoseColors.whiteLight,
                ),
              ),
              backgroundColor: MetamorfoseColors.redNormal,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(responsive.horizontalPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(responsive.borderRadius),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final responsive = ResponsiveLayout.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Erro ao abrir WhatsApp: $e",
              style: AppTypography.bodyMedium.copyWith(
                color: MetamorfoseColors.whiteLight,
              ),
            ),
            backgroundColor: MetamorfoseColors.redNormal,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(responsive.horizontalPadding),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(responsive.borderRadius),
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

  /// Modal para adicionar contato
  void _showAddContactModal(ResponsiveLayout responsive) {
    final bool useCompactLayout = responsive.useCompactLayout;
    
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

  /// Modal para editar contato
  void _showEditContactModal(SosContact contact, ResponsiveLayout responsive) {
    final bool useCompactLayout = responsive.useCompactLayout;
    
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
      _nameError = _nameController.text.trim().isEmpty 
          ? 'Nome é obrigatório' 
          : null;
    });
  }

  void _validatePhone() {
    setState(() {
      if (_phoneController.text.trim().isEmpty) {
        _phoneError = 'Telefone é obrigatório';
      } else {
        final cleanPhone = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
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
          
          // Criar contato vazio para atualizar
          final sosBloc = context.read<SosBloc>();
          final sosService = SosService();
          
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
    final ResponsiveLayout responsive = ResponsiveLayout.of(context);
    final double maxWidth = widget.useCompactLayout ? 500.0 : responsive.width;
    
    if (widget.useCompactLayout) {
      // Modal centralizado para compact
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(32),
        child: Container(
          width: maxWidth,
          constraints: BoxConstraints(
            maxHeight: responsive.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: MetamorfoseColors.whiteLight,
            borderRadius: BorderRadius.circular(responsive.borderRadius),
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
          maxHeight: responsive.height * 0.9,
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
        // Handle (apenas para compact)
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
        
        // Header
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
                MetamorfeseInput(
                  hintText: 'Nome completo',
                  controller: _nameController,
                  errorText: _nameError,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.person_outline,
                      size: 22,
                      color: MetamorfoseColors.purpleNormal,
                    ),
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Campo Telefone
                MetamorfeseInput(
                  hintText: 'Telefone',
                  controller: _phoneController,
                  errorText: _phoneError,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.phone_outlined,
                      size: 22,
                      color: MetamorfoseColors.purpleNormal,
                    ),
                  ),
                  onChanged: (value) {
                    final formatted = _formatPhoneNumber(value);
                    if (formatted != value) {
                      _phoneController.value = _phoneController.value.copyWith(
                        text: formatted,
                        selection: TextSelection.collapsed(offset: formatted.length),
                      );
                    }
                  },
                ),
                
                SizedBox(height: 16),
                
                // Campo Relacionamento
                MetamorfeseInput(
                  hintText: 'Relacionamento (ex.: mãe, amigo, parceiro)',
                  controller: _relationshipController,
                  errorText: _relationshipError,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.favorite_outline,
                      size: 22,
                      color: MetamorfoseColors.purpleNormal,
                    ),
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

// Sheet responsivo para técnicas de enfrentamento
class _ResponsiveCopingTechniquesSheet extends StatelessWidget {
  final bool useCompactLayout;
  
  const _ResponsiveCopingTechniquesSheet({required this.useCompactLayout});
  
  @override
  Widget build(BuildContext context) {
    final ResponsiveLayout responsive = ResponsiveLayout.of(context);
    final double maxWidth = useCompactLayout ? 600.0 : responsive.width;
    
    if (useCompactLayout) {
      // Modal centralizado para compact
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(32),
        child: Container(
          width: maxWidth,
          constraints: BoxConstraints(
            maxHeight: responsive.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: MetamorfoseColors.whiteLight,
            borderRadius: BorderRadius.circular(responsive.borderRadius),
            boxShadow: [
              BoxShadow(
                color: MetamorfoseColors.shadowLight,
                offset: const Offset(0, 8),
                blurRadius: 24,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
      );
    } else {
      // Bottom sheet para normal
      return Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: responsive.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: MetamorfoseColors.whiteLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: _buildTechniquesContent(),
      );
    }
  }

  Widget _buildTechniquesContent() {
    return Builder(
      builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle (apenas para compact)
        if (!useCompactLayout)
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: MetamorfoseColors.greyLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        
        // Header
        Padding(
          padding: EdgeInsets.all(useCompactLayout ? 32 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Técnicas de Enfrentamento',
                      style: AppTypography.titleLarge.copyWith(
                        color: MetamorfoseColors.greyDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (useCompactLayout)
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
                'Estratégias baseadas em evidências científicas para lidar com crises',
                style: AppTypography.bodyMedium.copyWith(
                  color: MetamorfoseColors.greyMedium,
                ),
              ),
            ],
          ),
        ),
        
        // Lista de técnicas
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              horizontal: useCompactLayout ? 32 : 24,
            ),
            children: [
              _ResponsiveCopingTechniqueCard(
                title: 'Terapia Cognitivo-Comportamental (TCC)',
                subtitle: 'Identificar e desafiar pensamentos negativos',
                description: 'Quando você se sentir sobrecarregado, pergunte-se: "Esta situação é realmente tão ruim quanto parece? Existe outra forma de ver isso?" A TCC ajuda a reconhecer padrões de pensamento que podem estar causando sofrimento e a desenvolver estratégias mais saudáveis para lidar com desafios.',
                color: MetamorfoseColors.greenNormal,
                technique: 'tcc',
                isCompact: useCompactLayout,
              ),
              
                             SizedBox(height: 16),
               
               _ResponsiveCopingTechniqueCard(
                 title: 'Terapia de Aceitação e Compromisso (ACT)',
                 subtitle: 'Aceitar emoções e focar no que importa',
                 description: 'Em vez de lutar contra seus sentimentos, observe-os com curiosidade. Lembre-se dos seus valores e do que realmente importa para você. A ACT ensina a aceitar experiências difíceis enquanto se compromete com ações alinhadas aos seus valores pessoais.',
                 color: MetamorfoseColors.blueNormal,
                 technique: 'act',
                 isCompact: useCompactLayout,
               ),
               
               SizedBox(height: 16),
               
               _ResponsiveCopingTechniqueCard(
                 title: 'Entrevista Motivacional',
                 subtitle: 'Explorar sua motivação para mudança',
                 description: 'Reflita sobre o que você quer mudar e por quê. Quais são os benefícios de fazer algo diferente agora? A Entrevista Motivacional ajuda a explorar ambivalências e fortalecer a motivação intrínseca para mudanças positivas em sua vida.',
                 color: MetamorfoseColors.purpleNormal,
                 technique: 'entrevista_motivacional',
                 isCompact: useCompactLayout,
               ),
              
              SizedBox(height: useCompactLayout ? 32 : 24),
            ],
          ),
        ),
      ],
      ),
    );
  }
}

// Card responsivo para técnica de enfrentamento
class _ResponsiveCopingTechniqueCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final String technique;
  final bool isCompact;

  const _ResponsiveCopingTechniqueCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.technique,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    final ResponsiveLayout responsive = ResponsiveLayout.of(context);
    return Container(
      padding: EdgeInsets.all(isCompact ? responsive.cardPadding * 1.5 : responsive.cardPadding),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(responsive.borderRadius),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(responsive.dynamicSpacing * 0.6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(responsive.borderRadius * 0.6),
                ),
                child: Icon(
                  Icons.psychology,
                  color: color,
                  size: responsive.subtitleFontSize,
                ),
              ),
              SizedBox(width: responsive.dynamicSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleSmall.copyWith(
                        color: MetamorfoseColors.greyDark,
                        fontWeight: FontWeight.w600,
                        fontSize: responsive.subtitleFontSize,
                      ),
                    ),
                    SizedBox(height: responsive.dynamicSpacing * 0.25),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: MetamorfoseColors.greyMedium,
                        fontSize: responsive.bodyFontSize,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.dynamicSpacing * 0.5, 
                  vertical: responsive.dynamicSpacing * 0.25
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(responsive.borderRadius * 0.4),
                ),
                child: Text(
                  technique.toUpperCase(),
                  style: AppTypography.bodySmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: responsive.bodyFontSize * 0.8,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: responsive.dynamicSpacing),
          
          Text(
            description,
            style: AppTypography.bodySmall.copyWith(
              color: MetamorfoseColors.greyMedium,
              fontStyle: FontStyle.italic,
              height: 1.4,
              fontSize: responsive.bodyFontSize,
            ),
          ),
          
          SizedBox(height: responsive.dynamicSpacing),
          
          // Botão roxo padrão para todas as técnicas
          _MetamorfeseButtonHelper.createPrimaryButton(
            text: isCompact 
                ? 'Conversar com Persona usando esta técnica'
                : 'Conversar com Persona\nusando esta técnica',
            onPressed: () {
              Navigator.pop(context);
              _redirectToVoiceChatWithTechnique(context, title, technique);
            },
          ),
        ],
      ),
    );
  }

  void _redirectToVoiceChatWithTechnique(BuildContext context, String title, String technique) {
    // Mapear técnica para personalidade correspondente
    final personalityType = _mapTechniqueToPersonality(technique);
    
    debugPrint("🎭 SOS - Técnica: $technique -> Personalidade: ${personalityType.id}");
    
    // Usar push com argumentos extras em vez de go com parâmetros na URL
    try {
      context.push('/voice-chat', extra: personalityType);
      debugPrint("🎭 SOS - Navegação GoRouter executada com personalidade: ${personalityType.id}");
    } catch (e) {
      debugPrint("🎭 SOS - Erro na navegação GoRouter: $e");
      // Fallback: navegar para home e depois para voice-chat
      context.go('/home');
      Future.delayed(Duration(milliseconds: 100), () {
        if (context.mounted) {
          context.push('/voice-chat', extra: personalityType);
        }
      });
    }
  }

  /// Mapeia a técnica de enfrentamento para a personalidade correspondente
  PersonalityType _mapTechniqueToPersonality(String technique) {
    switch (technique) {
      case 'tcc':
        return PersonalityType.tcc;
      case 'act':
        return PersonalityType.act;
      case 'entrevista_motivacional':
        return PersonalityType.entrevistaMotivacional;
      default:
        debugPrint("🎭 SOS - Técnica não reconhecida: $technique, usando padrão");
        return PersonalityType.padrao;
    }
  }
}

// Dialog para sessão de respiração
class _BreathingSessionDialog extends StatefulWidget {
  final BreathingExercise exercise;

  const _BreathingSessionDialog({required this.exercise});

  @override
  State<_BreathingSessionDialog> createState() => _BreathingSessionDialogState();
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
    final ResponsiveLayout responsive = ResponsiveLayout.of(context);
    
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(responsive.horizontalPadding * 1.3),
        decoration: BoxDecoration(
          color: MetamorfoseColors.whiteLight,
          borderRadius: BorderRadius.circular(responsive.borderRadius * 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.exercise.name,
              style: AppTypography.titleLarge.copyWith(
                color: MetamorfoseColors.greyDark,
                fontWeight: FontWeight.w700,
                fontSize: responsive.titleFontSize,
              ),
            ),
            
            SizedBox(height: responsive.largeSpacing),
            
            AnimatedBuilder(
              animation: _breathingAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _breathingAnimation.value,
                  child: Container(
                    width: responsive.buttonSize * 0.6,
                    height: responsive.buttonSize * 0.6,
                    decoration: BoxDecoration(
                      color: MetamorfoseColors.greenNormal.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.air,
                      color: MetamorfoseColors.greenNormal,
                      size: responsive.buttonSize * 0.3,
                    ),
                  ),
                );
              },
            ),
            
            SizedBox(height: responsive.largeSpacing),
            
            Text(
              _currentPhase,
              style: AppTypography.displayMedium.copyWith(
                color: MetamorfoseColors.greenNormal,
                fontWeight: FontWeight.w700,
                fontSize: responsive.titleFontSize * 1.2,
              ),
            ),
            
            SizedBox(height: responsive.dynamicSpacing),
            
            Text(
              '$_timeLeft',
              style: AppTypography.displayLarge.copyWith(
                color: MetamorfoseColors.greyDark,
                fontWeight: FontWeight.w200,
                fontSize: responsive.titleFontSize * 2.4,
              ),
            ),
            
            SizedBox(height: responsive.dynamicSpacing),
            
            Text(
              'Ciclo $_currentCycle de ${widget.exercise.cycles}',
              style: AppTypography.bodyMedium.copyWith(
                color: MetamorfoseColors.greyMedium,
                fontSize: responsive.bodyFontSize,
              ),
            ),
            
            SizedBox(height: responsive.largeSpacing),
            
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
                    horizontal: responsive.horizontalPadding * 1.3, 
                    vertical: responsive.dynamicSpacing
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(responsive.borderRadius),
                  ),
                ),
                child: Text(
                  'Parar',
                  style: AppTypography.titleMedium.copyWith(
                    color: MetamorfoseColors.whiteLight,
                    fontWeight: FontWeight.w600,
                    fontSize: responsive.subtitleFontSize,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}












