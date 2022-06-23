// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_parking/model_controller/login_signup/login_controller.dart';
import 'package:smart_parking/view/widgets/constance.dart';
import 'package:smart_parking/view/widgets/custom_buttom.dart';
import 'package:smart_parking/view/widgets/custom_text_field.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  TextString.smartParkingString,
                  style: TextStyle(
                    fontSize: 39,
//                fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  TextString.signInString,
                  style: const TextStyle(fontSize: 30, color: primaryColor),
                ),
                const SizedBox(
                  height: 30,
                ),
                login(),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget login() {
    LoginController loginController = Get.put(LoginController());
    return Form(
      key: loginController.formState,
      child: Column(
        children: [
          CustomTextField(
            controller: loginController.phoneNumber,
            title: TextString.phoneNumberString,
            hint: '+20101234567',
            textInputType: TextInputType.phone,
            autoFillHints: const [AutofillHints.telephoneNumber],

            // onChanged: (c) {
            //   loginController.phoneNumber = c;
            // },
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
          const SizedBox(
            height: 20,
          ),
          GetBuilder<LoginController>(
            builder: (c) => CustomTextField(
              title: TextString.passwordString,
              hint: '********',
              textInputType: TextInputType.visiblePassword,
              onChanged: (c) {
                loginController.password = c;
              },
              obscureText: !c.showPassword,
              iconButton: IconButton(
                onPressed: () {
                  c.showPassword = !c.showPassword;
                  c.update();
                },
                icon: c.showPassword
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              ),
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
          ),
          const SizedBox(
            height: 30,
          ),
          CustomButton(
            function: () {
              loginController.loginFun();
            },
            text: TextString.signInString,
          ),
        ],
      ),
    );
  }
}
