import 'package:flutter/material.dart';


class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: <Widget>[
              const SizedBox(
                height: 150,
              ),
              const Text(
                'Start by creating an account.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'I`m an early bird and I`m a night owl so I`m wise and I have worms',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              const SizedBox(
                height: 200,
              ),
              createAccount(),
              const SizedBox(
                height: 10,
              ),
              signIn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget createAccount() {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('Sign Up');
        },
        child: const Text(
          'CREATE AN ACCOUNT',
          style: TextStyle(fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            primary: Colors.lightBlue,
            onPrimary: Colors.white),
      ),
    );
  }

  Widget signIn() {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('login');
        },
        child: const Text('SIGN IN', style: TextStyle(fontSize: 20)),
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            primary: const Color(0xffe8f5fb),
            onPrimary: Colors.lightBlue),
      ),
    );
  }
}
