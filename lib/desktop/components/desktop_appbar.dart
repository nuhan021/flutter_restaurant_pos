import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_pos/cubits/database_cubit/db_cubit.dart';

class DesktopAppbar extends StatelessWidget {
  DesktopAppbar({super.key});

  DateTime dateTime = DateTime.now();


  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // logo text
            Text(
              'P O S',
              style: GoogleFonts.varelaRound(
                  color: Colors.deepOrange,
                  fontSize: 45,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(
              width: 60,
            ),

            // // search bar
            // const Padding(
            //   padding: EdgeInsets.only(left: 120),
            //   child: SizedBox(
            //       width: 300,
            //       child: MyTextField(
            //         hintText: 'Search product or any other...',
            //         myIcon: Icon(Icons.search_rounded),
            //       )),
            // )
            Row(
              children: [
                // date and time
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_sharp,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '${dateTime.year}-${dateTime.month}-${dateTime.day}',
                        style: GoogleFonts.varelaRound(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // add table button
                SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<DbCubit>(context).addTable();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_circle_outline),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'ADD TABLE',
                            style: GoogleFonts.varelaRound(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )),

                const SizedBox(
                  width: 10,
                ),

                SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<DbCubit>(context).deleteTable();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_circle_outline),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'REMOVE TABLE',
                            style: GoogleFonts.varelaRound(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ],
        ),
        IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/lock-screen');
            },
            tooltip: 'Lock',
            icon: Icon(
              Icons.lock_outline,
              color: Colors.deepOrange,
            ))
      ],
    );
  }
}
