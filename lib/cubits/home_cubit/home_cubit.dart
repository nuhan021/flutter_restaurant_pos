import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:restaurant_pos/cubits/home_cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(): super(InitialState());

  var myBox = Hive.box('res_table');

  void viewOrderList(List<dynamic> orderList, List<dynamic> tableData, int index) {
    emit(OrderFoundState(tableData: tableData,selectedItem: index));
  }

  // update Guest number
  void updateGuestNumber ({required int tableIndex, required String newGuestValue}) async {
    int newGuestNumber = int.parse(newGuestValue);
    Map<dynamic, dynamic> tableData = myBox.getAt(tableIndex);

    tableData['guest'] = newGuestNumber;
    myBox.putAt(tableIndex, tableData);

    List<dynamic> allTableData = myBox.values.toList();
    emit(OrderFoundState(tableData: allTableData, selectedItem: tableIndex));
  }
}