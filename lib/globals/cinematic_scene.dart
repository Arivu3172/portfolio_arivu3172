import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cursor_tracker.dart';
import 'package:portfolio_arivu/globals/speak_button.dart';
import 'package:portfolio_arivu/globals/text_style.dart';
import 'package:portfolio_arivu/globals/water_animations.dart';

/// Full-viewport film scene: letterbox, slug, staggered entrance.
class CinematicScene extends StatefulWidget {
  const CinematicScene({
    super.key,
    required this.sceneNo,
    required this.act,
    required this.title,
    required this.child,
    this.line,
    this.narration,
    this.minHeightFactor = 0.92,
    this.padHorizontal,
  });

  final String sceneNo;
  final String act;
  final String title;
  final String? line;
  /// Optional TTS script. Defaults to title + line when null.
  final String? narration;
  final Widget child;
  final double minHeightFactor;
  final double? padHorizontal;

  @override
  State<CinematicScene> createState() => _CinematicSceneState();
}

class _CinematicSceneState extends State<CinematicScene>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _lineGrow;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _lineGrow = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    final size = MediaQuery.sizeOf(context);
    final hPad = widget.padHorizontal ?? (size.width < 700 ? 20.0 : size.width * 0.1);
    final accent =
        CursorAmbient.maybeOf(context)?.accentColor ?? AppColors.themeColor;

    return SizedBox(
      width: size.width,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: size.height * widget.minHeightFactor,
        ),
        child: Stack(
          children: [
            // Film grain-ish vignette edges
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.55),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.65),
                      ],
                      stops: const [0.0, 0.12, 0.88, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            // Side letterbox rails
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 3,
                color: accent.withValues(alpha: 0.15),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                hPad,
                size.height * 0.12,
                hPad,
                size.height * 0.08,
              ),
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SceneSlug(
                        sceneNo: widget.sceneNo,
                        act: widget.act,
                        lineProgress: _lineGrow,
                        accent: accent,
                      ),
                      const SizedBox(height: 18),
                      CursorTintText(
                        widget.title,
                        coding: true,
                        style: AppTextStyles.headingStyles(
                          fontSize: size.width < 700 ? 28 : 36,
                        ),
                      ),
                      if (widget.line != null) ...[
                        const SizedBox(height: 10),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: Text(
                            widget.line!,
                            style: AppTextStyles.normalStyle(
                              color: AppColors.white.withValues(alpha: 0.72),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      SpeakButton(
                        text: widget.narration ??
                            [
                              'Scene ${widget.sceneNo}. ${widget.act}.',
                              widget.title,
                              if (widget.line != null) widget.line!,
                            ].join(' '),
                      ),
                      const SizedBox(height: 28),
                      widget.child,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SceneSlug extends StatelessWidget {
  const _SceneSlug({
    required this.sceneNo,
    required this.act,
    required this.lineProgress,
    required this.accent,
  });

  final String sceneNo;
  final String act;
  final Animation<double> lineProgress;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'SCENE $sceneNo',
          style: AppTextStyles.indexStyle().copyWith(
            letterSpacing: 3,
            color: accent,
          ),
        ),
        const SizedBox(width: 14),
        AnimatedBuilder(
          animation: lineProgress,
          builder: (context, _) {
            return Container(
              width: 48 * lineProgress.value,
              height: 1,
              color: accent,
            );
          },
        ),
        const SizedBox(width: 14),
        Text(
          act.toUpperCase(),
          style: AppTextStyles.headerTextStyle(
            color: AppColors.white.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}

/// Thin film progress rail for the active scene.
class FilmProgressRail extends StatelessWidget {
  const FilmProgressRail({
    super.key,
    required this.total,
    required this.active,
    required this.onSelect,
    required this.labels,
  });

  final int total;
  final int active;
  final ValueChanged<int> onSelect;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final accent =
        CursorAmbient.maybeOf(context)?.accentColor ?? AppColors.themeColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final selected = i == active;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            onTap: () => onSelect(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected ? accent : Colors.transparent,
                    width: 1.5,
                  ),
                ),
              ),
              child: Text(
                labels[i].toUpperCase(),
                style: AppTextStyles.headerTextStyle(
                  color: selected
                      ? accent
                      : AppColors.white.withValues(alpha: 0.7),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
