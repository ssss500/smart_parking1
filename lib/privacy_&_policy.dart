import 'package:flutter/material.dart';
import 'package:smart_parking/view/widgets/custom_buttom.dart';

class Policy extends StatefulWidget {
  const Policy({Key? key}) : super(key: key);

  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  [
                const Text(
                    '1. We may collect location data from the device you are using to access the App, in order to enable us to provide parking and other services via the App. This may require you to enable or authorise location services via the permission system used by your mobile operating system. If you do not enable or authorise location services, the App may not be able to provide you with all of its features or services.'),

                const Text(
                    '2. When booking, one hour will be charged                                        '),
                const Text('3. When you establish a user account or user profile with us we may collect personal details from you. This may include some or all of the following: your user name, password and an phone number.'),

                const Text('4. When you use the App to pay for parking, we may collect transaction details from you. This may include user details. You will also need to enter payment details.'),
                // SizedBox(height: 15,),
                const Text(
                    '5. The counter will start to count after an hour and calculate the time you stayed at slot'),
                // SizedBox(height: 15,),
                const Text(
                    '6. If you do not reach the garage gate within 30 min minutes, your booking will be canceled and the cost of one hour will be charged'),
                Center(
                    child: CustomButton(function: (){Navigator.pop(context);},text: "Okay",)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
