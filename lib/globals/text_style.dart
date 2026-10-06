import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';

class AppTextStyles {
  /// Funky display / brand
  static TextStyle nameStyle({double fontSize = 28}) {
    return GoogleFonts.syne(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: AppColors.themeColor,
      letterSpacing: -1.2,
      height: 0.95,
    );
  }

  /// Section titles
  static TextStyle headingStyles(
      {double fontSize = 36, Color color = AppColors.white}) {
    return GoogleFonts.syne(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: -0.8,
      height: 1.05,
    );
  }

  /// Strong supporting lines
  static TextStyle montserratStyle(
      {required Color color, double fontSize = 18}) {
    return GoogleFonts.spaceGrotesk(
      color: color,
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      letterSpacing: 0.2,
    );
  }

  /// Nav / UI labels
  static TextStyle headerTextStyle({Color color = Colors.white}) {
    return GoogleFonts.spaceGrotesk(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: 1.6,
    );
  }

  /// Body copy
  static TextStyle normalStyle(
      {Color color = Colors.white, double fontSize = 15}) {
    return GoogleFonts.spaceGrotesk(
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
      color: color,
      letterSpacing: 0.15,
      height: 1.6,
    );
  }

  static TextStyle comfortaaStyle() {
    return GoogleFonts.spaceGrotesk(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white54,
    );
  }

  /// Tiny gold index like 01 / 02
  static TextStyle indexStyle() {
    return GoogleFonts.syne(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: AppColors.themeColor,
      letterSpacing: 3,
    );
  }
}
