// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, non_constant_identifier_names, curly_braces_in_flow_control_structures
import 'dart:math' as math;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/model_controller/home_controller.dart';
import 'package:smart_parking/model_controller/models/model_slot.dart';
import 'package:smart_parking/model_controller/places_in_garage_controller.dart';
import 'package:smart_parking/view/widgets/constance.dart';
import 'package:smart_parking/view/widgets/custom_buttom.dart';
import 'package:smart_parking/view/widgets/custom_text.dart';

import 'payment/home_payment_view.dart';
import 'payment/new_payment_view.dart';

class PlacesInGarageView extends StatefulWidget {
  @override
  State<PlacesInGarageView> createState() => _PlacesInGarageViewState();
}

class _PlacesInGarageViewState extends State<PlacesInGarageView> {
  HomeController homeController=Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(homeController.titleParking!),
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  ListCarParking(true, 'A1'),
                  Expanded(
                      flex: 7,
                      child: SizedBox(
                        height: MediaQuery.of(Get.context!).size.height - 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RotatedBox(
                              quarterTurns: -1,
                              child: CustomText(
                                text: 'The Passage',
                                fontSize: 30,
                                color: Colors.black45,
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            RotatedBox(
                              quarterTurns: 1,
                              child: Opacity(
                                opacity: 0.5,
                                child: Image(
                                  image: AssetImage('assets/image/car.png'),
                                  height: 70,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Icon(
                              Icons.arrow_upward,
                              color: Colors.black45,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomText(
                              text: 'ENTRY',
                              color: Colors.black45,
                            )
                          ],
                        ),
                      )),
                  ListCarParking(false, 'A2'),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: CustomButton(
                  function: () {
                    PlacesInGarageController controller =
                        Get.put(PlacesInGarageController());

                    if (controller.slotSelected != '') {
                      Get.to(() => HomePaymentView());
                    } else {
                      Get.snackbar(
                        'Notes !',
                        "You should select any slot before booking",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.shade200,
                      );
                    }
                  },
                  text: 'book now',
                ),
              ),
            ],
          ),
        ));
  }
}

Widget ListCarParking(left, idSlot) {
  return Expanded(
    flex: 10,
    child: Container(
      padding: EdgeInsets.only(left: 6, right: 6),
      height: MediaQuery.of(Get.context!).size.height -
          200, //      width: double.infinity ,
      child: ListView.builder(
        shrinkWrap: true,
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          return CarImage(index: index, left: left, idSlot: idSlot);
        },
      ),
    ),
  );
}

Widget CarImage({index, left, idSlot}) {
  return GetBuilder<PlacesInGarageController>(
    init: PlacesInGarageController(),
    builder: (placesInGarageController) => MaterialButton(
      onPressed: () => placesInGarageController.selectSlotFun(idSlot),
      padding: EdgeInsets.all(0),
      child: Container(
        width: double.infinity,
        decoration: left
            ? BoxDecoration(
                border: Border(
                top: BorderSide(width: 1.0, color: primaryColor),
                bottom: BorderSide(width: 1.0, color: primaryColor),
                left: BorderSide(width: 1.0, color:primaryColor),
              ))
            : BoxDecoration(
                border: Border(
                top: BorderSide(width: 1.0, color: primaryColor),
                bottom: BorderSide(width: 1.0, color:primaryColor),
                right: BorderSide(width: 1.0, color: primaryColor),
              )),
        child: index > 0
            ? SizedBox(
                height: 70,
                child: Icon(
                  Icons.block,
                  color: Colors.red,
                ),
              )
            : (idSlot == 'A1'
                    ? placesInGarageController.A1 == 'empty'
                    : placesInGarageController.A2 == 'empty')
                ? Container(
                    height: 70,
                    color: placesInGarageController.slotSelected == ''
                        ? Colors.transparent
                        : placesInGarageController.slotSelected == idSlot
                            ? primaryColor
                            : Colors.transparent,
                    child: CustomText(
                      text: idSlot,
                    ),
                  )
                : (idSlot == 'A1'
                            ? placesInGarageController.A1 == 'full'
                            : placesInGarageController.A2 == 'full') &&
                        (idSlot == 'A1'
                            ? placesInGarageController.sensor1 == 1
                            : placesInGarageController.sensor2 == 1)
                    ? left
                        ? leftImage()
                        : imageCar()
                    : (idSlot == 'A1'
                                ? placesInGarageController.A1 == 'full'
                                : placesInGarageController.A2 == 'full') &&
                            (idSlot == 'A1'
                                ? placesInGarageController.sensor1 == 0
                                : placesInGarageController.sensor2 == 0)
                        ? Opacity(
                            opacity: 0.5,
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                left ? leftImage() : imageCar(),
                                Positioned(
                                    child: Icon(
                                  Icons.watch_later_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ))
                              ],
                            ),
//                            child: left ? leftImage() : imageCar(),
                          )
                        : Container(),
      ),
    ),
  );
}

Widget leftImage() {
  return Transform(
    alignment: Alignment.center,
    transform: Matrix4.rotationY(math.pi),
    child: Image(
      image: AssetImage('assets/image/car.png'),
      height: 70,
    ),
  );
}

Widget imageCar() {
  return Image(
    image: AssetImage('assets/image/car.png'),
    height: 70,
  );
}

Widget waitingImageCar() {
  return Image(
    image: AssetImage('assets/image/car.png'),
    height: 70,
  );
}
