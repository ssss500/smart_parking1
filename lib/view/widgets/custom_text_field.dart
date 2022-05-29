// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, sized_box_for_whitespace, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:smart_parking/view/widgets/constance.dart';

class CustomTextField extends StatelessWidget {
  String? hint, title;
  Function(String)? onChanged;
  TextEditingController? controller;
  IconData? iconData;
  TextInputType? textInputType;
  Color? color;
  int? maxLength;
  var validator, autoFillHints;
  bool autofocus;
  Color? colorIcon;

  CustomTextField(
      {this.hint,
      this.title,
      this.validator,
      this.color = Colors.black26,
      this.colorIcon = primaryColor,
      this.onChanged,
      this.maxLength,
      this.controller,
      this.iconData,
      this.autoFillHints,
      this.autofocus = false,
      this.textInputType});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextFormField(
              style: TextStyle(fontSize: 20, color: Colors.black),
              keyboardType: textInputType,
              onChanged: onChanged,
              controller: controller,
              maxLength: maxLength,
              validator: validator,
              autofocus: autofocus,
              autofillHints: autoFillHints,
              decoration: InputDecoration(
                //                labelText:labelText ,
                suffixIcon: Icon(
                  iconData,
                  color: colorIcon,
                ),
                contentPadding: EdgeInsets.only(
                  left: 25,
                ),
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    )),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 0,
            child: UnconstrainedBox(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Text(
                  "$title",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
