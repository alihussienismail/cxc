import 'package:carsxchange/providers/auth_provider.dart';
import 'package:carsxchange/views/screens/auth/login_screen.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../widgets/formTextField.dart';
import '../../widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = '/forgot-password';

  ForgotPasswordScreen({Key key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isValidEmail;

  bool _isLoading = false;

  TextEditingController controllerEmail = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 42),
                  Text(
                    'Forgot your password?'.tr(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Please enter the email address associated with your account, and we\'ll email you a link to reset your password.'
                        .tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: kDescriptionColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 26),
                  emailWidget(),
                  const SizedBox(height: 20.0),
                  _isLoading
                      ? const CircularProgressIndicator(color: kPrimaryColor)
                      : SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                              text: 'Reset Password'.tr(),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  bool passwordResetStatus =
                                      await Provider.of<Auth>(context,
                                              listen: false)
                                          .requestPasswordReset(
                                              controllerEmail.text);

                                  if (passwordResetStatus != null) {
                                    if (passwordResetStatus == true) {
                                      if (context.mounted) {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                LoginScreen.routeName);
                                        CherryToast.success(
                                                title: Text(
                                                    "Password reset email sent"
                                                        .tr()))
                                            .show(context);
                                      }
                                    } else if (passwordResetStatus == false) {
                                      if (context.mounted)
                                        CherryToast.warning(
                                                title: Text(
                                                    "Couldn't reset password"
                                                        .tr()))
                                            .show(context);
                                    }
                                  } else {
                                    if (context.mounted)
                                      CherryToast.error(
                                              title: Text(
                                                  "Error occurred during reset password"
                                                      .tr()))
                                          .show(context);
                                  }
                                  if (context.mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              }),
                        ),
                  const SizedBox(height: 24.0),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_back_ios_new_rounded),
                        const SizedBox(width: 6),
                        Text(
                          'Return to Login'.tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emailWidget() {
    return FormTextField(
      readonly: false,
      controller: controllerEmail,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      isSearch: true,
      label: 'Email address'.tr(),
      TextInputType: TextInputType.emailAddress,
      validate: (String value) {
        if (value.isEmpty) {
          return 'Email Cant be Empty'.tr();
        } else if (_isValidEmail == false) {
          return 'Email is wrong format !'.tr();
        } else {
          return null;
        }
      },
      onChanged: (val) {
        _isValidEmail = EmailValidator.validate(controllerEmail.text);
      },
    );
  }
}
