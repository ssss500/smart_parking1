// ignore_for_file: unnecessary_new, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:smart_parking/view/widgets/constance.dart';

import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final double width, height, borderRadius, sizeText;
  final String text;
  final Function function;
  final Color colorButton, colorText;
  final FontWeight fontWeight;

  CustomButton(
      {this.width = double.infinity,
      this.height = 50,
      this.borderRadius = 15,
      this.sizeText = 20,
      this.text = "",
      required this.function,
      this.colorButton = primaryColor,
      this.colorText = Colors.white,
      this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => function(),
        child: new Container(
            width: width,
            height: height,
            decoration: new BoxDecoration(
              color: colorButton,
              borderRadius: new BorderRadius.circular(borderRadius),
            ),
            child: new Center(
                child: CustomText(
              text: text,
              fontSize: sizeText,
              color: colorText,
              fontWeight: fontWeight,
            ))));
  }
}
