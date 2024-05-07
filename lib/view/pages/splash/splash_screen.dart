// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lamie/constants/colors.dart';
import 'package:lamie/constants/project_assets.dart';
import 'package:lamie/controller/tokens/token_manager.dart';
import 'package:lamie/util/screen_size.dart';
import 'package:lamie/view/pages/auth_page/auth_page.dart';
import 'package:lamie/view/pages/home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      checkAuthentication();
    });
  }

  void checkAuthentication() async {
    String? accessToken = await TokenManager.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthPage(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = ScreenSize.getHeight(context);
    double w = ScreenSize.getWidth(context);
    return Scaffold(
      backgroundColor: ProjectColors.blackColor,
      body: Center(
        child: SizedBox(
          height: h / 2,
          width: w,
          child: Image.asset(
            ProjectAssets.splashLogo,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
