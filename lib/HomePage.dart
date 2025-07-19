import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/AddTask.dart';
import 'package:todo_list/LoginPage.dart';
import 'package:todo_list/SettingsPage.dart';
import 'package:todo_list/TermsAndCondition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map<String, List<String>> tasksPerDay = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  @override
  Widget build(BuildContext context) {

    var date = DateTime.now();
    var formattedDate = DateFormat('EEEE, d MMMM y',).format(date);

    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
        actions: [
         Builder(
           builder: (context) =>  IconButton(
                icon: Icon(Icons.menu),
               onPressed: (){
                 Scaffold.of(context).openEndDrawer();
               },
           )
         )
        ],
      ),
      endDrawer: CustomnavigationDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Hi, Dave!\n',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )
                          ),
                          TextSpan(
                            text: '$formattedDate',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]
                            )
                          )
                        ]
                      )
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddTaskPage()),
                        );

                        if (result != null && result is Map<String, String>){
                          String day = result['day']!;
                          String task = result['task']!;

                          setState(() {
                            tasksPerDay[day]!.add(task);
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 2)
                        ),
                        child: Text(
                            '+ New Task',
                          style: TextStyle(
                            fontWeight: FontWeight.w600 ,
                            fontSize: 16,
                            color: Colors.black
                          )
                        ),
                      ),
                    )
                  ]
                ),
                SizedBox(height: 30),
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Text('Monday',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tasksPerDay['Monday']!
                          .map((task) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(task),
                          )
                        ).toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Tuesday',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tasksPerDay['Tuesday']!
                            .map((task) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(task),
                        )
                        ).toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Wednesday',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tasksPerDay['Wednesday']!
                            .map((task) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(task),
                        )
                        ).toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Thursday',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tasksPerDay['Thursday']!
                            .map((task) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(task),
                        )
                        ).toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Friday',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tasksPerDay['Friday']!
                            .map((task) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(task),
                        )
                        ).toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Saturday',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tasksPerDay['Saturday']!
                            .map((task) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(task),
                        )
                        ).toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Sunday',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tasksPerDay['Sunday']!
                            .map((task) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(task),
                        )
                        ).toList(),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}

class CustomnavigationDrawer extends StatelessWidget {
  const CustomnavigationDrawer({super.key});

  void _handleLogout(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
            title: Text('Log Out'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()
                    ),
                  );
                },
                child: Text('Log Out'),
              )
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget> [
          buildHeader(context),
          buildMenuItem(context),
          ],
      ),
    ),
  );

  Widget buildHeader(BuildContext context) => Container(
    color: Colors.green.shade700,
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    ),
    child: Column(
      children: [
        CircleAvatar(
          radius:52,
          backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1582266255765-fa5cf1a1d501?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Dave',
          style: TextStyle(fontSize: 28, color: Colors.black),
        )
      ],
    ),
  );

  Widget buildMenuItem(BuildContext context) => Column(
    children: [
      ListTile(
        leading: Icon(Icons.home_outlined),
        title: Text('Home'),
        onTap: () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(),
            )
        ),
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Settings'),
        onTap: () =>
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => SettingsPage(),
          )
        ),
      ),
      ListTile(
        leading: Icon(Icons.policy),
        title: Text('Terms & condition'),
        onTap: () =>
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Termsandcondition(),
          )
        ),
      ),
      ListTile(
        leading: Icon(Icons.logout),
        title: const Text(
          'Log Out',
          style:
          TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
        ),
        onTap: () => _handleLogout(context),
      ),
    ],
  );
}

