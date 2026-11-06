import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';

class AppTextStyles {
  static TextStyle nameStyle({double fontSize = 28}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: AppColors.themeColor,
      letterSpacing: -0.6,
      height: 1.05,
    );
  }

  static TextStyle headingStyles(
      {double fontSize = 36, Color color = AppColors.white}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: -0.4,
      height: 1.1,
    );
  }

  static TextStyle montserratStyle(
      {required Color color, double fontSize = 18}) {
    return GoogleFonts.manrope(
      color: color,
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      letterSpacing: -0.2,
    );
  }

  static TextStyle headerTextStyle({Color color = Colors.white}) {
    return GoogleFonts.manrope(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color,
      letterSpacing: 0.4,
    );
  }

  static TextStyle normalStyle(
      {Color color = Colors.white, double fontSize = 15}) {
    return GoogleFonts.manrope(
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      color: color,
      letterSpacing: 0.1,
      height: 1.6,
    );
  }

  static TextStyle comfortaaStyle() {
    return GoogleFonts.manrope(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white54,
    );
  }

  static TextStyle indexStyle() {
    return GoogleFonts.outfit(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.themeColor,
      letterSpacing: 1.4,
    );
  }
}
