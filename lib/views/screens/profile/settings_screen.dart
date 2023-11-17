import 'package:carsxchange/providers/auth_provider.dart';
import 'package:carsxchange/providers/misc_provider.dart';
import 'package:carsxchange/views/screens/auth/login_screen.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/global.dart';
import '../../widgets/formTextField.dart';

class AccountSettingsScreen extends StatefulWidget {
  static const String routeName = '/account-settings';

  AccountSettingsScreen({Key key}) : super(key: key);

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  TextEditingController controllerName = TextEditingController();

  TextEditingController controllerEmail = TextEditingController();

  TextEditingController controllerCompany = TextEditingController();
  PhoneNumber phoneNumberController;

  String initialPhoneNumber = "";

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isValidEmail;
  bool _isLoading = false;
  bool _isDeleteAccountLoading = false;

  @override
  void initState() {
    controllerName = TextEditingController(text: context.read<Auth>().user.name);
    controllerEmail = TextEditingController(text: context.read<Auth>().user.email);
    controllerCompany = TextEditingController(text: context.read<Auth>().user.company);
    initialPhoneNumber = context.read<Auth>().user.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        leadingWidth: 60,
        backgroundColor: kBackgroundHomeColor,
        elevation: 0.0,
        leading: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: isEnglish ? 20 : 0, right: isEnglish ? 0 : 20),
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                  height: 40,
                  width: 40,
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: kBackAppIconColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          'Account Settings'.tr(),
          style: const TextStyle(color: kBackAppIconColor, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 44),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 26),
                        nameWidget(),
                        const SizedBox(height: 18.0),
                        emailWidget(),
                        const SizedBox(height: 18.0),
                        phoneNumberWidget(context),
                        const SizedBox(height: 8.0),
                        companyWidget(),
                        const SizedBox(height: 18.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _isLoading
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30),
                                    child: CircularProgressIndicator(color: kPrimaryColor),
                                  )
                                : MaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    color: kPrimaryColor,
                                    onPressed: () async {
                                      if (formKey.currentState.validate()) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        String finalPhoneNumber = phoneNumberController != null ? phoneNumberController.completeNumber : initialPhoneNumber;
                                        bool updateStatus = await Provider.of<Auth>(context, listen: false).updateUserInfo(
                                          email: controllerEmail.text.trim(),
                                          company: controllerCompany.text.trim(),
                                          phone: finalPhoneNumber,
                                          name: controllerName.text.trim(),
                                        );

                                        if (updateStatus != null) {
                                          if (updateStatus == true) {
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              CherryToast.success(title: Text("Profile updated successfully".tr())).show(context);
                                            }
                                          } else if (updateStatus == false) {
                                            if (context.mounted) CherryToast.warning(title: Text("Couldn't update profile info".tr())).show(context);
                                          }
                                        } else {
                                          if (context.mounted) CherryToast.error(title: Text("Error occurred while updating profile".tr())).show(context);
                                        }

                                        if (context.mounted) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      child: Text(
                                        'Save Changes'.tr(),
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                        const SizedBox(height: 26.0),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Account Status'.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: kBackAppIconColor,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(4)), color: kActiveCardColor.withOpacity(0.1)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: Center(
                                child: Text(
                                  'ACTIVE'.tr(),
                                  style: const TextStyle(color: kActiveCardColor, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 28),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Email Verified'.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: kBackAppIconColor,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(4)), color: kActiveCardColor.withOpacity(0.1)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              child: Center(
                                child: Text(
                                  'VERIFIED'.tr(),
                                  style: const TextStyle(color: kActiveCardColor, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      _isDeleteAccountLoading
                          ? CircularProgressIndicator()
                          : InkWell(
                              onTap: () async {
                                setState(() {
                                  _isDeleteAccountLoading = true;
                                });
                                bool confirmStatus = await showConfirmAccountDeletionDialog(context);
                                if (context.mounted && confirmStatus == true) {
                                  bool accountDeletionStatus = await Provider.of<Auth>(context, listen: false).requestAccountDeletion();
                                  if (accountDeletionStatus != null && accountDeletionStatus == true) {
                                    if (context.mounted) {
                                      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                                      CherryToast.success(title: Text("Your account was disabled and pending deletion!".tr())).show(context);
                                    }
                                  } else {
                                    if (context.mounted) {
                                      CherryToast.error(title: Text("Error occurred during account deletion".tr())).show(context);
                                    }
                                  }
                                }
                                if (context.mounted) {
                                  setState(() {
                                    _isDeleteAccountLoading = false;
                                  });
                                }
                              },
                              child: Text(
                                "Do you want to erase your data and disable your account?".tr(),
                                style: TextStyle(fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget nameWidget() {
    return FormTextField(
      readonly: false,
      controller: controllerName,
      label: 'Name'.tr(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      TextInputType: TextInputType.text,
      validate: (String value) {
        if (value.isEmpty) {
          return 'Invalid Name'.tr();
        } else {
          return null;
        }
      },
    );
  }

  Widget companyWidget() {
    return FormTextField(
      readonly: false,
      controller: controllerCompany,
      label: 'Company'.tr(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      TextInputType: TextInputType.text,
      validate: (String value) {
        if (value.isEmpty) {
          return 'Company is required'.tr();
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
        _isValidEmail = EmailValidator.validate(val);
      },
    );
  }

  Widget phoneNumberWidget(BuildContext context) {
    return IntlPhoneField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: initialPhoneNumber,
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
      onChanged: (phone) {
        phoneNumberController = phone;
      },
    );
  }
}
