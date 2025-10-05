/// File: onboarding_butterfly_screen.dart
/// Description: Tela de onboarding que apresenta o conceito da borboleta.
///
/// Responsabilidades:
/// - Apresentar a metáfora da borboleta como transformação final
/// - Explicar o objetivo da jornada
/// - Navegação para próxima etapa do onboarding
///
/// Author: Vitoria Lana
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


/// Tela de onboarding da borboleta (butterfly)
class OnboardingButterflyScreen extends StatelessWidget {
  const OnboardingButterflyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double topPadding = MediaQuery.of(context).padding.top;
    final double centerY = screenSize.height / 2;
    
    final textOffsetFromCenter = ResponsiveValue<double>(
      context,
      defaultValue: 60.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 50.0),
        Condition.largerThan(name: TABLET, value: 70.0),
      ],
    ).value;
    
    final distanceFromTop = centerY + textOffsetFromCenter;
    
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
        Condition.largerThan(name: TABLET, value: 10.0),
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
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
            final double maxTextTop = constraints.maxHeight - 200;
            final double textTop = distanceFromTop < maxTextTop ? distanceFromTop : maxTextTop;
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
                          onPressed: () => context.go(Routes.onboardingEgg),
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Image.asset(
                        'assets/images/onboarding/ic_butterfly.png',
                        width: screenSize.width * ivyWidthFactor,
                        height: screenSize.height * ivyHeightFactor,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: textTop - (topPadding + backgroundTopPadding + screenSize.height * ivyHeightFactor)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: textHorizontalPadding),
                        child: Text(
                          'E esse aqui é você quando se transformar.',
                          style: TextStyle(
                            color: MetamorfoseColors.greyMedium,
                            fontSize: textFontSize,
                            fontFamily: 'DinNext',
                            fontWeight: FontWeight.w700,
                            height: 1.40,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Spacer(flex: 2),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: footerPadding),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/onboarding/ic_onboarding_progress_final.svg',
                              height: 11,
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
                                onPressed: () => context.go(Routes.onboardingFinal),
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