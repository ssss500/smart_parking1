// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, avoid_print, null_check_always_fails, avoid_init_to_null, avoid_function_literals_in_foreach_calls, prefer_collection_literals, void_checks, await_only_futures

import 'dart:async';

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
import 'package:smart_parking/model_controller/models/user_model.dart';
import 'package:smart_parking/model_controller/places_in_garage_controller.dart';

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
  int? costPerHour;

  //all marker
  //late List<MarkerData> customMarkers = [];
  Set<Marker> markers = Set(); //markers for google map
  late BitmapDescriptor icon;

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
    print("on init");
    await determinePosition().then((value) {
      myLatitude = value.latitude;
      myLongitude = value.longitude;
      print("myLatitude $myLatitude");
      initialCameraPosition =
          CameraPosition(target: LatLng(myLatitude!, myLongitude!), zoom: 13.9);
      update();
    });

    await createMarkers();
//   await addMyLocationInMarkers();

    super.onInit();
  }

  listenFirebaseUser() async {
    print(GetStorage().read('phoneNumber'));
    DatabaseReference starCountRef = await FirebaseDatabase.instance
        .ref('users/${GetStorage().read('phoneNumber')}/');
    await starCountRef.onValue.listen((DatabaseEvent event) {
//      Map<String, dynamic> data = Map<String, dynamic>.from(
//          event.snapshot.value as Map<String, dynamic>);
      userMode = UserModel.fromJson(
          Map<String, dynamic>.from(event.snapshot.value as dynamic));

      update();
    });
  }

//  goToMyLocation() async {
//    Position position = await determinePosition();
//    myLatitude = position.latitude;
//    myLongitude = position.longitude;
//
//    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
//        CameraPosition(target: LatLng(myLatitude!, myLongitude!), zoom: 15)));
//  }

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

// Cargar imagen del Marker

  // Crear Marker
  createMarkers() {
    markers.addAll({
      Marker(
          infoWindow: !userMode.toJson()['isReservation']
              ? InfoWindow(
                  title: 'First Garage',
                )
              : InfoWindow.noText,
          onTap: () {
            // Get directions

            if (!userMode.toJson()['isReservation']) {
              getPolylines(
                  latitudeEnd: 30.040429,
                  longitudeEnd: 31.010068,
                  title: 'First Garage',
                  serverTitle: 'firstGarage',
                  cost: 17,
                  image: 'assets/image/parking.png');
            } else {
              Get.snackbar(
                'Note !',
                "You must cancel the reservation in the other garage",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.shade200,
              );
            }
          },
          markerId: const MarkerId('id-1'),
          position: LatLng(30.040429, 31.010068)),
      Marker(
          infoWindow: !userMode.toJson()['isReservation']
              ? InfoWindow(
                  title: 'Second Garage',
                )
              : InfoWindow.noText,
          draggable: true,
          onTap: () async {
            if (!userMode.toJson()['isReservation']) {
              getPolylines(
                  latitudeEnd: 30.037391,
                  longitudeEnd: 30.985962,
                  title: 'Second Garage',
                  serverTitle: 'secondGarage',
                  cost: 10,
                  image: 'assets/image/parking2.png');
            } else {
              Get.snackbar(
                'Note !',
                "You must cancel the reservation in the other garage",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.shade200,
              );
            }
          },
          markerId: const MarkerId('id-2'),
          position: LatLng(30.037391, 30.985962)),
    });
    update();
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
    PlacesInGarageController places = Get.put(PlacesInGarageController());

    await FirebaseDatabase.instance
        .ref('users/${GetStorage().read('phoneNumber')}')
        .update({
      'inGarage': false,
      'isReservation': false,
    });
    await FirebaseDatabase.instance
        .ref(serverTitleGarage)
        .update({'gate': 'open', places.slotSelected: 'empty'});
    Get.snackbar(
      'Note !',
      "The gate is open, please cross now",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade200,
    );
    places.slotSelected='';
    update();
  }

  openGateToCross() async {
    PlacesInGarageController places = Get.put(PlacesInGarageController());

    await FirebaseDatabase.instance
        .ref('users/${GetStorage().read('phoneNumber')}')
        .update({
      'inGarage': true,
    });
    await FirebaseDatabase.instance
        .ref(serverTitleGarage)
        .update({'gate': 'open', places.slotSelected: 'openLed'});
    Get.snackbar(
      'Note !',
      "The gate is open, please cross now to ${places.slotSelected}",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade200,
    );
    update();
  }

  cancelOfReservation() async {
    PlacesInGarageController places = Get.put(PlacesInGarageController());

    await FirebaseDatabase.instance
        .ref('users/${GetStorage().read('phoneNumber')}')
        .update({
      'inGarage': false,
      'isReservation': false,
    });
    places.slotSelected='';
    await FirebaseDatabase.instance
        .ref(serverTitleGarage)
        .update({places.slotSelected: 'empty'});
    Get.snackbar(
      'Note !',
      "Your reservation has been canceled successfully",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.shade200,
    );
    update();
  }
}
