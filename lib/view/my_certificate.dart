import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_assets.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cinematic_scene.dart';
import 'package:portfolio_arivu/globals/text_style.dart';

class MyCertificate extends StatelessWidget {
  const MyCertificate({super.key});

  static const _items = [
    _CertItem(title: 'Flutter Certificate', asset: AppAssets.certificate1),
    _CertItem(title: 'CC Certificate', asset: AppAssets.certificate2),
    _CertItem(title: 'Provisional Certificate', asset: AppAssets.certificate3),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final count = width < 700 ? 1 : (width < 1100 ? 2 : 3);

    return CinematicScene(
      sceneNo: '03',
      act: 'Credentials',
      title: 'Proof in the Credits',
      line: 'Certificates that mark the craft behind the code.',
      child: GridView.builder(
        itemCount: _items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: count,
          mainAxisExtent: 260,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final item = _items[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _CertificateView(
                    title: item.title,
                    asset: item.asset,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bgColor2.withValues(alpha: 0.9),
                border: Border.all(
                  color: AppColors.themeColor.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.montserratStyle(
                      color: AppColors.themeColor,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Image.asset(item.asset, fit: BoxFit.contain),
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

class _CertItem {
  const _CertItem({required this.title, required this.asset});

  final String title;
  final String asset;
}

class _CertificateView extends StatelessWidget {
  const _CertificateView({required this.title, required this.asset});

  final String title;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Text(title, style: AppTextStyles.headerTextStyle()),
        backgroundColor: AppColors.bgColor2,
        foregroundColor: AppColors.themeColor,
      ),
      body: Center(child: Image.asset(asset)),
    );
  }
}
