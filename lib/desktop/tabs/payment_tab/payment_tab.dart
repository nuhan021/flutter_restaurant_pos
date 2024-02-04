import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_pos/cubits/payment_cubit/payment_cubit.dart';
import 'package:restaurant_pos/cubits/payment_cubit/payment_state.dart';

class PaymentTab extends StatelessWidget {
  PaymentTab({super.key});

  List tableCell = ['ITEM', 'PRICE', 'QUANTITY', 'TOTAL PRICE'];

  List orderItems = [];

  List<String> allTableNames = [];

  String? selectedValue;

  int? selectedTableIndex;

  Map<dynamic, dynamic> selectedTableData = {};

  int? guestNumber;

  int payableAmount = 0;

  List tipList = [5, 10, 15, 20];

  int tip = 0;

  int serviceCharge = 0;

  int totalAmount = 0;

  List<dynamic> paymentMethod = [
    {'title': 'CASH', 'icon': Icons.money},
    {'title': 'CARD', 'icon': Icons.payment},
    {'title': 'MBS', 'icon': Icons.mobile_friendly},
  ];

  String? paymentMethodTitle;

  TextEditingController receivedMoney = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // order list
        Expanded(
          flex: 11,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(
                      color: Colors.grey.shade600,
                    ),
                    left: BorderSide(
                      color: Colors.grey.shade600,
                    ),
                  )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<PaymentCubit, PaymentState>(
                          builder: (context, state) {
                        if (state is PaymentGetDataState) {
                          allTableNames = state.allTableNames.toList();
                          return Text(
                            'Total Table : ${allTableNames.length}',
                            style: GoogleFonts.varelaRound(
                              fontSize: 23,
                            ),
                          );
                        }

                        return Text(
                          'Total Table : ${allTableNames.length}',
                          style: GoogleFonts.varelaRound(
                            fontSize: 23,
                          ),
                        );
                      }),
                      BlocBuilder<PaymentCubit, PaymentState>(
                        builder: (context, state) {
                          if (state is PaymentGetDataState) {
                            allTableNames = state.allTableNames.toList();
                            return Row(
                              children: [
                                Icon(
                                  Icons.table_bar_outlined,
                                  color: Colors.orange.shade100,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'TABLE: $selectedValue',
                                      style: GoogleFonts.varelaRound(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: const Icon(Icons.arrow_drop_down),
                                      itemBuilder: (context) => allTableNames
                                          .map((option) => PopupMenuItem(
                                                value: option,
                                                child: Text(option),
                                              ))
                                          .toList(),
                                      onSelected: (value) {
                                        BlocProvider.of<PaymentCubit>(context)
                                            .selectTable(tableName: value);
                                        selectedValue = value;
                                      },
                                    )
                                  ],
                                )
                              ],
                            );
                          }
                          return Row(
                            children: [
                              Icon(
                                Icons.table_bar_outlined,
                                color: Colors.orange.shade100,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'TABLE: $selectedValue',
                                    style: GoogleFonts.varelaRound(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.arrow_drop_down),
                                    itemBuilder: (context) => allTableNames
                                        .map((option) => PopupMenuItem(
                                              value: option,
                                              child: Text(option),
                                            ))
                                        .toList(),
                                    onSelected: (value) {
                                      BlocProvider.of<PaymentCubit>(context)
                                          .selectTable(tableName: value);
                                      selectedValue = value;
                                    },
                                  )
                                ],
                              )
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),

              // table
              Expanded(
                  flex: 7,
                  child: Container(
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 25),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: BlocBuilder<PaymentCubit, PaymentState>(
                            builder: (context, state) {
                              if (state is PaymentSelectedTableData) {
                                selectedTableData = state.tableData;
                                orderItems = selectedTableData['orderList'];
                                selectedTableIndex = state.selectedTableIndex;
                              }
                              if (selectedTableData['isOrderSent'] == false) {
                                return Table(
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    TableRow(
                                        decoration: BoxDecoration(
                                            color: Colors.orange.shade100),
                                        children: tableCell.map((e) {
                                          return TableCell(
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Text(
                                                  e.toString(),
                                                  style:
                                                      GoogleFonts.varelaRound(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 3,
                                                          color:
                                                              Colors.grey[900]),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList()),
                                    TableRow(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            border: Border(
                                                bottom: BorderSide(
                                                    color:
                                                        Colors.grey.shade600))),
                                        children: [
                                          TableCell(
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Text(
                                                  'Order not send',
                                                  style:
                                                      GoogleFonts.varelaRound(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.orange.shade100,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const TableCell(
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(20.0),
                                              ),
                                            ),
                                          ),
                                          const TableCell(
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(20.0),
                                              ),
                                            ),
                                          ),
                                          const TableCell(
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(20.0),
                                              ),
                                            ),
                                          ),
                                        ])
                                  ],
                                );
                              }
                              return Table(
                                defaultVerticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(
                                      decoration: BoxDecoration(
                                          color: Colors.orange.shade100),
                                      children: tableCell.map((e) {
                                        return TableCell(
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Text(
                                                e.toString(),
                                                style: GoogleFonts.varelaRound(
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 3,
                                                    color: Colors.grey[900]),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList()),
                                  ...List.generate(orderItems.length, (index) {
                                    return TableRow(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            border: Border(
                                                bottom: BorderSide(
                                                    color:
                                                        Colors.grey.shade600))),
                                        children: [
                                          TableCell(
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Text(
                                                  orderItems[index]['foodName']
                                                      .toString(),
                                                  style:
                                                      GoogleFonts.varelaRound(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.orange.shade100,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Text(
                                                  '\$${orderItems[index]['price'].toString()}',
                                                  style:
                                                      GoogleFonts.varelaRound(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.orange.shade100,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Text(
                                                  orderItems[index]['quantity']
                                                      .toString(),
                                                  style:
                                                      GoogleFonts.varelaRound(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.orange.shade100,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Text(
                                                  '\$${orderItems[index]['totalPrice'].toString()}',
                                                  style:
                                                      GoogleFonts.varelaRound(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.orange.shade100,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]);
                                  })
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  )),

              // cancel button
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(
                    color: Colors.grey.shade600,
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: Colors.grey.shade600,
                    width: 1,
                  ),
                )),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<PaymentCubit>(context).cancelOrder(selectedTableIndex: selectedTableIndex!);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    child: const Text('CANCEL ORDER'),
                  ),
                ),
              )),
            ],
          ),
        ),

        // payment section
        Expanded(
            flex: 4,
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                  border: Border.all(
                color: Colors.grey.shade600,
                width: 1,
              )),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PAYABLE SECTION',
                      style: GoogleFonts.varelaRound(
                        fontSize: 21,
                      ),
                    ),

                    // amounts
                    BlocBuilder<PaymentCubit, PaymentState>(
                      builder: (context, state) {
                        if (state is PaymentSelectedTableData) {
                          guestNumber = state.tableData['guest'];
                          payableAmount = state.payableAmount;
                          serviceCharge = (10 * (payableAmount! / 100)).round();
                        }
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade600))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.people_alt_outlined,
                                    color: Colors.orange.shade100,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text('GUEST: $guestNumber')
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),

                    //add tip
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade600))),
                      child: Row(
                        children: [
                          Text(
                            'ADD TIP',
                            style: GoogleFonts.varelaRound(
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          BlocBuilder<PaymentAddTipCubit, int>(
                            builder: (context, selectedTipIndex) {
                              tip = tipList[selectedTipIndex];
                              return Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      // add tip
                                      ...List.generate(tipList.length, (index) {
                                        return InkWell(
                                          onTap: () {
                                            BlocProvider.of<PaymentAddTipCubit>(
                                                    context)
                                                .addTip(index: index);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Container(
                                                width: 50,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 12),
                                                decoration: BoxDecoration(
                                                  color: (selectedTipIndex ==
                                                          index)
                                                      ? Colors.orange.shade100
                                                      : Colors.grey.shade800,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '\$',
                                                      style: GoogleFonts.varelaRound(
                                                          fontSize: 16,
                                                          color:
                                                              (selectedTipIndex ==
                                                                      index)
                                                                  ? Colors
                                                                      .grey[900]
                                                                  : Colors.grey
                                                                      .shade600),
                                                    ),
                                                    const SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      '${tipList[index]}',
                                                      style: GoogleFonts.varelaRound(
                                                          fontSize: 21,
                                                          color:
                                                              (selectedTipIndex ==
                                                                      index)
                                                                  ? Colors
                                                                      .grey[900]
                                                                  : Colors.grey
                                                                      .shade600),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        );
                                      })
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // payment method
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade600))),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: BlocBuilder<PaymentMethodCubit, int>(
                          builder: (context, selectedMethodIndex) {
                            // add payment method name
                            paymentMethodTitle = paymentMethod[selectedMethodIndex]['title'].toString();
                            return Row(
                              children: [
                                ...List.generate(paymentMethod.length, (index) {
                                  return InkWell(
                                    onTap: () {
                                      BlocProvider.of<PaymentMethodCubit>(
                                              context)
                                          .addPaymentMethod(index: index);
                                    },
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Container(
                                          padding: const EdgeInsets.all(17),
                                          decoration: BoxDecoration(
                                            color:
                                                (selectedMethodIndex == index)
                                                    ? Colors.orange.shade100
                                                    : Colors.grey.shade800,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(paymentMethod[index]['icon'],
                                                  color: (selectedMethodIndex ==
                                                          index)
                                                      ? Colors.grey[900]
                                                      : Colors.grey.shade600),
                                              Text(
                                                '${paymentMethod[index]['title']}',
                                                style: GoogleFonts.varelaRound(
                                                    color:
                                                        (selectedMethodIndex ==
                                                                index)
                                                            ? Colors.grey[900]
                                                            : Colors
                                                                .grey.shade600),
                                              )
                                            ],
                                          ),
                                        )),
                                  );
                                })
                                // mobile banking system
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    // add received cash
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: Colors.grey.shade600),
                      )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'ADD CASH\nRECEIVED',
                            style: GoogleFonts.varelaRound(
                                color: Colors.orange.shade100),
                          ),
                          SizedBox(
                            width: 100,
                            child: TextField(
                              controller: receivedMoney,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
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
                      ),
                    ),

                    // figure amount
                    BlocBuilder<PaymentCubit, PaymentState>(
                      builder: (context, state) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade600),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'SUBTOTAL',
                                    style: GoogleFonts.varelaRound(
                                      fontSize: 13,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text('\$',
                                          style: GoogleFonts.varelaRound(
                                            fontSize: 13,
                                          )),
                                      Text(
                                        '$payableAmount',
                                        style: GoogleFonts.varelaRound(
                                            fontSize: 13,
                                            color: Colors.orange.shade100),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'TIPS',
                                    style: GoogleFonts.varelaRound(
                                      fontSize: 13,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text('\$',
                                          style: GoogleFonts.varelaRound(
                                            fontSize: 13,
                                          )),
                                      BlocBuilder<PaymentAddTipCubit, int>(
                                        builder: (context, state) {
                                          return Text(
                                            '$tip',
                                            style: GoogleFonts.varelaRound(
                                                fontSize: 13,
                                                color: Colors.orange.shade100),
                                          );
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'SERVICE CHARGE 10%',
                                    style: GoogleFonts.varelaRound(
                                      fontSize: 13,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text('\$',
                                          style: GoogleFonts.varelaRound(
                                            fontSize: 13,
                                          )),
                                      Text(
                                        '$serviceCharge',
                                        style: GoogleFonts.varelaRound(
                                            fontSize: 13,
                                            color: Colors.orange.shade100),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // total bill
                    BlocBuilder<PaymentAddTipCubit, int>(
                      builder: (context, selectedTipIndex) {
                        tip = tipList[selectedTipIndex];
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            children: [
                              BlocBuilder<PaymentCubit, PaymentState>(
                                builder: (context, state) {
                                  int amount = 0;
                                  if (serviceCharge != 0 ||
                                      payableAmount != 0) {
                                    amount =
                                        payableAmount + tip + serviceCharge;
                                    totalAmount = amount;
                                  }
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'TOTAL',
                                        style: GoogleFonts.varelaRound(
                                            fontSize: 21),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '\$',
                                            style: GoogleFonts.varelaRound(
                                              fontSize: 21,
                                            ),
                                          ),
                                          Text(
                                            '$amount',
                                            style: GoogleFonts.varelaRound(
                                                fontSize: 21,
                                                color: Colors.orange.shade100),
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green.shade400,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20)),
                                  onPressed: () {
                                    if(payableAmount == 0 || serviceCharge == 0) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Center(
                                            child: Text('Please select a right table!', style: TextStyle(
                                              fontSize: 21,
                                              fontWeight:FontWeight.bold,
                                              color: Colors.white
                                            ),),
                                          ),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 3),
                                        )
                                      );
                                    } else if(receivedMoney.text == '') {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Center(
                                              child: Text('Please add received money!', style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight:FontWeight.bold,
                                                  color: Colors.white
                                              ),),
                                            ),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 3),
                                          )
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Center(
                                              child: Text('Payment Success', style: TextStyle(
                                                  fontSize: 21,
                                                  fontWeight:FontWeight.bold,
                                              ),),
                                            ),
                                            backgroundColor: Colors.green,
                                            duration: Duration(seconds: 3),
                                          )
                                      );

                                      BlocProvider.of<PaymentCubit>(context).payment(title: selectedValue!, selectedTableIndex: selectedTableIndex!, tip: tip, totalAmount: totalAmount , serviceCharge: serviceCharge, paymentMethod: paymentMethodTitle!, receivedMoney: receivedMoney.text);
                                      receivedMoney.text = '';
                                    }
                                  },
                                  child: Text(
                                    'PAY NOW',
                                    style: GoogleFonts.varelaRound(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
