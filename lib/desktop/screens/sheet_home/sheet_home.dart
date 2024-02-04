import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_pos/cubits/sheet_home_cubit/sheet_home_cubit.dart';
import 'package:restaurant_pos/cubits/sheet_home_cubit/sheet_home_state.dart';

class SheetHome extends StatelessWidget {
  SheetHome({super.key});

  TextEditingController sheetNameController = TextEditingController();
  TextEditingController editNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'POS SHEET HOME',
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade100),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.orange.shade100
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade600),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              // this section is for toolbar
              Container(
                width: 60,
                height: double.infinity,
                decoration: BoxDecoration(
                    border:
                        Border(right: BorderSide(color: Colors.grey.shade600))),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),

                      // this button will open a dialog box to create new sheet
                      IconButton(
                        onPressed: () {
                          // create new sheet function
                          void createNewSheet() {
                            BlocProvider.of<SheetHomeCubit>(context)
                                .createSheet(
                                    sheetName: sheetNameController.text);
                            Navigator.pop(context);
                          }

                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: SizedBox(
                                  height: 150,
                                  width: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text(
                                          'Enter your sheet name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),

                                        // this text field is for take sheet name
                                        TextField(
                                          controller: sheetNameController,
                                          decoration: InputDecoration(
                                              label: const Text('Name'),
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

                                        // this button will create new sheet
                                        OutlinedButton(
                                          onPressed: () {
                                            createNewSheet();
                                          },
                                          child: const Text('Create'),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.deepOrange,
                        ),
                        tooltip: 'Create new sheet',
                      )
                    ],
                  ),
                ),
              ),

              // this section is for display all the sheets
              BlocBuilder<SheetHomeCubit, SheetHomeState>(
                builder: (context, state) {
                  List<dynamic> sheets = [];
                  if (state is SheetHomeLoaded) {
                    sheets = state.posSheetHomeData.toList();
                  }
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
                      itemCount: sheets.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 130,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.2 / 1.2,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onDoubleTap: () {
                            Navigator.pushNamed(context, '/pos-sheet', arguments: index);
                          },

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children:[ Image.asset(
                                      'assets/icons/archive.png',
                                      fit: BoxFit.fill,
                                    ),

                                      Positioned(
                                        right: 0,
                                          child: PopupMenuButton<String>(
                                            onSelected: (String result) {
                                              if(result == 'delete') {

                                                void deleteSheet() {
                                                  BlocProvider.of<SheetHomeCubit>(context).deleteSheet(sheetIdx: index);
                                                  Navigator.pop(context);
                                                }
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text('Do you want to delete ${sheets[index]['name']}'),
                                                      actions: [
                                                        OutlinedButton(
                                                          onPressed: (){
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Text('No'),
                                                        ),
                                                        OutlinedButton(
                                                          onPressed: (){
                                                            deleteSheet();
                                                          },
                                                          child: const Text('Yes'),
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                              else if( result == 'open') {
                                                Navigator.pushNamed(context, '/pos-sheet', arguments: index);
                                              } else {
                                                editNameController.text = sheets[index]['name'].toString();
                                                // update name function
                                                void updateSheetName() {
                                                  BlocProvider.of<SheetHomeCubit>(context).updateSheetName(sheetIndex: index, newName: editNameController.text);
                                                  Navigator.pop(context);
                                                }
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      child: Container(
                                                        padding: const EdgeInsets.all(10),
                                                        height: 150,
                                                        width: 200,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Text('Edit sheet name',),

                                                            TextField(
                                                              controller: editNameController,
                                                              decoration: InputDecoration(
                                                                  label: const Text('Edit name'),
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

                                                            OutlinedButton(
                                                              onPressed: () {
                                                                updateSheetName();
                                                              },
                                                              child: Text('Update'),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                              const PopupMenuItem<String>(
                                                value: 'open',
                                                child: Text('Open'),
                                              ),
                                              const PopupMenuItem<String>(
                                                value: 'edit',
                                                child: Text('Edit'),
                                              ),
                                              const PopupMenuItem<String>(
                                                value: 'delete',
                                                child: Text('Delete'),
                                              ),
                                            ],
                                            tooltip: 'More',
                                            child: Icon(Icons.more_vert, color: Colors.orange.shade100,),
                                          ),
                                      )

                                    ]
                                  ),
                                ),
                                Text(
                                  sheets[index]['name'],
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
