import 'package:carsxchange/constants/colors.dart';
import 'package:carsxchange/views/widgets/svg_asset.dart';
import 'package:flutter/material.dart';

Widget loaderWidget(BuildContext context) {
  return Center(
    child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            svgAsset('assets/svg/cxc_logo.svg'),
            const SizedBox(height: 20),
            const LinearProgressIndicator(
              backgroundColor: kGreyBorderColor,
            ),
          ],
        )),
  );
}
