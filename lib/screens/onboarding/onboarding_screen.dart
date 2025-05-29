/**
 * File: onboarding_screen.dart
 * Description: Tela inicial do onboarding do aplicativo.
 *
 * Responsabilidades:
 * - Exibir a primeira tela do onboarding
 * - Gerenciar a navegação para as próximas telas
 * - Apresentar a proposta do aplicativo
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:conversao_flutter/routes/routes.dart';
import 'package:conversao_flutter/theme/colors.dart';
import 'package:conversao_flutter/components/metamorfose_primary_button.dart';
import 'package:conversao_flutter/components/metamorfose_secondary_button.dart';

/// Tela inicial do fluxo de onboarding que introduz o usuário ao aplicativo Metamorfose.
/// Oferece opções para continuar o fluxo de onboarding ou ir diretamente para o login.
class OnboardingScreen extends StatelessWidget {
  // Constantes de layout seguindo o padrão do Kotlin
  static const double buttonHeight = 43;
  static const double maxButtonWidth = 358;
  static const double horizontalPadding = 24;
  static const double spacingGapXS = 16;
  static const double logoTopSpacing = 250;

  // Proporções originais da borboleta
  static const double originalButterflyWidth = 267;
  static const double originalButterflyHeight = 196.06;
  static const double butterflyAspectRatio = originalButterflyWidth / originalButterflyHeight;

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double butterflyWidth = screenSize.width * 0.7; // 70% da largura da tela
    final double butterflyHeight = butterflyWidth / butterflyAspectRatio;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [              
              const SizedBox(height: logoTopSpacing),
                        SvgPicture.asset(
                          'assets/images/onboarding/colored_butterfly.svg',
                width: butterflyWidth,
                height: butterflyHeight,
                        ),
              const SizedBox(height: 24.94),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                  style: const TextStyle(
                    fontSize: 36,
                    height: 1.4,
                              fontFamily: 'DinNext',
                    fontWeight: FontWeight.w600,
                    color: MetamorfoseColors.greyMedium,
                            ),
                            children: [
                    const TextSpan(text: 'Seu '),
                              TextSpan(
                                text: 'crescimento',
                                style: TextStyle(
                                  color: MetamorfoseColors.greenLight,
                        fontWeight: FontWeight.bold
                                ),
                              ),
                    const TextSpan(text: ',\nsua '),
                              TextSpan(
                                text: 'jornada',
                                style: TextStyle(
                                  color: MetamorfoseColors.purpleLight,
                        fontWeight: FontWeight.bold
                                ),
                              ),
                    const TextSpan(text: ',\nsua '),
                              TextSpan(
                                text: 'meta',
                                style: TextStyle(
                                  color: MetamorfoseColors.purpleLight,
                        fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: 'morfose',
                                style: TextStyle(
                                  color: MetamorfoseColors.greenLight,
                        fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
              const Spacer(),
              SizedBox(
                width: maxButtonWidth,
                height: buttonHeight,
                child: MetamorfosePrimaryButton(
                  text: 'Começar agora',
                      onPressed: () => context.go(Routes.onboardingWelcome),
                    ),
              ),
              const SizedBox(height: spacingGapXS),
              SizedBox(
                width: maxButtonWidth,
                height: buttonHeight,
                child: MetamorfeseSecondaryButton(
                      text: 'Já tenho uma conta',
                  onPressed: () => context.go(Routes.auth),
                    ),
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
} 