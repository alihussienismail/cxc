import 'package:carsxchange/constants/colors.dart';
import 'package:carsxchange/providers/auth_provider.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/password_text_field.dart';
import '../../widgets/primary_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String routeName = '/change-password';

  ChangePasswordScreen({Key key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController controllerPassword = TextEditingController();

  TextEditingController controllerNewPassword = TextEditingController();

  TextEditingController controllerConfirmNewPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 46),
                  Text(
                    'Change your password'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const SizedBox(height: 26),
                  passwordInputWidget(),
                  const SizedBox(height: 20.0),
                  const SizedBox(height: 20.0),
                  newPasswordInputWidget(),
                  const SizedBox(height: 20.0),
                  confirmNewPasswordInputWidget(),
                  const SizedBox(height: 20.0),
                  _isLoading
                      ? const CircularProgressIndicator(
                          color: kPrimaryColor,
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                              text: 'Update Password'.tr(),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (formKey.currentState.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  bool changePasswordStatus =
                                      await Provider.of<Auth>(context,
                                              listen: false)
                                          .changePassword(
                                              controllerPassword.text,
                                              controllerNewPassword.text);
                                  if (changePasswordStatus != null) {
                                    if (changePasswordStatus == true) {
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        CherryToast.success(
                                                title: Text(
                                                    "Password changed successfully"
                                                        .tr()))
                                            .show(context);
                                      }
                                    } else if (changePasswordStatus == false) {
                                      if (context.mounted) {
                                        CherryToast.warning(
                                                title: Text(
                                                    "Couldn't change password"
                                                        .tr()))
                                            .show(context);
                                      }
                                    }
                                  } else {
                                    if (context.mounted) {
                                      CherryToast.error(
                                              title: Text(
                                                  "Error occurred while changing password"
                                                      .tr()))
                                          .show(context);
                                    }
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
                          'Return to Profile'.tr(),
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

  Widget passwordInputWidget() {
    return PasswordTextField(
      title: 'Current Password'.tr(),
      controller: controllerPassword,
      validatorFun: (String value) {
        if (value.isEmpty) {
          return 'Password Cant be Empty'.tr();
        } else if (value.length < 6) {
          return 'Password is too weak'.tr();
        } else {
          return null;
        }
      },
    );
  }

  Widget newPasswordInputWidget() {
    return PasswordTextField(
      title: 'New Password'.tr(),
      controller: controllerNewPassword,
      validatorFun: (String value) {
        if (value.isEmpty) {
          return 'New Password Cant be Empty'.tr();
        } else if (value.length < 6) {
          return 'Password is too weak'.tr();
        } else {
          return null;
        }
      },
    );
  }

  Widget confirmNewPasswordInputWidget() {
    return PasswordTextField(
      title: 'Confirm New Password'.tr(),
      controller: controllerConfirmNewPassword,
      validatorFun: (String value) {
        if (value.isEmpty) {
          return 'Confirm New Password Cant be Empty'.tr();
        } else if (value != controllerNewPassword.text) {
          return 'Passwords must match'.tr();
        } else {
          return null;
        }
      },
    );
  }
}
