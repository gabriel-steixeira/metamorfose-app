import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/metamorfose_primary_button.dart';
import 'package:metamorfose_flutter/components/speech_bubble.dart';

/// Constantes de layout
class _LayoutConstants {
  static const double buttonHeight = 43;
  static const double buttonWidth = 358;
  static const double horizontalPadding = 16;
  static const double bottomPadding = 36;
}

/// Tela de boas-vindas do fluxo de onboarding.
/// Apresenta uma introdução sobre o conceito do aplicativo e sua proposta.
class OnboardingWelcomeScreen extends StatelessWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bubbleWidth = screenSize.width * 0.85;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background SVG
          Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7, // aproximadamente 600dp
              ),
            child: SvgPicture.asset(
                'assets/images/onboarding/bg_wave_4.svg',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/arrow_back.svg',
                      width: 34,
                      height: 34,
                    ),
                    onPressed: () => context.go(Routes.onboarding),
                    color: Colors.black,
                  ),
                ),
                
                const Spacer(flex: 1),
                
                // Speech bubble
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _LayoutConstants.horizontalPadding,
                  ),
                  child: SpeechBubble(
                    width: bubbleWidth,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Parabéns por começar!\n',
                            style: TextStyle(
                              color: MetamorfoseColors.greyMedium,
                              fontSize: 21.92,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: 'Eu sou o ',
                            style: TextStyle(
                              color: MetamorfoseColors.greyMedium,
                              fontSize: 16,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: 'Ivy',
                            style: TextStyle(
                              color: MetamorfoseColors.purpleNormal,
                              fontSize: 16,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                  ),
                ),
                          TextSpan(
                            text: ', seu guia nessa jornada de ',
                            style: TextStyle(
                              color: MetamorfoseColors.greyMedium,
                              fontSize: 16,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: 'superação',
                            style: TextStyle(
                              color: MetamorfoseColors.greenDark,
                              fontSize: 16,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: ' dos seus vícios. Vamos juntos nessa ',
                            style: TextStyle(
                              color: MetamorfoseColors.greyMedium,
                              fontSize: 16,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: 'transformação',
                            style: TextStyle(
                              color: MetamorfoseColors.purpleNormal,
                              fontSize: 16,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: '?',
                            style: TextStyle(
                              color: MetamorfoseColors.greyMedium,
                              fontSize: 16,
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
                
                const SizedBox(height: 20),
                
                // Ivy image
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    'assets/images/onboarding/ivy_happy.png',
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
                
                const Spacer(flex: 1),
                
                // Bottom button
                Padding(
                  padding: const EdgeInsets.only(
                    left: _LayoutConstants.horizontalPadding,
                    right: _LayoutConstants.horizontalPadding,
                    bottom: _LayoutConstants.bottomPadding,
                  ),
                  child: SizedBox(
                    width: _LayoutConstants.buttonWidth,
                    height: _LayoutConstants.buttonHeight,
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
 