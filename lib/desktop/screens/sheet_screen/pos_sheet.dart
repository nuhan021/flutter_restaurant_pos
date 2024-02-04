import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:restaurant_pos/cubits/sheet_cubit/sheet_cubit.dart';
import 'package:restaurant_pos/cubits/sheet_cubit/sheet_state.dart';

class PosSheet extends StatefulWidget {
  const PosSheet({
    super.key,
  });

  @override
  State<PosSheet> createState() => _PosSheetState();
}

class _PosSheetState extends State<PosSheet> {
  // this function take column title and type as arguments
  void addColumn({required String title, required String type}) {
    // call the addNewColumn function from the sheetCubit
    BlocProvider.of<SheetCubit>(context).addNewColumn(title: title, type: type);
  }

  // this function take column index as argument and delete the column that has been selected
  void removeColumn({required int colIDX}) {
    // call the deleteColumn function from the sheetCubit
    BlocProvider.of<SheetCubit>(context).deleteColumn(colIDX: colIDX);
  }

  // this function take new cells as argument and add new row
  void addRow({required Map<String, PlutoCell> newCells}) {
    // call the addRow function from the sheetCubit
    BlocProvider.of<SheetCubit>(context).addRow(cells: newCells);
  }

  // this variable take the column type
  String selectedColumnType = 'text';

  // this function is for store the column type from the child widget
  void onDataFromChild(String data) {
    selectedColumnType = data;
  }

  // this variable store the PlutoGridStateManager state
  PlutoGridStateManager? stateManager;
  // this variable is for hold sheet name
  String sheetName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title of the appBar
          title: BlocBuilder<SheetCubit, SheetState>(
            builder: (context, state) {
              if(state is SheetLoaded) {
                // store the name of current sheet
                sheetName = state.sheetName.toString();
              }
              return Text(
                sheetName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade100,
                ),
              );
            },
          ),
          centerTitle: true,
          // theme data for the appbar icons
          iconTheme: IconThemeData(color: Colors.orange.shade100),
        ),
        body: BlocBuilder<SheetCubit, SheetState>(
          builder: (context, state) {
            // create a empty columns and rows list for store dynamic values
            List<PlutoColumn> columns = [];
            List<PlutoRow> rows = [];

            // check the state of the sheetCubit
            if (state is SheetLoaded) {
              // take individual column data from the sheetCubit
              for (int i = 0; i < state.sheetData.length; i++) {
                // store the column title, field, type
                String title = state.sheetData[i]['title'];
                String field = state.sheetData[i]['field'];
                String type = state.sheetData[i]['type'];

                // set PlutoColumnType based on the type
                PlutoColumnType columnType = (type == 'text')
                    ? PlutoColumnType.text()
                    : (type == 'number')
                        ? PlutoColumnType.number()
                        : (type == 'time')
                            ? PlutoColumnType.time()
                            : (type == 'date')
                                ? PlutoColumnType.date()
                                : PlutoColumnType
                                    .currency(); // Default to text if the type is not recognized

                // create a new PlutoColumn based on the column title, field, type
                PlutoColumn newColumn = PlutoColumn(
                  title: title,
                  field: field,
                  type: columnType,
                  enableContextMenu: true,
                  enableRowDrag: true,
                  titlePadding: const EdgeInsets.all(10.0),
                );

                // add the newColumn to the columns list
                columns.add(newColumn);
              }

              // take individual row data from the sheetCubit
              for (int i = 0; i < state.sheetRowData.length; i++) {
                // store the row data in serializedCells
                List<dynamic> serializedCells = state.sheetRowData[i];

                // create a empty map to store the deserialized cells
                Map<String, PlutoCell> deserializedCells = {};
                // loop through the columns and create a new PlutoCell
                for (int j = 0; j < columns.length; j++) {
                  // take the field name from the columns list
                  String field = columns[j].field;

                  // take the value from the serializedCells list
                  dynamic value = (j < serializedCells.length)
                      ? serializedCells[j]['value']
                      : null;

                  deserializedCells[field] = PlutoCell(value: value);
                }

                // create new row
                PlutoRow newRow = PlutoRow(cells: deserializedCells);
                // add the row to the rows list
                rows.add(newRow);
              }
            }

            return PlutoGrid(
              key: UniqueKey(),
              columns: columns,
              rows: rows,
              onChanged: (PlutoGridOnChangedEvent event) {
                // call the updateRow function from the sheetCubit for update the change
                BlocProvider.of<SheetCubit>(context)
                    .updateRow(cell: event.row.cells, rowIdx: event.rowIdx);
              },
              onRowDoubleTap: (event) {
                void deleteRow() {
                  BlocProvider.of<SheetCubit>(context)
                      .deleteRow(rowIdx: event.rowIdx);
                }

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Do you want to delete this row?',
                        style: TextStyle(fontSize: 17),
                      ),
                      actions: [
                        OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No')),
                        OutlinedButton(
                            onPressed: () {
                              deleteRow();
                              Navigator.pop(context);
                            },
                            child: const Text('Yes'))
                      ],
                    );
                  },
                );
              },
              configuration: PlutoGridConfiguration(
                enterKeyAction: PlutoGridEnterKeyAction.toggleEditing,
                shortcut: PlutoGridShortcut(actions: {
                  ...PlutoGridShortcut.defaultActions,

                  // this shortcut is for add new row (control + shift + r)
                  LogicalKeySet(
                      LogicalKeyboardKey.controlLeft,
                      LogicalKeyboardKey.shift,
                      LogicalKeyboardKey.keyR): CustomEnterKeyAction(),
                }),
                style: const PlutoGridStyleConfig.dark(
                  iconColor: Colors.deepOrange,
                  activatedBorderColor: Colors.deepOrange,
                  defaultCellPadding: EdgeInsets.all(8.0),
                  oddRowColor: Colors.black54,
                  enableColumnBorderHorizontal: true,
                ),
              ),
              createHeader: (stateManager) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      // this button is for add new column
                      TextButton(
                          onPressed: () {
                            // get the last index of the columns list
                            final int lastIndex =
                                stateManager.refColumns.originalList.length;

                            // shoe dialog function
                            showDialog(
                              context: context,
                              builder: (context) {
                                TextEditingController titleController =
                                    TextEditingController();
                                titleController.text = 'new column $lastIndex';
                                return Dialog(
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    height: 200,
                                    width: 300,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextField(
                                          controller: titleController,
                                          decoration: InputDecoration(
                                              label: const Text('Title'),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .orange.shade100)),
                                              enabled: true,
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: BorderSide(
                                                      color: Colors
                                                          .orange.shade100)),
                                              prefixIcon: Icon(
                                                Icons.work_outline,
                                                color: Colors.orange.shade100,
                                              )),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Select column type :',
                                              style: TextStyle(fontSize: 17),
                                            ),
                                            SelectColumnTypeDropDown(
                                                onColumnTypeSelected:
                                                    onDataFromChild),
                                          ],
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              bool isTitleExist = false;

                                              for (int i = 0;
                                                  i < columns.length;
                                                  i++) {
                                                if (titleController.text
                                                        .toLowerCase() ==
                                                    columns[i]
                                                        .field
                                                        .toString()) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'The field name already taken'),
                                                    backgroundColor: Colors.red,
                                                  ));
                                                  isTitleExist = true;
                                                  break;
                                                }
                                              }

                                              if (isTitleExist == false) {
                                                stateManager.insertColumns(0, [
                                                  PlutoColumn(
                                                    // get the value from the text field
                                                    title: titleController.text,
                                                    field: titleController.text
                                                        .toLowerCase(),
                                                    type:
                                                        PlutoColumnType.text(),
                                                  )
                                                ]);

                                                // call the addColumn function
                                                addColumn(
                                                    title: titleController.text,
                                                    type: selectedColumnType
                                                        .toLowerCase());
                                                selectedColumnType = 'text';
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: const Text('Done'))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text('Add Column')),

                      // this button is for add new row
                      TextButton(
                        onPressed: () {
                          // get the last index of rows
                          final int lastIndex = rows.length;

                          // Create a map of cells based on the columns
                          Map<String, PlutoCell> newCells = {};

                          // run this for loop at < columns.length
                          for (int i = 0;
                              i < stateManager.columns.length;
                              i++) {
                            String field = stateManager.columns[i].field;
                            // set initial value null or ''
                            dynamic initialValue = '';
                            // create new cell based on how many time the for loop run
                            newCells[field] = PlutoCell(value: initialValue);
                          }

                          // insert new row at the last index of rows list
                          stateManager.insertRows(lastIndex, [
                            PlutoRow(cells: newCells),
                          ]);
                          // call addRow function for adding new row to the database
                          addRow(newCells: newCells);
                        },
                        child: const Text('Add Row'),
                      ),

                      const SizedBox(
                        width: 10,
                      ),
                      // this button is for remove column
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          // this is for removing column from the columns list
                          void deleteColumn() {
                            // Provide the field name of the column you want to delete
                            String columnToDelete =
                                value; // Replace with the actual field name

                            List<PlutoColumn> columnsToDelete = [];

                            for (int i = 0;
                                i < stateManager.columns.length;
                                i++) {
                              PlutoColumn column = stateManager.columns[i];
                              if (column.field == columnToDelete) {
                                columnsToDelete.add(column);
                                removeColumn(colIDX: i);
                              }
                            }
                            stateManager.removeColumns(columnsToDelete);
                          }

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    'Are you sure you want to delete this ${value.toUpperCase()} column?'),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('No'),
                                  ),
                                  OutlinedButton(
                                    onPressed: () {
                                      deleteColumn();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Yes, I\'m sure'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        itemBuilder: (BuildContext context) {
                          return columns.map((PlutoColumn item) {
                            return PopupMenuItem<String>(
                              value: item.field,
                              child: Text(
                                item.title,
                                textAlign: TextAlign.start,
                              ),
                            );
                          }).toList();
                        },
                        tooltip: 'Delete Column',
                        child: const Icon(
                          Icons.view_column_outlined,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }
}

class SelectColumnTypeDropDown extends StatefulWidget {
  final void Function(String) onColumnTypeSelected;
  const SelectColumnTypeDropDown(
      {super.key, required this.onColumnTypeSelected});

  @override
  State<SelectColumnTypeDropDown> createState() =>
      _SelectColumnTypeDropDownState();
}

class _SelectColumnTypeDropDownState extends State<SelectColumnTypeDropDown> {
  String selectedValue = 'text';
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedValue,
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue!;
          widget.onColumnTypeSelected(newValue);
        });
      },
      items: <String>['text', 'time', 'currency', 'number', 'date']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class CustomEnterKeyAction extends PlutoGridShortcutAction {
  @override
  void execute({
    required PlutoKeyManagerEvent keyEvent,
    required PlutoGridStateManager stateManager,
  }) {
    print('Pressed enter key.');
  }
}
