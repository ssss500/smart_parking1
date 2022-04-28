import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  DatabaseReference ref = FirebaseDatabase.instance.reference();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('login');
              },
              icon: const Icon(Icons.logout))
        ],
        backgroundColor: Colors.lightBlue,
      ),
      drawer: const DrawerClass(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose your slot",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 100,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ]),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 100,
                    width: 60,
                    child: const Center(
                        child: Text(
                      "P1",
                      style: TextStyle(fontSize: 40),
                    )),
                    color: Colors.green,
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  Container(
                    height: 100,
                    width: 60,
                    child: const Center(
                        child: Text(
                      "P2",
                      style: TextStyle(fontSize: 40),
                    )),
                    color: Colors.red,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            // ElevatedButton(onPressed: () {
            //
            // }, child: const Text("Book It")),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pushNamed('Payment');
                        var tableRef = ref.child("second garage");
                        await tableRef
                            .child("Slot 1")
                            .once()
                            .then((DataSnapshot snapshot) {
                          if (snapshot.value == 1) {
                            if (kDebugMode) {
                              print('emp');
                            }
                          } else {
                            if (kDebugMode) {
                              print('not emp');
                            }
                          }
                          if (kDebugMode) {
                            print(snapshot.value);
                          }
                        });
                      },
                      child: const Text("Booking",
                          style: TextStyle(fontSize: 40))),
                  const SizedBox(
                    width: 40,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        var tableRef = ref.child("second garage");
                        await tableRef
                            .child("gate")
                            .once()
                            .then((DataSnapshot snapshot) {
                          if (snapshot.value == true) {
                            tableRef.update({
                              'gate': false,
                            });
                            if (kDebugMode) {
                              print(snapshot.value);
                            }

                          } else {
                            tableRef.update({
                              'gate': true,
                            });
                            if (kDebugMode) {
                              print(snapshot.value);
                            }
                          }
                        });
                        // var gateValue = ref.child("second garage");
                        // await gateValue.update(
                        //     {
                        //       'gate': true,
                        //     }
                        // );
                        // gateValue.push();
                      },
                      child:
                          const Text('update', style: TextStyle(fontSize: 40)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConn1() {
    return FirebaseAnimatedList(
        shrinkWrap: true,
        query: ref,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation animation, int index) {
          if (snapshot.value["Slot 1"] == 0) {
            return Container(
              height: 40,
              color: Colors.green,
            );
          } else {
            return Container(
              height: 40,
              color: Colors.red,
            );
          }
        });
  }

  Widget buildConn2() {
    return FirebaseAnimatedList(
        shrinkWrap: true,
        query: ref,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation animation, int index) {
          if (snapshot.value["Slot 2"] == 0) {
            return Container(
              height: 40,
              color: Colors.green,
            );
          } else {
            return Container(
              height: 40,
              color: Colors.red,
            );
          }
        });
  }
}
