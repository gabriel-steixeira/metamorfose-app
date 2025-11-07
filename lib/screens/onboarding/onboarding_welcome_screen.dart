/// File: onboarding_welcome_screen.dart
/// Description: Tela de boas-vindas do fluxo de onboarding.
///
/// Responsabilidades:
/// - Apresentar uma introdução sobre o conceito do aplicativo
/// - Exibir a proposta de valor do Metamorfose
/// - Navegar para a próxima tela do onboarding
///
/// Author: Gabriel Teixeira
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/primary_button.dart';
import 'package:metamorfose_flutter/components/speech_bubble.dart';

/// Tela de boas-vindas do fluxo de onboarding.
/// Apresenta uma introdução sobre o conceito do aplicativo e sua proposta.
class OnboardingWelcomeScreen extends StatelessWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        Condition.smallerThan(name: MOBILE, value: 320.0),
        Condition.largerThan(name: TABLET, value: 400.0),
      ],
    ).value;

    final iconSize = ResponsiveValue<double>(
      context,
      defaultValue: 34.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 28.0),
        Condition.largerThan(name: TABLET, value: 40.0),
      ],
    ).value;

    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 21.92,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 18.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final bodyFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    final spacing = ResponsiveValue<double>(
      context,
      defaultValue: 20.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 24.0),
      ],
    ).value;

    final screenSize = MediaQuery.of(context).size;
    final bubbleWidth = screenSize.width * 0.85;

    return Scaffold(
      backgroundColor: MetamorfoseColors.whiteLight,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: SvgPicture.asset(
                'assets/images/onboarding/bg_wave_4.svg',
                width: MediaQuery.of(context).size.width,
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
                    onPressed: () => context.go(Routes.onboarding),
                    color: MetamorfoseColors.blackNormal,
                  ),
                ),
                
                const Spacer(flex: 1),
                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: SpeechBubble(
                    width: bubbleWidth,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Parabéns por começar!\n',
                            style: TextStyle(
                              color: MetamorfoseColors.greyMedium,
                              fontSize: titleFontSize,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: 'Eu sou o ',
                            style: TextStyle(
                              color: MetamorfoseColors.greyMedium,
                              fontSize: bodyFontSize,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: 'Ivy',
                            style: TextStyle(
                              color: MetamorfoseColors.purpleNormal,
                              fontSize: bodyFontSize,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: ', seu guia nessa jornada de ',
                            style: TextStyle(
                              color: MetamorfoseColors.greyMedium,
                              fontSize: bodyFontSize,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: 'superação',
                            style: TextStyle(
                              color: MetamorfoseColors.greenDark,
                              fontSize: bodyFontSize,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: ' dos seus vícios. Vamos juntos nessa ',
                            style: TextStyle(
                              color: MetamorfoseColors.greyMedium,
                              fontSize: bodyFontSize,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: 'transformação',
                            style: TextStyle(
                              color: MetamorfoseColors.purpleNormal,
                              fontSize: bodyFontSize,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: '?',
                            style: TextStyle(
                              color: MetamorfoseColors.greyMedium,
                              fontSize: bodyFontSize,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                    ),
                  ),
                ),
                
                SizedBox(height: spacing),
                
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    'assets/images/onboarding/ivy_happy.png',
                    width: MediaQuery.of(context).size.width * 0.8,
                    fit: BoxFit.contain,
                  ),
                ),
                
                const Spacer(flex: 1),
                
                Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    bottom: bottomPadding,
                  ),
                  child: SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: MetamorfosePrimaryButton(
                      text: 'Vamos lá',
                      onPressed: () => context.go(Routes.onboardingPlant),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 