import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cursor_tracker.dart';
import 'package:portfolio_arivu/globals/sound_fx.dart';

/// Text that brightens, tracks out, and grows a gold underline on hover.
class HoverText extends StatefulWidget {
  const HoverText(
    this.text, {
    super.key,
    required this.style,
    this.hoverColor,
    this.onTap,
    this.underline = true,
    this.scale = 1.03,
    this.letterSpacingBoost = 1.2,
    this.playClick = false,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  final String text;
  final TextStyle style;
  final Color? hoverColor;
  final VoidCallback? onTap;
  final bool underline;
  final double scale;
  final double letterSpacingBoost;
  final bool playClick;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  @override
  State<HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final ambient = CursorAmbient.maybeOf(context);
    final accent =
        widget.hoverColor ?? ambient?.accentColor ?? AppColors.themeColor;
    final baseColor = widget.style.color ?? AppColors.white;
    final baseTracking = widget.style.letterSpacing ?? 0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap == null
            ? null
            : () {
                if (widget.playClick) SoundFx.instance.playClick();
                widget.onTap!();
              },
        child: AnimatedScale(
          scale: _hover ? widget.scale : 1,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.centerLeft,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            style: widget.style.copyWith(
              color: _hover ? accent : baseColor,
              letterSpacing:
                  baseTracking + (_hover ? widget.letterSpacingBoost : 0),
              shadows: _hover
                  ? [
                      Shadow(
                        color: accent.withValues(alpha: 0.55),
                        blurRadius: 14,
                      ),
                    ]
                  : const [],
            ),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.text,
                    maxLines: widget.maxLines,
                    overflow: widget.overflow,
                    textAlign: widget.textAlign,
                  ),
                  if (widget.underline) ...[
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOutCubic,
                      height: _hover ? 1.5 : 0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accent,
                            accent.withValues(alpha: 0.15),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Wraps a child with hover scale + soft gold glow.
class HoverGlow extends StatefulWidget {
  const HoverGlow({
    super.key,
    required this.child,
    this.scale = 1.04,
    this.onTap,
  });

  final Widget child;
  final double scale;
  final VoidCallback? onTap;

  @override
  State<HoverGlow> createState() => _HoverGlowState();
}

class _HoverGlowState extends State<HoverGlow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final accent =
        CursorAmbient.maybeOf(context)?.accentColor ?? AppColors.themeColor;

    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hover ? widget.scale : 1,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              boxShadow: _hover
                  ? [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.35),
                        blurRadius: 18,
                      ),
                    ]
                  : const [],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
