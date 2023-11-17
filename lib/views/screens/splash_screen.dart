import 'dart:async';

import 'package:carsxchange/constants/global.dart';
import 'package:carsxchange/providers/auth_provider.dart';
import 'package:carsxchange/views/screens/home/home_screen.dart';
import 'package:carsxchange/views/screens/on_boarding_screen.dart';
import 'package:carsxchange/views/widgets/loader_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  double value = 0.0;

  @override
  void initState() {
    loadAppData();

    // controller.repeat(reverse: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loaderWidget(context),
    );
  }

  void loadAppData() async {
    Timer(const Duration(seconds: 2), () async {
      String onBoardingStatus = await storage.read(key: 'onBoarding');
      if (onBoardingStatus == 'done') {
        if (context.mounted) {
          await Provider.of<Auth>(context, listen: false).tryAutoLogin().then((isAuth) async {
            if (isAuth) {
              try {
                await OneSignal.shared.setExternalUserId(context.read<Auth>().user.id.toString());
              } catch (e, stack) {
                if (kDebugMode) {
                  print("onesignal EEE: $e");
                }
              }
              if (context.mounted) Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            } else {
              if (context.mounted) Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            }
          });
        }
      } else {
        if (context.mounted) Navigator.pushReplacementNamed(context, OnBoardingScreen.routeName);
      }
    });
  }
}
