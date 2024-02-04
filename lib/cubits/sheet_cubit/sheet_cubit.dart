import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:restaurant_pos/cubits/sheet_cubit/sheet_state.dart';

class SheetCubit extends Cubit<SheetState> {

  // this variable will get the selected sheet index
  final int sheetIndex;

  // var sheetDatabase = Hive.box('sheet');
  // var sheetRowDatabase = Hive.box('sheetRow');

  // this database are will store all individual sheet data
  var posSheetDatabase = Hive.box('pos_sheet_database');

  SheetCubit({required this.sheetIndex}) : super(SheetInitial()) {
    // initially when cubit are loaded it will call getSheetData function
    getSheetData();
  }

  // get selected index sheet data from the database
  void getSheetData() {
    // get the selected sheet index data as a map
    Map<dynamic, dynamic> sheetData = posSheetDatabase.getAt(sheetIndex);
    // get columns data from sheetData
    List<dynamic> cols = sheetData['cols'];
    List<dynamic> rows = sheetData['rows'];
    String sheetName = sheetData['name'].toString();

    // emit SheetLoaded state with columns and rows data
    emit(SheetLoaded(sheetData: cols, sheetRowData: rows, sheetName: sheetName));
  }

  // this function ads new column to the database
  void addNewColumn({required String title, required String type}) {
    // create a map for new column
    Map<dynamic,dynamic> newColumnData = {
      'title': title,
      'field': title.toLowerCase(),
      'type': type,
    };

    // get selected sheet index data as a list
    Map<dynamic, dynamic> sheetData = posSheetDatabase.getAt(sheetIndex);
    // add new column to the sheetData columns list
    sheetData['cols'].add(newColumnData);
    // update the sheetData at the index of the posSheetDatabase
    posSheetDatabase.putAt(sheetIndex, sheetData);
    // call the getSheetData function
    getSheetData();
  }


  // this function delete the selected columns from the database
  void deleteColumn({required int colIDX}) {
    // get selected sheet index data as a list
    Map<dynamic, dynamic> sheetData = posSheetDatabase.getAt(sheetIndex);

    // get the columns data from the sheetData
    List colList = sheetData['cols'];

    // if column list length is 1
    // then clear the row list of sheetData
    if(colList.length == 1) {
      // clearing rows from sheetData
      sheetData['rows'].clear();
      // update sheetData at the sheetIndex
      posSheetDatabase.putAt(sheetIndex, sheetData);
    } else {
      // loop through the rowList and remove the column at the index
      for(int i = 0; i < sheetData['rows'].length; i++) {
        // check if the item i want to delete is exist or not
        // if not exist don't delete otherwise delete
        if (colIDX >= 0 && colIDX < sheetData['rows'][i].length) {
          // Remove the row at the specified index (colIDX) from each row
          sheetData['rows'][i].removeAt(colIDX);
        }
      }
    }

    // delete the column at the colIDX
    sheetData['cols'].removeAt(colIDX);
    // update the sheetData at the sheetIndex
    posSheetDatabase.putAt(sheetIndex, sheetData);
  }


  // this function add new row to the database
  void addRow({required Map<String, PlutoCell> cells}) {
    // Convert PlutoCell values to a list of dynamic values
    List<dynamic> serializedCells = cells.values.map((plutoCell) {
      return {'value': plutoCell.value};
    }).toList();

    // get selected sheet index data as list
    Map<dynamic, dynamic> sheetData = posSheetDatabase.getAt(sheetIndex);
    // add new row to the rows list
    sheetData['rows'].add(serializedCells);
    // update the sheetData at the sheetIndex
    posSheetDatabase.putAt(sheetIndex,sheetData);
  }


  // this function will delete selected row from the database
  void deleteRow({required int rowIdx}) {
    // get selected sheet index data as list
    Map<dynamic, dynamic> sheetData = posSheetDatabase.getAt(sheetIndex);

    // remove selected row from the rows list at the rowIdx
    sheetData['rows'].removeAt(rowIdx);
    // update sheetData at the sheetIndex
    posSheetDatabase.putAt(sheetIndex, sheetData);
    // call the getSheetData function
    getSheetData();
  }


  // this function will update individual row with cells
  void updateRow({required Map<String, PlutoCell> cell, required int rowIdx}) {
    // Convert PlutoCell values to a list of dynamic values
    List<dynamic> serializedCells = cell.values.map((plutoCell) {
      return {'value': plutoCell.value};
    }).toList();

    // get selected sheet data at the sheetIndex
    Map<dynamic, dynamic> sheetData = posSheetDatabase.getAt(sheetIndex);
    // remove row from sheetData at the rowIdx
    sheetData['rows'].removeAt(rowIdx);
    // insert new updated row data (serializedCell) at the rowIdx
    sheetData['rows'].insert(rowIdx,serializedCells);
    // update sheetData at the sheetIndex
    posSheetDatabase.putAt(sheetIndex, sheetData);
  }

}
