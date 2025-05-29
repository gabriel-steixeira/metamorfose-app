/// File: colors.dart
/// Description: Cores do aplicativo Metamorfose.
///
/// Responsabilidades:
/// - Definir as cores do aplicativo
/// - Fornecer acesso às cores
///
/// Author: Gabriel Teixeira
/// Created on: 13-03-2024
/// Last modified: 13-03-2024
/// Version: 1.0.0
/// Squad: Metamorfose

import 'package:flutter/material.dart';

/// Definições de cores e gradientes do tema do app Metamorfose.
/// Contém cores personalizadas para o design do app e gradientes lineares 
/// usados em diversos elementos.
class MetamorfoseColors {
  // Purple
  static const purpleDarken = Color(0xFF4E347F);
  static const purpleDark = Color(0xFF7D53CC);
  static const purpleNormal = Color(0xFF9C68FF);
  static const purpleLight = Color(0xFFB18EF2);

  // Green
  static const greenDarken = Color(0xFF2C622E);
  static const greenDark = Color(0xFF43BD43);
  static const greenNormal = Color(0xFF58C45D);
  static const greenLight = Color(0xFF6EF575);

  // White
  static const whiteDark = Color(0xFFE5E5E5);
  static const whiteLight = Color(0xFFFFFFFF);
  static const whiteNormal = Color(0xFFF7F7F7);

  // Grey
  static const greyDark = Color(0xFF3C3C3C);
  static const greyMedium = Color(0xFF767676);
  static const greyLight = Color(0xFFAFAFAF);
  static const greyLightest = Color(0xFFC7C7C7);
  static const greyLightest2 = Color(0xFFEDEDED);
  static const greyExtraLight = Color(0xFFF7F7F7);

  // Black
  static const blackDark = Color(0xFF171717);
  static const blackNormal = Color(0xFF212121);
  static const blackLight = Color(0xFF424242);
  static const blackLighten = Color(0xFF9B9B9B);

  // Red
  static const redNormal = Color(0xFFE74C3C);
  static const redLight = Color(0xFFFFCDD2);

  // Blue
  static const blueDark = Color(0xFF3B5998);
  static const blueNormal = Color(0xFF3498DB);
  static const blueLight = Color(0xFFBBDEFB);

  // Pink
  static const pinkNormal = Color(0xFFE91E63);
  static const pinkLight = Color(0xFFF8BBD0);

  // Shadow
  static const defaultButtonShadow = Color(0xFFE5E5E5);
  
  // Transparent shadows
  static const shadowLight = Color(0x0C000000); // 5% de opacidade do preto
  static const shadowText = Color(0x40000000);  // 25% de opacidade do preto
  static const transparent = Color(0x00000000); // Transparente
}

/// Gradientes lineares utilizados no app
class MetamorfoseGradients {
  static const lightPurpleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFB18EF2),   // 0%
      Color(0xFFFAEAFF)  // 100%
    ],
  );

  static const greenGradient = LinearGradient(
    colors: [
      Color(0xFF57C785),  // 0%
      Color(0xFF6EF575)   // 100%
    ],
  );

  static const darkPurpleGradient = LinearGradient(
    colors: [
      Color(0xFF4E347F),  // 0%
      Color(0xFF9D68FF)   // 100%
    ],
  );

  static const lightPurple33Gradient = LinearGradient(
    colors: [
      Color(0xFFAF8CF2),  // 0%
      Color(0xFFD8C7FA)   // 33%
    ],
  );
} 