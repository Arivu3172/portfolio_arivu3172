
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio_arivu/globals/app_button.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/constants.dart';
import 'package:portfolio_arivu/globals/text_style.dart';
import 'package:portfolio_arivu/profile_animation%20.dart';
import 'package:portfolio_arivu/view/helper_class.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 final List<Map<String, dynamic>> socialButtons = [
  {
    'icon': FontAwesomeIcons.linkedin,
    'url': 'https://www.linkedin.com/in/arivazhagan-a-0431bb24a?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app',
  },
  {
    'icon': FontAwesomeIcons.github,
    'url': 'https://github.com/Arivu3172',
  },
  {
    'icon': FontAwesomeIcons.envelope,
    'url': 'mailto:arivazhagan3172@gmail.com',
  },
  // {
  //   'icon': FontAwesomeIcons.facebook,
  //   'url': 'https://www.facebook.com/share/1Gzq2e124c/',
  // },
 
  
  
];


  var socialBI;

  Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw 'Could not launch $url';
  }
}
  

  @override
  Widget build(BuildContext context) {
   
    final Size size = MediaQuery.of(context).size;
    return HelperClass(
      mobile: Column(
        children: [
          buildHomePersonalInfo(size),
          Constants.sizedBox(height: 25.0),
          const ProfileAnimation()
        ],
      ),
      tablet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: buildHomePersonalInfo(size)),
          const ProfileAnimation(),
        ],
      ),
      desktop: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: buildHomePersonalInfo(size)),
         const ProfileAnimation(),
        ],
      ),
      paddingWidth: size.width * 0.1,
   //   bgColor: Colors.transparent,
    );
  }

  Column buildHomePersonalInfo(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeInDown(
          duration: const Duration(milliseconds: 1200),
          child: Text(
            'Hello, It\'s Me',
            style: AppTextStyles.montserratStyle(color: Colors.white),
          ),
        ),
        Constants.sizedBox(height: 15.0),
        FadeInRight(
          duration: const Duration(milliseconds: 1400),
          child: Text(
            'ARIVAZHAGAN A',
            style: AppTextStyles.headingStyles(),
          ),
        ),
        Constants.sizedBox(height: 15.0),
        FadeInLeft(
          duration: const Duration(milliseconds: 1400),
          child: Row(
            children: [
              
                Text(
                  'And I\'m a ',
                  style: AppTextStyles.montserratStyle(color: Colors.white),
                ),
              
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'Flutter Developer',
                    textStyle:
                        AppTextStyles.montserratStyle(color:Colors.lightBlue),
                        //Colors.lightBlue
                  ),
                  TyperAnimatedText('Frontend Developer ',
                      textStyle: AppTextStyles.montserratStyle(
                          color:Colors.lightBlue)),
                  TyperAnimatedText('Android Developer',
                      textStyle: AppTextStyles.montserratStyle(
                          color: Colors.lightBlue)),
                          TyperAnimatedText('ios Developer',
                      textStyle: AppTextStyles.montserratStyle(
                          color:Colors.lightBlue)),
                          TyperAnimatedText('Web Developer',
                      textStyle: AppTextStyles.montserratStyle(
                          color: Colors.lightBlue)),
                          TyperAnimatedText('App Developer',
                      textStyle: AppTextStyles.montserratStyle(
                          color:Colors.lightBlue)),
                ],
                pause: const Duration(milliseconds: 1000),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              )
            ],
          ),
        ),
        // Constants.sizedBox(height: 15.0),
        // FadeInDown(
        //   duration: const Duration(milliseconds: 1600),
        //   child: Expanded(
        //     child: Text(
        //       'In publishing and graphic design, Lorem ipsum is a placeholder '
        //       'text commonly used to demonstrate the visual form of a document'
        //       ' or a typeface without relying on meaningful content.',
        //       style: AppTextStyles.normalStyle(),
        //     ),
        //   ),
        // ),
        Constants.sizedBox(height: 22.0),
        FadeInUp(
          duration: const Duration(milliseconds: 1600),
          child: SizedBox(
  height: 48,
  child: ListView.separated(
    itemCount: socialButtons.length,
    shrinkWrap: true,
    scrollDirection: Axis.horizontal,
    separatorBuilder: (context, child) => SizedBox(width: 8.0),
    itemBuilder: (context, index) {
      final item = socialButtons[index];
      return InkWell(
        onTap: () => _launchUrl(item['url']),
        onHover: (value) {
          setState(() {
            socialBI = value ? index : null;
          });
        },
        borderRadius: BorderRadius.circular(550.0),
        hoverColor: AppColors.themeColor,
        splashColor: AppColors.lawGreen,
        child: buildSocialButton(
          icon: item['icon'],
          hover: socialBI == index,
        ),
      );
    },
  ),
)

        ),
        Constants.sizedBox(height: 18.0),
        FadeInUp(
          duration: const Duration(milliseconds: 1800),
          child: AppButtons.buildMaterialButton(
              onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => resume()));

              }, buttonName: 'View Resume'),
        ),
      ],
    );
  }

 Ink buildSocialButton({required IconData icon, required bool hover}) {
  return Ink(
    width: 45,
    height:45,
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.themeColor, width: 2.0),
      color: AppColors.bgColor,
      shape: BoxShape.circle,
    ),
    padding: const EdgeInsets.all(6),
    child: Icon(
      icon,
      size: 24,
      color: hover ? AppColors.bgColor : AppColors.themeColor,
    ),
  );
}
}


class resume extends StatelessWidget {
  const resume ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Resume")),
      body: Center(child: Image.asset('assets/resume.png')),
    );
  }
}