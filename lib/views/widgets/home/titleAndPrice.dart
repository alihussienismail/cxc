import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class TitleAndPrice extends StatelessWidget {
  String title;
  String price;
  Color color;

  TitleAndPrice({
    Key key,
    @required this.title,
    @required this.price,
    this.color = kInactiveTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: kInactiveTextColor, fontSize: 14, fontWeight: FontWeight.w400),
              ),
              Text(price, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: Divider(color: kInactiveTextColor),
        ),
      ],
    );
  }
}
