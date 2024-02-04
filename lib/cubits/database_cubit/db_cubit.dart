import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:restaurant_pos/cubits/database_cubit/db_state.dart';

class DbCubit extends Cubit<DbState> {
  DbCubit() : super(InitialState());

  var myBox = Hive.box('res_table');


  // add table
  void addTable() async {
    int tableIndex = myBox.length + 1;
    Map<String, dynamic> tableData = {
      'title': 'T$tableIndex',
      'img': 'assets/icons/dinner-table.png',
      'guest': 0,
      'orderList': [],
      'isOrderSent': false
    };

    myBox.add(tableData);
  }


  // delete table
  void deleteTable() async {
    int lastIndex = myBox.length -1;
    if(myBox.length !=0) {
      myBox.deleteAt(lastIndex);
    }
  }

}