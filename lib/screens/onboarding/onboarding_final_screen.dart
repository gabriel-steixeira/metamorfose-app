import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static const double statusBarExtra = 8;
  static const double ivyWidthFactor = 0.8;
  static const double textFontSize = 18;
  static const double backgroundTopPadding = 5;
}

/// Tela final do onboarding
class OnboardingFinalScreen extends StatelessWidget {
  const OnboardingFinalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xFF9D68FF),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Fundo roxo da status bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: topPadding + _LayoutConstants.statusBarExtra,
              child: Container(color: Color(0xFF9D68FF)),
            ),
            // Background SVG
            Positioned(
              top: _LayoutConstants.backgroundTopPadding,
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
            // Conteúdo principal
            SafeArea(
              child: Column(
                children: [
                  // Botão voltar SVG igual ao padrão
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/arrow_back.svg',
                        width: 34,
                        height: 34,
                      ),
                      onPressed: () => context.go(Routes.onboardingButterfly),
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(flex: 1),
                  // Balão de fala acima do Ivy
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _LayoutConstants.horizontalPadding),
                    child: SpeechBubble(
                      width: screenSize.width * 0.85,
                      borderColor: MetamorfoseColors.purpleLight, // roxo claro
                      child: const Text(
                        'Está pronto para sua metamorfose?',
                        style: TextStyle(
                          color: MetamorfoseColors.greyMedium,
                          fontSize: 20,
                          fontFamily: 'DinNext',
                          fontWeight: FontWeight.w700,
                          height: 1.40,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Ivy image
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      'assets/images/onboarding/ivy_stars_eyes.png',
                      width: screenSize.width * _LayoutConstants.ivyWidthFactor,
                    ),
                  ),
                  // Texto extra entre Ivy e botão
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: _LayoutConstants.horizontalPadding, vertical: 16),
                    child: Text(
                      'Clique em SIM! para iniciar\n sua jornada',
                      style: const TextStyle(
                        color: MetamorfoseColors.greyMedium,
                        fontSize: _LayoutConstants.textFontSize,
                        fontFamily: 'DinNext',
                        fontWeight: FontWeight.w700,
                        height: 1.40,
                      ),
                      textAlign: TextAlign.center,
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
                        text: 'SIM!',
                        onPressed: () => context.go(Routes.auth),
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
 