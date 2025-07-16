import 'package:flutter/material.dart';
import 'package:todo_list/LoginPage.dart';
import 'package:get/get.dart';

class Signuppage extends StatefulWidget {
  static route () =>  MaterialPageRoute(
    builder: (context) => const Signuppage(),
  );
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _secureText = true;

  void dispose (){
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.only(top: 200),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Create an account',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )
              ),
              SizedBox(height: 20,),
              Form(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          //Text-form Size
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          prefixIcon: const Icon(Icons.person),
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your Name";
                          }
                        },
                      ),
                      SizedBox(height:20),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          //Text-form Size
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          prefixIcon: const Icon(Icons.email),
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your Email";
                          }
                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _secureText,
                        decoration: InputDecoration(
                          //text-form size
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.key),
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
                            return "Please enter your Password";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      SizedBox(height:20),
                      ElevatedButton(
                        onPressed: () {
                          print("Your Name:" + nameController.text,);
                          print("Your Email:" + emailController.text,);
                          print("Your Password:" + passwordController.text,);
                          Get.off(() => LoginPage());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[500],
                          fixedSize: Size(415, 55),
                        ),
                        child: const Text('Sign Up',
                            style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(height:20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, LoginPage.route());
                        },
                        child: RichText(
                            text: TextSpan(
                                text: ("Already have an account? "),
                                style: Theme.of(context).textTheme.titleMedium,
                                children: [
                                  TextSpan(
                                      text: 'Sign In',
                                      style:Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.green[900],
                                        fontWeight: FontWeight.bold,
                                      )
                                  )
                                ]
                            )
                        ),
                      )
                    ],
                  ),
                )
              )
            ],
          )
        ),
      )
    );
  }
}
