// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, avoid_print, null_check_always_fails, avoid_init_to_null, avoid_function_literals_in_foreach_calls, prefer_collection_literals, void_checks, await_only_futures

import 'dart:async';
import 'dart:math';

//import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:animations/animations.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

//import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:smart_parking/model_controller/models/user_model.dart';
import 'package:smart_parking/model_controller/places_in_garage_controller.dart';
import 'package:smart_parking/view/widgets/custom_text.dart';
import 'package:smart_parking/view/widgets/custom_text_field.dart';

import 'directions_model.dart';
import '../view/widgets/custom_markers_map.dart';
import 'directions_repository.dart';

class HomeController extends GetxController {
  final ContainerTransitionType transitionType = ContainerTransitionType.fade;

  late GoogleMapController googleMapController;
  late UserModel userMode;
  String serverTitleGarage = '';

  // my location var
  double? myLatitude = null, myLongitude = null;

  String? titleParking, image;
  late int resultBetweenTowDates;
  late int costPerHour;

  //all marker
  Set<Marker> markers = Set(); //markers for google map

  CameraPosition? initialCameraPosition;

  //to make a path between two points
  Directions? info;
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  @override
  void onClose() {
    googleMapController.dispose();
    super.onClose();
  }

  @override
  onInit() async {
    await listenFirebaseUser();
    Timer.periodic(Duration(minutes: 1), (timer) {
      if (userMode.toJson()['isReservation']) {
        calculateBetweenTowDates();
      }
      print(DateTime.now());
    });

//   await addMyLocationInMarkers();

    super.onInit();
  }

  listenFirebaseUser() async {
    //to get data user as stream

    DatabaseReference starCountRef = await FirebaseDatabase.instance
        .ref('users/${GetStorage().read('phoneNumber')}/');
    await starCountRef.onValue.listen((DatabaseEvent event) async {
      print('event ${event.snapshot.value}');

      userMode = UserModel.fromJson(
          Map<String, dynamic>.from(event.snapshot.value as dynamic));
//get my location
      await determinePosition().then((value) {
        myLatitude = value.latitude;
        myLongitude = value.longitude;

        initialCameraPosition = CameraPosition(
            target: LatLng(myLatitude!, myLongitude!), zoom: 13.9);

        update();
      });
      if (userMode.toJson()['isReservation']) {
        calculateBetweenTowDates();
      }

      if (userMode.toJson()['startTimeOfBooking'] != '') {
        final dateNow = DateTime.now();
        final difference = dateNow
            .difference(DateTime.parse(
                userMode.toJson()['startTimeOfBooking'] as String))
            .inHours;
        await FirebaseDatabase.instance
            .ref('${userMode.toJson()['garageReserved']}')
            .child(userMode.toJson()['slotReserved'])
            .get()
            .then((value) async {
          if (value.value == 'wait' && difference == 1) {
            await cancelOfReservation(wait: 'wait');
          }
        });
      }
      //to get markers
      DatabaseReference markersFromFirebase =
          await FirebaseDatabase.instance.ref('markers');
      await markersFromFirebase.get().then((value) async {
        List listMarkers = value.value as List;

        await createMarkers(listMarkers: listMarkers);
        await getLastLocation(listMarkers: listMarkers);
        update();
      });
      update();
    });
  }

//get permission gps
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  // create Marker
  createMarkers({listMarkers}) {
    for (int i = 0; i < listMarkers.length; i++) {
      markers.add(
        Marker(
            infoWindow: InfoWindow(
              title: listMarkers[i]['title'],
            ),
            onTap: () async {
              // Get directions

              if (!userMode.toJson()['isReservation']) {

                await getPolylines(
                    latitudeEnd: listMarkers[i]['latitude'],
                    longitudeEnd: listMarkers[i]['longitude'],
                    title: listMarkers[i]['title'],
                    serverTitle: listMarkers[i]['serverTitle'],
                    cost:listMarkers[i]['cost'].runtimeType == int ?listMarkers[i]['cost']: int.parse(listMarkers[i]['cost'].toString()),
                    image: listMarkers[i]['imageUrl']);
                print("serverTitleGarage : " + serverTitleGarage);
              } else {
                Get.snackbar(
                  'Note !',
                  "You must cancel the reservation in the other garage",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red.shade200,
                );
              }
            },
            markerId: MarkerId('id-$i'),
            position: LatLng(
                listMarkers[i]['latitude'], listMarkers[i]['longitude'])),
      );
      update();
    }
    print(markers);
  }

  getPolylines(
      {latitudeEnd, longitudeEnd, title, serverTitle, cost, image}) async {
    final directions = await DirectionsRepository().getDirections(
        origin: LatLng(myLatitude!, myLongitude!),
        destination: LatLng(latitudeEnd, longitudeEnd));
    info = directions;
    costPerHour = cost;
    titleParking = title;
    serverTitleGarage = serverTitle;
    this.image = image;
    update();
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blueGrey,
      points: polylineCoordinates,
      width: 2,
    );
    polylines[id] = polyline;
    update();
  }

  openGateToExit() async {
    String randomNumber = GetRandomNum();
    showDialog(
      context: Get.context!, //      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return openGateDialog(
            onPressed: () async {
              Get.back();
              PlacesInGarageController places =
                  Get.put(PlacesInGarageController());
              final startTime=userMode.startTimeOfBooking;
              showDialog(
                  context: Get.context!,
                  //      barrierDismissible: barrierDismissible,
                  builder: (BuildContext dialogContext) {
                    return invoiceDialog(startTimef:startTime);
                  });

              await FirebaseDatabase.instance
                  .ref('users/${GetStorage().read('phoneNumber')}')
                  .update({
                'inGarage': false,
                'isReservation': false,
                'slotReserved': '',
                'garageReserved': '',
                'startTimeOfBooking': '',
              });
              await FirebaseDatabase.instance
                  .ref(serverTitleGarage)
                  .update({'gate': 'open', places.slotSelected: 'empty'});
              // Get.back();

              // Get.snackbar(
              //   'Note !',
              //   "The gate is open, please cross now ,amount has been deducted ${(resultBetweenTowDates * (costPerHour / 60)).toInt()} EGP",
              //   snackPosition: SnackPosition.TOP,
              //   backgroundColor: Colors.green.shade200,
              // );
              places.slotSelected = '';

              // update();
            },
            randomNumber: randomNumber);
      },
    );
  }

  GetRandomNum() {
    const _chars = '123456789';
    Random _rnd = Random();
    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    return getRandomString(4).toString();
  }

  openGateToCross() async {
    String randomNumber = GetRandomNum();

    showDialog(
      context: Get.context!, //      barrierDismissible: barrierDismissible,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return openGateDialog(
            onPressed: () async {
              PlacesInGarageController places =
                  Get.put(PlacesInGarageController());

              await FirebaseDatabase.instance
                  .ref('users/${GetStorage().read('phoneNumber')}')
                  .update({
                'inGarage': true,
              });
              await FirebaseDatabase.instance.ref(serverTitleGarage).update({
                'gate': 'open'
                // , places.slotSelected: 'full'
              });
              Get.back();
              Get.snackbar(
                'Note !',
                "The gate is open, please cross now to ${places.slotSelected}",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green.shade200,
              );

              update();
            },
            randomNumber: randomNumber);
      },
    );
  }

  cancelOfReservation({wait}) async {
    PlacesInGarageController places = Get.put(PlacesInGarageController());

    await FirebaseDatabase.instance
        .ref('users/${GetStorage().read('phoneNumber')}')
        .update({
      'inGarage': false,
      'isReservation': false,
      'slotReserved': '',
      'garageReserved': '',
      'startTimeOfBooking': '',
    });

    await FirebaseDatabase.instance
        .ref(serverTitleGarage)
        .update({places.slotSelected: 'empty'});
    places.slotSelected = '';
    if (wait == 'wait') {
      Get.snackbar(
        'Note !',
        "Booking canceled",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade200,
      );
    } else {
      Get.snackbar(
        'Note !',
        "Your reservation has been canceled successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade200,
      );
    }
    update();
  }

  calculateBetweenTowDates() {
    final date2 = DateTime.now();
    final difference = date2
        .difference(
            DateTime.parse(userMode.toJson()['startTimeOfBooking'] as String))
        .inMinutes;
    resultBetweenTowDates = difference;
    update();
  }

  openGateDialog({onPressed, randomNumber}) {
    String confirmationNumber = '';
    return AlertDialog(
      title: Text('Note !'),
      content: SizedBox(
        height: 127,
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        'To confirm entering the portal, repeat this number   ',
                  ),
                  TextSpan(
                      text: randomNumber,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                ],
              ),
            ),
            SizedBox(
              height: 7,
            ),
            CustomTextField(
              title: 'confirmation number',
              onChanged: (c) {
                confirmationNumber = c;
              },
              maxLength: 4,
            )
          ],
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text(
            'cancel',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        MaterialButton(
          child: Text(
            'open gate',
            style: TextStyle(color: Colors.green),
          ),
          onPressed: () {
            if (confirmationNumber == randomNumber) {
              onPressed();
            } else {
              Get.snackbar(
                'Error !',
                "The confirmation number is incorrect",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red.shade200,
              );
            }
          },
        ),
      ],
    );
  }

  invoiceDialog({startTimef}) {
    final  DateTime now = DateTime.now();
    final  DateTime format = DateTime.parse(startTimef);

    final  String startTime = DateFormat("hh:mm").format(format);
    final  String startDate = DateFormat("yyyy-MM-dd").format(format);

    final  String dateNowFormat = DateFormat("yyyy-MM-dd").format(now);
    final String timeNowFormat = DateFormat("hh:mm").format(now);
    final result=resultBetweenTowDates;
    final cost=costPerHour;
    return AlertDialog(
      title: Text('Note !'),
      content: SizedBox(
        height: 140,
        width: MediaQuery.of(Get.context!).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Time to use the park : $result M',
                alignment: Alignment.centerLeft,
              ),
              SizedBox(
                height: 5,
              ),
              CustomText(
                text: 'cost per hour : $cost EGP',
                alignment: Alignment.centerLeft,
              ),
              SizedBox(
                height: 4,
              ),
              CustomText(
                text:
                    'cost per hour * Time = ${(((result - 60) * (cost / 60)).toInt())}',
                alignment: Alignment.centerLeft,
              ),
              SizedBox(
                height: 4,
              ),
              CustomText(
                text: 'Garage entry Date : ${startDate.toString()}',
                alignment: Alignment.centerLeft,
              ),
              SizedBox(
                height: 4,
              ),
              CustomText(
                text: 'Garage entry time : ${startTime.toString()}',
                alignment: Alignment.centerLeft,
              ),
              SizedBox(
                height: 4,
              ),
              CustomText(
                text: 'Date to go out : $dateNowFormat',
                alignment: Alignment.centerLeft,
              ),
              SizedBox(
                height: 4,
              ),
              CustomText(
                text: 'Time to go out : $timeNowFormat',
                alignment: Alignment.centerLeft,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          child: Text(
            'Done',
            style: TextStyle(color: Colors.green),
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ],
    );
  }

  getLastLocation({listMarkers}) {
    if (userMode.toJson()['isReservation'] == true) {
      for (int i = 0; i < listMarkers.length; i++) {
        if (userMode.toJson()['garageReserved'] ==
            listMarkers[i]['serverTitle']) {
          PlacesInGarageController places = Get.put(PlacesInGarageController());
          print('listMarkers[i] : ${listMarkers[i]['serverTitle']}');
          getPolylines(
              latitudeEnd: listMarkers[i]['latitude'],
              longitudeEnd: listMarkers[i]['longitude'],
              title: listMarkers[i]['title'],
              serverTitle: listMarkers[i]['serverTitle'],
              cost: listMarkers[i]['cost'],
              image: listMarkers[i]['imageUrl']);
          places.slotSelected = userMode.toJson()['slotReserved'];
        }
      }
    }
  }
}
