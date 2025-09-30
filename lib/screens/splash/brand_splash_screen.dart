/// File: brand_splash_screen.dart
/// Description: Tela de splash com a marca do aplicativo.
///
/// Responsabilidades:
/// - Exibir logo e marca do aplicativo
/// - Fazer transição para próxima tela
/// - Carregamento inicial da aplicação
///
/// Author: Gabriel Teixeira e Vitoria Lana
/// Created on: 29-05-2025
/// Last modified: 29-05-2025
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Tela de splash inicial que exibe o logo da marca Metamorfose.
/// Esta é a primeira tela que o usuário vê ao iniciar o aplicativo.
class BrandSplashScreen extends StatefulWidget {
  const BrandSplashScreen({super.key});

  @override
  State<BrandSplashScreen> createState() => _BrandSplashScreenState();
}

class _BrandSplashScreenState extends State<BrandSplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  /// Inicia o temporizador para navegar para a próxima tela após 2 segundos
  void _startTimer() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go(Routes.mascotSplash);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 48.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 64.0),
      ],
    ).value;

    final verticalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 48.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 32.0),
        Condition.largerThan(name: TABLET, value: 72.0),
      ],
    ).value;

    final logoWidthFactor = ResponsiveValue<double>(
      context,
      defaultValue: 0.5,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 0.65),
        Condition.largerThan(name: TABLET, value: 0.4),
      ],
    ).value;

    final logoHeightFactor = ResponsiveValue<double>(
      context,
      defaultValue: 0.18,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 0.2),
        Condition.largerThan(name: TABLET, value: 0.16),
      ],
    ).value;

    final spacingBetweenLogoAndText = ResponsiveValue<double>(
      context,
      defaultValue: 24.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 28.0),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 46.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 41.0),
        Condition.largerThan(name: TABLET, value: 51.0),
      ],
    ).value;

    final topSpacerFlex = ResponsiveValue<int>(
      context,
      defaultValue: 2,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 1),
        Condition.largerThan(name: TABLET, value: 3),
      ],
    ).value;

    final bottomSpacerFlex = ResponsiveValue<int>(
      context,
      defaultValue: 3,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 2),
        Condition.largerThan(name: TABLET, value: 4),
      ],
    ).value;
    
    return Scaffold(
      backgroundColor: MetamorfoseColors.purpleLight,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: topSpacerFlex),
              SvgPicture.asset(
                'assets/images/splashscreen/simple_butterfly.svg',
                width: screenSize.width * logoWidthFactor,
                height: screenSize.height * logoHeightFactor,
              ),
              SizedBox(height: spacingBetweenLogoAndText),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'metamorfose',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DinNext',
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacer(flex: bottomSpacerFlex),
            ],
          ),
        ),
      ),
    );
  }
} 