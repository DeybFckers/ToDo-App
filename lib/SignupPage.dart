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
  PasswordStrength? _passwordStrength;
  bool _showPasswordInstructions = false;

  void dispose (){
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void initState(){
    super.initState();
    passwordController.addListener((){
      final text = passwordController.text;
      final strength = PasswordStrength.calculate(text: passwordController.text);
      setState(() {
        _passwordStrength = strength;
        _showPasswordInstructions = text.isNotEmpty;
      });
    });
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
                key: formKey,
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
                        validator: (value){
                          if (value == null || value.isEmpty) {
                            return "Please enter your Name";
                          }
                          return null;
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
                        // EMAIL VALIDATOR
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your Email";
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if(!emailRegex.hasMatch(value)){
                            return "Enter a valid email address";
                          }
                          return null;
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
                      if (_showPasswordInstructions) ...[
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: PasswordStrength.buildInstructionChecklist(passwordController.text),
                        ),
                      ],
                      if (_passwordStrength != null) ... [
                        const SizedBox(height:10),
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds:300),
                              height: 8,
                              width: 300 * _passwordStrength!.widthPerc,
                              decoration: BoxDecoration(
                                color: _passwordStrength!.statusColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(width:2),
                            _passwordStrength!.statusWidget ?? const SizedBox(),
                          ],
                        )
                      ],
                      SizedBox(height:20),
                      ElevatedButton(
                        onPressed: () {
                          if(formKey.currentState!.validate()){
                            Get.off(() => LoginPage());
                          }
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

const int kDefaultStrengthLength = 8;

abstract class PasswordStrengthItem{
  Color get statusColor;
  double get widthPerc;
  Widget? get statusWidget => null;

}

enum PasswordStrength implements PasswordStrengthItem {
  weak,
  medium,
  strong,
  secure;

  @override
  Color get statusColor {
    switch (this) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.green;
      case PasswordStrength.secure:
        return const Color(0xFF0B6C0E);
      default:
        return Colors.red;
    }
  }

  double get widthPerc{
    switch(this){
      case PasswordStrength.weak:
        return 0.15;
      case PasswordStrength.medium:
        return 0.4;
      case PasswordStrength.strong:
        return 0.75;
      case PasswordStrength.secure:
        return 1.0;
    }
  }

  Widget? get statusWidget{
    switch (this){
      case PasswordStrength.weak:
        return const Text('Weak');
      case PasswordStrength.medium:
        return const Text('Medium');
      case PasswordStrength.strong:
        return const Text('Strong');
      case PasswordStrength.secure:
        return Row(
          children: [
            const Text('Secure'),
            const SizedBox(width: 5),
            Icon(Icons.check_circle, color: statusColor)
          ],
        );
      default:
        return null;
    }
  }

  static PasswordStrength? calculate({required String text}){
    if (text.isEmpty){
      return null;
    }
    if (text.length < kDefaultStrengthLength){
      return PasswordStrength.weak;
    }

    var counter = 0;
    if (text.contains(RegExp(r'[a-z]'))) counter++;
    if (text.contains(RegExp(r'[A-Z]'))) counter++;
    if (text.contains(RegExp(r'[0-9]'))) counter++;
    if (text.contains(RegExp(r'[!@#\$%&*()?£\-_=]'))) counter++;

    switch (counter){
      case 1:
        return PasswordStrength.weak;
      case 2:
        return PasswordStrength.medium;
      case 3:
        return PasswordStrength.strong;
      case 4:
        return PasswordStrength.secure;
      default:
        return PasswordStrength.weak;
    }
  }
  static List<Widget> buildInstructionChecklist(String text) {
    final rules = <Map<String, bool>>[
      {
        'At least $kDefaultStrengthLength characters': text.length >= kDefaultStrengthLength,
      },
      {
        'At least 1 lowercase letter': RegExp(r'[a-z]').hasMatch(text),
      },
      {
        'At least 1 uppercase letter': RegExp(r'[A-Z]').hasMatch(text),
      },
      {
        'At least 1 digit': RegExp(r'[0-9]').hasMatch(text),
      },
      {
        'At least 1 special character': RegExp(r'[!@#\$%&*()?£\-_=]').hasMatch(text),
      },
    ];

    return rules.map((rule) {
      final text = rule.keys.first;
      final passed = rule.values.first;
      return Row(
        children: [
          Icon(
            passed ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 18,
            color: passed ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: passed ? Colors.green[800] : Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      );
    }).toList();
  }
}