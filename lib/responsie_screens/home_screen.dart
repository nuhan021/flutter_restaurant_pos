import 'package:flutter/material.dart';
import 'package:restaurant_pos/mobile/screens/mobile_home_screen.dart';
import 'package:restaurant_pos/tablet/screens/tablet_home_screen.dart';

import '../desktop/screens/home_screen/desktop_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // if (constraints.maxWidth < 500) {
        //   return const MobileHomeScreen();
        // } else if (constraints.maxWidth < 1150) {
        //   return const TabletHomeScreen();
        // } else {
        //   return DesktopHomeScreen();
        // }

        return DesktopHomeScreen();
      },
    );
  }
}
