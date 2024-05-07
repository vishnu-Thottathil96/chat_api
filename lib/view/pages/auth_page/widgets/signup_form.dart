// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lamie/constants/colors.dart';
import 'package:lamie/constants/custom_text.dart';
import 'package:lamie/constants/enumes.dart';
import 'package:lamie/constants/project_assets.dart';
import 'package:lamie/constants/texts.dart';
import 'package:lamie/controller/validation/form_validation_functions.dart';
import 'package:lamie/providers/signup_provider.dart';
import 'package:lamie/view/widgets/custom_alert.dart';
import 'package:lamie/view/widgets/custom_snakbar.dart';
import 'package:lamie/util/screen_size.dart';
import 'package:lamie/view/widgets/custom_button.dart';
import 'package:lamie/view/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class SignupForm extends StatefulWidget {
  final VoidCallback onBackPressed;

  const SignupForm(
      {Key? key, required BuildContext context, required this.onBackPressed})
      : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    color: ProjectColors.whiteColor,
                    iconSize: 40,
                    onPressed: () {
                      widget.onBackPressed();
                    },
                    icon: const Icon(Icons.arrow_back)),
                CustomText.createCustomText(
                    context: context,
                    text: ProjectTexts.signUp,
                    textType: TextType.heading,
                    color: ProjectColors.whiteColor),
              ],
            ),
            CustomTextFormField(
              fieldColor: ProjectColors.primaryViolet,
              fieldHeightRatio: 0.07,
              context: context,
              controller: _userNameController,
              hintText: ProjectTexts.userName,
              keyboardType: TextInputType.text,
              validator: (value) =>
                  ValidationController.userNameValidator(value),
            ),
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
            CustomTextFormField(
              fieldColor: ProjectColors.primaryViolet,
              fieldHeightRatio: 0.07,
              context: context,
              controller: _confirmPasswordController,
              hintText: ProjectTexts.confirmPassword,
              obscureText: true,
              validator: (value) =>
                  ValidationController.confirmPasswordValidator(
                      value, _passwordController.text),
            ),
            Consumer<SignupProvider>(
              builder: (context, provider, child) => provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      backgroundColor: ProjectColors.liteViolet,
                      textColor: ProjectColors.whiteColor,
                      context: context,
                      logoPath: ProjectAssets.signupLogo,
                      buttonText: ProjectTexts.signUp,
                      onPressed: () {
                        _handleSignup(context: context, provider: provider);
                      }),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSignup(
      {required BuildContext context, required SignupProvider provider}) async {
    if (_formKey.currentState!.validate()) {
      var email = _emailController.text;
      var username = _userNameController.text;
      var password = _passwordController.text;
      var password2 = _confirmPasswordController.text;

      var result = await provider.signup(
          email: email,
          username: username,
          password: password,
          password2: password2);

      if (result.isSuccess) {
        _formKey.currentState!.reset();
        _userNameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        CustomAlertBox.showAlert(
            context: context,
            title: ProjectTexts.verificationSentTitle,
            message: ProjectTexts.verificationSentMessage);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            CustomSnakbar.createSnackBar(result.message, SnackBarType.error));
      }
    }
  }
  // void _submitSignupForm() {
  //   if (_formKey.currentState!.validate()) {
  //     CustomAlertBox.showAlert(
  //         context: context,
  //         title: ProjectTexts.verificationSentTitle,
  //         message: ProjectTexts.verificationSentMessage);
  //   }
  // }
}
