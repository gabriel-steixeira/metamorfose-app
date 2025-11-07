import 'package:flutter/material.dart';

/// Tipografia do app Metamorfose
/// Baseado no arquivo Type.kt do projeto original Kotlin
class AppTypography {
  AppTypography._();

  static const _fontFamily = 'DinNext';

  // Display Styles
  static const displayLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: 36.0,
  );
  
  static const displayMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: 28.0,
  );
  
  static const displaySmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: 24.0,
  );

  // Headline Styles
  static const headlineLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 36.0,
  );
  
  static const headlineMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 28.0,
  );
  
  static const headlineSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
  );

  // Title Styles
  static const titleLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );
  
  static const titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: 20.0,
  );
  
  static const titleSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );

  // Body Styles
  static const bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
  );
  
  static const bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: 14.0,
  );
  
  static const bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.normal,
    fontSize: 12.0,
  );

  // Label Styles
  static const labelLarge = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 14.0,
  );
  
  static const labelMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 12.0,
  );
  
  static const labelSmall = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.bold,
    fontSize: 10.0,
  );
} 