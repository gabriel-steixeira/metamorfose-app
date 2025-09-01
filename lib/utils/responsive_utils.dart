/**
 * File: responsive_utils.dart
 * Description: Utilitários responsivos para o aplicativo Metamorfose.
 *
 * Responsabilidades:
 * - Fornecer breakpoints responsivos
 * - Determinar o tipo de dispositivo
 * - Oferecer utilitários de largura, altura e padding responsivos
 *
 * Author: Evelin Cordeiro
 * Created on: 31-08-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:metamorfose_flutter/theme/colors.dart';

/// Breakpoints responsivos baseados em padrões da indústria
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1800;
  static const double ultraWide = 2560;
  
  // Breakpoints específicos para dispositivos menores
  static const double smallMobile = 360;
  static const double largeMobile = 480;
}

/// Enumeração dos tipos de dispositivo
enum DeviceType { smallMobile, mobile, tablet, desktop, largeDesktop, ultraWide }

/// Classe principal para utilitários responsivos
class ResponsiveUtils {
  /// Determina o tipo de dispositivo baseado na largura da tela
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= ResponsiveBreakpoints.ultraWide) return DeviceType.ultraWide;
    if (width >= ResponsiveBreakpoints.largeDesktop) return DeviceType.largeDesktop;
    if (width >= ResponsiveBreakpoints.desktop) return DeviceType.desktop;
    if (width >= ResponsiveBreakpoints.tablet) return DeviceType.tablet;
    if (width >= ResponsiveBreakpoints.mobile) return DeviceType.mobile;
    return DeviceType.smallMobile;
  }

  /// Retorna se o dispositivo é mobile (qualquer tipo)
  static bool isMobile(BuildContext context) {
    final type = getDeviceType(context);
    return type == DeviceType.mobile || type == DeviceType.smallMobile;
  }

  /// Retorna se o dispositivo é mobile pequeno
  static bool isSmallMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.smallMobile;

  /// Retorna se o dispositivo é tablet
  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  /// Retorna se o dispositivo é desktop (qualquer tipo)
  static bool isDesktop(BuildContext context) {
    final type = getDeviceType(context);
    return type == DeviceType.desktop || 
           type == DeviceType.largeDesktop || 
           type == DeviceType.ultraWide;
  }

  /// Retorna largura responsiva baseada em porcentagem da tela
  static double getResponsiveWidth(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  /// Retorna altura responsiva baseada em porcentagem da tela
  static double getResponsiveHeight(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

    /// Padding responsivo baseado no tipo de dispositivo
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.smallMobile:
        return const EdgeInsets.all(12);
      case DeviceType.mobile:
        return const EdgeInsets.all(16);
      case DeviceType.tablet:
        return const EdgeInsets.all(24);
      case DeviceType.desktop:
        return const EdgeInsets.all(32);
      case DeviceType.largeDesktop:
        return const EdgeInsets.all(40);
      case DeviceType.ultraWide:
        return const EdgeInsets.all(48);
    }
  }

    /// Padding horizontal responsivo
  static EdgeInsets getResponsiveHorizontalPadding(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.smallMobile:
        return const EdgeInsets.symmetric(horizontal: 12);
      case DeviceType.mobile:
        return const EdgeInsets.symmetric(horizontal: 16);
      case DeviceType.tablet:
        return const EdgeInsets.symmetric(horizontal: 32);
      case DeviceType.desktop:
        return const EdgeInsets.symmetric(horizontal: 48);
      case DeviceType.largeDesktop:
        return const EdgeInsets.symmetric(horizontal: 64);
      case DeviceType.ultraWide:
        return const EdgeInsets.symmetric(horizontal: 80);
    }
  }

    /// Tamanho de fonte responsivo
  static double getResponsiveFontSize(
      BuildContext context, double baseFontSize) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.smallMobile:
        return baseFontSize * 0.9;
      case DeviceType.mobile:
        return baseFontSize;
      case DeviceType.tablet:
        return baseFontSize * 1.1;
      case DeviceType.desktop:
        return baseFontSize * 1.2;
      case DeviceType.largeDesktop:
        return baseFontSize * 1.3;
      case DeviceType.ultraWide:
        return baseFontSize * 1.4;
    }
  }

    /// Espaçamento vertical responsivo
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.smallMobile:
        return baseSpacing * 0.8;
      case DeviceType.mobile:
        return baseSpacing;
      case DeviceType.tablet:
        return baseSpacing * 1.2;
      case DeviceType.desktop:
        return baseSpacing * 1.4;
      case DeviceType.largeDesktop:
        return baseSpacing * 1.6;
      case DeviceType.ultraWide:
        return baseSpacing * 1.8;
    }
  }

    /// Largura máxima do conteúdo para diferentes dispositivos
  static double getMaxContentWidth(BuildContext context) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.smallMobile:
        return double.infinity;
      case DeviceType.mobile:
        return double.infinity;
      case DeviceType.tablet:
        return 700;
      case DeviceType.desktop:
        return 900;
      case DeviceType.largeDesktop:
        return 1200;
      case DeviceType.ultraWide:
        return 1400;
    }
  }

    /// Border radius responsivo
  static double getResponsiveBorderRadius(
      BuildContext context, double baseBorderRadius) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.smallMobile:
        return baseBorderRadius * 0.9;
      case DeviceType.mobile:
        return baseBorderRadius;
      case DeviceType.tablet:
        return baseBorderRadius * 1.1;
      case DeviceType.desktop:
        return baseBorderRadius * 1.2;
      case DeviceType.largeDesktop:
        return baseBorderRadius * 1.3;
      case DeviceType.ultraWide:
        return baseBorderRadius * 1.4;
    }
  }

  /// Shadow padrão responsivo para inputs e botões
  static List<BoxShadow> getDefaultShadow({bool isInput = false}) {
    return [
      BoxShadow(
        color: MetamorfoseColors.defaultButtonShadow,
        blurRadius: isInput ? 8 : 0,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ];
  }

  /// Shadow elevado para cartões
  static List<BoxShadow> getElevatedShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ];
  }
}

/// Widget responsivo que adapta seu layout baseado no dispositivo
class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;
  final Widget? ultraWide;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
    this.ultraWide,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.ultraWide:
        return ultraWide ?? largeDesktop ?? desktop ?? tablet ?? mobile;
      case DeviceType.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.mobile:
      case DeviceType.smallMobile:
        return mobile;
    }
  }
}

/// Builder responsivo para construir layouts específicos por dispositivo
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    return builder(context, deviceType);
  }
}

/// Extensão para MediaQuery com utilitários responsivos
extension ResponsiveMediaQuery on BuildContext {
  /// Largura da tela
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Altura da tela
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Tipo de dispositivo
  DeviceType get deviceType => ResponsiveUtils.getDeviceType(this);

  /// Se é mobile
  bool get isMobile => ResponsiveUtils.isMobile(this);

  /// Se é tablet
  bool get isTablet => ResponsiveUtils.isTablet(this);

  /// Se é desktop
  bool get isDesktop => ResponsiveUtils.isDesktop(this);

  /// Padding responsivo
  EdgeInsets get responsivePadding =>
      ResponsiveUtils.getResponsivePadding(this);

  /// Padding horizontal responsivo
  EdgeInsets get responsiveHorizontalPadding =>
      ResponsiveUtils.getResponsiveHorizontalPadding(this);
}
