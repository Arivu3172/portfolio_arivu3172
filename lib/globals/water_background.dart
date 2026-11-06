import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cursor_tracker.dart';

/// Deep ink field with drifting orbs, orbital rings, and a cursor-linked mesh.
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
      duration: const Duration(seconds: 22),
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
    final cursorAlign = ambient?.visible == true ? ambient!.alignment : null;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return DecoratedBox(
          decoration: const BoxDecoration(gradient: AppColors.oceanGradient),
          child: CustomPaint(
            painter: _MeshBackdropPainter(
              progress: _controller.value,
              cursorAlign: cursorAlign,
            ),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _MeshBackdropPainter extends CustomPainter {
  _MeshBackdropPainter({
    required this.progress,
    this.cursorAlign,
  });

  final double progress;
  final Alignment? cursorAlign;

  static final List<Offset> _seeds = List<Offset>.generate(36, (i) {
    final rng = math.Random(i * 17 + 3);
    return Offset(rng.nextDouble(), rng.nextDouble());
  });

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress * math.pi * 2;
    final cursor = cursorAlign == null
        ? null
        : Offset(
            (cursorAlign!.x + 1) / 2 * size.width,
            (cursorAlign!.y + 1) / 2 * size.height,
          );

    _orb(
      canvas,
      size,
      center: Offset(
        size.width * (0.82 + math.sin(t) * 0.04),
        size.height * (0.16 + math.cos(t * 0.8) * 0.03),
      ),
      radius: size.shortestSide * 0.42,
      color: AppColors.themeColor,
      alpha: 0.16,
    );
    _orb(
      canvas,
      size,
      center: Offset(
        size.width * (0.12 + math.cos(t * 0.7) * 0.04),
        size.height * (0.78 + math.sin(t * 0.6) * 0.03),
      ),
      radius: size.shortestSide * 0.48,
      color: AppColors.aqua,
      alpha: 0.14,
    );

    final ringCenter = Offset(size.width * 0.72, size.height * 0.38);
    for (var i = 0; i < 3; i++) {
      final radius = size.shortestSide * (0.18 + i * 0.11);
      final ring = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = i == 1 ? 1.4 : 0.8
        ..color = (i.isEven ? AppColors.themeColor : AppColors.aqua)
            .withValues(alpha: 0.16 - i * 0.03);
      canvas.save();
      canvas.translate(ringCenter.dx, ringCenter.dy);
      canvas.rotate(t * (i.isEven ? 0.15 : -0.1) + i);
      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: radius),
        0.4,
        4.4,
        false,
        ring,
      );
      canvas.drawCircle(
        Offset(math.cos(t + i) * radius, math.sin(t + i) * radius),
        3.2,
        Paint()..color = AppColors.lawGreen.withValues(alpha: 0.7),
      );
      canvas.restore();
    }

    final nodes = <Offset>[];
    for (var i = 0; i < _seeds.length; i++) {
      final seed = _seeds[i];
      var point = Offset(
        seed.dx * size.width + math.sin(t + i) * 10,
        seed.dy * size.height + math.cos(t * 0.8 + i * 0.4) * 8,
      );
      if (cursor != null) {
        final delta = cursor - point;
        final dist = delta.distance;
        if (dist < 180 && dist > 0) {
          point += delta * ((1 - dist / 180) * 0.18);
        }
      }
      nodes.add(point);
    }

    final link = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < nodes.length; i++) {
      for (var j = i + 1; j < nodes.length; j++) {
        final dist = (nodes[i] - nodes[j]).distance;
        if (dist > 140) continue;
        var alpha = (1 - dist / 140) * 0.22;
        if (cursor != null) {
          final mid = Offset.lerp(nodes[i], nodes[j], 0.5)!;
          final near = (mid - cursor).distance;
          if (near < 160) alpha += (1 - near / 160) * 0.28;
        }
        link.color = AppColors.themeColor.withValues(alpha: alpha.clamp(0, 0.45));
        canvas.drawLine(nodes[i], nodes[j], link);
      }
    }

    for (var i = 0; i < nodes.length; i++) {
      var alpha = 0.35;
      var radius = 1.6;
      if (cursor != null) {
        final near = (nodes[i] - cursor).distance;
        if (near < 140) {
          alpha += (1 - near / 140) * 0.5;
          radius += (1 - near / 140) * 1.8;
        }
      }
      canvas.drawCircle(
        nodes[i],
        radius,
        Paint()
          ..color = (i.isEven ? AppColors.lawGreen : AppColors.robinEdgeBlue)
              .withValues(alpha: alpha.clamp(0, 0.9)),
      );
    }
  }

  void _orb(
    Canvas canvas,
    Size size, {
    required Offset center,
    required double radius,
    required Color color,
    required double alpha,
  }) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: alpha),
          color.withValues(alpha: alpha * 0.25),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _MeshBackdropPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.cursorAlign != cursorAlign;
  }
}
