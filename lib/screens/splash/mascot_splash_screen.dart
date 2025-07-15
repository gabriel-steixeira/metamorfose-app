/**
 * File: mascot_splash_screen.dart
 * Description: Tela de splash com o mascote do aplicativo.
 *
 * Responsabilidades:
 * - Exibir mascote e animações
 * - Fazer transição para próxima tela
 * - Apresentar personalidade da aplicação
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
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

    // Temporizador para navegar para o onboarding após 3 segundos
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Navegar para a tela de onboarding inicial
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
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MetamorfoseColors.purpleLight,
      body: Stack(
        children: [
          // Mascote centralizado
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SvgPicture.asset(
                'assets/images/splashscreen/ivy_face.svg',
                width: screenSize.width * 0.65,
                height: screenSize.height * 0.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 