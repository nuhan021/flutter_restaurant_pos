import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:restaurant_pos/routes/routes.dart';
import 'const.dart';
import 'package:desktop_window/desktop_window.dart';
import 'dart:ui' as ui;

void main() async {
  //initialize hive
  await Hive.initFlutter();

  //open database box
  tableBox = await Hive.openBox('res_table');
  foodItemBox = await Hive.openBox('food_items');
  foodSectionBox = await Hive.openBox('food_section');
  orderHistoryBox = await Hive.openBox('order_history');
  employeeData = await Hive.openBox('employee_data');
  employeePosition = await Hive.openBox('employee_position');
  posSheetDatabase = await Hive.openBox('pos_sheet_database');
  lockScreenPassword = await Hive.openBox('lock_screen_password_database');
  lockState = await Hive.openBox('lock_state');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  bool isLocked = true;

  var lockStateRef = Hive.box('lock_state');
  var lockScreenPassword = Hive.box('lock_screen_password_database');

  @override
  Widget build(BuildContext context) {
    // if something error
    // then remove those 2 if conditionn
    //*____________________________________________
    if (lockScreenPassword.values.isEmpty) {
      Map<dynamic, dynamic> passMap = {
        'password': '0000',
        'masterKey': '01609038329'
      };
      lockScreenPassword.add(passMap);
    }

    if (lockStateRef.values.isEmpty) {
      Map<dynamic, dynamic> lockStateMap = {'lockState': true};
      lockStateRef.add(lockStateMap);
    }
    //*____________________________________________

    isLocked = lockStateRef.getAt(0)['lockState'];

    // DesktopWindow.setWindowSize(const Size(1200, 600));
    DesktopWindow.setMinWindowSize(const Size(1200, 600));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepOrange, brightness: Brightness.dark),
      onGenerateRoute: Routes().onGenerateRoute,
      initialRoute: isLocked ? '/lock-screen' : '/home',
    );
  }
}
