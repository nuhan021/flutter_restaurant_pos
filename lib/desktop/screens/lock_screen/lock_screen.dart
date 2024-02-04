import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';

class LockScreen extends StatelessWidget {
  LockScreen({super.key});

  var lockScreenPassword = Hive.box('lock_screen_password_database');
  String? masterKey;
  String? password;

  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;




  @override
  Widget build(BuildContext context) {
    masterKey = lockScreenPassword.values.first['masterKey'];
    password = lockScreenPassword.values.first['password'];

    void checkPassword({required String givenPassword}) {
      if(givenPassword == password) {
        Navigator.pushReplacementNamed(context , '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(child: Text('Password wrong',style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.red),)),
            backgroundColor: Colors.black,
            behavior: SnackBarBehavior.floating,
          )
        );
      }
    }
    return Scaffold(
      // appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            color: Colors.deepOrange,
            width: double.infinity,
              height: double.infinity,
              child: Lottie.asset(
                  'assets/animation/lockScreen.json',
                fit: BoxFit.contain,
              )),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 50,
            left: MediaQuery.of(context).size.width / 2 - 200,
            child: Container(
              padding: const EdgeInsets.all(10),
              height: 100,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white54
                ),
                color: Colors.white.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 15,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: TextField(
                  controller: passwordController,
                  obscureText: _obscureText,
                  obscuringCharacter: '*',
                  style: const TextStyle(
                    color: Colors.black
                  ),
                  decoration: InputDecoration(
                      label: const Text('password'),
                      labelStyle: const TextStyle(color: Colors.white),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white
                        )
                      ),
                      prefixIcon: Icon(
                        Icons.person_outlined,
                        color: Colors.orange.shade100,
                      ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        String givenPassword = passwordController.text;
                        checkPassword(givenPassword: givenPassword);
                      },
                      icon: const Icon(Icons.arrow_circle_right_outlined, color: Colors.white54,),
                    ),
                  ),
                  onSubmitted: (value) {
                    checkPassword(givenPassword: value);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
