import 'package:flutter/material.dart';
import 'package:todo_list/HomePage.dart'; // Optional: for "Home" menu item

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
      endDrawer: CustomnavigationDrawer(), // 🔍 Add this
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
