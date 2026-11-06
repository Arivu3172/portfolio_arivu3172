import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_assets.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cursor_tracker.dart';
import 'package:portfolio_arivu/globals/portfolio_content.dart';
import 'package:portfolio_arivu/globals/sound_fx.dart';
import 'package:portfolio_arivu/globals/text_style.dart';
import 'package:portfolio_arivu/globals/voice_tts.dart';
import 'package:portfolio_arivu/globals/water_background.dart';
import 'package:portfolio_arivu/view/main_dashboard.dart';

/// Short intro: logo fade, then the portfolio.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _start();
  }

  Future<void> _start() async {
    unawaited(SoundFx.instance.playWhoosh());
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    unawaited(VoiceTts.instance.speak(PortfolioContent.splashNarration));
    await Future<void>.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    unawaited(VoiceTts.instance.stop());
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => const CursorTracker(
          child: MainDashBoard(),
        ),
        transitionDuration: const Duration(milliseconds: 450),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => SoundFx.instance.init(),
        child: WaterBackground(
          child: Center(
            child: FadeTransition(
              opacity: CurvedAnimation(parent: _intro, curve: Curves.easeOut),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: Image.asset(
                      AppAssets.splashLogo,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'ARIVAZHAGAN A',
                    style: AppTextStyles.nameStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Flutter Developer',
                    style: AppTextStyles.headerTextStyle(
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
