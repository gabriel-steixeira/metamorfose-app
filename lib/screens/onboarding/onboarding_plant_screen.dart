/// File: onboarding_plant_screen.dart
/// Description: Tela de onboarding que apresenta a planta do usuário.
///
/// Responsabilidades:
/// - Apresentar o conceito da planta virtual
/// - Explicar como a planta representa o progresso
/// - Navegação para próxima etapa do onboarding
///
/// Author: Gabriel Teixeira e Vitoria Lana
/// Created on: 29-05-2025
/// Last modified: 29-05-2025
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/primary_button.dart';

/// Tela de onboarding que explica o conceito da planta na jornada.
/// Demonstra como a planta é a base para toda a transformação.
class OnboardingPlantScreen extends StatelessWidget {
  const OnboardingPlantScreen({super.key});

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

    final footerPadding = ResponsiveValue<double>(
      context,
      defaultValue: 36.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 48.0),
      ],
    ).value;

    final textFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 21.92,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final backButtonSize = ResponsiveValue<double>(
      context,
      defaultValue: 34.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 28.0),
        Condition.largerThan(name: TABLET, value: 40.0),
      ],
    ).value;

    final buttonSize = ResponsiveValue<double>(
      context,
      defaultValue: 56.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 48.0),
        Condition.largerThan(name: TABLET, value: 64.0),
      ],
    ).value;

    final arrowIconSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final progressIconHeight = ResponsiveValue<double>(
      context,
      defaultValue: 11.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 9.0),
        Condition.largerThan(name: TABLET, value: 13.0),
      ],
    ).value;

    final smallSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 8.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 6.0),
        Condition.largerThan(name: TABLET, value: 12.0),
      ],
    ).value;

    final ivyWidthFactor = ResponsiveValue<double>(
      context,
      defaultValue: 0.7,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 0.8),
        Condition.largerThan(name: TABLET, value: 0.6),
      ],
    ).value;

    final ivyHeightFactor = ResponsiveValue<double>(
      context,
      defaultValue: 0.26,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 0.3),
        Condition.largerThan(name: TABLET, value: 0.22),
      ],
    ).value;

    final screenSize = MediaQuery.of(context).size;
    final double topPadding = MediaQuery.of(context).padding.top;
    final double centerY = screenSize.height / 2;
    final double textOffsetFromCenter = ResponsiveValue<double>(
      context,
      defaultValue: 60.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 40.0),
        Condition.largerThan(name: TABLET, value: 80.0),
      ],
    ).value;
    final double distanceFromTop = centerY + textOffsetFromCenter;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: MetamorfoseColors.purpleNormal,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: MetamorfoseColors.whiteLight,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: MetamorfoseColors.whiteLight,
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Garante que o texto nunca fique fora da tela
            final double maxTextTop = constraints.maxHeight - 200;
            final double textTop = distanceFromTop < maxTextTop ? distanceFromTop : maxTextTop;
            
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: topPadding + 8,
                  child: Container(color: MetamorfoseColors.purpleNormal),
                ),
                Positioned(
                  top: 5,
                  left: 0,
                  right: 0,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenSize.height * 0.7,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/onboarding/bg_wave_5.svg',
                      width: screenSize.width,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/arrow_back.svg',
                            width: backButtonSize,
                            height: backButtonSize,
                          ),
                          onPressed: () => context.go(Routes.onboardingWelcome),
                          color: MetamorfoseColors.blackNormal,
                        ),
                      ),
                      SizedBox(height: smallSpacing),
                      SvgPicture.asset(
                        'assets/images/onboarding/ivy_plant_onboarding.svg',
                        width: screenSize.width * ivyWidthFactor,
                        height: screenSize.height * ivyHeightFactor,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: textTop - (topPadding + 5 + screenSize.height * ivyHeightFactor)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: Text(
                          'Essa é sua plantinha, ela vai crescer e conversar com você.',
                          style: TextStyle(
                            color: MetamorfoseColors.greyMedium,
                            fontSize: textFontSize,
                            fontFamily: 'DinNext',
                            fontWeight: FontWeight.w700,
                            height: 1.40,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(flex: 2),
                      Padding(
                        padding: EdgeInsets.only(
                          left: horizontalPadding,
                          right: horizontalPadding,
                          bottom: footerPadding,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/onboarding/ic_onboarding_progress_beginning.svg',
                              height: progressIconHeight,
                            ),
                            const Spacer(),
                            SizedBox(
                              width: buttonSize,
                              height: buttonSize,
                              child: MetamorfosePrimaryButton(
                                text: '',
                                icon: SvgPicture.asset(
                                  'assets/images/arrow_white.svg',
                                  width: arrowIconSize,
                                  height: arrowIconSize,
                                ),
                                onPressed: () => context.go(Routes.onboardingEgg),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
} 