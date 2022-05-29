// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/model_controller/home_controller.dart';
import 'package:smart_parking/model_controller/models/user_model.dart';
import 'package:smart_parking/view/widgets/custom_text.dart';

class PersonalPage extends StatelessWidget {
  HomeController homeController=Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    print(homeController.name);
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: 100,
              height: 100,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
//                            border: Border.all(color: K.mainColor)
              ),
              child: Icon(Icons.person,size: 50,)
            ),
          ),
          CustomText(
           text: homeController.name,
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  CustomText(
                    text: "رقم الهاتف",
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    text: homeController.phoneNumber,
                    color: Colors.black,
                  ),
                ],
              ),

            ],
          ),

        ],
      ),
    );
  }
}
