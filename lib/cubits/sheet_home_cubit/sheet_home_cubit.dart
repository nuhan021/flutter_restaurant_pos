import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:restaurant_pos/cubits/sheet_home_cubit/sheet_home_state.dart';

class SheetHomeCubit extends Cubit<SheetHomeState> {

  var posSheetDatabase = Hive.box('pos_sheet_database');

  SheetHomeCubit() : super(SheetHomeInitial()) {
    getSheetData();
  }

  // get the data from the database
  void getSheetData() {
    List<dynamic> posSheetHomeData = posSheetDatabase.values.toList();
    emit(SheetHomeLoaded(posSheetHomeData: posSheetHomeData));
  }

  // create new sheet
  void createSheet({required String sheetName}) {
    Map<dynamic,dynamic> newSheetData = {
      'name': sheetName,
      'cols': [],
      'rows': []
    };
    // add new sheet to the database
    posSheetDatabase.add(newSheetData);
    getSheetData();
  }

  // delete database
  void deleteSheet({required int sheetIdx}) {
    posSheetDatabase.deleteAt(sheetIdx);
    getSheetData();
  }

  // update sheet name
  void updateSheetName({required int sheetIndex, required String newName}) {
    Map<dynamic, dynamic> sheetData = posSheetDatabase.getAt(sheetIndex);
    sheetData['name'] = newName;
    posSheetDatabase.putAt(sheetIndex, sheetData);
    getSheetData();
  }
}