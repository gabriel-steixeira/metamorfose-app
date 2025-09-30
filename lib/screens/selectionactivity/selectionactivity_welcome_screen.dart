import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/primary_button.dart';
import 'package:metamorfose_flutter/components/speech_bubble.dart';

/// Apresenta uma introdução sobre o conceito do aplicativo e sua proposta.
class SelectionActivityWelcomeScreen extends StatelessWidget {
  const SelectionActivityWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bubbleWidth = screenSize.width * 0.85;

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

    final subtitleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 14.0),
        Condition.largerThan(name: TABLET, value: 18.0),
      ],
    ).value;

    return Scaffold(
      backgroundColor: MetamorfoseColors.whiteLight,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: MetamorfoseGradients.softPurpleGradient,
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
                    onPressed: () => context.go(Routes.onboardingFinal),
                    color: MetamorfoseColors.purpleDark,
                  ),
                ),
                
                const Spacer(flex: 1),
                
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  child: SpeechBubble(
                    width: bubbleWidth,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: horizontalPadding * 0.75,
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'São só 4 perguntas rápidas.\n',
                              style: TextStyle(
                                color: MetamorfoseColors.purpleDark,
                                fontSize: titleFontSize,
                                fontFamily: 'DinNext',
                                fontWeight: FontWeight.w700,
                                height: 1.40,
                              ),
                            ),
                            TextSpan(
                              text: 'Assim daremos o primeiro passo juntos na sua ',
                              style: TextStyle(
                                color: MetamorfoseColors.greyMedium,
                                fontSize: subtitleFontSize,
                                fontFamily: 'DinNext',
                                fontWeight: FontWeight.w700,
                                height: 1.40,
                              ),
                            ),
                            TextSpan(
                              text: 'recuperação',
                              style: TextStyle(
                                color: MetamorfoseColors.greenDark,
                                fontSize: subtitleFontSize,
                                fontFamily: 'DinNext',
                                fontWeight: FontWeight.w700,
                                height: 1.40,
                              ),
                            ),
                            TextSpan(
                              text: '!',
                              style: TextStyle(
                                color: MetamorfoseColors.greyMedium,
                                fontSize: subtitleFontSize,
                                fontFamily: 'DinNext',
                                fontWeight: FontWeight.w700,
                                height: 1.40,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    'assets/images/selectionactivity/ivy_laugh.png',
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
                      text: 'Continuar',
                      onPressed: () => context.go(Routes.selectionActivityQuestions),
                      backgroundColor: MetamorfoseColors.greenLight,
                      borderColor: MetamorfoseColors.greenDark,
                      shadowColor: MetamorfoseColors.greenDark,
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
 