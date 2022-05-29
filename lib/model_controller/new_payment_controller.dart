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
        cvvCode.length == 3 &&
        cardHolderName.length > 4) {
      await FirebaseDatabase.instance
          .ref('users/${GetStorage().read("phoneNumber")}')
          .child('card')
          .get()
          .then((value) {
        List listCard;
        try {
          listCard = value.value as List;
        } catch (e) {
          listCard = [];
        }
        final data = {
          'cardNumber': cardNumber,
          'expiryDate': expiryDate,
          'cardHolderName': cardHolderName,
          'cvvCode': cvvCode,
        };
        listCard.addAll({data});
        print(listCard);
      });
    }
//    Get.to(() => HomeView());
  }
}
