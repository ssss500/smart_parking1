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
  WidgetsFlutterBinding.ensureInitialized();
  // bool isLogin;
//  await GetStorage.init();

//  await Firebase.initializeApp();
  if (defaultTargetPlatform == TargetPlatform.android) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
//  FirebaseAuth auth = FirebaseAuth.instance;

//  const MyApp({Key? key}) : super(key: key);
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
