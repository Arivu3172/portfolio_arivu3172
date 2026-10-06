import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';

/// Ambient cursor state for background / glow consumers.
class CursorAmbient extends InheritedWidget {
  const CursorAmbient({
    super.key,
    required this.position,
    required this.viewport,
    required this.visible,
    required super.child,
  });

  final Offset position;
  final Size viewport;
  final bool visible;

  static CursorAmbient? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CursorAmbient>();
  }

  /// 0–1 normalized pointer inside the viewport.
  Alignment get alignment {
    if (viewport.width <= 0 || viewport.height <= 0) {
      return Alignment.center;
    }
    final nx = (position.dx / viewport.width).clamp(0.0, 1.0);
    final ny = (position.dy / viewport.height).clamp(0.0, 1.0);
    return Alignment(nx * 2 - 1, ny * 2 - 1);
  }

  double get _nx =>
      viewport.width <= 0 ? 0.5 : (position.dx / viewport.width).clamp(0.0, 1.0);

  double get _ny =>
      viewport.height <= 0 ? 0.5 : (position.dy / viewport.height).clamp(0.0, 1.0);

  /// Gold accent that shifts with cursor (champagne → gold → amber → copper).
  Color get accentColor {
    if (!visible) return AppColors.themeColor;
    final t = (_nx * 0.65 + (1 - _ny) * 0.35).clamp(0.0, 1.0);
    if (t < 0.33) {
      return Color.lerp(AppColors.lawGreen, AppColors.themeColor, t / 0.33)!;
    }
    if (t < 0.66) {
      return Color.lerp(
        AppColors.themeColor,
        AppColors.robinEdgeBlue,
        (t - 0.33) / 0.33,
      )!;
    }
    return Color.lerp(
      AppColors.robinEdgeBlue,
      AppColors.aqua,
      (t - 0.66) / 0.34,
    )!;
  }

  /// Secondary coding hue (teal / soft blue) opposite the gold accent.
  Color get codeColor {
    if (!visible) return const Color(0xFF7EC8E3);
    final t = ((1 - _nx) * 0.5 + _ny * 0.5).clamp(0.0, 1.0);
    return Color.lerp(
      const Color(0xFF7EC8E3),
      const Color(0xFF9AE6B4),
      t,
    )!;
  }

  /// String / literal coding tone.
  Color get stringColor {
    if (!visible) return const Color(0xFFE8A87C);
    final t = (_nx * 0.4 + _ny * 0.6).clamp(0.0, 1.0);
    return Color.lerp(
      const Color(0xFFE8A87C),
      const Color(0xFFF5E6A3),
      t,
    )!;
  }

  List<Color> get textShimmerColors => [
        accentColor,
        codeColor,
        stringColor,
        accentColor,
        AppColors.aqua,
      ];

  /// Background that shifts with cursor (cool black ↔ warm gold charcoal).
  Color get backgroundColor {
    if (!visible || viewport.width <= 0) return AppColors.bgColor;
    final t = (_nx * 0.55 + (1 - _ny) * 0.45).clamp(0.0, 1.0);
    return Color.lerp(
      const Color(0xFF050505),
      const Color(0xFF1C160A),
      t,
    )!;
  }

  LinearGradient get backgroundGradient {
    final align = visible ? alignment : Alignment.center;
    final warm = visible ? 0.22 : 0.08;
    return LinearGradient(
      begin: Alignment(
        (align.x * 0.6).clamp(-1.0, 1.0),
        (align.y * 0.6 - 0.2).clamp(-1.0, 1.0),
      ),
      end: Alignment(
        (-align.x * 0.5).clamp(-1.0, 1.0),
        (-align.y * 0.4 + 0.8).clamp(-1.0, 1.0),
      ),
      colors: [
        backgroundColor,
        Color.lerp(backgroundColor, const Color(0xFF2A2110), warm)!,
        const Color(0xFF000000),
        Color.lerp(const Color(0xFF0A0A0A), backgroundColor, 0.5)!,
      ],
      stops: const [0.0, 0.35, 0.72, 1.0],
    );
  }

  @override
  bool updateShouldNotify(CursorAmbient oldWidget) {
    return position != oldWidget.position ||
        viewport != oldWidget.viewport ||
        visible != oldWidget.visible;
  }
}

/// Cinematic gold cursor that smoothly tracks the pointer
/// and drives ambient background color shifts.
class CursorTracker extends StatefulWidget {
  const CursorTracker({super.key, required this.child});

  final Widget child;

  @override
  State<CursorTracker> createState() => _CursorTrackerState();
}

class _CursorTrackerState extends State<CursorTracker>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  Offset _target = Offset.zero;
  Offset _ring = Offset.zero;
  Offset _dot = Offset.zero;
  Size _viewport = Size.zero;
  bool _visible = false;
  bool _pressed = false;

  bool get _enabled {
    if (kIsWeb) return true;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return false;
      default:
        return true;
    }
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration _) {
    if (!_visible || !mounted) return;

    // Soft cinematic lag: ring trails more than the core dot.
    _dot = Offset.lerp(_dot, _target, 0.45)!;
    _ring = Offset.lerp(_ring, _target, 0.18)!;

    setState(() {});
  }

  void _update(PointerEvent event) {
    _target = event.localPosition;
    if (!_visible) {
      _dot = _target;
      _ring = _target;
      _visible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_enabled) return widget.child;

    final ringSize = _pressed ? 54.0 : 36.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        _viewport = Size(constraints.maxWidth, constraints.maxHeight);
        final ambient = CursorAmbient(
          position: _visible ? _ring : Offset(_viewport.width / 2, _viewport.height / 2),
          viewport: _viewport,
          visible: _visible,
          child: widget.child,
        );

        return MouseRegion(
          cursor: SystemMouseCursors.none,
          onEnter: (e) {
            _visible = true;
            _update(e);
          },
          onExit: (_) => setState(() => _visible = false),
          onHover: _update,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerHover: _update,
            onPointerMove: _update,
            onPointerDown: (e) {
              _pressed = true;
              _update(e);
            },
            onPointerUp: (e) {
              _pressed = false;
              _update(e);
            },
            onPointerCancel: (_) => setState(() => _pressed = false),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Cursor-reactive base wash (visible under / around content)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    gradient: ambient.backgroundGradient,
                  ),
                ),
                // Soft gold spotlight that follows the ring
                if (_visible)
                  IgnorePointer(
                    child: CustomPaint(
                      painter: _CursorGlowPainter(
                        center: _ring,
                        pressed: _pressed,
                      ),
                    ),
                  ),
                ambient,
                if (_visible) ...[
                  Positioned(
                    left: _ring.dx - ringSize / 2,
                    top: _ring.dy - ringSize / 2,
                    child: IgnorePointer(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: ringSize,
                        height: ringSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.themeColor.withValues(
                              alpha: _pressed ? 0.95 : 0.7,
                            ),
                            width: 1.4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.themeColor.withValues(alpha: 0.28),
                              blurRadius: _pressed ? 22 : 14,
                              spreadRadius: _pressed ? 2 : 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: _dot.dx - 3.5,
                    top: _dot.dy - 3.5,
                    child: IgnorePointer(
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: AppColors.themeColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.themeColor.withValues(alpha: 0.55),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CursorGlowPainter extends CustomPainter {
  _CursorGlowPainter({required this.center, required this.pressed});

  final Offset center;
  final bool pressed;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = pressed ? size.shortestSide * 0.42 : size.shortestSide * 0.34;
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          (center.dx / size.width) * 2 - 1,
          (center.dy / size.height) * 2 - 1,
        ),
        radius: radius / size.shortestSide,
        colors: [
          AppColors.themeColor.withValues(alpha: pressed ? 0.18 : 0.11),
          AppColors.themeColor.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _CursorGlowPainter oldDelegate) {
    return oldDelegate.center != center || oldDelegate.pressed != pressed;
  }
}
