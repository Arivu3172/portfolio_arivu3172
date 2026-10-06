import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_arivu/globals/app_button.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cinematic_scene.dart';
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

    const services = [
      _ServiceItem(
        icon: FontAwesomeIcons.mobileScreenButton,
        title: 'Flutter App Development',
        description: 'Android, iOS, and web apps from UI to release.',
      ),
      _ServiceItem(
        icon: FontAwesomeIcons.code,
        title: 'Feature & API Work',
        description: 'Auth, REST, Firebase, and complex product flows.',
      ),
      _ServiceItem(
        icon: FontAwesomeIcons.bug,
        title: 'Bug Fix & Optimization',
        description: 'Stabilize apps, improve speed, and clean code.',
      ),
      _ServiceItem(
        icon: FontAwesomeIcons.rocket,
        title: 'MVP Builds',
        description: 'Scoped startup MVPs with clear milestones.',
      ),
    ];

    return CinematicScene(
      sceneNo: '05',
      act: 'Collaboration',
      title: 'Let’s Build the Next Scene',
      line: 'Available for Flutter freelance — hourly or fixed scope.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppButtons.buildMaterialButton(
            buttonName: 'Hire Me',
            onTap: _hireMe,
          ),
          const SizedBox(height: 24),
          GridView.builder(
            itemCount: services.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: count,
              mainAxisExtent: 140,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
            ),
            itemBuilder: (context, index) {
              final item = services[index];
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
                    FaIcon(item.icon, color: AppColors.themeColor, size: 18),
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
        ],
      ),
    );
  }
}

class _ServiceItem {
  const _ServiceItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
