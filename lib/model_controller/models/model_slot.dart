// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_new, non_constant_identifier_names

import 'package:firebase_database/firebase_database.dart';

class SlotModel {
  //string
  final A1, A2, gate;

  SlotModel({this.A1, this.A2, this.gate});

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(A1: json['A1'], A2: json['A2'], gate: json['gate']);
  }

  Map<String, dynamic> toJson() {
    return {'A1': A1, 'A2': A2, 'gate': gate};
  }
}
