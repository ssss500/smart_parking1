import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var name, email, password;
  late String confPassword;
  late String phone;
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
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  singUp() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AwesomeDialog(
              context: context,
              title: "Error",
              body: const Text("password is to weak")).show();

        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
              context: context,
              title: "Error",
              body: const Text("The account already exists for that email.")).show();

        }
      } catch (e) {

        if (kDebugMode) {
          print(e);
        }

      }
    } else {

      if (kDebugMode) {
        print("not valid");
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Create an account",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                signUp(),
              ],
            ),
          ),
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
              name = value;
            },
            validator: (value) {
              if (value!.length > 40) {
                return "the username can`t to be larger than 40 letters";
              }
              if (value.length < 2) {
                return "the username can`t to be less than 2 letters";
              }
              return null;
            },
            keyboardType: TextInputType.name,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.account_circle,
                  color: Color(0xff4c5166),
                ),
                hintText: 'Name',
                hintStyle: TextStyle(color: Colors.black38)),
          ),
          const SizedBox(
            height: 20,
          ),
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
              phone = value!;
            },
            validator: (value) {
              if (value!.length > 15) {
                return "the phone number can`t to be larger than 15 numbers";
              }
              if (value.length < 5) {
                return "the phone number can`t to be less than 5 numbers";
              }
              return null;
            },
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.phone,
                  color: Color(0xff4c5166),
                ),
                hintText: 'Phone Number',
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
            height: 20,
          ),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                UserCredential respons = await singUp();
                if (kDebugMode) {
                  print('==============');
                }
                if (kDebugMode) {
                  print(respons.user!.email);
                }
                if (kDebugMode) {
                  print('==============');
                }
                Navigator.of(context).pushReplacementNamed('Home');
              },
              child: const Text('CREATE AN ACCOUNT',
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

  Widget buildConfirmPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Confirm Password",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: const Color(0xffebefff),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ],
          ),
          height: 60,
          child: TextField(
            obscureText: sec,
            onChanged: (value) {
              confPassword = value;
            },
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
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 14),
                prefixIcon: const Icon(
                  Icons.vpn_key,
                  color: Color(0xff4c5166),
                ),
                hintText: "Confirm Password",
                hintStyle: const TextStyle(color: Colors.black38)),
          ),
        )
      ],
    );
  }
}
