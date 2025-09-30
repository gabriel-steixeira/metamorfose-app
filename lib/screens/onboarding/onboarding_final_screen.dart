import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/primary_button.dart';
import 'package:metamorfose_flutter/components/speech_bubble.dart';

/// Tela final do onboarding
class OnboardingFinalScreen extends StatelessWidget {
  const OnboardingFinalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double topPadding = MediaQuery.of(context).padding.top;

    // Valores responsivos
    final buttonHeight = ResponsiveValue<double>(
      context,
      defaultValue: 43.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 40.0),
        Condition.largerThan(name: TABLET, value: 52.0),
      ],
    ).value;

    final buttonWidth = ResponsiveValue<double>(
      context,
      defaultValue: 358.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: double.infinity),
        Condition.largerThan(name: TABLET, value: 400.0),
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

    final bottomPadding = ResponsiveValue<double>(
      context,
      defaultValue: 36.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 48.0),
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

    final ivyWidthFactor = ResponsiveValue<double>(
      context,
      defaultValue: 0.8,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 0.75),
        Condition.largerThan(name: TABLET, value: 0.85),
      ],
    ).value;

    final textFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 18.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final speechBubbleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 22.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 34.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 30.0),
        Condition.largerThan(name: TABLET, value: 38.0),
      ],
    ).value;

    final backgroundTopPadding = ResponsiveValue<double>(
      context,
      defaultValue: 5.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 3.0),
        Condition.largerThan(name: TABLET, value: 7.0),
      ],
    ).value;

    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

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
        body: Stack(
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
                  maxHeight: screenSize.height * 1.2,
                ),
                child: SvgPicture.asset(
                  'assets/images/onboarding/bg_wave_2.svg',
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
                        width: iconSize,
                        height: iconSize,
                      ),
                      onPressed: () => context.go(Routes.onboardingButterfly),
                      color: MetamorfoseColors.blackNormal,
                    ),
                  ),
                  const Spacer(flex: 1),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: SpeechBubble(
                      width: screenSize.width * 0.85,
                      borderColor: MetamorfoseColors.purpleLight,
                      child: Text(
                        'Está pronto para sua metamorfose?',
                        style: TextStyle(
                          color: MetamorfoseColors.greyMedium,
                          fontSize: speechBubbleFontSize,
                          fontFamily: 'DinNext',
                          fontWeight: FontWeight.w700,
                          height: 1.40,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      'assets/images/onboarding/ivy_stars_eyes.png',
                      width: screenSize.width * ivyWidthFactor,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
                    child: Text(
                      'Clique em SIM! para iniciar\n sua jornada',
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
                  const Spacer(flex: 1),
                  Padding(
                    padding: EdgeInsets.only(
                      left: horizontalPadding,
                      right: horizontalPadding,
                      bottom: bottomPadding,
                    ),
                    child: isMobile
                        ? SizedBox(
                            width: double.infinity,
                            height: buttonHeight,
                            child: MetamorfosePrimaryButton(
                              text: 'SIM!',
                              onPressed: () => context.go(Routes.selectionActivityWelcome),
                            ),
                          )
                        : Center(
                            child: SizedBox(
                              width: buttonWidth,
                              height: buttonHeight,
                              child: MetamorfosePrimaryButton(
                                text: 'SIM!',
                                onPressed: () => context.go(Routes.selectionActivityWelcome),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 