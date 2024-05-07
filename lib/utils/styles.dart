import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static ThemeData themeData(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        color: Color(0xFF121212),
        foregroundColor: Color(0xFFF5F5F5),
        surfaceTintColor: Color(0xFF121212),
        shadowColor: Color(0xFF1F1F1F),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue.shade400,
        surfaceTint: Colors.white,
        brightness: Brightness.light,
      ),
      primaryColor: const Color(0xFF121212),
      scaffoldBackgroundColor: const Color(0xFF121212),
      // scaffoldBackgroundColor: Colors.white,
      indicatorColor: const Color(0xffCBDCF8),
      hintColor: Colors.white30,
      highlightColor: const Color(0x22afafaf),
      hoverColor: const Color(0x22afafaf),
      focusColor: const Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor: const Color(0xFF151515),
      canvasColor: Colors.grey[50],
      brightness: Brightness.light,
      buttonTheme: Theme.of(context)
          .buttonTheme
          .copyWith(colorScheme: const ColorScheme.light()),
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: const Color(0xFFF5F5F5),
            displayColor: const Color(0xFFF5F5F5),
            decorationColor: const Color(0xFFF5F5F5),
          ),
      textSelectionTheme:
          const TextSelectionThemeData(selectionColor: Colors.white38),
    );
  }
}
