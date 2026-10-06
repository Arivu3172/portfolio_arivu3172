import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cinematic_scene.dart';
import 'package:portfolio_arivu/globals/portfolio_content.dart';
import 'package:portfolio_arivu/globals/text_style.dart';

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final count = width < 700 ? 1 : 2;

    return CinematicScene(
      sceneNo: '03',
      act: 'Toolkit',
      title: 'The Stack Behind the Scenes',
      line: 'Tools and patterns that keep every production scene sharp.',
      narration: PortfolioContent.sceneNarrations[2],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            itemCount: PortfolioContent.skillGroups.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: count,
              mainAxisExtent: 168,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
            ),
            itemBuilder: (context, index) {
              final group = PortfolioContent.skillGroups[index];
              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.bgColor2.withValues(alpha: 0.88),
                  border: Border.all(
                    color: AppColors.themeColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.title.toUpperCase(),
                      style: AppTextStyles.indexStyle(),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final item in group.items)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.themeColor
                                      .withValues(alpha: 0.45),
                                ),
                              ),
                              child: Text(
                                item,
                                style: AppTextStyles.headerTextStyle(
                                  color: AppColors.themeColor,
                                ).copyWith(fontSize: 12, letterSpacing: 0.6),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 28),
          Text('PROCESS', style: AppTextStyles.indexStyle()),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final horizontal = constraints.maxWidth >= 820;
              final steps = PortfolioContent.process;
              if (horizontal) {
                return Row(
                  children: [
                    for (var i = 0; i < steps.length; i++) ...[
                      Expanded(child: _ProcessBeat(stepIndex: i)),
                      if (i < steps.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: AppColors.themeColor.withValues(alpha: 0.55),
                          ),
                        ),
                    ],
                  ],
                );
              }
              return Column(
                children: [
                  for (var i = 0; i < steps.length; i++) ...[
                    _ProcessBeat(stepIndex: i),
                    if (i < steps.length - 1) const SizedBox(height: 10),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProcessBeat extends StatelessWidget {
  const _ProcessBeat({required this.stepIndex});

  final int stepIndex;

  @override
  Widget build(BuildContext context) {
    final step = PortfolioContent.process[stepIndex];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.themeColor.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(step.no, style: AppTextStyles.indexStyle()),
          const SizedBox(height: 8),
          Text(
            step.title,
            style: AppTextStyles.montserratStyle(
              color: AppColors.white,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            step.detail,
            style: AppTextStyles.normalStyle(
              color: AppColors.white.withValues(alpha: 0.72),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
