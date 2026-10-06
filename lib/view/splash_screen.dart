import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_assets.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cursor_tracker.dart';
import 'package:portfolio_arivu/globals/text_style.dart';
import 'package:portfolio_arivu/view/main_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _intro;
  late final AnimationController _pulse;
  late final AnimationController _exit;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _ringSpin;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _exit = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );

    _logoScale = Tween<double>(begin: 0.55, end: 1).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
      ),
    );
    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );
    _ringSpin = Tween<double>(begin: -0.35, end: 0).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.1, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _textFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOut),
      ),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.45, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _exitFade = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _exit, curve: Curves.easeInCubic),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await _intro.forward();
    if (!mounted) return;
    _pulse.repeat(reverse: true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    await _exit.forward();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => const CursorTracker(
          child: MainDashBoard(),
        ),
        transitionDuration: const Duration(milliseconds: 480),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _intro.dispose();
    _pulse.dispose();
    _exit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: FadeTransition(
        opacity: _exitFade,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.oceanGradient),
            ),
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) {
                final glow = 0.08 + (_pulse.value * 0.1);
                return DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.85,
                      colors: [
                        AppColors.themeColor.withValues(alpha: glow),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_intro, _pulse]),
                builder: (context, _) {
                  final pulseScale = 1 + (_pulse.value * 0.04);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: _logoScale.value * pulseScale,
                        child: Opacity(
                          opacity: _logoFade.value,
                          child: Transform.rotate(
                            angle: _ringSpin.value * math.pi,
                            child: _SplashLogoMark(
                              pulse: _pulse.value,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textFade,
                          child: Column(
                            children: [
                              Text(
                                'ARIVAZHAGAN A',
                                style: AppTextStyles.nameStyle(fontSize: 26),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'FLUTTER DEVELOPER',
                                style: AppTextStyles.indexStyle().copyWith(
                                  letterSpacing: 3.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 42,
              child: FadeTransition(
                opacity: _textFade,
                child: Center(
                  child: _LoadingBar(progress: _intro),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashLogoMark extends StatelessWidget {
  const _SplashLogoMark({required this.pulse});

  final double pulse;

  @override
  Widget build(BuildContext context) {
    final ringPad = 10 + (pulse * 4);
    return Container(
      width: 148,
      height: 148,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.themeColor.withValues(alpha: 0.28 + pulse * 0.2),
            blurRadius: 28 + pulse * 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.themeColor.withValues(alpha: 0.85),
                width: 2.2,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ringPad),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.lawGreen.withValues(alpha: 0.45),
                  width: 1,
                ),
              ),
            ),
          ),
          ClipOval(
            child: Image.asset(
              AppAssets.splashLogo,
              width: 112,
              height: 112,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 112,
                height: 112,
                alignment: Alignment.center,
                color: AppColors.bgColor2,
                child: Text(
                  'AA',
                  style: AppTextStyles.nameStyle(fontSize: 42),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingBar extends StatelessWidget {
  const _LoadingBar({required this.progress});

  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: AnimatedBuilder(
        animation: progress,
        builder: (context, _) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress.value.clamp(0.15, 1.0),
              minHeight: 2.5,
              backgroundColor: AppColors.white.withValues(alpha: 0.08),
              valueColor: const AlwaysStoppedAnimation(AppColors.themeColor),
            ),
          );
        },
      ),
    );
  }
}
