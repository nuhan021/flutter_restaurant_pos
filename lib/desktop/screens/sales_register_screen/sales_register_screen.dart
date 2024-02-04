import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_pos/cubits/sales_register_cubit/sales_register_cubit.dart';
import 'package:restaurant_pos/cubits/sales_register_cubit/sales_register_state.dart';

class SalesRegisterScreen extends StatelessWidget {
  SalesRegisterScreen({super.key});

  List<dynamic> historyData = [];

  List<String> filters = ['All', 'Last 7 days', 'Last 30 days'];

  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    int selectedFilterIndex = 0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'SALES REGISTER',
          style: TextStyle(
              color: Colors.orange.shade100, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
            color: Colors.orange.shade100
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                height: 430,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: Colors.grey.shade600, width: 1)),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      'Filter',
                      style: TextStyle(
                        color: Colors.orange.shade100,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    const SizedBox(
                      height: 7,
                    ),
                    // product filters
                    Expanded(
                      child:
                          BlocBuilder<SalesRegisterCubit, SalesRegisterState>(
                        builder: (context, state) {
                          if (state is SalesRegisterGetHistoryState) {
                            selectedFilterIndex = state.filterSelectedItem;
                            historyData = state.historyData;
                            return Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                      color: Colors.grey.shade600, width: 1)),
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: filters.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                        title: Text(filters[index]),
                                        leading: Radio(
                                          activeColor: Colors.deepOrange,
                                          value: filters[index],
                                          groupValue:
                                              filters[selectedFilterIndex],
                                          onChanged: (value) {
                                            BlocProvider.of<SalesRegisterCubit>(
                                                    context)
                                                .getHistory(filterIndex: index);
                                          },
                                        ));
                                  }),
                            );
                          }

                          return Container();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Custom Filter',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade100),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                              color: Colors.grey.shade600, width: 1)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // pick start date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Start date',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    DateTime? selectedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2030),
                                    );

                                    // Handle the selected date
                                    if (selectedDate != null) {
                                      startDate = selectedDate;
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.date_range_outlined,
                                    color: Colors.deepOrange,
                                  ))
                            ],
                          ),

                          // pick end date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'End date',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    DateTime? selectedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2030),
                                    );

                                    // Handle the selected date
                                    if (selectedDate != null) {
                                      endDate = selectedDate;
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.date_range_outlined,
                                    color: Colors.deepOrange,
                                  ))
                            ],
                          ),

                          SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.deepOrange
                                  )
                                ),
                                  onPressed: () {
                                    if(startDate != null && endDate != null) {
                                      BlocProvider.of<SalesRegisterCubit>(context)
                                          .customFilter(
                                          startDate: startDate!,
                                          endDate: endDate!);
                                    }
                                  },
                                  child: const Text('Filter')))
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            )),

            // history data
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: Colors.grey.shade600, width: 1)),
                child: BlocBuilder<SalesRegisterCubit, SalesRegisterState>(
                  builder: (context, state) {
                    if (state is SalesRegisterGetHistoryState) {
                      historyData = state.historyData.toList();
                    }

                    if (historyData.isEmpty) {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No history available !',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextButton(
                              onPressed: () {
                                // Navigator.pushReplacementNamed(context, '/home');
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/home', (route) => false);
                              },
                              child: Text(
                                'Take order',
                                style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600),
                              ))
                        ],
                      ));
                    } else {
                      return ListView.separated(
                        itemCount: historyData.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                        itemBuilder: (context, index) {
                          return ResizableContainer(
                            historyList: historyData[index],
                            objectIndex: index,
                            selectedFilterIndex: selectedFilterIndex,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResizableContainer extends StatefulWidget {
  final Map<dynamic, dynamic> historyList;
  final int objectIndex;
  final int selectedFilterIndex;

  const ResizableContainer(
      {super.key,
      required this.historyList,
      required this.objectIndex,
      required this.selectedFilterIndex});
  @override
  _ResizableContainerState createState() => _ResizableContainerState();
}

class _ResizableContainerState extends State<ResizableContainer> {
  bool isExpanded = false;
  bool isVisible = false;
  double scale = 0.0;
  void toggleSize() {
    setState(() {
      isExpanded = !isExpanded;
      _toggleVisibility();
    });
  }

  void _toggleVisibility() {
    if (isVisible == false) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          isVisible = !isVisible;
          scale = 1.0; // Change height as needed
        });
      });
    } else {
      setState(() {
        isVisible = !isVisible;
        scale = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> historyObj = widget.historyList;
    List<dynamic> objOrders = historyObj['orderList'];
    int objectIndex = widget.objectIndex;
    int selectedFilterIndex = widget.selectedFilterIndex;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
            padding: const EdgeInsets.all(10),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? 450.0 : 80.0,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.orange.shade100),
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      // for all data
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // table id
                              Column(
                                children: [
                                  Text(
                                    'Table ID',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[900]),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text('${historyObj['tableName']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[900]))
                                ],
                              ),
                              const SizedBox(
                                width: 60,
                              ),

                              // table gust number
                              Column(
                                children: [
                                  Text(
                                    'Guest NO',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[900]),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text('${historyObj['guest']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[900]))
                                ],
                              ),
                              const SizedBox(
                                width: 60,
                              ),

                              // paymentMethod
                              Column(
                                children: [
                                  Text(
                                    'Payment Method',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[900]),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text('${historyObj['paymentMethod']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[900]))
                                ],
                              ),
                              const SizedBox(
                                width: 60,
                              ),

                              // tip
                              Column(
                                children: [
                                  Text(
                                    'Tip',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[900]),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text('\$${historyObj['tip']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[900]))
                                ],
                              ),
                              const SizedBox(
                                width: 60,
                              ),

                              //serviceCharge
                              Column(
                                children: [
                                  Text(
                                    'Service Charge',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[900]),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text('\$${historyObj['serviceCharge']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[900]))
                                ],
                              ),
                              const SizedBox(
                                width: 60,
                              ),

                              // totalAmount
                              Column(
                                children: [
                                  Text(
                                    'Total Bill',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[900]),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text('\$${historyObj['totalAmount']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[900]))
                                ],
                              ),
                              const SizedBox(
                                width: 60,
                              ),

                              // receivedMoney
                              Column(
                                children: [
                                  Text(
                                    'Received Money',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[900]),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text('\$${historyObj['receivedMoney']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[900]))
                                ],
                              ),
                              const SizedBox(
                                width: 60,
                              ),

                              // time
                              Column(
                                children: [
                                  Text(
                                    'Time',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[900]),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text('${historyObj['time']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[900]))
                                ],
                              ),
                              const SizedBox(
                                width: 60,
                              ),

                              // date
                              Column(
                                children: [
                                  Text(
                                    'Date',
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[900]),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text('${historyObj['date']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[900]))
                                ],
                              ),
                              const SizedBox(
                                width: 60,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // for button
                      SizedBox(
                        width: 30,
                        child: IconButton(
                            onPressed: () {
                              toggleSize();
                            },
                            icon: isExpanded
                                ? Icon(
                                    Icons.arrow_drop_up,
                                    color: Colors.grey.shade900,
                                  )
                                : Icon(Icons.arrow_drop_down,
                                    color: Colors.grey.shade900)),
                      )
                    ],
                  ),
                ),

                // orders
                Visibility(
                    visible: isVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.grey.shade800),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...List.generate(objOrders.length, (index) {
                                return Padding(
                                  padding: index == objOrders.length - 1
                                      ? const EdgeInsets.only(bottom: 0)
                                      : const EdgeInsets.only(bottom: 15),
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    height: 80,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade600),
                                        borderRadius: BorderRadius.circular(7)),
                                    child: Center(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // food name
                                            Column(
                                              children: [
                                                Text(
                                                  'Item Name',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .orange.shade100),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${objOrders[index]['foodName']}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),

                                            const SizedBox(
                                              width: 60,
                                            ),
                                            // quantity
                                            Column(
                                              children: [
                                                Text(
                                                  'Item Quantity',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .orange.shade100),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${objOrders[index]['quantity']}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),

                                            const SizedBox(
                                              width: 60,
                                            ),

                                            // price
                                            Column(
                                              children: [
                                                Text(
                                                  'Item Price',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .orange.shade100),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '\$${objOrders[index]['price']}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),

                                            // total price
                                            const SizedBox(
                                              width: 60,
                                            ),

                                            // price
                                            Column(
                                              children: [
                                                Text(
                                                  'Item Total Price',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .orange.shade100),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '\$${objOrders[index]['totalPrice']}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                            ],
                          ),
                        ),
                      ),
                    )),

                Visibility(
                  visible: isVisible,
                  child: Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          BlocProvider.of<SalesRegisterCubit>(context)
                              .deleteData(
                                  index: objectIndex,
                                  filterIndex: selectedFilterIndex);
                        },
                        icon: const Icon(Icons.delete_outline),
                        color: Colors.red,
                      ),
                    ),
                  ),
                )
              ],
            )),
      ],
    );
  }
}
