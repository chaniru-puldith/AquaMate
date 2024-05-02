import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static ThemeData themeData(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF5F5F5),
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black12,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue.shade400,
        surfaceTint: Colors.white,
        brightness: Brightness.light,
      ),
      primaryColor: Colors.white,
      // scaffoldBackgroundColor: const Color(0xFFF5F5F9),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      indicatorColor: const Color(0xffCBDCF8),
      hintColor: Colors.black54,
      highlightColor: const Color(0x22afafaf),
      hoverColor: const Color(0x22afafaf),
      focusColor: const Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor: Colors.white,
      canvasColor: Colors.grey[50],
      brightness: Brightness.light,
      buttonTheme: Theme.of(context)
          .buttonTheme
          .copyWith(colorScheme: const ColorScheme.light()),
      fontFamily: GoogleFonts.poppins().fontFamily,
      textSelectionTheme:
          const TextSelectionThemeData(selectionColor: Colors.black38),
    );
  }
}
