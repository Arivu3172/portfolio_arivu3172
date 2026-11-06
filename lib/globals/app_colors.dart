import 'package:flutter/material.dart';

/// Aurora studio palette: ink navy, electric cyan, soft violet.
class AppColors {
  static const Color bgColor = Color(0xFF070B16);
  static const Color bgColor2 = Color(0xFF12182A);

  /// Primary cyan
  static const Color themeColor = Color(0xFF5EEAD4);

  /// Secondary violet
  static const Color aqua = Color(0xFFA78BFA);

  /// Mint highlight
  static const Color lawGreen = Color(0xFF99F6E4);

  /// Soft lilac
  static const Color robinEdgeBlue = Color(0xFFC4B5FD);

  static const Color white = Color(0xFFF4F7FB);

  static const Color waveDeep = Color(0xFF0B1220);
  static const Color waveMid = Color(0xFF152038);
  static const Color waveLight = Color(0xFF243352);

  static const Color glass = Color(0x335EEAD4);

  static const LinearGradient oceanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF070B16),
      Color(0xFF10182C),
      Color(0xFF1A1440),
      Color(0xFF071018),
    ],
    stops: [0.0, 0.38, 0.72, 1.0],
  );

  static const LinearGradient foamGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xCC5EEAD4),
      Color(0x99A78BFA),
      Color(0xE6070B16),
    ],
  );

  static const LinearGradient goldSheen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF99F6E4),
      Color(0xFF5EEAD4),
      Color(0xFFA78BFA),
      Color(0xFF5EEAD4),
    ],
  );
}
