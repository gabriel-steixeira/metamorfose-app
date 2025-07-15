/**
 * File: theme.dart
 * Description: Configurações de tema do aplicativo Metamorfose.
 *
 * Responsabilidades:
 * - Definir cores, tipografia e estilos do tema
 * - Configurar tema claro e escuro
 * - Fornecer acesso ao tema atual
 *
 * Author: Gabriel Teixeira e Vitoria Lana
 * Created on: 29-05-2025
 * Last modified: 29-05-2025
 * Version: 1.0.0
 * Squad: Metamorfose
 */

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metamorfose_flutter/theme/colors.dart';

/// Classe que define o tema do aplicativo Metamorfose.
/// Responsável por estabelecer as configurações visuais globais para garantir 
/// consistência visual em todo o aplicativo.
class MetamorfoseTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: MetamorfoseColors.purpleNormal,
        onPrimary: MetamorfoseColors.whiteLight,
        primaryContainer: MetamorfoseColors.purpleLight,
        onPrimaryContainer: MetamorfoseColors.purpleDarken,
        secondary: MetamorfoseColors.greenNormal,
        onSecondary: MetamorfoseColors.whiteLight,
        secondaryContainer: MetamorfoseColors.greenLight,
        onSecondaryContainer: MetamorfoseColors.greenDarken,
        error: Colors.red,
        onError: MetamorfoseColors.whiteLight,
        background: MetamorfoseColors.whiteNormal,
        onBackground: MetamorfoseColors.blackNormal,
        surface: MetamorfoseColors.whiteLight,
        onSurface: MetamorfoseColors.blackNormal,
        errorContainer: Colors.red.shade200,
        onErrorContainer: Colors.red.shade900,
        surfaceVariant: MetamorfoseColors.whiteDark,
        onSurfaceVariant: MetamorfoseColors.greyDark,
        outline: MetamorfoseColors.greyMedium,
        outlineVariant: MetamorfoseColors.greyLight,
        shadow: MetamorfoseColors.defaultButtonShadow,
        scrim: Colors.black.withOpacity(0.3),
        inverseSurface: MetamorfoseColors.blackNormal,
        onInverseSurface: MetamorfoseColors.whiteLight,
        inversePrimary: MetamorfoseColors.purpleLight,
        surfaceTint: MetamorfoseColors.purpleLight.withOpacity(0.05),
      ),
      textTheme: _createTextTheme(),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: MetamorfoseColors.whiteLight,
        elevation: 0,
        iconTheme: IconThemeData(color: MetamorfoseColors.purpleNormal),
        titleTextStyle: TextStyle(
          color: MetamorfoseColors.blackNormal,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor: MetamorfoseColors.purpleNormal,
          foregroundColor: MetamorfoseColors.whiteLight,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MetamorfoseColors.purpleNormal,
          side: BorderSide(color: MetamorfoseColors.purpleNormal),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MetamorfoseColors.purpleNormal,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: MetamorfoseColors.whiteLight,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MetamorfoseColors.whiteLight,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: MetamorfoseColors.greyLightest),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: MetamorfoseColors.greyLightest),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: MetamorfoseColors.purpleNormal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      useMaterial3: true,
    );
  }

  static TextTheme _createTextTheme() {
    return GoogleFonts.robotoTextTheme().copyWith(
      displayLarge: const TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: MetamorfoseColors.blackNormal,
      ),
      displayMedium: const TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: MetamorfoseColors.blackNormal,
      ),
      displaySmall: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: MetamorfoseColors.blackNormal,
      ),
      headlineLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: MetamorfoseColors.blackNormal,
      ),
      headlineMedium: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: MetamorfoseColors.blackNormal,
      ),
      headlineSmall: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: MetamorfoseColors.blackNormal,
      ),
      titleLarge: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: MetamorfoseColors.blackNormal,
      ),
      titleMedium: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: MetamorfoseColors.blackNormal,
      ),
      titleSmall: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: MetamorfoseColors.blackNormal,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: MetamorfoseColors.blackNormal,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: MetamorfoseColors.blackNormal,
      ),
      bodySmall: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: MetamorfoseColors.blackNormal,
      ),
      labelLarge: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: MetamorfoseColors.blackNormal,
      ),
      labelMedium: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: MetamorfoseColors.blackNormal,
      ),
      labelSmall: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: MetamorfoseColors.blackNormal,
      ),
    );
  }
} 