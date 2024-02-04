import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:restaurant_pos/cubits/database_cubit/db_cubit.dart';
import 'package:restaurant_pos/cubits/home_cubit/home_cubit.dart';
import 'package:restaurant_pos/cubits/home_cubit/home_state.dart';
import '../../../cubits/table_cubit/table_cubit.dart';

class HomeTab extends StatelessWidget {
  HomeTab({super.key});

  double horizontalPadding = 25;
  double verticalPadding = 15;
  int tableNumbers = 6;
  int tableIndex = 0;

  TextEditingController guestController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SelectedItemCubit(),
        ),
        BlocProvider(
          create: (context) => DbCubit(),
        ),
        BlocProvider(
          create: (context) => HomeCubit(),
        )
      ],
      child: Row(
        children: [
          Expanded(
              flex: 14,
              child: Column(
                children: [
                  // select floor
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                color: Colors.grey.shade600, width: 1),
                            top: BorderSide(
                                color: Colors.grey.shade600, width: 1),
                            bottom: BorderSide(
                                color: Colors.grey.shade600, width: 1))),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Table list text
                          Text(
                            'TABLE LIST',
                            style: GoogleFonts.varelaRound(
                                fontSize: 27, fontWeight: FontWeight.bold),
                          ),

                          // floor button
                          Row(
                            children: [
                              // first floor button
                              ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10)),
                                  child: Text(
                                    'Indoor',
                                    style: GoogleFonts.varelaRound(
                                      fontSize: 16,
                                    ),
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                  onPressed: null,
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10),
                                      backgroundColor: Colors.grey),
                                  child: Text(
                                    'Outdoor',
                                    style: GoogleFonts.varelaRound(
                                      fontSize: 16,
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  // table grid view
                  Expanded(
                    flex: 7,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                        color: Colors.grey.shade600,
                        width: 1,
                      ))),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: StreamBuilder(
                          stream: Hive.box('res_table').watch(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              List<dynamic> tableData =
                                  Hive.box('res_table').values.toList();
                              return BlocBuilder<SelectedItemCubit, int>(
                                builder: (context, selectedItems) {
                                  return GridView.builder(
                                    itemCount: tableData.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 350,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 1.6 / 1.3,
                                    ),
                                    itemBuilder: (context, index) {
                                      List<dynamic> orderList =
                                          tableData[index]['orderList'];
                                      int guest = tableData[index]['guest'];
                                      final isSelected =
                                          BlocProvider.of<SelectedItemCubit>(
                                                  context)
                                              .isSelected(index);
                                      return Container(
                                        decoration: BoxDecoration(
                                          // color: isSelected ? Colors.grey.shade600 : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              tableIndex =
                                                  (isSelected ? 0 : index);
                                              BlocProvider.of<
                                                          SelectedItemCubit>(
                                                      context)
                                                  .selectItem(index);
                                              BlocProvider.of<HomeCubit>(
                                                      context)
                                                  .viewOrderList(
                                                      orderList, tableData, index);
                                            },
                                            child: Stack(
                                              children: [
                                                // table image
                                                Image.asset(
                                                  'assets/icons/dinner-table.png',
                                                  scale: 2.8,
                                                  color: isSelected
                                                      ? Colors.deepOrange
                                                      : Colors.grey[600],
                                                ),

                                                // table name
                                                Positioned(
                                                    child: Text(
                                                  'T ${index + 1}',
                                                  style:
                                                      GoogleFonts.varelaRound(
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .orange[100]),
                                                )),

                                                Positioned(
                                                  top: 20,
                                                  left: 30,
                                                  child: Container(
                                                    height: 6,
                                                    width: 6,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: (guest != 0) ? Colors.yellow : Colors.green
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                            if (!snapshot.hasData) {
                              return const Text('no data availavle');
                            }

                            List<dynamic> tableData =
                                Hive.box('res_table').values.toList();

                            return BlocBuilder<SelectedItemCubit, int>(
                              builder: (context, selectedItems) {
                                return GridView.builder(
                                  itemCount: tableData.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 350,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 1.6 / 1.3,
                                  ),
                                  itemBuilder: (context, index) {
                                    List<dynamic> orderList =
                                        tableData[index]['orderList'];
                                    int guest = tableData[index]['guest'];
                                    final isSelected =
                                        BlocProvider.of<SelectedItemCubit>(
                                                context)
                                            .isSelected(index);
                                    return Container(
                                      decoration: BoxDecoration(
                                        // color: isSelected ? Colors.grey.shade600 : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            tableIndex =
                                                (isSelected ? 0 : index);
                                            BlocProvider.of<SelectedItemCubit>(
                                                    context)
                                                .selectItem(index);
                                            BlocProvider.of<HomeCubit>(context)
                                                .viewOrderList(
                                                    orderList, tableData, index);
                                          },
                                          child: Stack(
                                            children: [
                                              // table image
                                              Image.asset(
                                                'assets/icons/dinner-table.png',
                                                scale: 2.8,
                                                color: isSelected
                                                    ? Colors.deepOrange
                                                    : Colors.grey[600],
                                              ),

                                              // table name
                                              Positioned(
                                                  child: Text(
                                                tableData[index]['title'],
                                                style: GoogleFonts.varelaRound(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.orange[100]),
                                              )),
                                              Positioned(
                                                top: 20,
                                                left: 30,
                                                child: Container(
                                                  height: 6,
                                                  width: 6,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: (guest != 0) ? Colors.yellow : Colors.green
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // table and guest number with continue button
                  Expanded(
                      child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(
                        color: Colors.grey.shade600,
                        width: 1,
                      ),
                      left: BorderSide(
                        color: Colors.grey.shade600,
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: Colors.grey.shade600,
                        width: 1,
                      ),
                    )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                                    return Text(
                                      selectedItem == -1
                                          ? 'TABLE: NUN'
                                          : 'TABLE: ${selectedItem + 1}',
                                    );
                                  },
                                )
                              ],
                            ),

                            const SizedBox(
                              width: 15,
                            ),

                            // gust number
                            Row(
                              children: [
                                Icon(Icons.people_alt_outlined,
                                    color: Colors.orange[100]),
                                const SizedBox(
                                  width: 5,
                                ),
                                BlocBuilder<SelectedItemCubit, int>(
                                  builder: (context, selectedItem) {
                                    if (selectedItem != -1) {
                                      return BlocBuilder<HomeCubit, HomeState>(
                                        builder: (context, state) {
                                          if (state is OrderFoundState) {
                                            int guest =
                                                state.tableData[state.selectedItem]['guest'];
                                            guestController.text = guest.toString();
                                            return Row(
                                              children: [
                                                const Text('GUEST:'),
                                                const SizedBox(width: 10,),
                                                SizedBox(
                                                  width: 100,
                                                  child: TextField(
                                                    controller: guestController,
                                                    decoration: InputDecoration(
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
                                                          Icons.attach_money,
                                                          color: Colors.orange.shade100,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          return Container();
                                        },
                                      );
                                    }

                                    return const Text('GUEST: NUN');
                                  },
                                )
                              ],
                            ),
                          ],
                        ),

                        // select and continue button
                        BlocBuilder<SelectedItemCubit, int>(
                          builder: (context, selectedItem) {
                            return SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  onPressed: selectedItem == -1 ? null : () {
                                    BlocProvider.of<HomeCubit>(context).updateGuestNumber(tableIndex: selectedItem, newGuestValue: guestController.text.toString());
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 25)),
                                  child: Text(
                                    'CONTINUE',
                                    style: GoogleFonts.varelaRound(
                                      fontSize: 16,
                                    ),
                                  )),
                            );
                          },
                        )
                      ],
                    ),
                  )),
                ],
              )),

          //order pallet
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              decoration: BoxDecoration(
                  border: Border(
                left: BorderSide(color: Colors.grey.shade600, width: 1),
                top: BorderSide(color: Colors.grey.shade600, width: 1),
                bottom: BorderSide(color: Colors.grey.shade600, width: 1),
              )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // order text
                  FittedBox(
                    child: Text(
                      'ORDER #',
                      style: GoogleFonts.varelaRound(
                        fontSize: 27,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.bold,
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
                      bottom: BorderSide(color: Colors.grey.shade600, width: 1),
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
                            BlocBuilder<SelectedItemCubit, int>(
                              builder: (context, selectedItem) {
                                return Text(selectedItem == -1
                                    ? 'TABLE: NUN'
                                    : 'TABLE: ${selectedItem + 1}');
                              },
                            )
                          ],
                        ),

                        const SizedBox(height: 15,),
                        // gust number
                        Row(
                          children: [
                            Icon(Icons.people_alt_outlined,
                                color: Colors.orange[100]),
                            const SizedBox(
                              width: 5,
                            ),
                            BlocBuilder<SelectedItemCubit, int>(
                              builder: (context, selectedItem) {
                                if (selectedItem != -1) {
                                  return BlocBuilder<HomeCubit, HomeState>(
                                    builder: (context, state) {
                                      if (state is OrderFoundState) {
                                        int guest = state.tableData[state.selectedItem]['guest'];
                                        return Text('GUEST: $guest');
                                      }
                                      return Container();
                                    },
                                  );
                                }

                                return const Text('GUEST: NUN');
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  // order list for table
                  Expanded(child: BlocBuilder<SelectedItemCubit, int>(
                      builder: (context, selectedItem) {
                    if (selectedItem == -1) {
                      return Center(
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
                              'NO TABLE IN THIS\nMOMENT CLICKED',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.varelaRound(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state is OrderFoundState) {
                          List<dynamic> orderList = state.tableData[state.selectedItem]['orderList'];

                          // orders of the selected tables
                          if (orderList.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: ListView.separated(
                                itemCount: orderList.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 15,
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
                                            child: Image.asset(
                                                orderList[index]['foodImage'])),

                                        // item name and price
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
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
                                                  orderList[index]['foodName'],
                                                  overflow: TextOverflow.ellipsis,
                                                  style:
                                                      GoogleFonts.varelaRound(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.grey[900]),
                                                ),

                                                //item price
                                                Text(
                                                  '\$${orderList[index]['totalPrice']}',
                                                  style:
                                                      GoogleFonts.varelaRound(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.grey[900]),
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
                                                Icon(Icons.add,
                                                    size: 20,
                                                    color: Colors.grey[900]),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: Text(
                                                    orderList[index]['quantity']
                                                        .toString(),
                                                    style:
                                                        GoogleFonts.varelaRound(
                                                            fontSize: 21,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .grey[900]),
                                                  ),
                                                ),
                                                Icon(Icons.remove,
                                                    size: 20,
                                                    color: Colors.grey[900]),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Center(
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
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          return Container();
                        }
                      },
                    );
                  }))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
