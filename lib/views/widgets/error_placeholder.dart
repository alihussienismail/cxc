import 'package:carsxchange/views/widgets/svg_asset.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget errorWidget(BuildContext context) {
  return Center(
    child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            svgAsset('assets/svg/error_handle.svg'),
            const SizedBox(height: 20),
            Text("Ops, Something went wrong".tr()),
          ],
        )),
  );
}
