import 'package:flutter/material.dart';
import 'package:todo_list/SignupPage.dart';
import 'package:get/get.dart';
import 'package:todo_list/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  static route () =>  MaterialPageRoute(
    builder: (context) => const LoginPage(),
  );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _secureText = true;
  bool circular = false;


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Centered content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'To-Do List',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              //Text-form Size
                              contentPadding:  EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                            },
                          ),
                           SizedBox(height: 20),
                          TextFormField(
                            controller: passwordController,
                            obscureText: _secureText,
                            decoration: InputDecoration(
                              //text-form size
                              contentPadding:  EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 16),
                              labelText: 'Password',
                              prefixIcon:  Icon(Icons.key),
                              suffixIcon: passwordController.text.isNotEmpty
                                  ? IconButton(
                                icon: Icon(_secureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _secureText = !_secureText;
                                  });
                                },
                              )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () async  {
                              setState(() {
                                circular = true;
                              });
                              if(formKey.currentState!.validate()){
                                try{
                                  UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
                                      email: emailController.text ,
                                      password: passwordController.text);

                                  User? user = userCredential.user;

                                  final userDoc = await firebaseStore
                                  .collection('users')
                                  .doc(user!.uid)
                                  .get();

                                  String name = userDoc.data()?['Name']??'';
                                  String email = userDoc.data()?['Email']??'';

                                  Get.offAll(() => HomePage(
                                    uid:user.uid,
                                    name: name,
                                    email: email,
                                  ));
                                  circular = false;

                                } catch (e) {
                                  final snackBar = SnackBar(content: Text(e.toString()));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  setState(() {
                                    circular = false;
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[500],
                              fixedSize: Size(415, 55),
                            ),
                            child:  circular ? CircularProgressIndicator() :
                                Text('Login',
                                style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom button
          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => Signuppage());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                fixedSize: const Size(415, 55),
                side: BorderSide(color: Colors.green, width: 2),
              ),
              child: Text(
                'Create new account',
                style: TextStyle(color: Colors.green[500]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}