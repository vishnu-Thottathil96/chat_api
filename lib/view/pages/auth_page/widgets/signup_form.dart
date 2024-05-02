import 'package:flutter/material.dart';
import 'package:lamie/constants/colors.dart';
import 'package:lamie/constants/custom_text.dart';
import 'package:lamie/constants/enumes.dart';
import 'package:lamie/constants/project_assets.dart';
import 'package:lamie/constants/texts.dart';
import 'package:lamie/controller/validation/form_validation_functions.dart';
import 'package:lamie/view/widgets/custom_alert.dart';
import 'package:lamie/view/widgets/custom_snakbar.dart';
import 'package:lamie/util/screen_size.dart';
import 'package:lamie/view/widgets/custom_button.dart';
import 'package:lamie/view/widgets/custom_text_field.dart';

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
            CustomButton(
                backgroundColor: ProjectColors.liteViolet,
                textColor: ProjectColors.whiteColor,
                context: context,
                logoPath: ProjectAssets.signupLogo,
                buttonText: ProjectTexts.signUp,
                onPressed: () {
                  _submitSignupForm();
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText.createCustomText(
                    context: context,
                    text: ProjectTexts.signUpnWithOther,
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
                      buttonText: ProjectTexts.googleSignup,
                      onPressed: () {
                        print('object');
                      }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitSignupForm() {
    if (_formKey.currentState!.validate()) {
      CustomAlertBox.showAlert(
          context: context,
          title: ProjectTexts.verificationSentTitle,
          message: ProjectTexts.verificationSentMessage);
    }
  }
}
