import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_assets.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cinematic_scene.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!wide) ...[
            _AboutPhoto(size: 140),
            const SizedBox(height: 20),
          ],
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _AboutPhoto(size: 200),
                const SizedBox(width: 28),
                Expanded(child: _aboutText()),
              ],
            )
          else
            _aboutText(),
          const SizedBox(height: 22),
          Text('EXPERIENCE', style: AppTextStyles.indexStyle()),
          const SizedBox(height: 12),
          const _ExpRow(
            role: 'Flutter Developer',
            detail:
                'Howdy · TimesMed Doctor & Patient · TimesMed VKA · Coding Style',
          ),
          const SizedBox(height: 8),
          const _ExpRow(
            role: 'Core work',
            detail: 'UI, auth, APIs, Firebase, performance & release support',
          ),
          const SizedBox(height: 22),
          Text('SKILLS', style: AppTextStyles.indexStyle()),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _SkillChip(label: 'Flutter'),
              _SkillChip(label: 'Dart'),
              _SkillChip(label: 'Firebase'),
              _SkillChip(label: 'REST API'),
              _SkillChip(label: 'State Management'),
              _SkillChip(label: 'Android'),
              _SkillChip(label: 'iOS'),
              _SkillChip(label: 'Web'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _aboutText() {
    return Text(
      'Flutter developer with 2+ years of production experience. '
      'I deliver mobile and web apps with clean Dart code, solid '
      'state management, and stable API / Firebase integrations.',
      style: AppTextStyles.normalStyle(
        color: AppColors.white.withValues(alpha: 0.85),
      ),
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
  const _ExpRow({required this.role, required this.detail});

  final String role;
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
          child: RichText(
            text: TextSpan(
              text: '$role  ',
              style: AppTextStyles.montserratStyle(
                color: AppColors.themeColor,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: detail,
                  style: AppTextStyles.normalStyle(
                    color: AppColors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.themeColor.withValues(alpha: 0.55),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.headerTextStyle(color: AppColors.themeColor),
      ),
    );
  }
}
