import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_assets.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cinematic_scene.dart';
import 'package:portfolio_arivu/globals/portfolio_content.dart';
import 'package:portfolio_arivu/globals/text_style.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;

    return CinematicScene(
      sceneNo: '02',
      act: 'Character Study',
      title: 'The Developer Behind the Build',
      line:
          'A story of shipping production Flutter apps — clean code, clear UX, and steady delivery.',
      narration: PortfolioContent.sceneNarrations[1],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatsRow(wide: wide),
          const SizedBox(height: 24),
          if (!wide) ...[
            const _AboutPhoto(size: 140),
            const SizedBox(height: 20),
          ],
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _AboutPhoto(size: 200),
                const SizedBox(width: 28),
                Expanded(child: _aboutCopy()),
              ],
            )
          else
            _aboutCopy(),
          const SizedBox(height: 26),
          Text('EXPERIENCE', style: AppTextStyles.indexStyle()),
          const SizedBox(height: 12),
          for (final exp in PortfolioContent.experience) ...[
            _ExpRow(
              role: exp.role,
              org: exp.org,
              detail: exp.detail,
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 12),
          Text('EDUCATION', style: AppTextStyles.indexStyle()),
          const SizedBox(height: 12),
          for (final item in PortfolioContent.education) ...[
            _ExpRow(role: item.title, org: '', detail: item.meta),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _aboutCopy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          PortfolioContent.aboutBody,
          style: AppTextStyles.normalStyle(
            color: AppColors.white.withValues(alpha: 0.85),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          PortfolioContent.aboutFocus,
          style: AppTextStyles.normalStyle(
            color: AppColors.white.withValues(alpha: 0.65),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    final stats = PortfolioContent.stats;
    return Wrap(
      spacing: wide ? 18 : 12,
      runSpacing: 12,
      children: [
        for (final s in stats)
          Container(
            width: wide ? 140 : 120,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.themeColor.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.value,
                  style: AppTextStyles.nameStyle(fontSize: wide ? 28 : 22),
                ),
                const SizedBox(height: 4),
                Text(
                  s.label.toUpperCase(),
                  style: AppTextStyles.indexStyle().copyWith(
                    fontSize: 10,
                    color: AppColors.white.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AboutPhoto extends StatelessWidget {
  const _AboutPhoto({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 1.25,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.themeColor.withValues(alpha: 0.8)),
        image: const DecorationImage(
          image: AssetImage(AppAssets.profile),
          fit: BoxFit.cover,
          alignment: Alignment(0, -0.2),
        ),
      ),
    );
  }
}

class _ExpRow extends StatelessWidget {
  const _ExpRow({
    required this.role,
    required this.org,
    required this.detail,
  });

  final String role;
  final String org;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 7),
          color: AppColors.themeColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: role,
                  style: AppTextStyles.montserratStyle(
                    color: AppColors.themeColor,
                    fontSize: 14,
                  ),
                  children: [
                    if (org.isNotEmpty)
                      TextSpan(
                        text: '  ·  $org',
                        style: AppTextStyles.normalStyle(
                          color: AppColors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                detail,
                style: AppTextStyles.normalStyle(
                  color: AppColors.white.withValues(alpha: 0.68),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
