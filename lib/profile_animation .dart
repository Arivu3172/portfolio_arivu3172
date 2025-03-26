
import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_assets.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';

class ProfileAnimation extends StatefulWidget {
  const ProfileAnimation({super.key});

  @override
  _ProfileAnimationState createState() {
    return _ProfileAnimationState();
  }
}

class _ProfileAnimationState extends State<ProfileAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);

    _animation = Tween(begin: const Offset(0,0.05), end: const Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  SlideTransition(
      position: _animation,
      child: Container(
         width: 240,
         height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(900)),
        boxShadow: [
      BoxShadow(
        color:AppColors.themeColor,
        blurRadius: 10, 
        spreadRadius: 2, 
        offset: Offset(5, -5),
        
      ),
       BoxShadow(
        color:AppColors.themeColor,
        blurRadius: 10, 
        spreadRadius: 2, 
        offset: Offset(-5,5), 
        
      ),
    ],

        image: DecorationImage(image: AssetImage(AppAssets.profile1),
         
         
         fit: BoxFit.fill,
      
        
        )
                  ),
      ),
    );
  }
}