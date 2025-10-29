import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF2E8B57);
  static const Color primaryLight = Color(0xFF3DA372);
  static const Color primaryDark = Color(0xFF1F6B41);
  static const Color secondaryColor = Color(0xFFFFA726);
  static const Color secondaryLight = Color(0xFFFFB74D);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);

  // Gradients
  static Gradient primaryGradient = const LinearGradient(
    colors: [primaryColor, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Gradient secondaryGradient = const LinearGradient(
    colors: [secondaryColor, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: primaryColor.withOpacity(0.3),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  // Text Styles
  static TextStyle headline1 = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.2,
  );

  static TextStyle headline2 = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  static TextStyle headline3 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  static TextStyle bodyText = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static TextStyle bodyTextBold = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.5,
  );

  static TextStyle caption = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.4,
  );

  static TextStyle captionBold = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textSecondary,
    height: 1.4,
  );

  static TextStyle smallText = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textLight,
    height: 1.3,
  );

  static TextStyle button = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: surfaceColor,
    height: 1.2,
  );

  // Theme Data
  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: surfaceColor,
        onSecondary: textPrimary,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: headline2.copyWith(color: textPrimary),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: surfaceColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        labelStyle: caption.copyWith(color: textSecondary),
        hintStyle: caption.copyWith(color: textLight),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surfaceColor,
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        buttonColor: primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: surfaceColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: button.copyWith(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
