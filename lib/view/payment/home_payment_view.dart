// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:smart_parking/view/payment/new_payment_view.dart';
import 'package:smart_parking/view/widgets/custom_text.dart';

import '../widgets/constance.dart';

class HomePaymentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(TextString.addNewCard),
        backgroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 15.0, left: 15, top: 15),
        child: Column(
          children: [
            //add new car button
            Container(
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 20,
                ),
                child: MaterialButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Get.to(() =>NewPaymentView());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: TextString.addNewCard,
                        fontSize: 20,
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: CreditCardWidget(
                      cardNumber: "1234522223313167899",
                      expiryDate: "expiryDate",
                      cardHolderName: "cardHolderName",
                      cvvCode: "cvvCode",
                      showBackView: false,
                      obscureCardNumber: true,
                      obscureCardCvv: true,
                      onCreditCardWidgetChange: (creditCardBrand) {},
                    ),
                  );
                },
              ),
            ), //list of old cards
          ],
        ),
      ),
    );
  }
}
