import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/sound_fx.dart';
import 'package:portfolio_arivu/globals/text_style.dart';

class AppButtons {
  static MaterialButton buildMaterialButton({
    required String buttonName,
    required VoidCallback onTap,
  }) {
    return MaterialButton(
      onPressed: () {
        SoundFx.instance.playClick();
        onTap();
      },
      color: AppColors.themeColor,
      splashColor: AppColors.lawGreen,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      hoverColor: AppColors.lawGreen,
      elevation: 4,
      height: 48,
      minWidth: 140,
      focusElevation: 10,
      child: Text(
        buttonName,
        style: AppTextStyles.headerTextStyle(color: Colors.black),
      ),
    );
  }
}
