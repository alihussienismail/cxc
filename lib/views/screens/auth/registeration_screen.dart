import 'package:carsxchange/providers/auth_provider.dart';
import 'package:carsxchange/views/screens/auth/verify_register_screen.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/colors.dart';
import '../../widgets/formTextField.dart';
import '../../widgets/password_text_field.dart';
import '../../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  bool _invalidLogin = false;

  bool _isValidEmail;

  TextEditingController controllerEmail = TextEditingController();

  TextEditingController controllerPassword = TextEditingController();

  String _email;

  String _phoneNumber;

  String _password;

  String _firstName;

  String _lastName;

  TextEditingController controllerFirstname = TextEditingController();

  TextEditingController controllerLastName = TextEditingController();

  bool _agreesToPoliciesAndTerms = false;

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
                  const SizedBox(height: 46),
                  Text(
                    'Register to CarsXchange'.tr(),
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
                  firstNameWidget(),
                  const SizedBox(height: 16.0),
                  lastNameWidget(),
                  const SizedBox(height: 16.0),
                  emailWidget(),
                  const SizedBox(height: 16.0),
                  phoneNumberWidget(),
                  const SizedBox(height: 16.0),
                  passwordInputWidget(),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Checkbox(
                        activeColor: kPrimaryColor,
                        value: _agreesToPoliciesAndTerms,
                        onChanged: (newValue) {
                          setState(() {
                            _agreesToPoliciesAndTerms = newValue;
                          });
                        },
                      ),
                      Flexible(
                        child: Wrap(
                          children: [
                            Text('I agree with CarsXchange '.tr()),
                            InkWell(
                              onTap: () => launchUrl(
                                  Uri.parse(
                                      'https://carsxchange.com/terms-and-conditions/'),
                                  mode: LaunchMode.externalApplication),
                              child: Text('Terms of Service'.tr(),
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  )),
                            ),
                            Text(' and '.tr()),
                            InkWell(
                              onTap: () => launchUrl(
                                  Uri.parse(
                                      'https://carsxchange.com/privacy-policy/'),
                                  mode: LaunchMode.externalApplication),
                              child: Text('Privacy Policy'.tr(),
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  _isLoading
                      ? const CircularProgressIndicator(color: kPrimaryColor)
                      : SizedBox(
                          width: double.infinity,
                          child: PrimaryButton(
                              text: 'Register'.tr(),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState.validate()) {
                                  if (_agreesToPoliciesAndTerms != true) {
                                    if (context.mounted)
                                      CherryToast.warning(
                                              title: Text(
                                                  "You have to agree with privacy policy and terms of service"
                                                      .tr()))
                                          .show(context);
                                    return;
                                  }
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  bool registrationStatus =
                                      await Provider.of<Auth>(context,
                                              listen: false)
                                          .register(
                                              "$_firstName $_lastName",
                                              _email,
                                              _phoneNumber,
                                              _password,
                                              _password);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (registrationStatus != null) {
                                    if (registrationStatus == true) {
                                      if (context.mounted) {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                VerifyRegisterScreen.routeName);
                                        CherryToast.success(
                                                title: Text(
                                                    "Account registered successfully"
                                                        .tr()))
                                            .show(context);
                                      }
                                    } else if (registrationStatus == false) {
                                      if (context.mounted)
                                        CherryToast.warning(
                                                title: Text(
                                                    "Couldn't register, check your data"
                                                        .tr()))
                                            .show(context);
                                    }
                                  } else {
                                    if (context.mounted)
                                      CherryToast.error(
                                              title: Text(
                                                  "Error occurred while registering"
                                                      .tr()))
                                          .show(context);
                                  }
                                }
                              }),
                        ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?  '.tr(),
                        style: const TextStyle(
                            fontSize: 14.0, color: kDescriptionColor),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Login'.tr(),
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

  Widget firstNameWidget() {
    return FormTextField(
      readonly: false,
      controller: controllerFirstname,
      label: 'First Name'.tr(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      TextInputType: TextInputType.text,
      onChanged: (val) {
        // if (_formKey.currentState.validate()) {}
        _firstName = val.trim();
      },
      validate: (String value) {
        if (value.isEmpty) {
          return 'Invalid First Name'.tr();
        } else {
          return null;
        }
      },
    );
  }

  Widget phoneNumberWidget() {
    return IntlPhoneField(
      decoration: InputDecoration(
        labelText: 'Phone Number'.tr(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kExpiredCardColor, width: 2.0),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kBorderColor, width: 1.0),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: kBorderColor, width: 1.0),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),
      initialCountryCode: 'AE',
      onChanged: (phone) {
        _phoneNumber = phone.completeNumber;
      },
    );
  }

  Widget lastNameWidget() {
    return FormTextField(
      readonly: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controllerLastName,
      label: 'Last Name'.tr(),
      TextInputType: TextInputType.text,
      onChanged: (val) {
        // if (_formKey.currentState.validate()) {}
        _lastName = val.trim();
      },
      validate: (String value) {
        if (value.isEmpty) {
          return 'Invalid Last Name'.tr();
        } else {
          return null;
        }
      },
    );
  }

  Widget emailWidget() {
    return FormTextField(
      readonly: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controllerEmail,
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
        } else if (value.length < 6) {
          return 'Password is too weak'.tr();
        } else {
          return null;
        }
      },
    );
  }
}
