import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../svg_asset.dart';

class AccountCards extends StatelessWidget {
  String assetName;
  String title;

  AccountCards({
    Key key,
    this.title,
    this.assetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            svgAsset(assetName),
            const SizedBox(
              width: 8,
            ),
            Text(
              title,
              style: const TextStyle(color: kDescriptionColor, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
