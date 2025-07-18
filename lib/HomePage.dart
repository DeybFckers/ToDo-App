import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/AddTask.dart';

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
      endDrawer: NavigationDrawer(),
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

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer();
}

