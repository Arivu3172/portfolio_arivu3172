import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/view/main_dashboard.dart';

class FooterClass extends StatelessWidget {
  const FooterClass({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size _ = MediaQuery.of(context).size;
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      color: Colors.black,
      //color: AppColors.bgColor2,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(
        horizontal: 40,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => MainDashBoard()),
          );
          
        },
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.themeColor),
          child: const Icon(
            Icons.arrow_upward,
            size: 25,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}