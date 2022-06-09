// ignore_for_file: use_key_in_widget_constructors, unnecessary_string_interpolations

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smart_parking/model_controller/login_signup/signup_controller.dart';
import 'package:smart_parking/view/home_view.dart';
import 'package:smart_parking/view/widgets/custom_buttom.dart';

import '../widgets/constance.dart';
import '../widgets/custom_text.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();

  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SignupController signupController = Get.put(SignupController());
    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 30),
              //gif
              SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset('assets/image/otp.gif'),
                ),
              ),
              const SizedBox(height: 8),
              //title
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: "${signupController.phoneNumber.text}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      autoFocus: true,
                      enablePinAutofill:true ,
                      length: 6,
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 4) {
                          return "Wrong Code Verification";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: signupController.otpController,
                      keyboardType: TextInputType.number,
//                      boxShadows: const [
//                        BoxShadow(
//                          offset: Offset(0, 1),
//                          color: Colors.black12,
//                          blurRadius: 10,
//                        )
//                      ],
                      onCompleted: (v) {
                        debugPrint("Completed");
                      },

                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                      onChanged: (String value) {},
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: [
//                  const Text(
//                    "Didn't receive the code? ",
//                    style: TextStyle(color: Colors.black54, fontSize: 15),
//                  ),
//                  TextButton(
//                    onPressed: () => snackBar("OTP resend!!"),
//                    child: const Text(
//                      "RESEND",
//                      style: TextStyle(
//                          color: Color(0xFF91D3B3),
//                          fontWeight: FontWeight.bold,
//                          fontSize: 16),
//                    ),
//                  )
//                ],
//              ),
//              const SizedBox(
//                height: 14,
//              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: CustomButton(
                  function: () {
                    formKey.currentState!.validate();
                    signupController.verifyOTP();

                    snackBar("OTP Verified!!");

//                        },
//                      );
//                    }
                  },
                  text: "VERIFY",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
