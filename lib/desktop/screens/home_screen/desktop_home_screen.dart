import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_pos/cubits/database_cubit/db_cubit.dart';
import 'package:restaurant_pos/cubits/menu_tab_cubit/menu_tab_cubit.dart';
import 'package:restaurant_pos/cubits/payment_cubit/payment_cubit.dart';
import 'package:restaurant_pos/cubits/tab_cubit.dart';
import 'package:restaurant_pos/desktop/components/desktop_appbar.dart';
import 'package:restaurant_pos/desktop/tabs/home_tab/home_tab.dart';
import 'package:restaurant_pos/desktop/tabs/menu_tab/menu_tab.dart';
import 'package:restaurant_pos/desktop/tabs/more_tab/more_tab.dart';
import 'package:restaurant_pos/desktop/tabs/payment_tab/payment_tab.dart';
import 'package:vertical_tabs_flutter/vertical_tabs.dart';

class DesktopHomeScreen extends StatelessWidget {
  DesktopHomeScreen({super.key});

  double horizontalPadding = 25;
  double verticalPadding = 15;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //custom appbar
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              child: BlocProvider(
                create: (context) => DbCubit(),
                child: DesktopAppbar(),
              ),
            ),

            // main body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [

                    // vertical tab
                    Expanded(
                      flex: 2,
                      child: VerticalTabs(
                        // selectedTabBackgroundColor: Colors.grey.shade700,

                        indicatorSide: IndicatorSide.start,
                        tabBackgroundColor: Colors.transparent,
                        tabsWidth: 150,
                        tabs: [
                          Tab(
                            child: Center(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/icons/home.png',
                                      height: 20,
                                      color: Colors.orange.shade100,
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      'HOME',
                                      style: GoogleFonts.varelaRound(
                                          fontSize: 14,
                                          letterSpacing: 3,
                                          color: Colors.orange.shade100),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: Center(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    Image.asset('assets/icons/menu-2.png',
                                        height: 20,
                                        color: Colors.orange.shade100),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      'MENU',
                                      style: GoogleFonts.varelaRound(
                                          fontSize: 14,
                                          letterSpacing: 3,
                                          color: Colors.orange.shade100),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: Center(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    Image.asset(
                                        'assets/icons/payment-protection.png',
                                        height: 20,
                                        color: Colors.orange.shade100),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      'PAYMENT',
                                      style: GoogleFonts.varelaRound(
                                          fontSize: 14,
                                          letterSpacing: 3,
                                          color: Colors.orange.shade100),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Tab(
                            child: Center(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    Image.asset(
                                        'assets/icons/app.png',
                                        height: 20,
                                        color: Colors.orange.shade100),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      'MORE',
                                      style: GoogleFonts.varelaRound(
                                          fontSize: 14,
                                          letterSpacing: 3,
                                          color: Colors.orange.shade100),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                        contents: [
                          HomeTab(),
                          MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => MenuTabCubit(),
                              ),
                              BlocProvider(
                                create: (context) => FoodMenuTabCubit(),
                              ),
                            ],
                            child: const MenuTab(),
                          ),
                          MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => PaymentCubit(),
                              ),
                              BlocProvider(
                                create: (context) => PaymentAddTipCubit(),
                              ),BlocProvider(
                                create: (context) => PaymentMethodCubit(),
                              ),
                            ],
                            child: PaymentTab(),
                          ),
                          MoreTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
