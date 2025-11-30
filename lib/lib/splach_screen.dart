import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:gourmet/welcome_page.dart';
import 'package:lottie/lottie.dart';

class SplachScreen extends StatelessWidget {
  const SplachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(child: LottieBuilder.asset('assets/animation/Chef_animation.json')),
      backgroundColor: Colors.black,
      splashIconSize: 300,
      nextScreen: WelcomePage(),
    );
  }
}
