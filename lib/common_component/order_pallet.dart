import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_pos/cubits/table_cubit/table_cubit.dart';

class OrderPallet extends StatelessWidget {
  const OrderPallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      decoration: BoxDecoration(
          border: Border(
        left: BorderSide(color: Colors.grey.shade600, width: 1),
        top: BorderSide(color: Colors.grey.shade600, width: 1),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // order text
          Text(
            'ORDER #',
            style: GoogleFonts.varelaRound(
              fontSize: 27,
              color: Colors.grey[300],
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),

          const SizedBox(
            height: 25,
          ),

          // table no and gust no
          Container(
            padding: const EdgeInsets.only(bottom: 15, right: 25),
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.grey.shade600, width: 1),
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // table number
                Row(
                  children: [
                    Icon(
                      Icons.table_bar_outlined,
                      color: Colors.orange[100],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    BlocBuilder<SelectedItemCubit, int>(
                      builder: (context, selectedItem) {
                        return Text('TABLE:$selectedItem');
                      },
                    )
                  ],
                ),

                // gust number
                Row(
                  children: [
                    Icon(Icons.people_alt_outlined,
                        color: Colors.orange[100]),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text('GUEST:')
                  ],
                ),
              ],
            ),
          ),

          // order list for table
          Expanded(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/fast-food.png',
                  scale: 5,
                  color: Colors.deepOrange,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'NO PRODUCTS IN THIS\nMOMENT ADDED',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.varelaRound(
                    fontSize: 10,
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
