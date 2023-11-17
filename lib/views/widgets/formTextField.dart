import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class FormTextField extends StatefulWidget {
  final Function onChanged;
  final String label;
  final Function validate;
  AutovalidateMode autovalidateMode;
  final bool expandable;
  final TextInputType;
  String initText;
  final int maxLength;
  final Function onTap;
  final Widget ico;
  final TextEditingController controller;
  bool readonly = false;
  bool isSearch = false;

  FormTextField({
    this.label,
    this.onChanged,
    this.validate,
    this.autovalidateMode,
    this.expandable = false,
    this.TextInputType,
    this.initText,
    this.maxLength,
    this.onTap,
    this.ico,
    this.controller,
    this.readonly,
    this.isSearch = false,
  });

  @override
  _FormTextFieldState createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // textDirection: TextDirection.rtl,
      // textAlign: TextAlign.right,
      readOnly: widget.readonly,
      onTap: widget.onTap,
      cursorColor: kPrimaryColor,
      keyboardType: widget.TextInputType,
      maxLength: widget.maxLength,
      expands: widget.expandable,
      maxLines: widget.expandable ? null : 1,
      controller: widget.controller,

      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 36),
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

        labelText: widget.label,
        labelStyle: const TextStyle(color: Colors.black),

        //alignLabelWithHint: true,
      ),

      onChanged: widget.onChanged,
      initialValue: widget.initText,
      validator: widget.validate,
      autovalidateMode: widget.autovalidateMode,
      style: const TextStyle(
        color: Colors.black,
      ),
    );
  }
}
