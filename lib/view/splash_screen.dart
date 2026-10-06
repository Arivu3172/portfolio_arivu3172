import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_assets.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cursor_tracker.dart';
import 'package:portfolio_arivu/globals/text_style.dart';
import 'package:portfolio_arivu/view/main_dashboard.dart';

/// Opening title card — letterbox, slug, slow zoom, iris cut to portfolio.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _master;
  late final AnimationController _grain;
  late final AnimationController _exit;

  late final Animation<double> _fadeFromBlack;
  late final Animation<double> _letterbox;
  late final Animation<double> _slugFade;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoZoom;
  late final Animation<double> _lineGrow;
  late final Animation<double> _titleFade;
  late final Animation<double> _titleTrack;
  late final Animation<double> _creditFade;
  late final Animation<double> _iris;
  late final Animation<double> _exitDim;

  @override
  void initState() {
    super.initState();

    _master = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _grain = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    _exit = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeFromBlack = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.0, 0.18, curve: Curves.easeOut),
    );
    _letterbox = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.05, 0.28, curve: Curves.easeOutCubic),
    );
    _slugFade = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.18, 0.38, curve: Curves.easeOut),
    );
    _logoFade = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.28, 0.52, curve: Curves.easeOut),
    );
    _logoZoom = Tween<double>(begin: 1.18, end: 1.0).animate(
      CurvedAnimation(
        parent: _master,
        curve: const Interval(0.28, 0.95, curve: Curves.easeOutCubic),
      ),
    );
    _lineGrow = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.48, 0.68, curve: Curves.easeOutCubic),
    );
    _titleFade = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.55, 0.78, curve: Curves.easeOut),
    );
    _titleTrack = Tween<double>(begin: 10, end: 2.2).animate(
      CurvedAnimation(
        parent: _master,
        curve: const Interval(0.55, 0.85, curve: Curves.easeOutCubic),
      ),
    );
    _creditFade = CurvedAnimation(
      parent: _master,
      curve: const Interval(0.68, 0.9, curve: Curves.easeOut),
    );
    _iris = CurvedAnimation(
      parent: _exit,
      curve: Curves.easeInCubic,
    );
    _exitDim = CurvedAnimation(
      parent: _exit,
      curve: const Interval(0.35, 1.0, curve: Curves.easeIn),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await _master.forward();
    if (!mounted) return;
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    await _exit.forward();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => const CursorTracker(
          child: MainDashBoard(),
        ),
        transitionDuration: const Duration(milliseconds: 700),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _master.dispose();
    _grain.dispose();
    _exit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final barH = math.max(36.0, size.height * 0.08);

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: Listenable.merge([_master, _grain, _exit]),
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Base cinematic wash
              Opacity(
                opacity: _fadeFromBlack.value,
                child: const DecoratedBox(
                  decoration: BoxDecoration(gradient: AppColors.oceanGradient),
                ),
              ),

              // Soft spotlight behind logo
              Opacity(
                opacity: _logoFade.value * 0.9,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.08),
                      radius: 0.75,
                      colors: [
                        AppColors.themeColor.withValues(alpha: 0.16),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Title card content
              Opacity(
                opacity: (1 - _exitDim.value).clamp(0.0, 1.0),
                child: Center(
                  child: Transform.scale(
                    scale: _logoZoom.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Opacity(
                          opacity: _slugFade.value,
                          child: Text(
                            'SCENE 00  ·  OPENING TITLE',
                            style: AppTextStyles.indexStyle().copyWith(
                              letterSpacing: 3.4,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        SizedBox(height: size.height < 700 ? 28 : 36),
                        Opacity(
                          opacity: _logoFade.value,
                          child: _CinematicLogo(
                            reveal: _logoFade.value,
                          ),
                        ),
                        SizedBox(height: size.height < 700 ? 28 : 34),
                        // Gold rule draw
                        SizedBox(
                          width: 160 * _lineGrow.value,
                          height: 1.2,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.themeColor.withValues(
                                    alpha: 0.2 + _lineGrow.value * 0.8,
                                  ),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Opacity(
                          opacity: _titleFade.value,
                          child: Text(
                            'ARIVAZHAGAN A',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.nameStyle(
                              fontSize: size.width < 700 ? 28 : 36,
                            ).copyWith(
                              letterSpacing: _titleTrack.value,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Opacity(
                          opacity: _creditFade.value,
                          child: Text(
                            'A FILM BY CODE  ·  FLUTTER',
                            style: AppTextStyles.indexStyle().copyWith(
                              letterSpacing: 2.8,
                              color: AppColors.white.withValues(alpha: 0.55),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Film grain
              IgnorePointer(
                child: Opacity(
                  opacity: 0.055 * _fadeFromBlack.value,
                  child: CustomPaint(
                    painter: _FilmGrainPainter(seed: _grain.value),
                    size: Size.infinite,
                  ),
                ),
              ),

              // Vignette
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      radius: 1.15,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.55),
                      ],
                    ),
                  ),
                ),
              ),

              // Letterbox bars
              Align(
                alignment: Alignment.topCenter,
                child: Transform.translate(
                  offset: Offset(0, -barH * (1 - _letterbox.value)),
                  child: Container(
                    height: barH,
                    width: double.infinity,
                    color: Colors.black,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Transform.translate(
                  offset: Offset(0, barH * (1 - _letterbox.value)),
                  child: Container(
                    height: barH,
                    width: double.infinity,
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: _creditFade.value * (1 - _iris.value),
                      child: Text(
                        'ROLLING',
                        style: AppTextStyles.indexStyle().copyWith(
                          fontSize: 10,
                          letterSpacing: 4,
                          color: AppColors.themeColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Iris wipe exit
              if (_iris.value > 0)
                IgnorePointer(
                  child: CustomPaint(
                    painter: _IrisWipePainter(progress: _iris.value),
                    size: Size.infinite,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CinematicLogo extends StatelessWidget {
  const _CinematicLogo({required this.reveal});

  final double reveal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.themeColor.withValues(alpha: 0.22 * reveal),
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(150, 150),
            painter: _ArcRingPainter(progress: reveal),
          ),
          ClipOval(
            child: Image.asset(
              AppAssets.splashLogo,
              width: 118,
              height: 118,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 118,
                height: 118,
                alignment: Alignment.center,
                color: AppColors.bgColor2,
                child: Text(
                  'AA',
                  style: AppTextStyles.nameStyle(fontSize: 44),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArcRingPainter extends CustomPainter {
  _ArcRingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..color = AppColors.themeColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawCircle(center, radius, track);

    final arc = Paint()
      ..shader = ui.Gradient.sweep(
        center,
        [
          AppColors.lawGreen.withValues(alpha: 0.2),
          AppColors.themeColor,
          AppColors.aqua,
          AppColors.lawGreen.withValues(alpha: 0.2),
        ],
        const [0.0, 0.35, 0.7, 1.0],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _FilmGrainPainter extends CustomPainter {
  _FilmGrainPainter({required this.seed});

  final double seed;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random((seed * 10000).floor());
    final paint = Paint()..style = PaintingStyle.fill;
    final count = (size.width * size.height / 2800).clamp(80, 220).toInt();

    for (var i = 0; i < count; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final a = 0.25 + rng.nextDouble() * 0.75;
      paint.color = Colors.white.withValues(alpha: a);
      canvas.drawRect(Rect.fromLTWH(x, y, 1.2, 1.2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FilmGrainPainter oldDelegate) {
    return oldDelegate.seed != seed;
  }
}

/// Classic iris-in wipe to black before route change.
class _IrisWipePainter extends CustomPainter {
  _IrisWipePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = math.sqrt(
      math.pow(size.width / 2, 2) + math.pow(size.height / 2, 2),
    );
    final radius = maxR * (1 - progress);

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addOval(Rect.fromCircle(center: center, radius: math.max(0, radius)));

    canvas.drawPath(path, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant _IrisWipePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
