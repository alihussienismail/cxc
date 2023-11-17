import 'package:carsxchange/constants/colors.dart';
import 'package:carsxchange/views/widgets/svg_asset.dart';
import 'package:flutter/material.dart';

class SlidableDetailWidget extends StatelessWidget {
  String iconAssetName;
  String title;
  String subTitle;

  SlidableDetailWidget({Key key, this.iconAssetName, this.title, this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return title == null || subTitle == null
        ? const SizedBox(
            height: 0,
          )
        : Container(
            width: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, border: Border.all(color: kInactiveTextColor, width: 1)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: svgAsset(iconAssetName),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                        ),
                        Text(
                          subTitle,
                          style: const TextStyle(color: kInactiveTextColor, fontWeight: FontWeight.w400, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
