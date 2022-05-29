// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_new

import 'package:firebase_database/firebase_database.dart';

class UserModel {
  //string
  final name, phoneNumber;

  //list
  final cards;

  UserModel({this.name, this.phoneNumber, this.cards});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        cards: json['cards']);
  }

  Map<String, dynamic> toJson() {

    return {"name": name, "phoneNumber": phoneNumber, 'cards': cards};
  }
}
