import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_arivu/globals/app_button.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cinematic_scene.dart';
import 'package:portfolio_arivu/globals/portfolio_content.dart';
import 'package:portfolio_arivu/globals/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class FreelancingPage extends StatelessWidget {
  const FreelancingPage({super.key});

  static const _email = 'arivazhagan3172@gmail.com';

  Future<void> _hireMe() async {
    final subject = Uri.encodeComponent('Freelance Flutter project');
    final body = Uri.encodeComponent(
      'Hi Arivazhagan,\n\nI would like to discuss a Flutter project.\n\n',
    );
    await launchUrl(Uri.parse('mailto:$_email?subject=$subject&body=$body'));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final count = width < 700 ? 1 : 2;

    const icons = [
      FontAwesomeIcons.mobileScreenButton,
      FontAwesomeIcons.code,
      FontAwesomeIcons.bug,
      FontAwesomeIcons.rocket,
    ];

    return CinematicScene(
      sceneNo: '06',
      act: 'Collaboration',
      title: 'Let’s Build the Next Scene',
      line: 'Available for Flutter freelance — hourly or fixed scope.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'From MVP to production polish — clear scope, weekly updates, and code you can own.',
            style: AppTextStyles.normalStyle(
              color: AppColors.white.withValues(alpha: 0.78),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 18),
          AppButtons.buildMaterialButton(
            buttonName: 'Hire Me',
            onTap: _hireMe,
          ),
          const SizedBox(height: 24),
          Text('SERVICES', style: AppTextStyles.indexStyle()),
          const SizedBox(height: 12),
          GridView.builder(
            itemCount: PortfolioContent.services.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: count,
              mainAxisExtent: 140,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
            ),
            itemBuilder: (context, index) {
              final item = PortfolioContent.services[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgColor2.withValues(alpha: 0.9),
                  border: Border.all(
                    color: AppColors.themeColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FaIcon(icons[index], color: AppColors.themeColor, size: 18),
                    const SizedBox(height: 12),
                    Text(
                      item.title,
                      style: AppTextStyles.montserratStyle(
                        color: AppColors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.description,
                      style: AppTextStyles.normalStyle(
                        color: AppColors.white.withValues(alpha: 0.75),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text('ENGAGEMENT', style: AppTextStyles.indexStyle()),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _EngageChip(label: 'Hourly'),
              _EngageChip(label: 'Fixed scope'),
              _EngageChip(label: 'Weekly demos'),
              _EngageChip(label: 'Source handover'),
            ],
          ),
        ],
      ),
    );
  }
}

class _EngageChip extends StatelessWidget {
  const _EngageChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.themeColor.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.headerTextStyle(color: AppColors.themeColor),
      ),
    );
  }
}
