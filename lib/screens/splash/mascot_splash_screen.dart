/// File: mascot_splash_screen.dart
/// Description: Tela de splash com o mascote do aplicativo.
///
/// Responsabilidades:
/// - Exibir mascote e animações
/// - Fazer transição para próxima tela
/// - Apresentar personalidade da aplicação
///
/// Author: Ester Santos
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

/// Tela de splash que exibe o mascote do Metamorfose.
/// Segunda tela de splash exibida após o logo da marca.
class MascotSplashScreen extends StatefulWidget {
  const MascotSplashScreen({super.key});

  @override
  State<MascotSplashScreen> createState() => _MascotSplashScreenState();
}

class _MascotSplashScreenState extends State<MascotSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(Routes.onboarding);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mascotWidth = ResponsiveValue<double>(
      context,
      defaultValue: 0.65,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 0.70),
        Condition.largerThan(name: TABLET, value: 0.60),
      ],
    ).value;

    final mascotHeight = ResponsiveValue<double>(
      context,
      defaultValue: 0.25,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 0.30),
        Condition.largerThan(name: TABLET, value: 0.22),
      ],
    ).value;

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


    return Scaffold(
      backgroundColor: MetamorfoseColors.purpleLight,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SvgPicture.asset(
              'assets/images/splashscreen/ivy_face.svg',
              width: MediaQuery.of(context).size.width * mascotWidth,
              height: MediaQuery.of(context).size.height * mascotHeight,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
} 