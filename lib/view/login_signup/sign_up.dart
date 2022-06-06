// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/model_controller/login_signup/signup_controller.dart';
import 'package:smart_parking/view/login_signup/verification_code.dart';
import 'package:smart_parking/view/widgets/constance.dart';
import 'package:smart_parking/view/widgets/custom_buttom.dart';
import 'package:smart_parking/view/widgets/custom_text.dart';
import 'package:smart_parking/view/widgets/custom_text_field.dart';

class SignUpView extends StatelessWidget {
  SignupController signupController = Get.put(SignupController());

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
                //title
                CustomText(
                  text: TextString.createAccountString,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(
                  height: 40,
                ),
                //name,phone,password
                Form(
                  key: signupController.formState,
                  child: Column(
                    children: [
                      //name
                      CustomTextField(
                        title: TextString.nameString,
                        hint: 'Mohmed Ahmed',

                        autoFillHints: const [AutofillHints.name],
                        onChanged: (text) {
                          signupController.name = text;
                        },
                        iconData: Icons.person,
                        validator: (value) {
                          if (value!.length > 40) {
                            return "the username can`t to be larger than 40 letters";
                          }
                          if (value.length < 2) {
                            return "the username can`t to be less than 2 letters";
                          }
                          return null;
                        },
                      ), //email

                      //phone
                      CustomTextField(
                        title: TextString.phoneNumberString,
                        hint: '0101234567',
                        textInputType: TextInputType.phone,
                        autoFillHints: const [AutofillHints.telephoneNumber],
                        onChanged: (c) {
                          signupController.phoneNumber = c;
                        },
                        iconData: Icons.phone,
                        validator: (value) {
                          if (value!.length > 13) {
                            return "the phone number can`t to be larger than 13 numbers";
                          }
                          if (value.length < 13) {
                            return "the phone number can`t to be less than 13 numbers";
                          }
                          return null;
                        },
                      ),
                      //password
                      CustomTextField(
                        title: TextString.passwordString,
                        hint: '********',
                        textInputType: TextInputType.visiblePassword,
                        onChanged: (c) {
                          signupController.password = c;
                        },
                        iconData: Icons.password,
                        validator: (value) {
                          if (value!.length > 30) {
                            return "the password can`t to be larger than 15 letters";
                          }
                          if (value.length < 5) {
                            return "the password can`t to be less than 5 letters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 35,
                      ), //create account button
                      CustomButton(
                        function: () {

                          signupController.singUp();
                        },
                        text: TextString.createAccountString,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
