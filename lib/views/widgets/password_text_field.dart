import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class PasswordTextField extends StatefulWidget {
  final Function onChanged;
  final Function validatorFun;
  String title;
  final TextEditingController controller;

  PasswordTextField({
    this.onChanged,
    this.validatorFun,
    this.title,
    this.controller,
  });

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kExpiredCardColor, width: 2.0),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),

        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kBorderColor, width: 1.0),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: kBorderColor, width: 1.0),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        labelStyle: const TextStyle(color: Colors.black),
        contentPadding: const EdgeInsets.only(top: 0, bottom: 0, right: 5),

        prefixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  width: 6,
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ],
        ),
        suffixIcon: IconButton(
          icon: _obscure
              ? const Icon(
                  Icons.visibility_off,
                  color: kBorderColor,
                )
              : const Icon(
                  Icons.visibility,
                  color: kBorderColor,
                ),
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        ),

        labelText: widget.title ?? 'Password'.tr(),
        // labelStyle: const TextStyle(color: kPrimaryColor),
      ),
      onChanged: widget.onChanged,
      validator: widget.validatorFun,
      style: const TextStyle(
        color: Colors.black,
      ),
    );
  }
}
