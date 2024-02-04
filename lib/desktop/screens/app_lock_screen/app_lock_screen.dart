import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  bool isActive = false;

  double cHeight = 90;

  bool isVisible = false;

  String currentPassword = '';

  var lockStateRef = Hive.box('lock_state');
  var lockScreenPassword = Hive.box('lock_screen_password_database');

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController retypeNewPasswordController = TextEditingController();

  void visibilityFun() {
    // get database ref

    Map<dynamic, dynamic> lockStateMap = {'lockState': isActive};
    lockStateRef.putAt(0, lockStateMap);
    Future.delayed(
      isVisible ? const Duration(seconds: 0) : const Duration(seconds: 1),
      () {
        setState(() {
          isVisible = !isVisible;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLocked = lockStateRef.values.first['lockState'];

    if (isLocked == true) {
      isActive = true;
      cHeight = 350;
      currentPassword = lockScreenPassword.values.first['password'];
      Future.delayed(
        isVisible ? const Duration(seconds: 0) : const Duration(seconds: 1),
        () {
          setState(() {
            isVisible = true;
          });
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'APP LOCK',
          style: TextStyle(
              fontSize: 21,
              color: Colors.orange.shade100,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.orange.shade100),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceOut,
              padding: const EdgeInsets.all(10.0),
              width: 400,
              height: cHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade600),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                        isActive ? 'Turn off app lock' : 'Turn on app lock'),
                    trailing: Switch(
                      value: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value;
                          cHeight = isActive ? 350 : 90;
                          visibilityFun();
                        });
                      },
                      activeColor: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Visibility(
                    visible: isVisible,
                    child: Column(
                      children: [
                        Text(
                          'Change password',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: currentPasswordController,
                          decoration: InputDecoration(
                              label: const Text('Current password'),
                              errorText: null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.orange.shade100)),
                              enabled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.orange.shade100)),
                              prefixIcon: Icon(
                                Icons.person_outlined,
                                color: Colors.orange.shade100,
                              )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: newPasswordController,
                          decoration: InputDecoration(
                              label: const Text('New password'),
                              errorText: null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.orange.shade100)),
                              enabled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.orange.shade100)),
                              prefixIcon: Icon(
                                Icons.person_outlined,
                                color: Colors.orange.shade100,
                              )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: retypeNewPasswordController,
                          decoration: InputDecoration(
                              label: const Text('Re-type password'),
                              errorText: null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.orange.shade100)),
                              enabled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.orange.shade100)),
                              prefixIcon: Icon(
                                Icons.person_outlined,
                                color: Colors.orange.shade100,
                              )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Save changes'),
                          onPressed: () {
                            if (currentPasswordController.text.isEmpty ||
                                newPasswordController.text.isEmpty ||
                                retypeNewPasswordController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Center(
                                  child: Text(
                                    "Please fill all fields",
                                    style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ),
                                backgroundColor: Colors.black,
                                behavior: SnackBarBehavior.floating,
                              ));
                            } else {
                              if(currentPassword != currentPasswordController.text) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Center(
                                    child: Text(
                                      "Old password not correct",
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ),
                                  backgroundColor: Colors.black,
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                              else if(newPasswordController.text != retypeNewPasswordController.text) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Center(
                                    child: Text(
                                      "New password and re-type password not match",
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ),
                                  backgroundColor: Colors.black,
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                              else {


                                Map<dynamic,dynamic> updatedPasswordMap = {
                                  'password' : newPasswordController.text,
                                  'masterKey': lockScreenPassword.values.first['masterKey']
                                };

                                lockScreenPassword.putAt(0, updatedPasswordMap);

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Center(
                                    child: Text(
                                      "Password updated successfully",
                                      style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ),
                                  backgroundColor: Colors.black,
                                  behavior: SnackBarBehavior.floating,
                                ));
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
