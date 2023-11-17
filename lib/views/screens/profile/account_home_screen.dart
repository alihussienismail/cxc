import 'package:carsxchange/models/user_model.dart';
import 'package:carsxchange/providers/auth_provider.dart';
import 'package:carsxchange/providers/misc_provider.dart';
import 'package:carsxchange/views/screens/auth/login_screen.dart';
import 'package:carsxchange/views/screens/profile/change_password_screen.dart';
import 'package:carsxchange/views/widgets/error_placeholder.dart';
import 'package:carsxchange/views/widgets/loader_widget.dart';
import 'package:change_case/change_case.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../widgets/home/account_screen_cards.dart';
import 'language_screen.dart';
import 'my_offers_screen.dart';
import 'notification_settings_screen.dart';
import 'settings_screen.dart';

class AccountHomeScreen extends StatefulWidget {
  const AccountHomeScreen({Key key}) : super(key: key);

  @override
  State<AccountHomeScreen> createState() => _AccountHomeScreenState();
}

class _AccountHomeScreenState extends State<AccountHomeScreen> {
  User userDetails;
  bool _loggingOut = false;
  bool _isLoading = true;
  bool _isFirstLoad = true;

  @override
  void didChangeDependencies() {
    if (_isFirstLoad) {
      _isFirstLoad = false;
      Provider.of<Auth>(context, listen: false).getUserInfo().then((user) {
        userDetails = user;
        if (context.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? loaderWidget(context)
        : userDetails == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  errorWidget(context),
                  Builder(
                    builder: (context) => MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color: kPrimaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          child: Text(
                            'Try Again'.tr(),
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isFirstLoad = true;
                            _isLoading = true;
                            didChangeDependencies();
                          });
                        }),
                  )
                ],
              )
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: kCircleAvatarBackgroundColor,
                          child: Text(
                            userDetails.name[0].toUpperCase(),
                            style: const TextStyle(color: kBackAppIconColor, fontSize: 24, fontWeight: FontWeight.w700),
                          ),
                        ),
                        title: Text(
                          userDetails.name.toCapitalCase(),
                          style: const TextStyle(color: kBackAppIconColor, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          'Dealer'.tr(),
                          style: const TextStyle(fontSize: 10, color: kInactiveTextColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return AccountSettingsScreen();
                              }));
                            },
                            child: AccountCards(
                              assetName: 'assets/svg/account_settings.svg',
                              title: 'Account Settings'.tr(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return MyOffersScreen();
                              }));
                            },
                            child: AccountCards(
                              assetName: 'assets/svg/my_offers.svg',
                              title: 'My Offers'.tr(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () {
                              selectNavigatorPage(context, 0);
                            },
                            child: AccountCards(
                              assetName: 'assets/svg/my_bids.svg',
                              title: 'My Bids'.tr(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return const NotificationSettingsScreen();
                              }));
                            },
                            child: AccountCards(
                              assetName: 'assets/svg/notifications.svg',
                              title: 'Notifications'.tr(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return LanguageScreen();
                              })).then((value) {
                                setState(() {
                                  _isLoading = true;
                                  _isFirstLoad = true;
                                });
                                didChangeDependencies();
                              });
                            },
                            child: AccountCards(
                              assetName: 'assets/svg/language.svg',
                              title: 'Language'.tr(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, ChangePasswordScreen.routeName);
                            },
                            child: AccountCards(
                              assetName: 'assets/svg/resetPassword.svg',
                              title: 'Reset Password '.tr(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _loggingOut
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 30),
                                      child: CircularProgressIndicator(
                                        color: kPrimaryColor,
                                      ),
                                    )
                                  ],
                                )
                              : InkWell(
                                  onTap: () async {
                                    setState(() {
                                      _loggingOut = true;
                                    });
                                    bool confirmStatus = await showConfirmLogOutDialog(context);
                                    if (context.mounted && confirmStatus == true) {
                                      bool logOutStatus = await Provider.of<Auth>(context, listen: false).logOut();
                                      if (logOutStatus != null && logOutStatus == true) {
                                        if (context.mounted) {
                                          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                                          CherryToast.success(title: Text("Logged out successfully".tr())).show(context);
                                        }
                                      } else {
                                        if (context.mounted) {
                                          CherryToast.error(title: Text("Error occurred during logout".tr())).show(context);
                                        }
                                      }
                                    }
                                    if (context.mounted) {
                                      setState(() {
                                        _loggingOut = false;
                                      });
                                    }
                                  },
                                  child: AccountCards(
                                    assetName: 'assets/svg/profile.svg',
                                    title: 'Logout '.tr(),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              );
  }
}
