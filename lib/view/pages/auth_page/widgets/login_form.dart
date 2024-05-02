import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lamie/constants/colors.dart';
import 'package:lamie/constants/custom_text.dart';
import 'package:lamie/constants/enumes.dart';
import 'package:lamie/constants/project_assets.dart';
import 'package:lamie/constants/texts.dart';
import 'package:lamie/controller/validation/form_validation_functions.dart';
import 'package:lamie/util/screen_size.dart';
import 'package:lamie/view/pages/home/home.dart';
import 'package:lamie/view/widgets/custom_button.dart';
import 'package:lamie/view/widgets/custom_text_field.dart';

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
            CustomButton(
                backgroundColor: ProjectColors.liteViolet,
                textColor: ProjectColors.blackColor,
                context: context,
                logoPath: ProjectAssets.loginLogo,
                buttonText: ProjectTexts.login,
                onPressed: () {
                  log('login button event');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ));
                }),
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
                  CustomButton(
                      backgroundColor: ProjectColors.primaryViolet,
                      textColor: ProjectColors.whiteColor,
                      context: context,
                      logoPath: ProjectAssets.googleLogo,
                      buttonText: ProjectTexts.googleLogin,
                      onPressed: () {
                        print('object');
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

  void _submitLoginForm() {
    if (_formKey.currentState!.validate()) {
      // Proceed with login logic
      // You can access the email and password like so:
      // String email = _emailController.text;
      // String password = _passwordController.text;
      // Implement your login logic here
    }
  }
}
