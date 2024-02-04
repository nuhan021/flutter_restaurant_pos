import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_pos/cubits/menu_tab_cubit/menu_tab_cubit.dart';
import 'package:restaurant_pos/cubits/menu_tab_cubit/menu_tab_state.dart';

import '../../../cubits/tab_cubit.dart';

class MenuTab extends StatefulWidget {
  const MenuTab({super.key});

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  List orders = [];

  // tab list
  List<Widget> tabViews = [];

  // food section list
  List<dynamic> sections = [];

  // food item list
  List<dynamic> foodItemList = [];

// table list
  List tableDataList = [];
  List<String> tableList = [];
  String? selectedValue;
  int? selectedValueGuestNumb;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final MenuTabCubit tabCubit = BlocProvider.of<MenuTabCubit>(context);

    return Row(
      children: [
        Expanded(
          flex: 11,
          child: BlocBuilder<FoodMenuTabCubit, MenuTabState>(
            builder: (context, state) {
              if (state is MenuTabGetFoodSectionState) {
                sections = state.foodSection.toList();
                foodItemList = state.foodList.toList();
                tableDataList = state.tableList.toList();

                if (tableList.isEmpty) {
                  for (int i = 0; i < tableDataList.length; i++) {
                    tableList.add(tableDataList[i]['title']);
                  }
                }

                List<Tab> generatedTabs = sections
                    .map((section) => Tab(
                          text: section,
                        ))
                    .toList();
                for (int i = 0; i < sections.length; i++) {
                  List foodItems = [];
                  for (var item in foodItemList) {
                    if (item['section'] == sections[i]) {
                      foodItems.add(item);
                    }
                  }
                  tabViews.add(GridView.builder(
                    itemCount: foodItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 280,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.2 / 1.3,
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
                                        topLeft: Radius.circular(8.0)),
                                    child: Image.asset(
                                      foodItems[index]['foodImage'],
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ),

                            // food details
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // food name
                                    FittedBox(
                                      child: Text(
                                        foodItems[index]['foodName'],
                                        style: GoogleFonts.varelaRound(
                                            fontSize: 19,
                                            color: Colors.orange.shade100),
                                      ),
                                    ),

                                    // food category
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'PRICE: ',
                                              style: GoogleFonts.varelaRound(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              '\$${foodItems[index]['price']}',
                                              style: GoogleFonts.varelaRound(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              if (selectedIndex == null) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Center(
                                                      child: Text(
                                                    'Please select a table!',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 21),
                                                  )),
                                                  backgroundColor: Colors.red,
                                                  duration:
                                                      Duration(seconds: 2),
                                                ));
                                              } else if (selectedValueGuestNumb ==
                                                  0) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        const SnackBar(
                                                  content: Center(
                                                      child: Text(
                                                    'This table has no guest!',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 21),
                                                  )),
                                                  backgroundColor: Colors.red,
                                                  duration:
                                                      Duration(seconds: 2),
                                                ));
                                              } else {
                                                BlocProvider.of<
                                                            FoodMenuTabCubit>(
                                                        context)
                                                    .addTableFood(
                                                        index: selectedIndex,
                                                        foodName:
                                                            foodItems[index]
                                                                ['foodName'],
                                                        foodImage:
                                                            foodItems[index]
                                                                ['foodImage'],
                                                        price: foodItems[index]
                                                            ['price']);
                                              }
                                            },
                                            child: const Text('ADD'))
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
                  ));
                }
                return DefaultTabController(
                  length: sections.length,
                  child: Column(
                    children: [
                      //food items
                      Expanded(
                          flex: 9,
                          child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border: Border(
                                top: BorderSide(color: Colors.grey.shade600),
                                bottom: BorderSide(color: Colors.grey.shade600),
                                left: BorderSide(color: Colors.grey.shade600),
                              )),
                              child: BlocBuilder<MenuTabCubit, int>(
                                builder: (context, tabIndex) {
                                  return IndexedStack(
                                    index: tabIndex,
                                    children: tabViews,
                                  );
                                },
                              ))),

                      // food items tab bar
                      Expanded(
                          child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                  color: Colors.grey.shade600,
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: Colors.grey.shade600,
                                  width: 1,
                                ))),
                        child: TabBar(
                          unselectedLabelColor: Colors.orange.shade100,
                          labelColor: Colors.deepOrange,
                          indicatorColor: Colors.deepOrange,
                          indicatorWeight: 4,
                          isScrollable: true,
                          labelStyle: GoogleFonts.varelaRound(
                              fontSize: 17, fontWeight: FontWeight.bold),
                          unselectedLabelStyle: GoogleFonts.varelaRound(
                            fontSize: 17,
                          ),
                          tabs: generatedTabs,
                          onTap: (index) {
                            tabCubit.setTabIndex(index);
                          },
                        ),
                      )),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),

        // order pallet
        Expanded(
            flex: 4,
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade600, width: 1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // order text
                  FittedBox(
                    child: Text(
                      'ORDER # 12345',
                      style: GoogleFonts.varelaRound(
                        fontSize: 27,
                        color: Colors.grey[300],
                        letterSpacing: 3,
                      ),
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
                      bottom: BorderSide(
                        color: Colors.grey.shade600,
                        width: 1,
                      ),
                    )),
                    child: Column(
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
                            Row(
                              children: [
                                Text('TABLE: $selectedValue'),
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  itemBuilder: (context) {
                                    return tableList
                                        .map(
                                          (option) => PopupMenuItem<String>(
                                            value: option,
                                            child: Row(
                                              children: [
                                                Text(option)
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList();
                                  },
                                  onSelected: (value) {
                                    setState(() {
                                      selectedValue = value;
                                      for (int i = 0;
                                          i < tableDataList.length;
                                          i++) {
                                        if (tableDataList[i]['title'] ==
                                            value) {
                                          selectedValueGuestNumb =
                                              tableDataList[i]['guest'];
                                          orders =
                                              tableDataList[i]['orderList'];
                                          selectedIndex = i;
                                        }
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
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
                            Text('GUEST: $selectedValueGuestNumb')
                          ],
                        ),
                      ],
                    ),
                  ),

                  // order list for table
                  Expanded(
                      child: Center(
                    child: Column(
                      children: [
                        // food items

                        BlocBuilder<FoodMenuTabCubit, MenuTabState>(
                          builder: (context, state) {
                            if (state is MenuTabGetFoodSectionState) {
                              return Expanded(
                                  child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: ListView.separated(
                                  itemCount: orders.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 20,
                                  ),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.orange.shade100,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      height: 80,
                                      width: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // image of item
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(orders[index]
                                                      ['foodImage']
                                                  .toString())),

                                          // item name and price
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // item name
                                                  Text(
                                                    orders[index]['foodName'],
                                                    overflow: TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.varelaRound(
                                                            fontSize: 16,
                                                            color: Colors
                                                                .grey[900]),
                                                  ),

                                                  //item price
                                                  Text(
                                                    '\$${orders[index]['totalPrice']}',
                                                    style:
                                                        GoogleFonts.varelaRound(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[900]),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),

                                          // quantity
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Quantity',
                                                style: GoogleFonts.varelaRound(
                                                    fontSize: 16,
                                                    color: Colors.grey[900]),
                                              ),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      BlocProvider.of<
                                                                  FoodMenuTabCubit>(
                                                              context)
                                                          .increaseFoodItem(
                                                              index: index,
                                                              selectedTableIndex:
                                                                  selectedIndex!);
                                                    },
                                                    child: Icon(Icons.add,
                                                        size: 20,
                                                        color:
                                                            Colors.grey[900]),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    child: Text(
                                                      orders[index]['quantity']
                                                          .toString(),
                                                      style: GoogleFonts
                                                          .varelaRound(
                                                              fontSize: 21,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .grey[900]),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      BlocProvider.of<
                                                                  FoodMenuTabCubit>(
                                                              context)
                                                          .removeTableFood(
                                                              index: index,
                                                              selectedTableIndex:
                                                                  selectedIndex!);
                                                    },
                                                    child: Icon(Icons.remove,
                                                        size: 20,
                                                        color:
                                                            Colors.grey[900]),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ));
                            }
                            return Container();
                          },
                        ),

                        // billing section
                        BlocBuilder<FoodMenuTabCubit, MenuTabState>(
                          builder: (context, state) {
                            // subtotal of all food item and based on item quantity
                            int? subtotal = 0;
                            // get each food item totalPrice based on item quantity
                            // and combine then in subtotal variable
                            for (var element in orders) {
                              subtotal =
                                  (subtotal! + element['totalPrice']) as int?;
                            }
                            // calculate 10% vat based on subtotal
                            int serviceCharge =
                                (10 * (subtotal! / 100)).round();
                            // add subtotal and service charge to get total bill amount
                            int total = subtotal + serviceCharge;
                            return Expanded(
                                child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade600,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // subtotal
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'SUBTOTAL',
                                              style: GoogleFonts.varelaRound(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              '\$${subtotal.toString()}',
                                              style: GoogleFonts.varelaRound(
                                                  fontSize: 16),
                                            )
                                          ],
                                        ),

                                        // service charge
                                        FittedBox(
                                          child: Text(
                                            'SERVICE CHARGE 10% : ${serviceCharge.toString()}',
                                            style: GoogleFonts.varelaRound(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'TOTAL',
                                                  style:
                                                      GoogleFonts.varelaRound(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                Text(
                                                  '\$${total.toString()}',
                                                  style:
                                                      GoogleFonts.varelaRound(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                )
                                              ],
                                            ),

                                            const SizedBox(
                                              height: 20,
                                            ),

                                            // buttons
                                            Column(
                                              children: [
                                                // cancel button
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      if (selectedIndex ==
                                                          null) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Center(
                                                            child: Text(
                                                              'Please select a table',
                                                              style: TextStyle(
                                                                  fontSize: 21,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              Colors.red,
                                                          duration: Duration(
                                                              seconds: 2),
                                                        ));
                                                      } else {
                                                        if (orders.isEmpty) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                            content: Center(
                                                              child: Text(
                                                                'Please add item first',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        21,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                Colors.red,
                                                            duration: Duration(
                                                                seconds: 2),
                                                          ));
                                                        } else {
                                                          BlocProvider.of<
                                                                      FoodMenuTabCubit>(
                                                                  context)
                                                              .cancelOrder(
                                                                  selectedTableIndex:
                                                                      selectedIndex!);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                            content: Center(
                                                              child: Text(
                                                                'Order canceled',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        21,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                Colors.orange,
                                                            duration: Duration(
                                                                seconds: 3),
                                                          ));
                                                          setState(() {
                                                            selectedValueGuestNumb =
                                                                0;
                                                            orders = [];
                                                          });
                                                        }
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 20),
                                                    ),
                                                    child: Text(
                                                      'CANCEL ORDER',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts
                                                          .varelaRound(
                                                              color: Colors
                                                                  .grey[900],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(
                                                  height: 13,
                                                ),

                                                // send order
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      if (selectedIndex ==
                                                          null) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                const SnackBar(
                                                          content: Center(
                                                            child: Text(
                                                              'Please select a table',
                                                              style: TextStyle(
                                                                  fontSize: 21,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              Colors.red,
                                                          duration: Duration(
                                                              seconds: 2),
                                                        ));
                                                      } else {
                                                        if (orders.isEmpty) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                            content: Center(
                                                              child: Text(
                                                                'Please add item first',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        21,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                Colors.red,
                                                            duration: Duration(
                                                                seconds: 2),
                                                          ));
                                                        } else {
                                                          BlocProvider.of<
                                                                      FoodMenuTabCubit>(
                                                                  context)
                                                              .sendOrder(
                                                                  selectedTableIndex:
                                                                      selectedIndex!);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                            content: Center(
                                                              child: Text(
                                                                'Order send and added to payment section',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        21,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                Colors.green,
                                                            duration: Duration(
                                                                seconds: 3),
                                                          ));
                                                        }
                                                      }
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Colors
                                                          .greenAccent[200],
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 20),
                                                    ),
                                                    child: Text(
                                                      'SEND ORDER',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts
                                                          .varelaRound(
                                                              color: Colors
                                                                  .grey[900],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ));
                          },
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ))
      ],
    );
  }
}
