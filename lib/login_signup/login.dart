
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberpwd = false;
  bool sec = true;
  var visable = const Icon(
    Icons.visibility,
    color: Color(0xff4c5166),
  );
  var visableoff = const Icon(
    Icons.visibility_off,
    color: Color(0xff4c5166),
  );
  // ignore: prefer_typing_uninitialized_variables
  var email, password;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  signIn()async{
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password
        );
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AwesomeDialog(
              context: context,
              title: "Error",
              body: const Text("No user found for that email.")).show();
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
              context: context,
              title: "Error",
              body: const Text("Wrong password provided for that user.")).show();
        }
      }
    }else{

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                      "Smart Parking 🚗",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    signUp(),
                    const SizedBox(
                      height: 15,
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget signUp() {
    return Form(
      key: formstate,
      child: Column(
        children: [
          TextFormField(
            onSaved: (value) {
              email = value;
            },
            validator: (value) {
              if (value!.length > 100) {
                return "the email can`t to be larger than 100 letters";
              }
              if (value.length < 5) {
                return "the email can`t to be less than 5 letters";
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xff4c5166),
                ),
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            onSaved: (value) {
              password = value!;
            },
            validator: (value) {
              if (value!.length > 30) {
                return "the password can`t to be larger than 15 letters";
              }
              if (value.length < 5) {
                return "the password can`t to be less than 5 letters";
              }
              return null;
            },
            obscureText: sec,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      sec = !sec;
                    });
                  },
                  icon: sec ? visableoff : visable,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
                contentPadding: const EdgeInsets.only(top: 14),
                prefixIcon: const Icon(
                  Icons.vpn_key,
                  color: Color(0xff4c5166),
                ),
                hintText: "Password",
                hintStyle: const TextStyle(color: Colors.black38)),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildRememberassword(),
              buildForgetPassword()
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                UserCredential user = await signIn();
                if (kDebugMode) {
                  print('==============');
                }
                if (kDebugMode) {
                  print(user.user!.email);
                }
                if (kDebugMode) {
                  print('==============');
                }
                Navigator.of(context).pushReplacementNamed('Home');
              },
              child: const Text('SIGN IN',
                  style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  primary: Colors.lightBlue,
                  onPrimary: Colors.white),
            ),
          ),
        ],
      ),
    );
  }




  Widget buildRememberassword() {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          Theme(
              data: ThemeData(unselectedWidgetColor: Colors.black38),
              child: Checkbox(
                value: rememberpwd,
                checkColor: Colors.white,
                activeColor: Colors.lightBlue,
                onChanged: (value) {
                  setState(() {
                    rememberpwd = value!;
                  });
                },
              )),
          const Text(
            "Remember me",
          ),
        ],
      ),
    );
  }

  Widget buildForgetPassword() {
    return TextButton(
        child: const Text("Forget Password !",),
        onPressed: () {},
      );

  }


}
