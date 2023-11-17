import 'package:carsxchange/providers/auth_provider.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/global.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool emailWhenWinBid = true;
  bool emailWhenCarAdded = true;
  bool notifyWhenCarAdded = true;
  bool notifyWhenWinBid = true;
  bool isLoading = false;

  @override
  void initState() {
    emailWhenWinBid = context.read<Auth>().user.notifyWonAuction;
    emailWhenCarAdded = context.read<Auth>().user.notifyNewAuction;
    notifyWhenCarAdded = context.read<Auth>().pushOnNewAuction;
    notifyWhenWinBid = context.read<Auth>().pushIfWonAuction;
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
          'Notifications'.tr(),
          style: const TextStyle(color: kBackAppIconColor, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 26),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Email Notifications'.tr(),
                            style: const TextStyle(color: kBackAppIconColor, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          CupertinoSwitch(
                            activeColor: kPrimaryColor,
                            thumbColor: Colors.white,
                            trackColor: Colors.black12,
                            value: emailWhenWinBid,
                            onChanged: (value) {
                              setState(() {
                                emailWhenWinBid = !emailWhenWinBid;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Email me when I win an auction'.tr(),
                              style: const TextStyle(color: kBackAppIconColor, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          CupertinoSwitch(
                            activeColor: kPrimaryColor,
                            thumbColor: Colors.white,
                            trackColor: Colors.black12,
                            value: emailWhenCarAdded,
                            onChanged: (value) {
                              setState(() {
                                emailWhenCarAdded = !emailWhenCarAdded;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Email me when a car is added to auction'.tr(),
                              style: const TextStyle(color: kBackAppIconColor, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Mobile Notifications'.tr(),
                            style: const TextStyle(color: kBackAppIconColor, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          CupertinoSwitch(
                            activeColor: kPrimaryColor,
                            thumbColor: Colors.white,
                            trackColor: Colors.black12,
                            value: notifyWhenWinBid,
                            onChanged: (value) {
                              setState(() {
                                notifyWhenWinBid = !notifyWhenWinBid;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Notify me when I win an auction'.tr(),
                              style: const TextStyle(color: kBackAppIconColor, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          CupertinoSwitch(
                            activeColor: kPrimaryColor,
                            thumbColor: Colors.white,
                            trackColor: Colors.black12,
                            value: notifyWhenCarAdded,
                            onChanged: (value) {
                              setState(() {
                                notifyWhenCarAdded = !notifyWhenCarAdded;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Notify me when a car is added to auction'.tr(),
                              style: const TextStyle(color: kBackAppIconColor, fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          isLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: CircularProgressIndicator(color: kPrimaryColor),
                                )
                              : MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  color: kPrimaryColor,
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    bool updateStatus = await Provider.of<Auth>(context, listen: false).updateNotificationSettings(
                                      emailNewAuction: emailWhenCarAdded,
                                      emailWinningAuction: emailWhenWinBid,
                                      notifyNewAuction: notifyWhenCarAdded,
                                      notifyWinningAuction: notifyWhenWinBid,
                                    );
                                    if (updateStatus != null) {
                                      if (updateStatus == true) {
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                          CherryToast.success(title: Text("Notification settings updated successfully".tr())).show(context);
                                        }
                                      } else if (updateStatus == false) {
                                        if (context.mounted) CherryToast.warning(title: Text("Couldn't update notification settings".tr())).show(context);
                                      }
                                    } else {
                                      if (context.mounted) CherryToast.error(title: Text("Error occurred changing notification settings".tr())).show(context);
                                    }
                                    if (context.mounted) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text(
                                      'Save Changes'.tr(),
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                                    ),
                                  ),
                                ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
