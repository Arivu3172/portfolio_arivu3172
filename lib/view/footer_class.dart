import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/text_style.dart';

class FooterClass extends StatelessWidget {
  const FooterClass({super.key, this.onScrollToTop});

  final VoidCallback? onScrollToTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.92),
        border: Border(
          top: BorderSide(
            color: AppColors.themeColor.withValues(alpha: 0.35),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('END CREDITS', style: AppTextStyles.indexStyle()),
                const SizedBox(height: 8),
                Text(
                  'Arivazhagan A  ·  Flutter Developer',
                  style: AppTextStyles.normalStyle(
                    color: AppColors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Code · Story · Motion · Ship',
                  style: AppTextStyles.normalStyle(
                    color: AppColors.white.withValues(alpha: 0.45),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onScrollToTop,
            child: Container(
              height: 42,
              width: 42,
              alignment: Alignment.center,
              color: AppColors.themeColor,
              child: const Icon(
                Icons.arrow_upward,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
