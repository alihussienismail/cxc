import 'dart:ui';

import 'package:carsxchange/constants/colors.dart';
import 'package:carsxchange/constants/global.dart';
import 'package:carsxchange/views/screens/home/home_screen.dart';
import 'package:carsxchange/views/widgets/formTextField.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

String getCarImageUrl(String name) {
  return "$BASE_URL/storage/car_images/$name";
}

Future<bool> showConfirmBiddingDialog(
    {@required BuildContext context,
    String type = "bid",
    @required int bidAmount}) async {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (ctx, anim1, anim2) => AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      title: Text(
        type == "bid" ? 'Add Bid'.tr() : "Add Offer".tr(),
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kBackAppIconColor),
      ),
      content: Text(
        '${'Are you sure want to'.tr()} ${type == "bid" ? 'bid with'.tr() : "offer".tr()} $bidAmount${' AED?'.tr()}',
        style: const TextStyle(fontSize: 14),
      ),
      elevation: 2,
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: kPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Text(
                'Confirm'.tr(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              child: Text(
                'Cancel'.tr(),
                style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ),
      ],
    ),
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
      child: FadeTransition(
        opacity: anim1,
        child: child,
      ),
    ),
    context: context,
  );
}

Future<int> showEnterOfferAmountDialog(
    {@required BuildContext context, @required int highestPrice}) async {
  int offerAmount = highestPrice;
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (ctx, anim1, anim2) => AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      title: Text(
        "Enter your offer price".tr(),
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kBackAppIconColor),
      ),
      content: SizedBox(
        height: 65,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: FormTextField(
            readonly: false,
            initText: highestPrice.toString(),
            label: 'Offer Amount'.tr(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            TextInputType: TextInputType.number,
            onChanged: (val) {
              if (val != null && val != "") {
                offerAmount = int.parse(val);
              } else {
                offerAmount = 0;
              }
            },
          ),
        ),
      ),
      elevation: 2,
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: kPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Text(
                'Confirm'.tr(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            onPressed: () {
              if (offerAmount == null || offerAmount == 0) {
                if (context.mounted)
                  CherryToast.warning(title: Text("Invalid offer amount".tr()))
                      .show(context);
              } else {
                Navigator.pop(context, offerAmount);
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              child: Text(
                'Cancel'.tr(),
                style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            onPressed: () {
              Navigator.pop(context, null);
            },
          ),
        ),
      ],
    ),
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
      child: FadeTransition(
        opacity: anim1,
        child: child,
      ),
    ),
    context: context,
  );
}

Future<bool> showConfirmLogOutDialog(BuildContext context) async {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (ctx, anim1, anim2) => AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      title: Text(
        "Logout".tr(),
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kBackAppIconColor),
      ),
      content: Text(
        'Are you sure your want to logout?'.tr(),
        style: const TextStyle(fontSize: 14),
      ),
      elevation: 2,
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: kPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Text(
                'Confirm'.tr(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              child: Text(
                'Cancel'.tr(),
                style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ),
      ],
    ),
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
      child: FadeTransition(
        opacity: anim1,
        child: child,
      ),
    ),
    context: context,
  );
}

Future<bool> showConfirmAccountDeletionDialog(BuildContext context) async {
  return showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black38,
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (ctx, anim1, anim2) => AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      title: Text(
        "Delete Account".tr(),
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kBackAppIconColor),
      ),
      content: Text(
        'Are you sure your want to close your account and erase your data?'
            .tr(),
        style: const TextStyle(fontSize: 14),
      ),
      elevation: 2,
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: kPrimaryColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Text(
                'Confirm'.tr(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, right: 20),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              child: Text(
                'Cancel'.tr(),
                style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ),
      ],
    ),
    transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
      filter:
          ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
      child: FadeTransition(
        opacity: anim1,
        child: child,
      ),
    ),
    context: context,
  );
}

void selectNavigatorPage(BuildContext context, int index) {
  HomeScreenState stateObject =
      context.findAncestorStateOfType<HomeScreenState>();
  stateObject.setState(() {
    selectedNavigationIndex = index;
  });
}
