import 'package:flutter/material.dart';
import 'package:todo_list/HomePage.dart'; // Optional: for "Home" menu item

class SettingsPage extends StatelessWidget {
  final String uid;
  final String name;
  final String email;
  const SettingsPage({super.key, required this.uid, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.green,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          )
        ],
      ),
      endDrawer: CustomnavigationDrawer(
          uid: uid,
          name: name,
          email: email),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(75),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to settings',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
