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

import 'directions_model.dart';
import '../view/widgets/custom_markers_map.dart';
import 'directions_repository.dart';

class HomeController extends GetxController {
  final ContainerTransitionType transitionType = ContainerTransitionType.fade;

  late GoogleMapController googleMapController;
  var userMode;
  String name = '', phoneNumber = '', serverTitleGarage = '';
  List cards = [];

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
    listenFirebaseUser();
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
    DatabaseReference starCountRef = await FirebaseDatabase.instance
        .ref('users/${GetStorage().read('phoneNumber')}/');
    await starCountRef.onValue.listen((DatabaseEvent event) {
      Map<String, dynamic> data = Map<String, dynamic>.from(
          event.snapshot.value as Map<String, dynamic>);
      userMode = UserModel.fromJson(data);
      name = userMode.name;
      phoneNumber = userMode.phoneNumber;
      cards = userMode.cards;
      update();
    });
  }

  goToMyLocation() async {
    Position position = await determinePosition();
    myLatitude = position.latitude;
    myLongitude = position.longitude;

    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(myLatitude!, myLongitude!), zoom: 15)));
  }

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
          infoWindow: InfoWindow(
            title: 'الجراج الاول',
          ),
          onTap: () {
            // Get directions
            getPolylines(
                latitudeEnd: 30.040429,
                longitudeEnd: 31.010068,
                title: 'الجراج الاول',
                serverTitle: 'firstGarage',
                cost: 17,
                image: 'assets/image/parking.png');
          },
          markerId: const MarkerId('id-1'),
          position: LatLng(30.040429, 31.010068)),
      Marker(
          infoWindow: InfoWindow(
            title: 'الجراج الثاني',
          ),
          draggable: true,
          onTap: () async {
            getPolylines(
                latitudeEnd: 30.037391,
                longitudeEnd: 30.985962,
                title: 'الجراج الثاني',
                serverTitle: 'secondGarage',
                cost: 10,
                image: 'assets/image/parking2.png');
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
    this.serverTitleGarage = serverTitle;
    this.image = image;
    update();
//    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//      "AIzaSyAjtS38IGjsiLNNvKiDE-cNw7habDajgB8",
//      PointLatLng(myLatitude!, myLongitude!),
//      PointLatLng(latitudeEnd, longitudeEnd),
//      travelMode: TravelMode.driving,
//    );
//
//    if (result.points.isNotEmpty) {
//      polylineCoordinates = [];
//      result.points.forEach((PointLatLng point) {
//        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//      });
//    } else {
//      print(result.errorMessage);
//    }
//
//    addPolyLine(polylineCoordinates);
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

//  addMyLocationInMarkers(){
//    markers.add(
//      Marker(
//          infoWindow: InfoWindow(
//            title: 'Me',
//          ),
//          icon:BitmapDescriptor.defaultMarker,
//          markerId: const MarkerId('me'),
//          position: LatLng(myLatitude!, myLongitude!)),
//    );
//    update();
//  }
}
