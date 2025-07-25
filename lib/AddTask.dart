import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/HomePage.dart';
import 'package:get/get.dart';

class AddTaskPage extends StatefulWidget {
  final String uid;
  final String name;
  final String email;
  const AddTaskPage({super.key, required this.uid, required this.name, required this.email });

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final List<String> daysofWeek = [ 'Monday', 'Tuesday', 'Wednesday',
                                    'Thursday', 'Friday', 'Saturday', 'Sunday'];

  final taskController = TextEditingController();
  late String selectedDay;

  void initState(){
    super.initState();
    selectedDay = daysofWeek[0];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25, right: 25, top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select a Day :',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedDay,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                      items: daysofWeek.map((day){
                        return DropdownMenuItem<String>(
                          value: day,
                          child: Text(day),
                          );
                        }
                      ).toList(),
                      onChanged: (value){
                        if(value !=null){
                          setState(() {
                            selectedDay = value;
                          });
                        }
                      }
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: taskController,
                    maxLines: 25, // Allows multiline input
                    decoration: InputDecoration(
                      hintText: 'Write a Task...',
                      filled: true,
                      fillColor: Colors.grey[100], // Light background color
                      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () async {
                    //add data to firestore
                    if(taskController.text.isNotEmpty){
                      final uid = firebaseAuth.currentUser!.uid;

                      await firebaseStore.collection('todos').add({
                        'userId': uid,
                        'todoList' : taskController.text,
                        'Day' : selectedDay,
                        'Done' : false,
                      });
                      Get.offAll(() => HomePage(uid: uid, name: widget.name, email: widget.email));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    fixedSize: Size(415, 20),
                  ),
                  child: Text('Add',
                      style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    )
                  )
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}
