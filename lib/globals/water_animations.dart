import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cursor_tracker.dart';
import 'package:portfolio_arivu/globals/text_style.dart';

/// Wave-shaped clip that rises to reveal content (tide coming in).
class TideReveal extends StatefulWidget {
  const TideReveal({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1400),
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;

  @override
  State<TideReveal> createState() => _TideRevealState();
}

class _TideRevealState extends State<TideReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, child) {
        return ClipPath(
          clipper: _TideClipper(progress: _progress.value),
          child: Opacity(
            opacity: 0.35 + (_progress.value * 0.65),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _TideClipper extends CustomClipper<Path> {
  _TideClipper({required this.progress});

  final double progress;

  @override
  Path getClip(Size size) {
    final path = Path();
    final revealY = size.height * (1 - progress);
    path.moveTo(0, size.height);
    path.lineTo(0, revealY);

    for (double x = 0; x <= size.width; x += 6) {
      final wave = math.sin((x / size.width * 3 * math.pi) + progress * 4) * 14;
      path.lineTo(x, revealY + wave * (1 - progress));
    }

    path
      ..lineTo(size.width, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant _TideClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}

/// Soft aqua shimmer sweeping across text.
class ShimmerText extends StatefulWidget {
  const ShimmerText({
    super.key,
    required this.text,
    required this.style,
    this.duration = const Duration(seconds: 3),
  });

  final String text;
  final TextStyle style;
  final Duration duration;

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ambient = CursorAmbient.maybeOf(context);
    final colors = ambient?.textShimmerColors ??
        const [
          AppColors.aqua,
          AppColors.themeColor,
          AppColors.lawGreen,
          AppColors.themeColor,
          AppColors.aqua,
        ];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return ui.Gradient.linear(
              Offset(bounds.width * (t * 2 - 0.5), 0),
              Offset(bounds.width * (t * 2 + 0.15), bounds.height),
              colors,
              const [0.0, 0.3, 0.5, 0.7, 1.0],
            );
          },
          child: child,
        );
      },
      child: Text(widget.text, style: widget.style),
    );
  }
}

/// Accent label whose color follows the cursor (gold / coding hues).
class CursorTintText extends StatelessWidget {
  const CursorTintText(
    this.text, {
    super.key,
    required this.style,
    this.coding = false,
  });

  final String text;
  final TextStyle style;
  final bool coding;

  @override
  Widget build(BuildContext context) {
    final ambient = CursorAmbient.maybeOf(context);
    if (ambient == null || !ambient.visible) {
      return Text(text, style: style.copyWith(color: AppColors.themeColor));
    }

    if (!coding) {
      return Text(
        text,
        style: style.copyWith(color: ambient.accentColor),
      );
    }

    // Coding-style gradient: keyword / string / type tones track the pointer.
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        final align = ambient.alignment;
        return ui.Gradient.linear(
          Offset(bounds.width * (align.x + 1) / 2, 0),
          Offset(bounds.width * (1 - (align.x + 1) / 2), bounds.height),
          [
            ambient.codeColor,
            ambient.accentColor,
            ambient.stringColor,
            ambient.codeColor,
          ],
          const [0.0, 0.35, 0.7, 1.0],
        );
      },
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }
}

/// Gentle vertical float — like drifting underwater.
class DriftFloat extends StatefulWidget {
  const DriftFloat({
    super.key,
    required this.child,
    this.amplitude = 8,
    this.duration = const Duration(seconds: 3),
    this.delay = Duration.zero,
  });

  final Widget child;
  final double amplitude;
  final Duration duration;
  final Duration delay;

  @override
  State<DriftFloat> createState() => _DriftFloatState();
}

class _DriftFloatState extends State<DriftFloat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    Future.delayed(widget.delay, () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final dy = math.sin(_controller.value * math.pi) * widget.amplitude;
        return Transform.translate(offset: Offset(0, dy), child: child);
      },
      child: widget.child,
    );
  }
}

/// Expanding ripple rings behind a child (CTA / icons).
class RipplePulse extends StatefulWidget {
  const RipplePulse({
    super.key,
    required this.child,
    this.color = AppColors.themeColor,
  });

  final Widget child;
  final Color color;

  @override
  State<RipplePulse> createState() => _RipplePulseState();
}

class _RipplePulseState extends State<RipplePulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _RipplePainter(
            progress: _controller.value,
            color: widget.color,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _RipplePainter extends CustomPainter {
  _RipplePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = math.max(size.width, size.height) * 0.85;

    for (var i = 0; i < 2; i++) {
      final t = (progress + i * 0.45) % 1.0;
      final radius = maxR * t;
      final opacity = (1 - t) * 0.35;
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = color.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Rising bubble particles for atmosphere.
class BubbleField extends StatefulWidget {
  const BubbleField({super.key, this.bubbleCount = 14});

  final int bubbleCount;

  @override
  State<BubbleField> createState() => _BubbleFieldState();
}

class _BubbleFieldState extends State<BubbleField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Bubble> _bubbles;
  final _random = math.Random(42);

  @override
  void initState() {
    super.initState();
    _bubbles = List.generate(widget.bubbleCount, (_) {
      return _Bubble(
        x: _random.nextDouble(),
        size: 3 + _random.nextDouble() * 7,
        speed: 0.15 + _random.nextDouble() * 0.35,
        phase: _random.nextDouble() * math.pi * 2,
        sway: 8 + _random.nextDouble() * 16,
      );
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _BubblePainter(
              bubbles: _bubbles,
              progress: _controller.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _Bubble {
  _Bubble({
    required this.x,
    required this.size,
    required this.speed,
    required this.phase,
    required this.sway,
  });

  final double x;
  final double size;
  final double speed;
  final double phase;
  final double sway;
}

class _BubblePainter extends CustomPainter {
  _BubblePainter({required this.bubbles, required this.progress});

  final List<_Bubble> bubbles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final b in bubbles) {
      final y = size.height * (1 - ((progress * b.speed + b.phase) % 1.0));
      final x = b.x * size.width +
          math.sin(progress * math.pi * 2 + b.phase) * b.sway;
      final paint = Paint()
        ..color = AppColors.themeColor.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(x, y), b.size, paint);
      canvas.drawCircle(
        Offset(x - b.size * 0.25, y - b.size * 0.25),
        b.size * 0.25,
        Paint()..color = Colors.white.withValues(alpha: 0.25),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Animated liquid underline for selected nav items.
class LiquidNavIndicator extends StatelessWidget {
  const LiquidNavIndicator({
    super.key,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(2),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: AppTextStyles.headerTextStyle(
                  color: selected ? AppColors.themeColor : AppColors.white,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 1.5,
                child: Align(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    height: 1.5,
                    width: selected ? 22.0 : 0.0,
                    color: AppColors.themeColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
