import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/login_signup/sign_up.dart';
import 'package:smart_parking/pages/home_screen.dart';
import 'intro.dart';
import 'login_signup/login.dart';
import 'pages/payment.dart';



main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // bool isLogin;
  await Firebase.initializeApp();
  FirebaseAuth.instance.currentUser;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Intro(),
      routes: {
        'login': (context) => const LoginScreen(),
        'Sign Up': (context) => const SignUpScreen(),
        'Home': (context) =>  const HomeScreen(),
        'Intro':(context) => const Intro(),
        'Payment':(context) => const PayScreen(),
      },
    );
  }
}