import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_pos/cubits/more_function_cubits/more_cubit.dart';

class MoreTab extends StatelessWidget {
  MoreTab({super.key});

  List<dynamic> moreList = [
    {
      'icon': 'assets/icons/cashier.png',
      'title': 'SALES REGISTER',
      'route': '/s-register'
    },
    {
      'icon': 'assets/icons/wine.png',
      'title': 'PRODUCT LISTING',
      'route': '/p-listing'
    },
    {
      'icon': 'assets/icons/display.png',
      'title': 'KITCHEN DISPLAY',
      'route': '/k-display'
    },
    {
      'icon': 'assets/icons/dashboard.png',
      'title': 'REPORTS',
      'route': '/reports'
    },
    {
      'icon': 'assets/icons/employee.png',
      'title': 'EMPLOYEE',
      'route': '/employee'
    },
    {
      'icon': 'assets/icons/refund.png',
      'title': 'RETURN',
      'route': '/return'
    },
    {
      'icon': 'assets/icons/setting.png',
      'title': 'SETTINGS',
      'route': '/settings'
    },
    {
      'icon': 'assets/icons/excel.png',
      'title': 'POS sheet',
      'route': '/pos-sheet-home'
    },

  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HoverCubit(),
      child: Container(
          padding: const EdgeInsets.all(70),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade600,
            ),
            borderRadius: BorderRadius.circular(7),
          ),

          child: GridView.builder(
            itemCount: moreList.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1.7 / 1,
            ),
            itemBuilder: (context, index) {
              return BlocProvider(
                create: (context) => HoverCubit(),
                child: Builder(
                  builder: (context) {
                    return InkWell(
                      onHover: (value) {
                        BlocProvider.of<HoverCubit>(context).onHoverChange(isHovered: value);
                      },
                      onTap: () {
                        Navigator.pushNamed(context, moreList[index]['route'].toString());
                      },
                      child: BlocBuilder<HoverCubit, bool>(
                        builder: (context, isHovered) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.orange.shade100),
                              borderRadius: BorderRadius.circular(7),
                              color: isHovered ? Colors.grey[800] : Colors.transparent,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    moreList[index]['icon'],
                                    height: 70,
                                    color: Colors.orange.shade100,
                                  ),
                                  const SizedBox(height: 15,),
                                  Text(
                                    moreList[index]['title'],
                                    style: GoogleFonts.varelaRound(
                                      color: Colors.orange.shade100,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          )

      ),
    );
  }
}
