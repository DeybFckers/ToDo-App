import 'package:flutter/material.dart';
import 'package:todo_list/HomePage.dart';

class Termsandcondition extends StatelessWidget {
  const Termsandcondition({super.key});

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
      endDrawer: CustomavigationDrawer(), // 🔍 Add this
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
