import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/text_style.dart';

/// Luxury section chrome: gold corner brackets + indexed title.
class SectionFrame extends StatelessWidget {
  const SectionFrame({
    super.key,
    required this.index,
    required this.title,
    required this.accent,
    required this.child,
    this.subtitle,
  });

  final String index;
  final String title;
  final String accent;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CornerBracketPainter(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(index, style: AppTextStyles.indexStyle()),
                const SizedBox(width: 12),
                Container(
                  width: 36,
                  height: 1,
                  color: AppColors.themeColor.withValues(alpha: 0.7),
                ),
              ],
            ),
            const SizedBox(height: 14),
            RichText(
              text: TextSpan(
                text: '$title ',
                style: AppTextStyles.headingStyles(fontSize: 32),
                children: [
                  TextSpan(
                    text: accent,
                    style: AppTextStyles.headingStyles(
                      fontSize: 32,
                      color: AppColors.themeColor,
                    ),
                  ),
                ],
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 10),
              Text(
                subtitle!,
                style: AppTextStyles.normalStyle(
                  color: AppColors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
            ],
            const SizedBox(height: 28),
            child,
          ],
        ),
      ),
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.themeColor
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    const arm = 22.0;

    // Top-left
    canvas.drawLine(const Offset(0, arm), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(arm, 0), paint);

    // Top-right
    canvas.drawLine(Offset(size.width - arm, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, arm), paint);

    // Bottom-left
    canvas.drawLine(
        Offset(0, size.height - arm), Offset(0, size.height), paint);
    canvas.drawLine(
        Offset(0, size.height), Offset(arm, size.height), paint);

    // Bottom-right
    canvas.drawLine(Offset(size.width - arm, size.height),
        Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - arm),
        Offset(size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
