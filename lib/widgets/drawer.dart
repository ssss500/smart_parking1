import 'package:flutter/material.dart';

class DrawerClass extends StatefulWidget {
  const DrawerClass({Key? key}) : super(key: key);
  @override
  _DrawerClass createState() => _DrawerClass();
}

class _DrawerClass extends State<DrawerClass> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children:  [
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.deepOrange,
              child: Text('A'),
            ),
              accountName: Text('Ahmed'),
              accountEmail: Text('ahmed@gmail.com')),
          ListTile(
            title: const Text('My Profile'),
            leading: const Icon(Icons.account_circle_sharp),
            onTap: (){},
          )
        ],
      ),
    );
  }
}
