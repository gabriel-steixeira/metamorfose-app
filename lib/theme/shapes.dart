import 'package:flutter/material.dart';

/// Shapes do app Metamorfose
/// Baseado no arquivo Shape.kt do projeto original Kotlin
class AppShapes {
  AppShapes._();

  // Raios padrão
  static const double extraSmallRadius = 4.0;
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double extraLargeRadius = 24.0;

  // Shapes para botões
  static final buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(smallRadius),
  );

  // Shapes para cards
  static final cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(mediumRadius),
  );

  // Shapes para campos de texto
  static final inputShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(smallRadius),
  );

  // Shapes para diálogos
  static final dialogShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(largeRadius),
  );

  // Shapes para bottom sheets
  static final bottomSheetShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(largeRadius),
      topRight: Radius.circular(largeRadius),
    ),
  );
} 