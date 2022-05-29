// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:smart_parking/view/widgets/constance.dart';

class CustomMarkers extends StatelessWidget {
  late String image;

   bool myLocation;

  CustomMarkers(this.image, {this.myLocation = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          Icons.location_on,
          color: Colors.black,
          size: 60,
        ),
        Positioned(
          left: 15,
          top: 8,
          child: Container(
            width: 30,
            height: 30,
          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30)),
            child:myLocation? Icon(Icons.person,color: primaryColor,size: 30,):
            CircleAvatar(
              backgroundImage: AssetImage('assets/image/parking.png'),
            ),
          ),
        )
      ],
    );
  }
}
