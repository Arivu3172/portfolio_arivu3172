
import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_assets.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/constants.dart';
import 'package:portfolio_arivu/globals/text_style.dart';
import 'package:portfolio_arivu/view/helper_class.dart';

class MyCertificate extends StatefulWidget {
  const MyCertificate({Key? key}) : super(key: key);

  @override
  State<MyCertificate> createState() => _MyCertificateState();
}

class _MyCertificateState extends State<MyCertificate> {
  bool isApp = false, isGraphic = false, isDataAnalyst = false;

  final onHoverActive = Matrix4.identity()..translate(0, -10, 0);
  final onHoverRemove = Matrix4.identity()..translate(0, 0, 0);


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return HelperClass(
      mobile: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          buildMyServicesText(),
          Constants.sizedBox(height: 60.0),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => flutter()));
            },
            onHover: (value) {
              setState(() {
                isApp = value;
              });
            },
            child: buildAnimatedContainer(
              title: 'Flutter',
              asset: AppAssets.certificate1,
              hover: isApp,
            ),
          ),
          Constants.sizedBox(height: 24.0),
          InkWell(
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => kcg()));
            },
            onHover: (value) {
              setState(() {
                isGraphic = value;
              });
            },
            child: buildAnimatedContainer(
              title: 'CC Certificate',
              asset: AppAssets.certificate2,
              hover: isGraphic,
            ),
          ),
          Constants.sizedBox(height: 24.0),
          InkWell(
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => provisional()));
            },
            onHover: (value) {
              setState(() {
                isDataAnalyst = value;
              });
            },
            child: buildAnimatedContainer(
              title: 'Provisional',
              asset: AppAssets.certificate3,
              hover: isDataAnalyst,
            ),
          )
        ],
      ),
      tablet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildMyServicesText(),
          Constants.sizedBox(height: 60.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => flutter()));
                },
                onHover: (value) {
                  setState(() {
                    isApp = value;
                  });
                },
                child: buildAnimatedContainer(
                  title: 'Flutter',
                  asset: AppAssets.certificate1,
                  hover: isApp,
                ),
              ),
              Constants.sizedBox(width: 24.0),
              InkWell(
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => kcg()));
                },
                onHover: (value) {
                  setState(() {
                    isGraphic = value;
                  });
                },
                child: buildAnimatedContainer(
                  title: 'CC Certificate',
                  asset: AppAssets.certificate2,
                  hover: isGraphic,
                ),
              ),
            ],
          ),
          Constants.sizedBox(height: 26.0),
          InkWell(
            onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => provisional()));
            },
            onHover: (value) {
              setState(() {
                isDataAnalyst = value;
              });
            },
            child: buildAnimatedContainer(
              title: 'Provisional',
              asset: AppAssets.certificate3,
              hover: isDataAnalyst,
              width: 725.0,
              hoverWidth: 735.0,
            ),
          )
        ],
      ),
      desktop: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildMyServicesText(),
          Constants.sizedBox(height: 60.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => flutter()));
                },
                onHover: (value) {
                  setState(() {
                    isApp = value;
                  });
                },
                child: buildAnimatedContainer(
                  title: 'Flutter',
                  asset: AppAssets.certificate1,
                  hover: isApp,
                ),
              ),
              Constants.sizedBox(width: 24.0),
              InkWell(
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => kcg()));
                },
                onHover: (value) {
                  setState(() {
                    isGraphic = value;
                  });
                },
                child: buildAnimatedContainer(
                  title: 'CC Certificate',
                  asset: AppAssets.certificate2,
                  hover: isGraphic,
                ),
              ),
              Constants.sizedBox(width: 24.0),
              InkWell(
                onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => provisional()), // Corrected syntax
    );
  },
                onHover: (value) {
                  setState(() {
                    isDataAnalyst = value;
                  });
                },
                child: buildAnimatedContainer(
                  title: 'Provisional',
                  asset: AppAssets.certificate3,
                  hover: isDataAnalyst,
                ),
              )
            ],
          ),
        ],
      ),
      paddingWidth: size.width * 0.04,
   //   bgColor: AppColors.bgColor,
    );
  }

  FadeInDown buildMyServicesText() {
    return FadeInDown(
      duration: const Duration(milliseconds: 1200),
      child: RichText(
        text: TextSpan(
          text: 'My ',
          style: AppTextStyles.headingStyles(fontSize: 30.0),
          children: [
            TextSpan(
              text: 'Certificate',
              style: AppTextStyles.headingStyles(
                  fontSize: 30.0, color: AppColors.robinEdgeBlue),
            )
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildAnimatedContainer({
    required String title,
    required String asset,
    required bool hover,
    double width = 300,
    double hoverWidth = 310,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: hover ? hoverWidth : width,
      height: hover ? 340 : 350,
      alignment: Alignment.center,
      transform: hover ? onHoverActive : onHoverRemove,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.black,
       // color: AppColors.bgColor2,
        borderRadius: BorderRadius.circular(30),
        border:
            hover ? Border.all(color: AppColors.themeColor, width: 3) : null,
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 4.0,
            blurRadius: 4.5,
            offset: Offset(3.0, 4.5),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Text(
            title,
            style: AppTextStyles.montserratStyle(
                color: Colors.white, fontSize: 22.0),
          ),
          Constants.sizedBox(height: 15.0),
           Image.asset(
             asset,
             width: 350,
            height:225,
            fit: BoxFit.fill,
          // color: AppColors.themeColor,
          ),
          
        
          // Constants.sizedBox(height: 12.0),
          // Text(
          //   'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.'
          //   ' The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters,',
          //   style: AppTextStyles.normalStyle(fontSize: 14.0),
          //   textAlign: TextAlign.center,
          // ),
          // Constants.sizedBox(height: 20.0),
          // AppButtons.buildMaterialButton(buttonName: 'View', onTap: () {})
        ],
      ),
    );
  }
}



class flutter extends StatelessWidget {
  const flutter ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Certificate")),
      body: Center(child: Image.asset("assets/flutter.jpg")),
    );
  }
}

class provisional extends StatelessWidget {
  const provisional({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Provisional Certificate")),
      body: Center(child: Image.asset("assets/provisional.jpg")),
    );
  }
}

class kcg extends StatelessWidget {
  const kcg ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CC Certificate")),
      body: Center(child: Image.asset("assets/kcg.jpg")),
    );
  }
}