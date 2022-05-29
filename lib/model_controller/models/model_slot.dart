// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_new

import 'package:firebase_database/firebase_database.dart';

class SlotModel {
  //string
  final sensor1, sensor2, slot1, slot2, gate;

  SlotModel(
      {this.sensor1,
      this.sensor2,
      this.slot1 = '',
      this.slot2 = '',
      this.gate});

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
        sensor1: json['sensor1'],
        sensor2: json['sensor2'],
        slot1: json['slot1'],
        slot2: json['slot2'],
        gate: json['gate']);
  }

  Map<String, dynamic> toJson() {
    return {
      "sensor1": sensor1,
      "sensor2": sensor2,
      'slot1': slot1,
      'slot2': slot2,
      'gate': gate
    };
  }
}
