import 'package:flutter/material.dart';

class PayScreen extends StatelessWidget {
  const PayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pay your payment',
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Parking ID:',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const Text('2334g',
                style: TextStyle(fontSize: 18, color: Colors.black)),
            const SizedBox(
              height: 15,
            ),

            Container(
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.width * .9,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.blueAccent),
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:const  [
                        Text(
                          '2hour parking',
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                        Text(
                          '112',
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:const  [
                        Text(
                          'Tax',
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                        Text(
                          '12',
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:const  [
                        Text(
                          'Services Fee',
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                        Text(
                          '45',
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:const  [
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                        Text(
                          '500',
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                      ],),
                  ],
                ),
              ),

            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        )
                      ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children:const [
                        SizedBox(height: 10,),
                        // TextField(
                        //   keyboardType: TextInputType.number,
                        //   decoration: InputDecoration(
                        //       labelText: '',
                        //       hintText: '',
                        //       border: OutlineInputBorder()),
                        // ),
                        SizedBox(height: 15,),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Card Number',
                              hintText: 'Enter your Card ',
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(height: 15,),
                        TextField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              labelText: 'Card Name',
                              hintText: 'Enter your Card Name',
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(height: 15,),
                        TextField(
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              labelText: 'CVV',
                              border: OutlineInputBorder()),
                        ),



                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () async{

                  },
                  child: const Text("Booking",style: TextStyle(fontSize: 40))),
            ),

          ],
        ),
      ),
    );
  }
}