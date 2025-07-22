import 'package:flutter/material.dart';
import 'package:todo_list/HomePage.dart';

class Termsandcondition extends StatelessWidget {
  final String uid;
  final String name;
  final String email;
  const Termsandcondition({super.key, required this.uid, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Condition'),
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
          email: email
      ), // 🔍 Add this
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(75),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Terms and Condition',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
