// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_new

import 'package:firebase_database/firebase_database.dart';

class UserModel {
  //string
  final name, phoneNumber;
  bool inGarage, isReservation;

  //list
  List card=[];

  UserModel({
    this.name,
    this.phoneNumber,
    required this.card,
    required this.inGarage,
    required this.isReservation,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        inGarage: json['inGarage'],
        phoneNumber: json['phoneNumber'],
        isReservation: json['isReservation'],
        card: json['card']??=[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phoneNumber": phoneNumber,
      "isReservation": isReservation,
      'card': card,
      'inGarage': inGarage
    };
  }
}
