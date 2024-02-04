import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DynamicTab extends StatelessWidget {
  final List<dynamic> foodList;
  const DynamicTab({super.key, required this.foodList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: foodList.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.2/1.3,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[600],
          ),
          child: Column(
            children: [

              // food image
              Expanded(
                flex: 2,
                child: SizedBox(
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        topLeft: Radius.circular(8.0)
                      ),
                      child: Image.asset(
                        foodList[index]['foodImage'],
                        fit: BoxFit.cover,
                      ),
                    )),
              ),

              // food details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // food name
                      Text(foodList[index]['foodName'], style: GoogleFonts.varelaRound(
                        fontSize: 19,
                        color: Colors.orange.shade100
                      ),),

                      // food category
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('PRICE: ' ,style: GoogleFonts.varelaRound(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),),
                              const SizedBox(width: 4,),
                              Text('\$${foodList[index]['price']}', style: GoogleFonts.varelaRound(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),)
                            ],
                          ),

                          ElevatedButton(onPressed: (){
                          }, child: const Text('ADD'))
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
