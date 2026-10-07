import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_arivu/globals/app_assets.dart';
import 'package:portfolio_arivu/globals/app_button.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cursor_tracker.dart';
import 'package:portfolio_arivu/globals/portfolio_content.dart';
import 'package:portfolio_arivu/globals/hover_text.dart';
import 'package:portfolio_arivu/globals/speak_button.dart';
import 'package:portfolio_arivu/globals/text_style.dart';
import 'package:portfolio_arivu/globals/water_animations.dart';
import 'package:portfolio_arivu/view/hacker_resume.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final socialButtons = const [
    {
      'icon': FontAwesomeIcons.linkedin,
      'url': 'https://www.linkedin.com/in/arivazhagan-a-0431bb24a',
    },
    {
      'icon': FontAwesomeIcons.github,
      'url': 'https://github.com/Arivu3172',
    },
    {
      'icon': FontAwesomeIcons.envelope,
      'url': 'mailto:arivazhagan3172@gmail.com',
    },
  ];

  int? socialBI;
  late final AnimationController _intro;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final wide = size.width >= 900;

    final fade = CurvedAnimation(parent: _intro, curve: Curves.easeOutCubic);
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _intro, curve: Curves.easeOutCubic));

    return SizedBox(
      width: size.width,
      height: math.max(size.height * 0.96, 560),
      child: Stack(
        children: [
          // Letterbox bars
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 28,
            child: Container(color: Colors.black.withValues(alpha: 0.85)),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 28,
            child: Container(color: Colors.black.withValues(alpha: 0.9)),
          ),
          Positioned(
            right: wide ? -40 : -20,
            bottom: wide ? 60 : 40,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.04,
                child: Text(
                  'AA',
                  style: AppTextStyles.nameStyle(fontSize: wide ? 220 : 130),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _GoldSlashPainter()),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              wide ? size.width * 0.1 : 22,
              wide ? 130 : 110,
              wide ? size.width * 0.12 : 22,
              48,
            ),
            child: FadeTransition(
              opacity: fade,
              child: SlideTransition(
                position: slide,
                child: wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(child: _heroCopy(wide)),
                          const SizedBox(width: 40),
                          DriftFloat(
                            amplitude: 6,
                            duration: const Duration(seconds: 4),
                            child: const _ProfilePortrait(size: 380),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: DriftFloat(
                              amplitude: 4,
                              child: const _ProfilePortrait(size: 180),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Expanded(child: _heroCopy(wide)),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroCopy(bool wide) {
    final accent =
        CursorAmbient.maybeOf(context)?.accentColor ?? AppColors.themeColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HoverText(
          'SCENE 01  ·  OPENING TITLE',
          underline: false,
          scale: 1.05,
          letterSpacingBoost: 1.2,
          style: AppTextStyles.indexStyle().copyWith(
            letterSpacing: 3.2,
            color: accent,
          ),
        ),
        const SizedBox(height: 18),
        HoverGlow(
          scale: 1.02,
          child: ShimmerText(
            text: 'ARIVAZHAGAN A',
            style: AppTextStyles.nameStyle(fontSize: wide ? 52 : 32),
          ),
        ),
        const SizedBox(height: 10),
        HoverText(
          'Senior Flutter Developer  ·  2+ Years',
          underline: true,
          scale: 1.03,
          letterSpacingBoost: 1.0,
          style: AppTextStyles.montserratStyle(
            color: AppColors.themeColor,
            fontSize: wide ? 18 : 15,
          ),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: wide ? 560 : 520),
          child: HoverText(
            'A cinematic portfolio where code meets storytelling, '
            'design meets motion, and every scroll feels like a scene.',
            underline: false,
            scale: 1.01,
            letterSpacingBoost: 0.3,
            style: AppTextStyles.normalStyle(
              color: AppColors.white.withValues(alpha: 0.82),
              fontSize: wide ? 16 : 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: HoverText(
            'Production Flutter for Android, iOS, and web — '
            'clean architecture, sharp UI, reliable delivery.',
            underline: false,
            scale: 1.01,
            letterSpacingBoost: 0.3,
            style: AppTextStyles.normalStyle(
              color: AppColors.white.withValues(alpha: 0.62),
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SpeakButton(text: PortfolioContent.sceneNarrations[0]),
        const SizedBox(height: 22),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (var i = 0; i < socialButtons.length; i++)
              InkWell(
                onTap: () => _launchUrl(socialButtons[i]['url'] as String),
                onHover: (v) => setState(() => socialBI = v ? i : null),
                child: _SocialSquare(
                  icon: socialButtons[i]['icon'] as IconData,
                  hover: socialBI == i,
                ),
              ),
            AppButtons.buildMaterialButton(
              buttonName: 'View Resume',
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder<void>(
                    pageBuilder: (_, __, ___) => const HackerResumePage(),
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
              },
            ),
          ],
        ),
        if (wide) const Spacer(),
        if (wide) ...[
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'SCROLL TO CONTINUE',
                style: AppTextStyles.indexStyle().copyWith(
                  fontSize: 10,
                  color: AppColors.white.withValues(alpha: 0.45),
                ),
              ),
              const SizedBox(width: 10),
              DriftFloat(
                amplitude: 5,
                duration: const Duration(milliseconds: 1200),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.themeColor.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ProfilePortrait extends StatelessWidget {
  const _ProfilePortrait({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * 0.78,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.themeColor, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: AppColors.themeColor.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.profile,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -0.15),
          ),
          // Cinematic bottom fade into black/gold theme
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.55),
                ],
                stops: const [0.45, 0.75, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 12,
            child: Text(
              'DEV PROFILE',
              style: AppTextStyles.indexStyle().copyWith(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialSquare extends StatelessWidget {
  const _SocialSquare({required this.icon, required this.hover});

  final IconData icon;
  final bool hover;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: hover ? AppColors.themeColor : Colors.transparent,
        border: Border.all(color: AppColors.themeColor, width: 1.2),
      ),
      child: FaIcon(
        icon,
        size: 18,
        color: hover ? Colors.black : AppColors.themeColor,
      ),
    );
  }
}

class _GoldSlashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.72, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width * 0.55, size.height)
      ..lineTo(size.width * 0.42, size.height)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.themeColor.withValues(alpha: 0.12),
            AppColors.themeColor.withValues(alpha: 0.02),
            Colors.transparent,
          ],
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

