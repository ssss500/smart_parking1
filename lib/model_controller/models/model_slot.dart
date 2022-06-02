// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_new, non_constant_identifier_names

import 'package:firebase_database/firebase_database.dart';

class SlotModel {
  //string
  final sensor1, sensor2, A1, A2, gate;

  SlotModel(
      {this.sensor1,
      this.sensor2,
      this.A1 = '',
      this.A2 = '',
      this.gate});

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
        sensor1: json['sensor1'],
        sensor2: json['sensor2'],
        A1: json['A1'],
        A2: json['A2'],
        gate: json['gate']);
  }

  Map<String, dynamic> toJson() {
    return {
      "sensor1": sensor1,
      "sensor2": sensor2,
      'A1': A1,
      'A2': A2,
      'gate': gate
    };
  }
}
