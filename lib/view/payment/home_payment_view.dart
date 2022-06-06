// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers, prefer_const_constructors, avoid_print, unnecessary_string_interpolations

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_parking/model_controller/home_controller.dart';
import 'package:smart_parking/model_controller/places_in_garage_controller.dart';
import 'package:smart_parking/view/home_view.dart';
import 'package:smart_parking/view/payment/new_payment_view.dart';
import 'package:smart_parking/view/widgets/custom_text.dart';

import '../widgets/constance.dart';

class HomePaymentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(TextString.yourCards),
        backgroundColor: primaryColor,
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
                  color: primaryColor, borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 20,
                ),
                child: MaterialButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Get.to(() => NewPaymentView());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: TextString.addNewCard,
                        fontSize: 20,
                        color: Colors.white,
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
            ), //list cards
            StreamBuilder(
                stream: FirebaseDatabase.instance
                    .ref('users/${GetStorage().read("phoneNumber")}')
                    .child('card')
                    .onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  if (snapshot.hasError) {
                    return Container();
                  }
                  List values;
                  try {
                    DatabaseEvent dataValues =
                        snapshot.data! as DatabaseEvent; //here's the typo;
                    values = dataValues.snapshot.value as List;
                    print(values);
                  } catch (e) {
                    values = [];
                    print('catch : $e');
                  }
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: values.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MaterialButton(
                          onPressed: () => paymentFun(),
                          child: Container(
                            child: CreditCardWidget(
                              width: MediaQuery.of(context).size.width,
                              cardNumber: values[index]['cardNumber'],
                              expiryDate: values[index]['expiryDate'],
                              cardHolderName: values[index]['cardHolderName'],
                              cvvCode: values[index]['cvvCode'],
                              showBackView: false,
                              obscureCardNumber: true,
                              obscureCardCvv: true,
                              isHolderNameVisible: true,
                              onCreditCardWidgetChange: (creditCardBrand) {},
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  paymentFun() async {
    PlacesInGarageController places = Get.put(PlacesInGarageController());
    HomeController homeController = Get.put(HomeController());

    await FirebaseDatabase.instance.ref(homeController.serverTitleGarage).child(places.slotSelected).get().then((value) async {
      if(value.value!='full'){
        await FirebaseDatabase.instance
            .ref('${homeController.serverTitleGarage}')
            .update({
          places.slotSelected: 'full',
        });
        await FirebaseDatabase.instance
            .ref('users/${GetStorage().read('phoneNumber')}')
            .update({
          'isReservation': true,
          'startTimeOfBooking': DateTime.now().toString(),
          'slotReserved': places.slotSelected,
          'garageReserved':homeController.serverTitleGarage
        });
        Get.to(HomeView());

        Get.snackbar(
          'Successful',
          "Slot number ${places.slotSelected} has been booked successfully ،and it was discounted ${homeController.costPerHour} EGP",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade200,
        );
      }else{
        Get.back();
        Get.snackbar(
          'Sorry!!',
          "This place has been booked by someone else, you can choose another place",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade200,
        );
      }
    
    });


  }
}
