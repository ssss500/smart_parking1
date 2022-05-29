// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;

  final double fontSize;

  final Color color;

  final Alignment alignment;
  var textDirection;

//  final int maxLine;
  final double height;
  final FontWeight fontWeight;
  CustomText({
    this.text = '',
    this.fontSize = 16,
    this.color = Colors.black,
    this.alignment = Alignment.center,
    this.textDirection = TextDirection.ltr, //    this.maxLine=0,
    this.height = 1,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        text,
        textAlign: TextAlign.center,
        textDirection: textDirection,
        style: TextStyle(
          fontWeight: fontWeight,
          color: color,
          height: height,
          fontSize: fontSize,
        ),
//        maxLines: maxLine,
      ),
    );
  }
}
