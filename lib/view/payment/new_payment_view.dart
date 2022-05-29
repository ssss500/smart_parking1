// ignore_for_file: unnecessary_const, non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:get/get.dart';
import 'package:smart_parking/model_controller/new_payment_controller.dart';
import 'package:smart_parking/view/home_view.dart';
import 'package:smart_parking/view/widgets/constance.dart';
import 'package:smart_parking/view/widgets/custom_buttom.dart';

class NewPaymentView extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 0,
        backgroundColor:primaryColor,
        title: const Text('Add Payment Info'),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GetBuilder<NewPaymentController>(
          init: NewPaymentController(),
          builder: (paymentController) => Column(
            children: [
              CreditCardWidget(
                cardNumber: paymentController.cardNumber,
                expiryDate: paymentController.expiryDate,
                cardHolderName: paymentController.cardHolderName,
                cvvCode: paymentController.cvvCode,
                showBackView: paymentController.isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                onCreditCardWidgetChange: (creditCardBrand) {},
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    CreditCardForm(
                      cardNumber: paymentController.cardNumber,
                      expiryDate: paymentController.expiryDate,
                      cardHolderName: paymentController.cardHolderName,
                      cvvCode: paymentController.cvvCode,
                      onCreditCardModelChange:
                          paymentController.onCreditCardModelChange,
                      themeColor: Colors.black,
                      formKey: formKey,
                      cardNumberDecoration: CustomInputDecoration(
                          labelText: "Number", hintText: 'xxxx xxxx xxxx xxxx'),
                      expiryDateDecoration: CustomInputDecoration(
                          labelText: 'Expired Date', hintText: 'xx/xx'),
                      cvvCodeDecoration: CustomInputDecoration(
                          labelText: 'CVV', hintText: 'xxx'),
                      cardHolderDecoration: CustomInputDecoration(
                          labelText: 'Card Holder', hintText: 'xxx'),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 15.0, right: 15),
                      child: CustomButton(
                          text: 'Save Card Details',
                          function: () {
                       paymentController.saveCardFun();
                          }),
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  CustomInputDecoration({labelText, hintText}) {
    return InputDecoration(
      labelText: labelText,
      contentPadding: EdgeInsets.only(
        left: 25,
      ),
      hintText: hintText,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        borderSide: BorderSide(color: Colors.black, width: 1),
      ),
    );
  }
}
