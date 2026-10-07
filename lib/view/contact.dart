import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_arivu/globals/app_button.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cinematic_scene.dart';
import 'package:portfolio_arivu/globals/portfolio_content.dart';
import 'package:portfolio_arivu/globals/text_style.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  static const _email = 'arivazhagan3172@gmail.com';
  static const _linkedin =
      'https://www.linkedin.com/in/arivazhagan-a-0431bb24a';
  static const _github = 'https://github.com/Arivu3172';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _sendMessage() async {
    final subject = Uri.encodeComponent('Portfolio inquiry');
    final body = Uri.encodeComponent(
      'Name: ${_nameController.text.trim()}\n'
      'Email: ${_emailController.text.trim()}\n\n'
      '${_messageController.text.trim()}',
    );
    await _launch('mailto:$_email?subject=$subject&body=$body');
  }

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 900;

    return CinematicScene(
      sceneNo: '06',
      act: 'Final Frame',
      title: 'Start the Conversation',
      line: 'The next scene could be yours — freelance or full-time.',
      narration: PortfolioContent.sceneNarrations[5],
      child: narrow
          ? Column(
              children: [
                _links(),
                const SizedBox(height: 20),
                _form(),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: _links()),
                const SizedBox(width: 24),
                Expanded(flex: 6, child: _form()),
              ],
            ),
    );
  }

  Widget _links() {
    return Column(
      children: [
        _InfoTile(
          icon: FontAwesomeIcons.envelope,
          title: 'Email',
          value: _email,
          onTap: () => _launch('mailto:$_email'),
        ),
        const SizedBox(height: 10),
        _InfoTile(
          icon: FontAwesomeIcons.linkedin,
          title: 'LinkedIn',
          value: 'arivazhagan-a-0431bb24a',
          onTap: () => _launch(_linkedin),
        ),
        const SizedBox(height: 10),
        _InfoTile(
          icon: FontAwesomeIcons.github,
          title: 'GitHub',
          value: 'Arivu3172',
          onTap: () => _launch(_github),
        ),
      ],
    );
  }

  Widget _form() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgColor2.withValues(alpha: 0.9),
        border: Border.all(
          color: AppColors.themeColor.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: [
          _field(_nameController, 'Your Name'),
          const SizedBox(height: 12),
          _field(_emailController, 'Your Email'),
          const SizedBox(height: 12),
          _field(_messageController, 'Message', maxLines: 4),
          const SizedBox(height: 18),
          AppButtons.buildMaterialButton(
            buttonName: 'Send Message',
            onTap: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      cursorColor: AppColors.themeColor,
      style: AppTextStyles.normalStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.comfortaaStyle(),
        filled: true,
        fillColor: AppColors.bgColor.withValues(alpha: 0.55),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(
            color: AppColors.themeColor.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: const BorderSide(color: AppColors.themeColor),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgColor2.withValues(alpha: 0.75),
          border: Border.all(
            color: AppColors.themeColor.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          children: [
            FaIcon(icon, size: 16, color: AppColors.themeColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headerTextStyle(
                      color: AppColors.themeColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(value, style: AppTextStyles.normalStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
