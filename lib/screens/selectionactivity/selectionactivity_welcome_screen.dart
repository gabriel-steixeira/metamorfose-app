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

/// Apresenta uma introdução sobre o conceito do aplicativo e sua proposta.
class SelectionActivityWelcomeScreen extends StatelessWidget {
  const SelectionActivityWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bubbleWidth = screenSize.width * 0.85;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background com gradiente softPurpleGradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: MetamorfoseGradients.softPurpleGradient,
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
                    onPressed: () => context.go(Routes.onboardingFinal),
                    color: MetamorfoseColors.purpleDark,  // Roxo escuro para contraste sobre o gradiente
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
                            text: 'São só 4 perguntas rápidas.\n',
                            style: TextStyle(
                              color: MetamorfoseColors.purpleDark,  // Roxo escuro para contraste
                              fontSize: 21.92,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: 'Assim daremos o primeiro passo juntos na sua ',
                            style: TextStyle(
                              color: MetamorfoseColors.greyMedium,  // Roxo escuro para contraste
                              fontSize: 16,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: 'recuperação',
                            style: TextStyle(
                              color: MetamorfoseColors.greenDark,  // Verde escuro para destaque
                              fontSize: 16,
                              fontFamily: 'DinNext',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          TextSpan(
                            text: '!',
                            style: TextStyle(
                              color: MetamorfoseColors.greyMedium,  // Roxo escuro para contraste
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
                    'assets/images/selectionactivity/ivy_laugh.png',
                    width: MediaQuery.of(context).size.width * 0.8,
                    fit: BoxFit.contain,
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
                      text: 'Continuar',
                      onPressed: () => context.go(Routes.selectionActivityQuestions),
                      backgroundColor: MetamorfoseColors.greenLight,  // Verde da paleta Metamorfose
                      borderColor: MetamorfoseColors.greenDark,     // Borda verde
                      shadowColor: MetamorfoseColors.greenDark,    // Sombra verde
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
 