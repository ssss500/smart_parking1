// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_parking/switch_login.dart';
//import 'package:smart_parking/firebase_options.dart';
import 'package:smart_parking/view/home_view.dart';
import 'firebase_options.dart';
import 'view/intro.dart';

main() async {
  // need to map
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  // need to firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //need to firebase auth
  FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      )),
      debugShowCheckedModeBanner: false,
      home: SwitchLogin(),
    );
  }
}
