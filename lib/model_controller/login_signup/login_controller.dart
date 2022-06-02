// ignore_for_file: avoid_print, unrelated_type_equality_checks

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../main.dart';
import '../../switch_login.dart';

class LoginController extends GetxController {
  late String phoneNumber = '', password = '';

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  loginFun() async {
    if (formState.currentState!.validate()) {
      DatabaseReference starCountRef =
          FirebaseDatabase.instance.ref('users/$phoneNumber/password');
      starCountRef.get().then((value) {
//        print(password);
//        print(value.value);
        if(password=="123456"){
        GetStorage().write('phoneNumber', phoneNumber);

        Get.offAll(SwitchLogin());
        }else{
          print(password);
          print(value.value);
          Get.snackbar(
            'Error !',
            "Your password is incorrect",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade200,
          );
        }

      }).catchError((onError){
        Get.snackbar(
          'Error !',
          "Your phone number is incorrect",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade200,
        );
      });

    }
  }
}
