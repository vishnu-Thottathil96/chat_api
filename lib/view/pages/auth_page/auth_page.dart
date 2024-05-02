import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lamie/constants/enumes.dart';
import 'package:lamie/constants/project_assets.dart';
import 'package:lamie/util/screen_size.dart';
import 'package:lamie/view/pages/auth_page/widgets/login_form.dart';
import 'package:lamie/view/pages/auth_page/widgets/signup_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void toggleAuthPage({required AuthPageMode navigateTo}) {
    _pageController.animateToPage(
      navigateTo == AuthPageMode.login ? 0 : 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = ScreenSize.getHeight(context);
//final AuthPageToggleController togleController = AuthPageToggleController();
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            // Ensuring the content takes at least the full viewport height
            minHeight: h,
          ),
          child: IntrinsicHeight(
            // This makes the content inside take up the available space
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  ProjectAssets.backDropImage,
                  fit: BoxFit.cover,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                  child: SizedBox(
                    height: MediaQuery.of(context)
                        .size
                        .height, // Or some other fixed height for testing
                    child: PageView(
                      controller: _pageController,
                      children: [
                        LoginForm(
                          context: context,
                          onSignUpPressed: () =>
                              toggleAuthPage(navigateTo: AuthPageMode.signup),
                        ),
                        SignupForm(
                          context: context,
                          onBackPressed: () =>
                              toggleAuthPage(navigateTo: AuthPageMode.login),
                        ),
                      ],
                    ),
                  ),
                  //  togleController.currentMode == AuthPageMode.login
                  //     ? LoginForm(
                  //         context: context,
                  //       )
                  //     : SignupForm(context: context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
