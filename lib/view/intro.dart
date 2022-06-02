// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_parking/view/login_signup/sign_up.dart';
import 'package:smart_parking/view/widgets/constance.dart';
import 'package:smart_parking/view/widgets/custom_buttom.dart';
import 'package:smart_parking/view/widgets/custom_text.dart';

import 'login_signup/login.dart';

class Intro extends StatelessWidget {
// the first page intro to app to sign up or login in
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                CustomText(
                  text: 'Start by creating an account',
                  fontSize: 40,
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomText(
                  text: 'I`m an early bird and I`m a night owl so I`m wise and I have worms',
                  fontSize: 20,
                  color: Colors.grey,
                ),

                const SizedBox(
                  height: 200,
                ),
//              createAccount(),
                CustomButton(
                  function: () {
                    Get.to(() =>SignUpView());
                  },
                  text: TextString.createAccountString,
                  borderRadius: 15,
                  height: 60,
                  width: double.infinity - 30,
                ),
                const SizedBox(
                  height: 15,
                ),

                CustomButton(
                  function: () {

                    Get.to(() =>LoginView());
                  },
                  text: TextString.signInString,
                  borderRadius: 15,
                  height: 60,
                  colorText: Colors.black,
                  colorButton: secondColor,
                  width: double.infinity - 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }


}
