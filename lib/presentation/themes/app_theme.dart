import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pp_26/presentation/themes/custom_colors.dart';

class DefaultThemeGetter {
  static ThemeData get() {
    const primary = Color(0xFF5080EF);
    const primaryLight = Colors.black;
    const primaryDark = Colors.black;
    const onBackground = Colors.black;
    const surface = Colors.black;
    const customColorsExtension = CustomColors.light;

    return ThemeData(
      primaryColor: primary,
      primaryColorLight: primaryLight,
      primaryColorDark: primaryDark,
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w800,
          fontSize: 36.0,
          height: 1.2,
        ),
        bodyLarge: GoogleFonts.syne(
          fontWeight: FontWeight.w400,
          fontSize: 15.0,
          height: 1.4,
          letterSpacing: -0.4,
        ),
        bodyMedium: GoogleFonts.syne(
          fontWeight: FontWeight.w700,
          fontSize: 12.0,
          height: 1.2,
        ),
        displayLarge: GoogleFonts.syne(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.syne(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.syne(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 1.2,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 22.0,
          height: 1.1,
        ),
        titleMedium: const TextStyle(
          fontFamily: 'SF-Pro-Display',
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        titleSmall: GoogleFonts.jost(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          height: 1.0,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'SF-Pro-Display',
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: GoogleFonts.syne(
          fontWeight: FontWeight.w700,
          fontSize: 12.0,
          height: 1.2,
        ),
        labelMedium: GoogleFonts.syne(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
        labelLarge: GoogleFonts.nunito(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
          height: 1.1,
        ),
        bodySmall: GoogleFonts.nunito(
          fontWeight: FontWeight.w500,
          fontSize: 12.0,
          height: 1.0,
        ),
      ).apply(
        bodyColor: onBackground,
        displayColor: onBackground,
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.transparent,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(
            const Size(
              double.infinity,
              48.0,
            ),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.disabled)) {
                return primary.withOpacity(0.3);
              }
              return primary;
            },
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(
              const Size(
                double.infinity,
                53.0,
              ),
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            side: MaterialStateProperty.all(
              const BorderSide(color: primary),
            )),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        customColorsExtension,
      ],
      colorScheme: const ColorScheme(
        primary: primary,
        primaryContainer: primaryDark,
        secondary: Color(0xFF2274F1),
        surface: surface,
        onSurface: Colors.black,
        background: Color(0xFF0E0A1E),
        secondaryContainer: Color(0xFF34C85A),
        onBackground: onBackground,
        error: Colors.white,
        onError: Colors.white,
        brightness: Brightness.light,
        onPrimary: Colors.white,
        onSecondary: Color(0xFF0D0D0D),
      ),
    );
  }
}
