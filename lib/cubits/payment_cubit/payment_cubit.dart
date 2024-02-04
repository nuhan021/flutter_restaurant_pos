import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_pos/cubits/payment_cubit/payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitialState()) {
    getData();
  }

  // initialize hive table database
  var tableListBox = Hive.box('res_table');

  // initialize hive order history database
  var orderHistory = Hive.box('order_history');

  // get all table name
  void getData() async {
    // get table data
    List<dynamic> tableList = tableListBox.values.toList();
    // create a list for store the table names
    List<String> allTableNames = [];
    // loop all table data to store table name to the allTableNames list
    for (var element in tableList) {
      // add the table title to the allTableNames list
      allTableNames.add(element['title']);
    }
    // emit PaymentGetDataState with all table names list
    emit(PaymentGetDataState(allTableNames: allTableNames));
  }

  // get the selected table data
  void selectTable({required String tableName}) async {
    // get all table data
    List<dynamic> tableList = tableListBox.values.toList();
    // create a empty map for store the selected table data
    Map<dynamic, dynamic> selectedTableData = {};
    // initialize payableAmount variable with its value 0 for store actual payable amount
    int? payableAmount = 0;
    int? selectedTableIndex;

    // loop the tableList
    for (int i = 0; i < tableList.length; i++) {
      // check the given tableName with the tableList table title to find actual selected table
      if (tableList[i]['title'] == tableName) {
        // add the selected table data to selectedTableData map
        selectedTableData = tableList[i];
        // add the selected table index to selectedTableIndex variable
        selectedTableIndex = i;
        // get the orderList from the selected table
        List orderList = selectedTableData['orderList'];
        // looping the orderList of the selected table
        // to add all food item total price in the payableAmount variable
        for (var e in orderList) {
          // add one by one by one total price of the food item in the payableAmount variable
          payableAmount = (payableAmount! + e['totalPrice']) as int?;
        }
        // if match the tableName to the table title
        // then break the loop
        break;
      }
    }
    // emit paymentSelectedTableData with selectedTableData and payableAmount
    emit(PaymentSelectedTableData(
        tableData: selectedTableData,
        payableAmount: payableAmount!,
        selectedTableIndex: selectedTableIndex!));
  }

  void cancelOrder({required int selectedTableIndex}) async {
    //get the selected table data
    Map<dynamic, dynamic> selectedTableData = tableListBox.getAt(selectedTableIndex);
    // update the entire table data at the index of the selectedTableIndex
    Map<dynamic, dynamic> newTableData = {
      'title': selectedTableData['title'],
      'img': selectedTableData['img'],
      'guest': 0,
      'orderList': [],
      'isOrderSent': false
    };

    tableListBox.putAt(selectedTableIndex, newTableData);

    emit(PaymentSelectedTableData(tableData: newTableData, payableAmount: 0, selectedTableIndex: selectedTableIndex));
  }

  void payment(
      {required String title,
      required int selectedTableIndex,
      required int tip,
        required int serviceCharge,
        required String paymentMethod,
        required String receivedMoney,
      required int totalAmount}) async {

    // Get the current time
    DateTime now = DateTime.now();
    // format the time in 12-hour format
    String formattedTime = DateFormat.jm().format(now);
    // format the date as date-month-year
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);

    // create a empty table data map
    Map<dynamic,dynamic> tableData = {
      'title': title,
      'img': 'assets/icons/dinner-table.png',
      'guest': 0,
      'orderList': [],
      'isOrderSent': false
    };

    // get food order list table database
    List<dynamic> orderList = await tableListBox.getAt(selectedTableIndex)['orderList'];
    // get the gust number of the table
    int guestNumber = await tableListBox.getAt(selectedTableIndex)['guest'];

    // create a order history map
    Map<dynamic, dynamic> orderHistoryMap = {
      'tableName': title,
      'guest': guestNumber,
      'orderList': orderList,
      'paymentMethod': paymentMethod,
      'tip': tip,
      'serviceCharge': serviceCharge,
      'totalAmount': totalAmount,
      'receivedMoney': receivedMoney,
      'time': formattedTime,
      'date': formattedDate
    };

    // add the empty table data at the index of selectedTableIndex
    await tableListBox.putAt(selectedTableIndex, tableData);
    // add the orderHistoryMap to the order history database
    await orderHistory.add(orderHistoryMap);
    // call the get data function for new table data
    getData();
    // emit state with new table data , new payableAmount selectedTableIndex
    emit(PaymentSelectedTableData(tableData: tableData, payableAmount: 0, selectedTableIndex: selectedTableIndex));
  }
}

// select tips section cubit
class PaymentAddTipCubit extends Cubit<int> {
  PaymentAddTipCubit() : super(0);

  void addTip({required int index}) {
    // get the index and emit the index
    emit(index);
  }
}

// select payment method cubit
class PaymentMethodCubit extends Cubit<int> {
  PaymentMethodCubit() : super(0);

  void addPaymentMethod({required int index}) {
    // get the index and emit the index
    emit(index);
  }
}
