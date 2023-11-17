import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import 'svg_asset.dart';

class PrimaryButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color color;
  final Color borderColor;
  final String iconPath;
  double fontSize = 18.0;

  PrimaryButton({Key key, this.text, this.onPressed, this.fontSize, this.color, this.iconPath, this.borderColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: MaterialButton(
        color: color ?? kPrimaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: borderColor == null
              ? const BorderSide(
                  color: Colors.transparent,
                )
              : const BorderSide(
                  color: kPrimaryColor,
                ),
        ),
        onPressed: onPressed,
        child: iconPath != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      text.toUpperCase(),
                      style: TextStyle(
                        fontSize: fontSize,
                        color: borderColor ?? Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 8),
                  svgAsset(iconPath),
                ],
              )
            : Text(
                text.toUpperCase(),
                style: TextStyle(
                  fontSize: fontSize,
                  color: borderColor ?? Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
