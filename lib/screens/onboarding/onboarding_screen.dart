/// File: onboarding_screen.dart
/// Description: Tela inicial do onboarding do aplicativo.
///
/// Responsabilidades:
/// - Exibir a primeira tela do onboarding
/// - Gerenciar a navegação para as próximas telas
/// - Apresentar a proposta do aplicativo
///
/// Author: Gabriel Teixeira e Vitoria Lana
/// Created on: 29-05-2025
/// Last modified: 29-05-2025
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorfose_flutter/routes/routes.dart';
import 'package:metamorfose_flutter/theme/colors.dart';
import 'package:metamorfose_flutter/components/primary_button.dart';
import 'package:metamorfose_flutter/components/secondary_button.dart';

/// Tela inicial do fluxo de onboarding que introduz o usuário ao aplicativo Metamorfose.
/// Oferece opções para continuar o fluxo de onboarding ou ir diretamente para o login.
class OnboardingScreen extends StatelessWidget {
  // Proporções originais da borboleta
  static const double originalButterflyWidth = 267;
  static const double originalButterflyHeight = 196.06;
  static const double butterflyAspectRatio = originalButterflyWidth / originalButterflyHeight;

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Valores responsivos para espaçamentos
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 50.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 80.0),
      ],
    ).value;

    final logoTopSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 60.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 30.0),
        Condition.largerThan(name: TABLET, value: 80.0),
      ],
    ).value;

    final spacingAfterLogo = ResponsiveValue<double>(
      context,
      defaultValue: 24.94,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 16.0),
        Condition.largerThan(name: TABLET, value: 32.0),
      ],
    ).value;

    final spacingAfterText = ResponsiveValue<double>(
      context,
      defaultValue: 40.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 60.0),
      ],
    ).value;

    final buttonSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 16.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 12.0),
        Condition.largerThan(name: TABLET, value: 20.0),
      ],
    ).value;

    final bottomSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 36.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 24.0),
        Condition.largerThan(name: TABLET, value: 48.0),
      ],
    ).value;

    // Valores responsivos para tamanhos de fonte
    final titleFontSize = ResponsiveValue<double>(
      context,
      defaultValue: 34.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 29.0),
        Condition.largerThan(name: TABLET, value: 39.0),
      ],
    ).value;

    // Valores responsivos para a borboleta
    final butterflyWidth = ResponsiveValue<double>(
      context,
      defaultValue: 267.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: 200.0),
        Condition.largerThan(name: TABLET, value: 350.0),
      ],
    ).value;

    final butterflyHeight = butterflyWidth / butterflyAspectRatio;

    // Detecção de dispositivo para layout condicional
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Scaffold(
      backgroundColor: MetamorfoseColors.whiteLight,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: logoTopSpacing),
                    SvgPicture.asset(
                      'assets/images/onboarding/colored_butterfly.svg',
                      width: butterflyWidth,
                      height: butterflyHeight,
                    ),
                    SizedBox(height: spacingAfterLogo),
                    RichText(
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: titleFontSize,
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: ',\nsua '),
                          TextSpan(
                            text: 'jornada',
                            style: TextStyle(
                              color: MetamorfoseColors.purpleLight,
                              fontWeight: FontWeight.bold,
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
                    SizedBox(height: spacingAfterText),
                  ],
                ),
              ),
              _buildResponsiveButtons(context, isMobile),
              SizedBox(height: buttonSpacing),
              _buildSecondaryButton(context, isMobile),
              SizedBox(height: bottomSpacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsiveButtons(BuildContext context, bool isMobile) {
    // Valores responsivos para largura máxima dos botões
    final maxButtonWidth = ResponsiveValue<double>(
      context,
      defaultValue: 358.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: double.infinity),
        Condition.largerThan(name: TABLET, value: 400.0),
      ],
    ).value;

    final buttonWidget = MetamorfosePrimaryButton(
      text: 'Começar agora',
      onPressed: () => context.go(Routes.onboardingWelcome),
    );

    if (isMobile) {
      return SizedBox(
        width: double.infinity,
        child: buttonWidget,
      );
    } else {
      return Center(
        child: SizedBox(
          width: maxButtonWidth,
          child: buttonWidget,
        ),
      );
    }
  }

  Widget _buildSecondaryButton(BuildContext context, bool isMobile) {
    // Valores responsivos para largura máxima dos botões
    final maxButtonWidth = ResponsiveValue<double>(
      context,
      defaultValue: 358.0,
      conditionalValues: const [
        Condition.smallerThan(name: MOBILE, value: double.infinity),
        Condition.largerThan(name: TABLET, value: 400.0),
      ],
    ).value;

    final buttonWidget = MetamorfeseSecondaryButton(
      text: 'Já tenho uma conta',
      onPressed: () => context.go(Routes.auth),
    );

    if (isMobile) {
      return SizedBox(
        width: double.infinity,
        child: buttonWidget,
      );
    } else {
      return Center(
        child: SizedBox(
          width: maxButtonWidth,
          child: buttonWidget,
        ),
      );
    }
  }
} 