// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_parking/model_controller/home_controller.dart';
import 'package:smart_parking/model_controller/models/user_model.dart';
import 'package:smart_parking/view/widgets/constance.dart';
import 'package:smart_parking/view/widgets/custom_text.dart';

import '../switch_login.dart';
import 'widgets/custom_buttom.dart';

class PersonalPage extends StatelessWidget {
  HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                  width: 100,
                  height: 100,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, color: primaryColor,
//                            border: Border.all(color: K.mainColor)
                  ),
                  child: Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.white,
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            CustomText(
              text: homeController.userMode.toJson()['name'],
              color: Colors.black,
              fontSize: 30,
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  width: 300,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: CustomText(
                    text:
                        "Phone Number  : ${homeController.userMode.toJson()['phoneNumber'].toString()}",
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 250,
                  child: CustomButton(
                    function: () {
                      GetStorage().remove('phoneNumber');
                      Get.offAll(SwitchLogin());
                    },
                    text: 'Login out',
                    sizeText: 25,
                    colorText: Colors.white,
                    colorButton: Colors.red,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
