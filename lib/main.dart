import 'dart:developer';

import 'package:carsxchange/providers/auth_provider.dart';
import 'package:carsxchange/providers/cars_provider.dart';
import 'package:carsxchange/views/screens/auth/forgot_password_screen.dart';
import 'package:carsxchange/views/screens/auth/login_screen.dart';
import 'package:carsxchange/views/screens/auth/verify_register_screen.dart';
import 'package:carsxchange/views/screens/home/home_screen.dart';
import 'package:carsxchange/views/screens/on_boarding_screen.dart';
import 'package:carsxchange/views/screens/profile/change_password_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

import 'constants/colors.dart';
import 'constants/global.dart';
import 'views/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId("545398d4-a4bd-4202-b82a-152eed4c9e33");

  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    if (kDebugMode) {
      log("Accepted permission: $accepted");
    }
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
    if (kDebugMode) {
      log("I GOT A NOTIFICATION WHILE IN FOREGROUND! WONT SHOW IT");
    }
    event.complete(null);
  });

  storage = const FlutterSecureStorage();
  String isEnglishCurrent;

  try {
    isSeenOnBoarding = await storage.read(key: "isSeenOnBoarding");
    isEnglishCurrent = await storage.read(key: "current_language_en");
  } on PlatformException catch (e) {
    await storage.deleteAll();
  }

  if (isSeenOnBoarding == null) {
    isSeenOnBoarding = 'false';
    await storage.write(key: "isSeenOnBoarding", value: 'false');
  }
  if (isEnglishCurrent == null) {
    await storage.write(key: "current_language_en", value: 'en');
    isEnglish = true;
  } else {
    isEnglish = isEnglishCurrent == 'en' ? true : false;
  }

  print('Current Language is $isEnglish');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: isEnglish ? const Locale('en') : const Locale('ar'),
      startLocale: isEnglish ? const Locale('en') : const Locale('ar'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProxyProvider<Auth, Cars>(
            create: (_) => Cars(null),
            update: (BuildContext context, Auth authProvider, Cars previousCarsProvider) => Cars(authProvider.authToken),
          )
        ],
        child: const MyApp(),
      ),
    ));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'carsXchange'.tr(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black),
          hintStyle: TextStyle(color: kGreyColor),
        ),
      ).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: kPrimaryColor,
            ),
        textTheme: GoogleFonts.publicSansTextTheme(),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const SplashScreen(),
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
        VerifyRegisterScreen.routeName: (ctx) => const VerifyRegisterScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        OnBoardingScreen.routeName: (ctx) => OnBoardingScreen(),
        ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
        ChangePasswordScreen.routeName: (ctx) => ChangePasswordScreen(),
      },
      // home: OnBoardingScreen(),
    );
  }
}
