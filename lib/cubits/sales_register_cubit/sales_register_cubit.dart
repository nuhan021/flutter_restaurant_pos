import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:restaurant_pos/cubits/sales_register_cubit/sales_register_state.dart';

class SalesRegisterCubit extends Cubit<SalesRegisterState> {
  SalesRegisterCubit() : super(SalesRegisterInitialState()) {
    getHistory(filterIndex: 0);
  }

  // initialize salesRegister database
  var salesRegisterBox = Hive.box('order_history');

  // get all data
  void getHistory({required int filterIndex}) async {
    // Get the current time
    DateTime currentDate = DateTime.now();

    // get all sales history
    List<dynamic> getHistory = salesRegisterBox.values.toList();
    List<dynamic> history = getHistory.reversed.toList();

    // filter the history based on filterIndex number
    if(filterIndex == 1) {
      history = history.where((element) {
        DateTime orderDate = DateFormat('dd-MM-yyyy').parse(element['date']);
        Duration difference = currentDate.difference(orderDate);
        return difference.inDays <= 7;
      }).toList();
    } else if(filterIndex == 2) {
      history = history.where((element) {
        DateTime orderDate = DateFormat('dd-MM-yyyy').parse(element['date']);
        Duration difference = currentDate.difference(orderDate);
        return difference.inDays <= 30;
      }).toList();
    }

    emit(SalesRegisterGetHistoryState(historyData: history,filterSelectedItem: filterIndex));
  }

  // delete selected data
  void deleteData({required int index, required int filterIndex}) async {
    // remove the history from database
    salesRegisterBox.deleteAt(index);
    // get all sales history
    List<dynamic> history = salesRegisterBox.values.toList();
    emit(SalesRegisterGetHistoryState(historyData: history, filterSelectedItem: filterIndex));
  }

  // custom filter
  void customFilter({required DateTime startDate, required DateTime endDate}) async {
    // format the startDate and endDate as dd-MM-yyyy
    String startDateFormatted = DateFormat('dd-MM-yyyy').format(startDate);
    String endDateFormatted = DateFormat('dd-MM-yyyy').format(endDate);
    // get all sales history
    List<dynamic> history = salesRegisterBox.values.toList();
    // filter the history based on startDate and endDate
    history = history.where((element) {
      DateTime orderDate = DateFormat('dd-MM-yyyy').parse(element['date']);
      return orderDate.isAfter(DateFormat('dd-MM-yyyy').parse(startDateFormatted)) && orderDate.isBefore(DateFormat('dd-MM-yyyy').parse(endDateFormatted));
    }).toList();

    emit(SalesRegisterGetHistoryState(historyData: history,filterSelectedItem: 0));
  }
}