


import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_assets.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/constants.dart';
import 'package:portfolio_arivu/globals/text_style.dart';
import 'package:portfolio_arivu/view/helper_class.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return HelperClass(
      mobile: Column(
        children: [
          buildAboutMeContents(),
          Constants.sizedBox(height: 35.0),
         // buildProfilePicture(),
        ],
      ),
      tablet: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        // buildProfilePicture(),
          Constants.sizedBox(width: 25.0),
          Expanded(child: buildAboutMeContents())
        ],
      ),
      desktop: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        // buildProfilePicture(),
          Constants.sizedBox(width: 25.0),
          Expanded(child: buildAboutMeContents())
        ],
      ),
      paddingWidth: size.width * 0.1,
     // bgColor: AppColors.bgColor2,
    );
  }

  FadeInRight buildProfilePicture() {
    return FadeInRight(
      duration: const Duration(milliseconds: 1200),
      child: Container(
         width: 240,
         height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        image: DecorationImage(image: AssetImage(AppAssets.profile,),
         
         
         fit: BoxFit.fill,
      
        
        )
                  ),
      ),
    );
  }

  Container buildAboutMeContents() {
    return Container(
   
      width: double.infinity,
      margin: EdgeInsets.all(20),
    decoration: BoxDecoration(
      //color: AppColors.bgColor,
      color: Colors.black,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(100),bottomRight: Radius.circular(100))
    ),
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeInRight(
              duration: const Duration(milliseconds: 1200),
              child: RichText(
                text: TextSpan(
                  text: 'About ',
                  style: AppTextStyles.headingStyles(fontSize: 30.0),
                  children: [
                    TextSpan(
                      text: 'Me!',
                      style: AppTextStyles.headingStyles(
                          fontSize: 30, color: AppColors.robinEdgeBlue),
                    )
                  ],
                ),
              ),
            ),
            Constants.sizedBox(height: 6.0),
            FadeInLeft(
              duration: const Duration(milliseconds: 1400),
              child: Text(
                'Flutter Developer!',
                style: AppTextStyles.montserratStyle(color: Colors.white),
              ),
            ),
            Constants.sizedBox(height: 8.0),
            FadeInLeft(
              duration: const Duration(milliseconds: 1600),
              child: Text(
                "Passionate Flutter developer with a strong foundation in Dart and cross-platform app development. Skilled in building high-performance, user-friendly applications with responsive UI, API integration, and Firebase services. A quick learner with a problem-solving mindset, eager to contribute and grow in a dynamic environment",
                style: AppTextStyles.normalStyle(),
              ),
            ),
            Constants.sizedBox(height: 15.0),
            // FadeInUp(
            //   duration: const Duration(milliseconds: 1800),
            //   child: AppButtons.buildMaterialButton(
            //       onTap: () {}, buttonName: 'Read More'),
            // )
          ],
        ),
      ),
    );
  }
}