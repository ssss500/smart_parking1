// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_new

import 'package:firebase_database/firebase_database.dart';

class UserModel {
  //string
  final name, phoneNumber, startTimeOfBooking,slotReserved,garageReserved;
  bool inGarage, isReservation;

  //list
  List card = [];

  UserModel({
    this.name,
    this.slotReserved,
    this.phoneNumber,
    this.startTimeOfBooking,
    this.garageReserved,
    required this.card,
    required this.inGarage,
    required this.isReservation,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      inGarage: json['inGarage'],
      garageReserved: json['garageReserved'],
      slotReserved: json['slotReserved'],
      phoneNumber: json['phoneNumber'],
      isReservation: json['isReservation'],
      startTimeOfBooking: json['startTimeOfBooking'],
      card: json['card'] ??= [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "slotReserved": slotReserved,
      "garageReserved": garageReserved,
      "startTimeOfBooking": startTimeOfBooking,
      "phoneNumber": phoneNumber,
      "isReservation": isReservation,
      'card': card,
      'inGarage': inGarage
    };
  }
}
