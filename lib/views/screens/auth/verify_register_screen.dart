import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class VerifyRegisterScreen extends StatelessWidget {
  static const routeName = '/verify_registration';

  const VerifyRegisterScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 64),
                Text(
                  'Please wait for our email!'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 18),
                Text(
                  'New accounts on CarsXchange are subject to admin review before they are approved. We will email you soon!'.tr(),
                  style: const TextStyle(fontSize: 16, color: kDescriptionColor),
                  textAlign: TextAlign.center,
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
    );
  }
}
