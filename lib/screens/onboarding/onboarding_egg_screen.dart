/// File: onboarding_egg_screen.dart
/// Description: Tela de onboarding que apresenta o conceito do ovo.
///
/// Responsabilidades:
/// - Apresentar a metáfora do ovo como estado inicial
/// - Explicar o processo de transformação
/// - Navegação para próxima etapa do onboarding
///
/// Author: Ester Santos
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


/// Tela de onboarding do ovo (egg)
class OnboardingEggScreen extends StatelessWidget {
  const OnboardingEggScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    final centerY = screenSize.height / 2;
    
    // Valores responsivos
    final backgroundTopPadding = ResponsiveValue<double>(
      context,
      defaultValue: 5.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 3.0),
        Condition.largerThan(name: TABLET, value: 8.0),
      ],
    ).value;

    final statusBarExtra = ResponsiveValue<double>(
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
        Condition.smallerThan(name: MOBILE, value: 0.65),
        Condition.largerThan(name: TABLET, value: 0.75),
      ],
    ).value;

    final ivyHeightFactor = ResponsiveValue<double>(
      context,
      defaultValue: 0.26,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 0.24),
        Condition.largerThan(name: TABLET, value: 0.28),
      ],
    ).value;

    final backButtonSize = ResponsiveValue<double>(
      context,
      defaultValue: 34.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 30.0),
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
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 24.0),
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

    final textOffsetFromCenter = ResponsiveValue<double>(
      context,
      defaultValue: 60.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 50.0),
        Condition.largerThan(name: TABLET, value: 70.0),
      ],
    ).value;

    final textHorizontalPadding = ResponsiveValue<double>(
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

    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final progressIndicatorHeight = ResponsiveValue<double>(
      context,
      defaultValue: 11.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 9.0),
        Condition.largerThan(name: TABLET, value: 13.0),
      ],
    ).value;

    final distanceFromTop = centerY + textOffsetFromCenter;

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
            final maxTextTop = constraints.maxHeight - 200;
            final textTop = distanceFromTop < maxTextTop ? distanceFromTop : maxTextTop;
            
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: topPadding + statusBarExtra,
                  child: Container(color: MetamorfoseColors.purpleNormal),
                ),
                Positioned(
                  top: backgroundTopPadding,
                  left: 0,
                  right: 0,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: screenSize.height * 0.7,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/onboarding/bg_wave_1.svg',
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
                          onPressed: () => context.go(Routes.onboardingPlant),
                          color: MetamorfoseColors.blackNormal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Image.asset(
                        'assets/images/onboarding/ic_egg.png',
                        width: screenSize.width * ivyWidthFactor,
                        height: screenSize.height * ivyHeightFactor,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: textTop - (topPadding + backgroundTopPadding + screenSize.height * ivyHeightFactor)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: textHorizontalPadding),
                        child: Text(
                          'Esse é você agora, aqui você começa sua jornada de transformação.',
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
                              'assets/images/onboarding/ic_onboarding_progress_temp_medium.svg',
                              height: progressIndicatorHeight,
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
                                onPressed: () => context.go(Routes.onboardingButterfly),
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