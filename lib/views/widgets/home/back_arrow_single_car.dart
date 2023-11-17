import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/global.dart';

class BackArrowCard extends StatelessWidget {
  BuildContext context;
  BackArrowCard({
    Key key,
    this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Card(
          elevation: 0,
          color: Colors.white.withOpacity(0.5),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
                isEnglish
                    ? Icons.arrow_back_ios_new_rounded
                    : Icons.keyboard_arrow_right_outlined,
                color: kBackAppIconColor),
          )),
    );
  }
}
