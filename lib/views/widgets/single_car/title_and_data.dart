import 'package:change_case/change_case.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class TitleAndData extends StatelessWidget {
  String title;
  String data;

  TitleAndData({Key key, @required this.title, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    data != null ? data = data.toCapitalCase() : null;
    return data == null || data == "Null"
        ? const SizedBox(height: 0)
        : Column(
            children: [
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(color: kInactiveTextColor, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Flexible(
                        child: Text(data,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: data == 'Bad' || data == "False" || data == "Accident Reported" || data == "Damaged" || data == "To Be Repaired" || data == "Accident Reported"
                                    ? kExpiredCardColor
                                    : data == 'Excellent' || data == 'Good' || data == 'True' || data == 'Available' || data == 'No Accident' || data == 'None'
                                        ? kActiveCardColor
                                        : Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w800))),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(color: kInactiveTextColor),
              ),
            ],
          );
  }
}
