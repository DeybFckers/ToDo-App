import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/AddTask.dart';
import 'package:todo_list/LoginPage.dart';
import 'package:todo_list/SettingsPage.dart';
import 'package:todo_list/TermsAndCondition.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  final String uid;
  final String name;
  final String email;
  const HomePage({super.key, required this.uid, required this.name, required this.email,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore firebaseStore = FirebaseFirestore.instance;

  @override
  void initState(){
    super.initState();
    fetchTasks();
  }

  Map<String, List<Map<String, dynamic>>> tasksPerDay = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  Future<void> fetchTasks() async {

    try {
      QuerySnapshot snapshot = await firebaseStore
          .collection('todos')
          .where('userId', isEqualTo: widget.uid)
          .where('Done', isEqualTo: false)
          .get();

      Map<String, List<Map<String, dynamic>>> updatedTasks = {
        'Monday': [],
        'Tuesday': [],
        'Wednesday': [],
        'Thursday': [],
        'Friday': [],
        'Saturday': [],
        'Sunday': [],
      };

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // save document ID
        String day = data['Day'];
        if (updatedTasks.containsKey(day)) {
          updatedTasks[day]!.add(data);
        }
      }

      setState(() {
        tasksPerDay = updatedTasks;
      });
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

  void _editTask(Map<String, dynamic> task) {
    TextEditingController controller = TextEditingController(text: task['todoList']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Task'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              //Update Database
              await firebaseStore
                  .collection('todos')
                  .doc(task['id'])
                  .update({'todoList': controller.text});
              Navigator.pop(context);
              fetchTasks(); // refresh
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }


  void _deleteTask(Map<String, dynamic> task) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete the task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              //Delete Database
              await firebaseStore
                  .collection('todos')
                  .doc(task['id'])
                  .delete();
              Navigator.pop(context);
              fetchTasks(); // refresh
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  //Done
  void _toggleDone(Map<String, dynamic> task) async {
    final dynamic id = task['id'];
    final taskId = id is String ? id : id?.toString(); // Ensure it's a String
    final currentStatus = task['Done'] ?? false;

      await firebaseStore
          .collection('todos')
          .doc(taskId)
          .update({'Done': !currentStatus});

      fetchTasks();
  }





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

      endDrawer: CustomnavigationDrawer(
        uid: widget.uid,
        name: widget.name,
        email: widget.email),

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
                            text: 'Hi, ${widget.name}!\n',
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
                      onTap: () {
                        Get.offAll(()=> AddTaskPage(uid: widget.uid, name: widget.name, email: widget.email));
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Monday',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if(tasksPerDay['Monday']!.isNotEmpty)...[
                          IconButton(
                            onPressed: () {
                              for (var task in tasksPerDay['Monday']!) {
                                _editTask(task);
                                break;
                              }
                            },
                            icon: Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () {
                              for (var task in tasksPerDay['Monday']!) {
                                _deleteTask(task);
                                break;
                              }
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ]
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 16, left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tasksPerDay['Monday']!
                          .map((task) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(task['todoList'],),
                          )
                        ).toList(),
                      ),
                    ),
                    if(tasksPerDay['Monday']!.isNotEmpty)...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                for (var task in tasksPerDay['Monday']!) {
                                  _toggleDone(task);
                                  break;
                                }
                              },
                              icon: Icon(Icons.check, color: Colors.green)
                          ),
                        ],
                      )
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Tuesday',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if(tasksPerDay['Tuesday']!.isNotEmpty)...[
                          IconButton(
                            onPressed: () {
                              for (var task in tasksPerDay['Tuesday']!) {
                                _editTask(task); // or call dialog for first task only
                                break; // only one task to edit
                              }
                            },
                            icon: Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () {
                              for (var task in tasksPerDay['Monday']!) {
                                _deleteTask(task);
                                break;
                              }
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ]
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 16, left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tasksPerDay['Tuesday']!
                            .map((task) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(task['todoList'],),
                        )
                        ).toList(),
                      ),
                    ),
                    if(tasksPerDay['Tuesday']!.isNotEmpty)...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                for (var task in tasksPerDay['Tuesday']!) {
                                  _toggleDone(task);
                                  break;
                                }
                              },
                              icon: Icon(Icons.check, color: Colors.green)
                          ),
                        ],
                      )
                    ],

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Wednesday',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if(tasksPerDay['Wednesday']!.isNotEmpty)...[
                          IconButton(
                            onPressed: () {
                              for (var task in tasksPerDay['Wednesday']!) {
                                _editTask(task); // or call dialog for first task only
                                break; // only one task to edit
                              }
                            },
                            icon: Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () {
                              for (var task in tasksPerDay['Monday']!) {
                                _deleteTask(task);
                                break;
                              }
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ]
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 16, left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tasksPerDay['Wednesday']!
                            .map((task) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(task['todoList'],),
                        )
                        ).toList(),
                      ),
                    ),
                    if(tasksPerDay['Wednesday']!.isNotEmpty)...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                for (var task in tasksPerDay['Wednesday']!) {
                                  _toggleDone(task);
                                  break;
                                }
                              },
                              icon: Icon(Icons.check, color: Colors.green)
                          ),
                        ],
                      )
                    ],

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Thursday',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if(tasksPerDay['Thursday']!.isNotEmpty)...[
                          IconButton(
                            onPressed: () {
                              for (var task in tasksPerDay['Thursday']!) {
                                _editTask(task); // or call dialog for first task only
                                break; // only one task to edit
                              }
                            },
                            icon: Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () {
                              for (var task in tasksPerDay['Monday']!) {
                                _deleteTask(task);
                                break;
                              }
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ]
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 16, left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tasksPerDay['Thursday']!
                            .map((task) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(task['todoList'],),
                        )
                        ).toList(),
                      ),
                    ),
                    if(tasksPerDay['Thursday']!.isNotEmpty)...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                for (var task in tasksPerDay['Thursday']!) {
                                  _toggleDone(task);
                                  break;
                                }
                              },
                              icon: Icon(Icons.check, color: Colors.green)
                          ),
                        ],
                      )
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Friday',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if(tasksPerDay['Friday']!.isNotEmpty)...[
                          IconButton(
                            onPressed: () {
                              for (var task in tasksPerDay['Friday']!) {
                                _editTask(task); // or call dialog for first task only
                                break; // only one task to edit
                              }
                            },
                            icon: Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () {
                              for (var task in tasksPerDay['Monday']!) {
                                _deleteTask(task);
                                break;
                              }
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ]
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 16, left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tasksPerDay['Friday']!
                            .map((task) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(task['todoList'],),
                        )
                        ).toList(),
                      ),
                    ),
                    if(tasksPerDay['Friday']!.isNotEmpty)...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                for (var task in tasksPerDay['Friday']!) {
                                  _toggleDone(task);
                                  break;
                                }
                              },
                              icon: Icon(Icons.check, color: Colors.green)
                          ),
                        ],
                      )
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Saturday',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if(tasksPerDay['Saturday']!.isNotEmpty)...[
                          IconButton(
                            onPressed: () {
                              for (var task in tasksPerDay['Saturday']!) {
                                _editTask(task); // or call dialog for first task only
                                break; // only one task to edit
                              }
                            },
                            icon: Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () {
                              for (var task in tasksPerDay['Monday']!) {
                                _deleteTask(task);
                                break;
                              }
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ]
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 16, left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tasksPerDay['Saturday']!
                            .map((task) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(task['todoList'],),
                        )
                        ).toList(),
                      ),
                    ),
                    if(tasksPerDay['Saturday']!.isNotEmpty)...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                for (var task in tasksPerDay['Saturday']!) {
                                  _toggleDone(task);
                                  break;
                                }
                              },
                              icon: Icon(Icons.check, color: Colors.green)
                          ),
                        ],
                      )
                    ],
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Sunday',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if(tasksPerDay['Sunday']!.isNotEmpty)...[
                          IconButton(
                            onPressed: () {
                              for (var task in tasksPerDay['Sunday']!) {
                                _editTask(task);
                                break;
                              }
                            },
                            icon: Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () {
                              for (var task in tasksPerDay['Monday']!) {
                                _deleteTask(task);
                                break;
                              }
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ]
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 16, left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green, width: 2)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: tasksPerDay['Sunday']!
                            .map((task) => Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(task['todoList'],),
                        )
                        ).toList(),
                      ),
                    ),
                    if(tasksPerDay['Sunday']!.isNotEmpty)...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                for (var task in tasksPerDay['Sunday']!) {
                                  _toggleDone(task);
                                  break;
                                }
                              },
                              icon: Icon(Icons.check, color: Colors.green)
                          ),
                        ],
                      )
                    ],
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
  final String uid;
  final String name;
  final String email;

  const CustomnavigationDrawer({
    super.key,
    required this.uid,
    required this.name,
    required this.email,
  });

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
                  Navigator.pop(context);
                  Get.offAll(() => LoginPage());
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
          name,
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        SizedBox(height: 12),
        Text(
          email,
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        SizedBox(height: 12),
      ],
    ),
  );

  Widget buildMenuItem(BuildContext context) => Column(
    children: [
      ListTile(
        leading: Icon(Icons.home_outlined),
        title: Text('Home'),
        onTap: () {
          Navigator.pop(context);
          Get.off(() => HomePage(
              uid: uid, name: name, email: email)
          );
        },
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Settings'),
        onTap: () {
          Navigator.pop(context);
          Get.off(() => SettingsPage(
              uid: uid, name: name, email: email)
          );
        },
      ),
      ListTile(
        leading: Icon(Icons.policy),
        title: Text('Terms & condition'),
        onTap: () {
          Navigator.pop(context);
          Get.off(() => Termsandcondition(
              uid: uid, name: name, email: email)
          );
        },
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

