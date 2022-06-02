// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_parking/view/home_view.dart';

class NewPaymentController extends GetxController {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  void onCreditCardModelChange(CreditCardModel creditCardModel) {
//    setState(() {
    cardNumber = creditCardModel.cardNumber;
    expiryDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;
    update();
//    });
  }

  Future<void> saveCardFun() async {
    if (cardNumber.length == 19 &&
        expiryDate.length == 5 &&
        cvvCode.length > 2 &&
        cardHolderName.length > 4) {
      await FirebaseDatabase.instance
          .ref('users/${GetStorage().read("phoneNumber")}')
          .child('card')
          .get()
          .then((value) async {
        var list = [];
        var listCards = [];
        try {
          list = value.value as List;
        } catch (e) {
          list = [];
        }
        final data = {
          'cardNumber': cardNumber,
          'expiryDate': expiryDate,
          'cardHolderName': cardHolderName,
          'cvvCode': cvvCode,
        };
        print("data " + data.toString());
        print("list " + list.toString());
        if (list.isNotEmpty) {
          listCards.addAll(list);
        }
        listCards.addAll([data]);
        print("listCard " + listCards.toString());

        await FirebaseDatabase.instance
            .ref('users/${GetStorage().read("phoneNumber")}')
            .child('card')
            .set(listCards)
            .then((value) {
          Get.back();
        });
      });
    }
  }
}
