// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

//import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_parking/main.dart';
import 'package:smart_parking/switch_login.dart';
import 'package:smart_parking/view/personal_page.dart';
import 'package:smart_parking/view/places_in_garage_view.dart';
import 'package:smart_parking/view/widgets/constance.dart';
import 'package:smart_parking/view/widgets/custom_buttom.dart';
import 'package:smart_parking/view/widgets/custom_text.dart';

import '../model_controller/home_controller.dart';
const double fabDimension = 56.0;

class HomeView extends StatelessWidget {
  HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 60,
              width: 40,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: OpenContainer(
                  transitionType: homeController.transitionType,
                  openBuilder: (context, VoidCallback _) {

                    return PersonalPage();
                  },
                  closedElevation: 0.0,
                  closedShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(fabDimension / 2),
                    ),
                  ),
                  closedColor: Color(0x90000000),
                  closedBuilder: (BuildContext context, VoidCallback openContainer) {
                    return Center(
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: CircleAvatar(
//              backgroundColor: Color(0x90000000),
//              radius: 28,
//              child: IconButton(
//                icon: Icon(Icons.person),
//                onPressed: () {
//
////                  FirebaseAuth auth = FirebaseAuth.instance;
////                  auth.signOut();
////                  GetStorage().remove('phoneNumber');
////                  Get.offAll(SwitchLogin());
//                },
//                iconSize: 26,
//                color: primaryColor,
//              ),
//            ),
//          )
        ],
      ),
      body: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (c) => c.initialCameraPosition == null
            ? const Center(
                child: CircularProgressIndicator(
                color: primaryColor,
              ))
            : Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  GoogleMap(
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
//                    onCameraMoveStarted:(){
//                      print('on Camera Move Started');
//                    } ,
                    initialCameraPosition: c.initialCameraPosition!,
                    onMapCreated: (GoogleMapController controllerMap) {
                      c.googleMapController = controllerMap;
                    },
                    polylines: {
                      if (c.info != null)
                        Polyline(
                          polylineId: const PolylineId('overview_polyline'),
                          color: Colors.blueGrey,
                          width: 3,
                          points: c.info!.polylinePoints
                              .map((e) => LatLng(e.latitude, e.longitude))
                              .toList(),
                        ),
                    },
                    mapType: MapType.terrain,
                    markers: c.markers,
                  ),
                  Positioned(
                    child: c.info == null
                        ? Container()
                        : Container(
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: bottomSheet(),
                          ),
                  )
                ],
              ),
      ),
    );
  }
}

Widget bottomSheet() {
  return GetBuilder<HomeController>(
    init: HomeController(),
    builder: (c) => Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(c.image!),
                    )),
              ),
              Container(
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomText(
                          text: c.titleParking!,
                          color: Colors.black,
                          fontSize: 23,
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CustomText(
                            text:
                                '${c.info?.totalDistance}, ${c.info?.totalDuration}',
                            color: primaryColor,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CustomText(
                            text: '${c.costPerHour}\$ / h ',
                            color: primaryColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          CustomButton(
            function: () {
              Get.to(() => PlacesInGarageView());
            },
            text: 'Book Now',
          )
        ],
      ),
    ),
  );
}
