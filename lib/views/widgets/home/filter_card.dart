import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class FilterCard extends StatelessWidget {
  String title;
  bool isSelected;

  FilterCard({
    Key key,
    this.title,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: isSelected ? kPrimaryColor : kBackgroundHomeColor, borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: isSelected ? Colors.white : kInactiveTextColor, fontSize: 12, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
