import 'package:carsxchange/providers/auth_provider.dart';
import 'package:carsxchange/views/screens/home/home_screen.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../widgets/formTextField.dart';
import '../../widgets/password_text_field.dart';
import '../../widgets/primary_button.dart';
import 'forgot_password_screen.dart';
import 'registeration_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  bool _invalidLogin = false;

  bool _isValidEmail;

  TextEditingController controllerEmail = TextEditingController();

  TextEditingController controllerPassword = TextEditingController();

  String _email;

  String _password;

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
                  const SizedBox(height: 64),
                  Text(
                    'Log in to CarsXchange'.tr(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Enter your details below'.tr(),
                    style:
                        const TextStyle(fontSize: 16, color: kDescriptionColor),
                  ),
                  const SizedBox(height: 26),
                  emailWidget(),
                  const SizedBox(height: 16.0),
                  passwordInputWidget(),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, ForgotPasswordScreen.routeName);
                        },
                        child: Text(
                          'Forgot Password ?'.tr(),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: kForgetPassColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  _isLoading
                      ? const CircularProgressIndicator(color: kPrimaryColor)
                      : SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                              text: 'Login'.tr(),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  bool loginStatus = await Provider.of<Auth>(
                                          context,
                                          listen: false)
                                      .login(_email, _password);

                                  if (loginStatus != null) {
                                    if (loginStatus == true) {
                                      try {
                                        if (context.mounted)
                                          await OneSignal.shared
                                              .setExternalUserId(context
                                                  .read<Auth>()
                                                  .user
                                                  .id
                                                  .toString());
                                      } catch (e, stack) {
                                        if (kDebugMode) {
                                          print("onesignal EEE: $e");
                                        }
                                      }
                                      if (context.mounted) {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                HomeScreen.routeName);
                                        CherryToast.success(
                                                title:
                                                    Text("Success Login".tr()))
                                            .show(context);
                                      }
                                    } else if (loginStatus == false) {
                                      if (context.mounted) {
                                        CherryToast.warning(
                                                title: Text(
                                                    "Invalid Credentials".tr()))
                                            .show(context);
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    }
                                  } else {
                                    if (context.mounted)
                                      CherryToast.error(
                                              title: Text(
                                                  "Error occurred during login"
                                                      .tr()))
                                          .show(context);
                                  }
                                }
                                return;
                              }),
                        ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have an account?  '.tr(),
                        style: const TextStyle(
                            fontSize: 14.0, color: kDescriptionColor),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Get started'.tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
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
      isSearch: true,
      label: 'Email address'.tr(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
        // if (_formKey.currentState.validate()) {}
        _email = val.trim();
        _isValidEmail = EmailValidator.validate(_email);
      },
    );
  }

  Widget passwordInputWidget() {
    return PasswordTextField(
      controller: controllerPassword,
      onChanged: (val) {
        _invalidLogin = false;
        // if (_formKey.currentState.validate()) {}
        _password = val.trim();
      },
      validatorFun: (String value) {
        if (_invalidLogin) {
          return 'Password is Wrong'.tr();
        }
        if (value.isEmpty) {
          return 'Password Cant be Empty'.tr();
        } else {
          return null;
        }
      },
    );
  }
}
