// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lamie/constants/colors.dart';
import 'package:lamie/constants/custom_text.dart';
import 'package:lamie/constants/enumes.dart';
import 'package:lamie/constants/project_assets.dart';
import 'package:lamie/constants/texts.dart';
import 'package:lamie/controller/tokens/token_manager.dart';
import 'package:lamie/controller/validation/form_validation_functions.dart';
import 'package:lamie/providers/google_login.dart';
import 'package:lamie/providers/login_provider.dart';
import 'package:lamie/util/screen_size.dart';
import 'package:lamie/view/pages/home/home.dart';
import 'package:lamie/view/widgets/custom_button.dart';
import 'package:lamie/view/widgets/custom_snakbar.dart';
import 'package:lamie/view/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onSignUpPressed;

  const LoginForm(
      {Key? key, required BuildContext context, required this.onSignUpPressed})
      : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    double h = ScreenSize.getHeight(context);
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(h / 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText.createCustomText(
                context: context,
                text: ProjectTexts.login,
                textType: TextType.heading,
                color: ProjectColors.whiteColor),
            CustomTextFormField(
              fieldColor: ProjectColors.primaryViolet,
              fieldHeightRatio: 0.07,
              context: context,
              controller: _emailController,
              hintText: ProjectTexts.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => ValidationController.emailValidator(value),
            ),
            CustomTextFormField(
              fieldColor: ProjectColors.primaryViolet,
              fieldHeightRatio: 0.07,
              context: context,
              controller: _passwordController,
              hintText: ProjectTexts.password,
              obscureText: true,
              validator: (value) =>
                  ValidationController.passwordValidator(value),
            ),
            Consumer<LoginProvider>(
              builder: (context, provider, child) => provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      backgroundColor: ProjectColors.liteViolet,
                      textColor: ProjectColors.blackColor,
                      context: context,
                      logoPath: ProjectAssets.loginLogo,
                      buttonText: ProjectTexts.login,
                      onPressed: () {
                        _handleLogin(context, provider);
                      }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText.createCustomText(
                    context: context,
                    text: ProjectTexts.loginWithOther,
                    color: ProjectColors.whiteColor),
              ],
            ),
            SizedBox(
              child: Column(
                children: [
                  Consumer<GoogleLoginProvider>(
                      builder: (context, provider, child) {
                    return CustomButton(
                        backgroundColor: ProjectColors.primaryViolet,
                        textColor: ProjectColors.whiteColor,
                        context: context,
                        logoPath: ProjectAssets.googleLogo,
                        buttonText: ProjectTexts.googleLogin,
                        onPressed: () async {
                          var result = await provider.signInWithGoogle();

                          if (result.isSuccess) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                                (route) => false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(result.message),
                              backgroundColor: ProjectColors.redColor,
                            ));
                          }
                        });
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText.createCustomText(
                    context: context,
                    text: ProjectTexts.dontHaveAccount,
                    color: ProjectColors.whiteColor),
              ],
            ),
            CustomButton(
                backgroundColor: ProjectColors.primaryViolet,
                textColor: ProjectColors.whiteColor,
                context: context,
                logoPath: ProjectAssets.signupLogo,
                buttonText: ProjectTexts.signUp,
                onPressed: () {
                  widget.onSignUpPressed();
                }),
          ],
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context, LoginProvider provider) async {
    if (_formKey.currentState!.validate()) {
      var email = _emailController.text;
      var password = _passwordController.text;
      var result = await provider.login(email: email, password: password);

      if (result.isSuccess) {
        _formKey.currentState!.reset();
        _emailController.clear();
        _passwordController.clear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false);

        printTokens();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnakbar.createSnackBar(result.message, SnackBarType.error));
      }
    }
  }
}

void printTokens() async {
  String? accessToken = await TokenManager.getAccessToken();
  String? refreshToken = await TokenManager.getRefreshToken();
  log('Access Token: $accessToken');
  log('Refresh Token: $refreshToken');
}

///////////////////////
// class GoogleSignInApi {
//   static final _googleSignIn = GoogleSignIn();
//   static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
// }

// Future signIn() async {
//   await GoogleSignInApi.login();
// }

// Future<void> signIn() async {
//   try {
//     GoogleSignInAccount? user = await GoogleSignInApi.login();

//     if (user != null) {
//       print("Google Sign-In successful.");
//       print("Name: ${user.displayName}");
//       print("Email: ${user.email}");
//       print("Profile Photo URL: ${user.photoUrl}");
//       GoogleSignInAuthentication googleAuth = await user.authentication;
//       print(googleAuth.accessToken);

//       // If you need to use the Google sign-in data for further operations, such as
//       // sending to a server or using in your app, you can include those operations here.
//     } else {
//       print("Google Sign-In aborted by user.");
//     }
//   } catch (error) {
//     print("Error during Google Sign-In: $error");
//   }
// }
