import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cursor_tracker.dart';
import 'package:portfolio_arivu/globals/water_animations.dart';

/// Black canvas with gold dust, diagonal sheen, and soft vignette.
/// Background tint follows the custom cursor when available.
class WaterBackground extends StatefulWidget {
  const WaterBackground({super.key, required this.child});

  final Widget child;

  @override
  State<WaterBackground> createState() => _WaterBackgroundState();
}

class _WaterBackgroundState extends State<WaterBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ambient = CursorAmbient.maybeOf(context);
    final gradient = ambient?.backgroundGradient ?? AppColors.oceanGradient;
    final cursorAlign = ambient?.visible == true
        ? ambient!.alignment
        : null;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(gradient: gradient),
          child: CustomPaint(
            painter: _LuxuryBackdropPainter(
              progress: _controller.value,
              cursorAlign: cursorAlign,
            ),
            child: child,
          ),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(child: BubbleField(bubbleCount: 18)),
          widget.child,
        ],
      ),
    );
  }
}

class _LuxuryBackdropPainter extends CustomPainter {
  _LuxuryBackdropPainter({
    required this.progress,
    this.cursorAlign,
  });

  final double progress;
  final Alignment? cursorAlign;

  @override
  void paint(Canvas canvas, Size size) {
    // Gold beam: prefers cursor, else slow cinematic drift
    final beamCenter = cursorAlign ??
        Alignment(
          math.sin(progress * 2 * math.pi) * 0.4,
          -0.2 + math.cos(progress * 2 * math.pi) * 0.15,
        );
    final beam = Paint()
      ..shader = RadialGradient(
        center: beamCenter,
        radius: cursorAlign != null ? 1.05 : 1.25,
        colors: [
          AppColors.themeColor.withValues(
            alpha: cursorAlign != null ? 0.2 : 0.14,
          ),
          AppColors.themeColor.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, beam);

    // Fine gold grid (luxury blueprint feel)
    final grid = Paint()
      ..color = AppColors.themeColor.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    const step = 56.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // Soft bottom vignette band
    final band = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          AppColors.themeColor.withValues(alpha: 0.06),
          Colors.black.withValues(alpha: 0.55),
        ],
        stops: const [0.55, 0.78, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, band);
  }

  @override
  bool shouldRepaint(covariant _LuxuryBackdropPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.cursorAlign != cursorAlign;
  }
}
