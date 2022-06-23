// ignore_for_file: avoid_print, unrelated_type_equality_checks, await_only_futures

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../main.dart';
import '../../switch_login.dart';

class LoginController extends GetxController {
  late String  password = '';
  TextEditingController phoneNumber =TextEditingController(text: '+2');
  bool showPassword=false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  loginFun() async {
    if (formState.currentState!.validate()) {
      //Verify the password
      DatabaseReference starCountRef =
          await FirebaseDatabase.instance.ref('users/${phoneNumber.text}/password');
      starCountRef.get().then((value) {
        if (password ==  value.value) {
          GetStorage().write('phoneNumber', phoneNumber.text);
          Get.offAll(SwitchLogin());

        } else {
          print(password);
          print(value.value);
          //show error
          Get.snackbar(
            'Error !',
            "Your password is incorrect",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade200,
          );
        }
      }).catchError((onError) {
        //show error
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
