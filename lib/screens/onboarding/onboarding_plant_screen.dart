/**
 * File: onboarding_plant_screen.dart
 * Description: Tela de onboarding que apresenta a planta do usuário.
 *
 * Responsabilidades:
 * - Apresentar o conceito da planta virtual
 * - Explicar como a planta representa o progresso
 * - Navegação para próxima etapa do onboarding
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/metamorfose_primary_button.dart';

/// Constantes de layout para facilitar manutenção e clareza
class _LayoutConstants {
  static const double backgroundTopPadding = 5;
  static const double statusBarExtra = 8;
  static const double ivyWidthFactor = 0.7;
  static const double ivyHeightFactor = 0.26;
  static const double backButtonSize = 34;
  static const double buttonSize = 56;
  static const double arrowIconSize = 20;
  static const double textFontSize = 21.92;
  static const double textOffsetFromCenter = 60; // px abaixo do centro
  static const double textHorizontalPadding = 24.0;
  static const double footerPadding = 36.0;
}

/// Tela de onboarding que explica o conceito da planta na jornada.
/// Demonstra como a planta é a base para toda a transformação.
class OnboardingPlantScreen extends StatelessWidget {
  const OnboardingPlantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double topPadding = MediaQuery.of(context).padding.top;
    final double centerY = screenSize.height / 2;
    final double distanceFromTop = centerY + _LayoutConstants.textOffsetFromCenter;

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
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Garante que o texto nunca fique fora da tela
            final double maxTextTop = constraints.maxHeight - 200; // 200px de margem inferior para footer
            final double textTop = distanceFromTop < maxTextTop ? distanceFromTop : maxTextTop;
            return Stack(
              children: [
                // Fundo roxo da status bar (cobre toda a área superior, inclusive notch)
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
                      maxHeight: screenSize.height * 0.7,
                    ),
                    child: SvgPicture.asset(
                      'assets/images/onboarding/bg_wave_5.svg',
                      width: screenSize.width,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                // Conteúdo principal
                SafeArea(
                  child: Column(
                    children: [
                      // Botão voltar SVG
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/arrow_back.svg',
                            width: _LayoutConstants.backButtonSize,
                            height: _LayoutConstants.backButtonSize,
                          ),
                          onPressed: () => context.go(Routes.onboardingWelcome),
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Ivy SVG centralizado
                      SvgPicture.asset(
                        'assets/images/onboarding/ivy_plant_onboarding.svg',
                        width: screenSize.width * _LayoutConstants.ivyWidthFactor,
                        height: screenSize.height * _LayoutConstants.ivyHeightFactor,
                        fit: BoxFit.contain,
                      ),
                      // Espaço dinâmico para o texto (garantido pelo LayoutBuilder)
                      SizedBox(height: textTop - (topPadding + _LayoutConstants.backgroundTopPadding + screenSize.height * _LayoutConstants.ivyHeightFactor)),
                      // Texto centralizado
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: _LayoutConstants.textHorizontalPadding),
                        child: Text(
                          'Essa é sua plantinha, ela vai crescer e conversar com você.',
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
                      const Spacer(flex: 2),
                      // Rodapé: duas colunas
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: _LayoutConstants.footerPadding),
                        child: Row(
                          children: [
                            // Indicador SVG à esquerda
                            SvgPicture.asset(
                              'assets/images/onboarding/ic_onboarding_progress_beginning.svg',
                              height: 11,
                            ),
                            const Spacer(),
                            // Botão à direita com arrow_white.svg dentro
                            SizedBox(
                              width: _LayoutConstants.buttonSize,
                              height: _LayoutConstants.buttonSize,
                              child: MetamorfosePrimaryButton(
                                text: '',
                                icon: SvgPicture.asset(
                                  'assets/images/arrow_white.svg',
                                  width: _LayoutConstants.arrowIconSize,
                                  height: _LayoutConstants.arrowIconSize,
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