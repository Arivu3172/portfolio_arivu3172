import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cinematic_scene.dart';
import 'package:portfolio_arivu/globals/cursor_tracker.dart';
import 'package:portfolio_arivu/globals/portfolio_content.dart';
import 'package:portfolio_arivu/globals/text_style.dart';
import 'package:portfolio_arivu/globals/water_animations.dart';

class MyProject extends StatefulWidget {
  const MyProject({super.key});

  @override
  State<MyProject> createState() => _MyProjectState();
}

class _MyProjectState extends State<MyProject> {
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final count = width < 700 ? 1 : (width < 1100 ? 2 : 2);
    final projects = PortfolioContent.projects;

    return CinematicScene(
      sceneNo: '04',
      act: 'Feature Presentation',
      title: 'Stories Shipped in Code',
      line: 'Selected productions — each one a scene of product, UI, and craft.',
      narration: PortfolioContent.sceneNarrations[3],
      child: GridView.builder(
        itemCount: projects.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: count,
          mainAxisExtent: 280,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final project = projects[index];
          final hover = hoveredIndex == index;
          final isCoding = project.title == 'Coding Style';
          final accent =
              CursorAmbient.maybeOf(context)?.accentColor ?? AppColors.themeColor;
          return MouseRegion(
            onEnter: (_) => setState(() => hoveredIndex = index),
            onExit: (_) => setState(() => hoveredIndex = null),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              decoration: BoxDecoration(
                border: Border.all(
                  color: hover ? accent : accent.withValues(alpha: 0.35),
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(project.image, fit: BoxFit.cover),
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${project.year}  ·  ${project.platforms}',
                          style: AppTextStyles.indexStyle().copyWith(
                            fontSize: 10,
                            color: AppColors.white.withValues(alpha: 0.55),
                          ),
                        ),
                        const SizedBox(height: 6),
                        CursorTintText(
                          project.title,
                          coding: isCoding || hover,
                          style: AppTextStyles.montserratStyle(
                            color: AppColors.themeColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hover ? project.description : project.role,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.normalStyle(
                            color: AppColors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final tag in project.tags)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: accent.withValues(alpha: 0.45),
                                  ),
                                ),
                                child: Text(
                                  tag,
                                  style: AppTextStyles.indexStyle().copyWith(
                                    fontSize: 9,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
