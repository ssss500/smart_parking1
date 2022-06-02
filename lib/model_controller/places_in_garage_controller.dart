// ignore_for_file: await_only_futures, prefer_typing_uninitialized_variables, avoid_print, non_constant_identifier_names

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/model_controller/home_controller.dart';
import 'package:smart_parking/model_controller/models/model_slot.dart';

class PlacesInGarageController extends GetxController {
  var slotSelected = '';
  late SlotModel slotModel;

  late String A1, A2, gate;
  late int sensor1, sensor2;

  selectSlotFun(idSlot) {
    if (idSlot == 'A1'
        ? A1 == 'empty'
        : A2 == 'empty' && idSlot == 'A1'
            ? sensor1 == 0
            : sensor2 == 0) {
      slotSelected = idSlot;
      update();
      print(slotSelected);
    }else{
      Get.snackbar(
        'Notes !',
        "You are not able to choose this place",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade200,
      );
    }

  }

  @override
  onInit() async {
    listenFirebaseUser();
    super.onInit();
  }

  listenFirebaseUser() async {
    print('listenFirebaseUser');
    HomeController homeController = Get.put(HomeController());
    DatabaseReference starCountRef =
        await FirebaseDatabase.instance.ref(homeController.serverTitleGarage);
    await starCountRef.onValue.listen((DatabaseEvent event) {
      slotModel = SlotModel.fromJson(
          Map<String, dynamic>.from(event.snapshot.value as dynamic));
      A1 = slotModel.toJson()['A1'];
      A2 = slotModel.toJson()['A2'];
      sensor1 = slotModel.toJson()['sensor1'];
      sensor2 = slotModel.toJson()['sensor2'];
      gate = slotModel.toJson()['gate'];
      update();
    });
  }
}
