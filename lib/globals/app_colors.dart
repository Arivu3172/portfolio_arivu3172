import 'package:flutter/material.dart';

class AppColors {
  /// Pure black base
  static const Color bgColor = Color(0xFF0A0A0A);

  /// Soft charcoal panel
  static const Color bgColor2 = Color(0xFF161616);

  /// Primary gold accent
  static const Color themeColor = Color(0xFFD4AF37);

  /// Rich amber gold (hover / secondary)
  static const Color aqua = Color(0xFFB8860B);

  /// Light champagne gold for splash / highlight
  static const Color lawGreen = Color(0xFFF5E6A3);

  /// Bright title gold
  static const Color robinEdgeBlue = Color(0xFFE8C547);

  static const Color white = Color(0xFFFFFFFF);

  /// Layer tones (kept names for existing widgets)
  static const Color waveDeep = Color(0xFF111111);
  static const Color waveMid = Color(0xFF1C1C1C);
  static const Color waveLight = Color(0xFF2A2A2A);

  /// Glass panel fill
  static const Color glass = Color(0x33D4AF37);

  static const LinearGradient oceanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF000000),
      Color(0xFF121212),
      Color(0xFF1A1408),
      Color(0xFF000000),
    ],
    stops: [0.0, 0.35, 0.7, 1.0],
  );

  static const LinearGradient foamGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xCCD4AF37),
      Color(0x99B8860B),
      Color(0xE60A0A0A),
    ],
  );

  static const LinearGradient goldSheen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF5E6A3),
      Color(0xFFD4AF37),
      Color(0xFFB8860B),
      Color(0xFFD4AF37),
    ],
  );
}
