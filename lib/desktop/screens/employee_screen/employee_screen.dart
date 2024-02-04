import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_pos/const.dart';
import 'package:restaurant_pos/cubits/employee_cubit/employee_cubit.dart';
import 'package:restaurant_pos/cubits/employee_cubit/employee_state.dart';
import 'package:restaurant_pos/desktop/screens/employee_screen/employee_edit.dart';

class EmployeeScreen extends StatelessWidget {
  EmployeeScreen({super.key});

  // this variable will store the picked NID card image path
  String? pickedNIDCardImagePath;

  // nid icon path
  String nidIcon = 'assets/icons/id-card.png';

  // this variable will store the picked employee image path
  String? pickedEmployeeImagePath;

  // employee icon path
  String employeeIcon = 'assets/icons/people.png';

  // this variable will store the picked employee cv image
  String? pickedEmployeeCVImagePath;

  // employee cv icon path
  String employeeCVIcon = 'assets/icons/personal-information.png';

  // this variable will store the selected position
  String? selectedPosition;

  String employeePosition = '';

  // all textField controllers
  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController dateOfBirthController = TextEditingController();

  TextEditingController presentAddressController = TextEditingController();

  TextEditingController permanentAddressController = TextEditingController();

  TextEditingController nidNumberController = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController salaryController = TextEditingController();

  TextEditingController positionNameController = TextEditingController();

  // position list
  List<dynamic> positionList = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // app bar
        appBar: AppBar(
          backgroundColor: Colors.grey.shade800,
          elevation: 0,
          title: Text(
            'EMPLOYEES',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.orange.shade100),
          ),
          iconTheme: IconThemeData(color: Colors.orange.shade100),
          actions: [
            IconButton(
                onPressed: () {
                  BlocProvider.of<EmployeeCubit>(context).getEmployeeData();
                },
                icon: const Icon(Icons.refresh))
          ],
        ),

        // body
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
                border: Border.all(color: Colors.grey.shade600, width: 1)),
            child: Row(
              children: [
                // employee list
                Expanded(
                  child: BlocBuilder<EmployeeCubit, EmployeeState>(
                    builder: (context, state) {
                      if (state is Employee) {
                        List employeeData = state.employee.toList();

                        // this gridview will display all employee data
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            itemCount: employeeData.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 280,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              childAspectRatio: 1.2 / 1.9,
                            ),
                            itemBuilder: (context, index) {
                              employeePosition =
                                  employeeData[index]['position'];
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[600],
                                ),
                                child: Column(
                                  children: [
                                    // food image
                                    Expanded(
                                      flex: 2,
                                      child: SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.file(
                                                File(employeeData[index]
                                                    ['employee_image_url']),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )),
                                    ),

                                    // food details
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              // food name
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                          '${employeeData[index]['first_name']} ${employeeData[index]['last_name']}',
                                                          style: TextStyle(
                                                              fontSize: 19,
                                                              color: Colors
                                                                  .orange
                                                                  .shade100))),

                                                  // edite button
                                                  IconButton(
                                                    onPressed: () {
                                                      // open dialog box
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          // return EmployeeEdit();
                                                          return MultiBlocProvider(
                                                            providers: [
                                                              BlocProvider(
                                                                create: (context) =>
                                                                    SelectEditEmployeePositionCubit(),
                                                              ),
                                                              BlocProvider(
                                                                create: (context) =>
                                                                    EmployeeCubit(),
                                                              ),
                                                            ],
                                                            child: EmployeeEdit(
                                                              positionList:
                                                                  positionList,
                                                              employeePosition:
                                                                  employeePosition,
                                                              firstName:
                                                                  employeeData[
                                                                          index]
                                                                      [
                                                                      'first_name'],
                                                              lastName:
                                                                  employeeData[
                                                                          index]
                                                                      [
                                                                      'last_name'],
                                                              dateOfBirth:
                                                                  employeeData[
                                                                          index]
                                                                      [
                                                                      'date_of_birth'],
                                                              presentAddress:
                                                                  employeeData[
                                                                          index]
                                                                      [
                                                                      'present_address'],
                                                              permanentAddress:
                                                                  employeeData[
                                                                          index]
                                                                      [
                                                                      'permanent_address'],
                                                              nidNumber:
                                                                  employeeData[
                                                                          index]
                                                                      ['nid'],
                                                              phoneNumber:
                                                                  employeeData[
                                                                          index]
                                                                      ['phone'],
                                                              salary:
                                                                  employeeData[
                                                                          index]
                                                                      [
                                                                      'salary'],
                                                              selectedIndex:
                                                                  index,
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      size: 17,
                                                    ),
                                                  )
                                                ],
                                              ),

                                              const SizedBox(
                                                height: 15,
                                              ),

                                              // food category
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Salary: ${employeeData[index]['salary']} TK'),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        '${employeeData[index]['position']}',
                                                      )),

                                                      // view button
                                                      IconButton(
                                                          onPressed: () {
                                                            // dedicated delete function
                                                            void
                                                                deleteEmployee() {
                                                              BlocProvider.of<
                                                                          EmployeeCubit>(
                                                                      context)
                                                                  .deleteEmployee(
                                                                      selectedEmployeeIndex:
                                                                          index);
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context);
                                                            }

                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Dialog(
                                                                  elevation: 30,

                                                                  // employee details
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            20),
                                                                    height: double
                                                                        .infinity,
                                                                    width: 600,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          // employee image
                                                                          ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                // show dialog box for view the cv image
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (context) {
                                                                                    return Dialog(
                                                                                      elevation: 30,
                                                                                      child: SizedBox(
                                                                                        height: 800,
                                                                                        width: 800,
                                                                                        child: Stack(children: [
                                                                                          // zoom functionality image
                                                                                          SizedBox(
                                                                                            height: double.infinity,
                                                                                            width: double.infinity,
                                                                                            child: InteractiveViewer(
                                                                                              maxScale: 3,
                                                                                              minScale: 1,
                                                                                              child: Image.file(
                                                                                                File(employeeData[index]['employee_image_url']),
                                                                                                fit: BoxFit.contain,
                                                                                              ),
                                                                                            ),
                                                                                          ),

                                                                                          // cancel button
                                                                                          IconButton(
                                                                                              onPressed: () {
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              icon: Icon(
                                                                                                Icons.cancel_outlined,
                                                                                                color: Colors.grey.shade200,
                                                                                              ))
                                                                                        ]),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                              child: Image.file(
                                                                                File(employeeData[index]['employee_image_url']),
                                                                                height: 151,
                                                                                width: 151,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          const SizedBox(
                                                                              height: 15),

                                                                          // employee name
                                                                          RichText(
                                                                              text: TextSpan(style: TextStyle(fontSize: 27, color: Colors.orange.shade100, fontWeight: FontWeight.bold), children: [
                                                                            TextSpan(
                                                                              text: '${employeeData[index]['first_name']} ${employeeData[index]['last_name']}',
                                                                            )
                                                                          ])),

                                                                          const SizedBox(
                                                                              height: 65),

                                                                          // employee date of birth
                                                                          RichText(
                                                                              text: TextSpan(style: TextStyle(fontSize: 17, color: Colors.orange.shade100, fontWeight: FontWeight.bold), children: [
                                                                            const TextSpan(
                                                                              text: 'Date of Birth: ',
                                                                            ),
                                                                            TextSpan(
                                                                                text: employeeData[index]['date_of_birth'],
                                                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
                                                                          ])),

                                                                          const SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          // employee present address
                                                                          RichText(
                                                                              text: TextSpan(style: TextStyle(fontSize: 17, color: Colors.orange.shade100, fontWeight: FontWeight.bold), children: [
                                                                            const TextSpan(
                                                                              text: 'Present Address: ',
                                                                            ),
                                                                            TextSpan(
                                                                                text: employeeData[index]['present_address'],
                                                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
                                                                          ])),

                                                                          const SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),

                                                                          // employee permanent address
                                                                          RichText(
                                                                              text: TextSpan(style: TextStyle(fontSize: 17, color: Colors.orange.shade100, fontWeight: FontWeight.bold), children: [
                                                                            const TextSpan(
                                                                              text: 'Permanent Address: ',
                                                                            ),
                                                                            TextSpan(
                                                                                text: employeeData[index]['permanent_address'],
                                                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
                                                                          ])),

                                                                          const SizedBox(
                                                                              height: 15),

                                                                          // employee nid number
                                                                          RichText(
                                                                              text: TextSpan(style: TextStyle(fontSize: 17, color: Colors.orange.shade100, fontWeight: FontWeight.bold), children: [
                                                                            const TextSpan(
                                                                              text: 'NID NO: ',
                                                                            ),
                                                                            TextSpan(
                                                                                text: employeeData[index]['nid'],
                                                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
                                                                          ])),

                                                                          const SizedBox(
                                                                              height: 15),

                                                                          // employee phone number
                                                                          RichText(
                                                                              text: TextSpan(style: TextStyle(fontSize: 17, color: Colors.orange.shade100, fontWeight: FontWeight.bold), children: [
                                                                            const TextSpan(
                                                                              text: 'Phone NO: ',
                                                                            ),
                                                                            TextSpan(
                                                                                text: employeeData[index]['phone'],
                                                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
                                                                          ])),

                                                                          const SizedBox(
                                                                              height: 15),

                                                                          // employee salary
                                                                          RichText(
                                                                              text: TextSpan(style: TextStyle(fontSize: 17, color: Colors.orange.shade100, fontWeight: FontWeight.bold), children: [
                                                                            const TextSpan(
                                                                              text: 'Salary: ',
                                                                            ),
                                                                            TextSpan(
                                                                                text: "${employeeData[index]['salary']} TK",
                                                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
                                                                          ])),

                                                                          const SizedBox(
                                                                              height: 15),

                                                                          // employee position
                                                                          RichText(
                                                                              text: TextSpan(style: TextStyle(fontSize: 17, color: Colors.orange.shade100, fontWeight: FontWeight.bold), children: [
                                                                            const TextSpan(
                                                                              text: 'Position: ',
                                                                            ),
                                                                            TextSpan(
                                                                                text: employeeData[index]['position'],
                                                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal)),
                                                                          ])),

                                                                          const SizedBox(
                                                                            height:
                                                                                25,
                                                                          ),

                                                                          // employee nid and cv image
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              // nid image
                                                                              Row(children: [
                                                                                Text(
                                                                                  'NID image: ',
                                                                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.orange.shade100),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      // show dialog box for view the cv image
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (context) {
                                                                                          return Dialog(
                                                                                            elevation: 30,
                                                                                            child: SizedBox(
                                                                                              height: 800,
                                                                                              width: 800,
                                                                                              child: Stack(children: [
                                                                                                // zoom functionality image
                                                                                                SizedBox(
                                                                                                  height: double.infinity,
                                                                                                  width: double.infinity,
                                                                                                  child: InteractiveViewer(
                                                                                                    maxScale: 3,
                                                                                                    minScale: 1,
                                                                                                    child: Image.file(
                                                                                                      File(employeeData[index]['nid_image_url']),
                                                                                                      fit: BoxFit.contain,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),

                                                                                                // cancel button
                                                                                                IconButton(
                                                                                                    onPressed: () {
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    icon: Icon(
                                                                                                      Icons.cancel_outlined,
                                                                                                      color: Colors.grey.shade200,
                                                                                                    ))
                                                                                              ]),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                    child: Image.file(
                                                                                      File(employeeData[index]['nid_image_url']),
                                                                                      height: 151,
                                                                                      width: 151,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ]),

                                                                              // cv image
                                                                              Row(children: [
                                                                                Text(
                                                                                  'CV image: ',
                                                                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.orange.shade100),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      // show dialog box for view the cv image
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (context) {
                                                                                          return Dialog(
                                                                                            elevation: 30,
                                                                                            child: SizedBox(
                                                                                              height: 800,
                                                                                              width: 800,
                                                                                              child: Stack(children: [
                                                                                                // zoom functionality image
                                                                                                SizedBox(
                                                                                                  height: double.infinity,
                                                                                                  width: double.infinity,
                                                                                                  child: InteractiveViewer(
                                                                                                    maxScale: 3,
                                                                                                    minScale: 1,
                                                                                                    child: Image.file(
                                                                                                      File(employeeData[index]['employee_cv_image_url']),
                                                                                                      fit: BoxFit.contain,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),

                                                                                                // cancel button
                                                                                                IconButton(
                                                                                                    onPressed: () {
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    icon: Icon(
                                                                                                      Icons.cancel_outlined,
                                                                                                      color: Colors.grey.shade200,
                                                                                                    ))
                                                                                              ]),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                    child: Image.file(
                                                                                      File(employeeData[index]['employee_cv_image_url']),
                                                                                      height: 151,
                                                                                      width: 151,
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ]),
                                                                            ],
                                                                          ),

                                                                          const SizedBox(
                                                                            height:
                                                                                75,
                                                                          ),

                                                                          // delete cancel and print button
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              // delete button
                                                                              ElevatedButton(
                                                                                onPressed: () {
                                                                                  // show delete dialog
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return AlertDialog(
                                                                                        title: const Text('Delete employee'),
                                                                                        content: const Text('Are you sure you want to delete this employee?'),
                                                                                        actions: [
                                                                                          TextButton(
                                                                                            onPressed: () {
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: const Text('Cancel'),
                                                                                          ),
                                                                                          TextButton(
                                                                                            onPressed: deleteEmployee,
                                                                                            child: const Text('Delete'),
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child: const Text('Delete'),
                                                                              ),

                                                                              Row(
                                                                                children: [
                                                                                  ElevatedButton(
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: const Text('Close'),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  const ElevatedButton(
                                                                                    onPressed: null,
                                                                                    child: Text('Print ID card'),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ],
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
                                                              Icons
                                                                  .visibility_outlined,
                                                              size: 17)),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),

                // add new employee
                Container(
                    padding: const EdgeInsets.all(13),
                    width: 400,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        border: Border(
                      left: BorderSide(color: Colors.grey.shade600, width: 1),
                    )),
                    child: Column(
                      children: [
                        // employee and positions tab bar
                        TabBar(
                          tabs: const [
                            Tab(
                              icon: Icon(Icons.person_add_alt),
                              text: 'Employee',
                            ),
                            Tab(
                              icon: Icon(Icons.workspace_premium_outlined),
                              text: 'Position',
                            ),
                          ],
                          indicatorColor: Colors.deepOrange,
                          labelColor: Colors.orange.shade100,
                          unselectedLabelColor: Colors.grey.shade600,
                          padding: const EdgeInsets.only(bottom: 35),
                        ),

                        // tabBarView for employee and positions tabBar
                        Expanded(
                          child: TabBarView(children: [
                            // employee tabBar
                            SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // boiler text
                                  const Text(
                                    '+ Add New Employee',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 30,
                                  ),

                                  // first name
                                  TextField(
                                    controller: firstNameController,
                                    decoration: InputDecoration(
                                        label: const Text('First name'),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        enabled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        prefixIcon: Icon(
                                          Icons.person_outlined,
                                          color: Colors.orange.shade100,
                                        )),
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // last name
                                  TextField(
                                    controller: lastNameController,
                                    decoration: InputDecoration(
                                        label: const Text('Last name'),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        enabled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        prefixIcon: Icon(
                                          Icons.person_outlined,
                                          color: Colors.orange.shade100,
                                        )),
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // date of birth
                                  TextField(
                                    controller: dateOfBirthController,
                                    decoration: InputDecoration(
                                        label: const Text(
                                            'Date of birth (dd/mm/yyyy)'),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        enabled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        prefixIcon: Icon(
                                          Icons.date_range_outlined,
                                          color: Colors.orange.shade100,
                                        )),
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // present address
                                  TextField(
                                    controller: presentAddressController,
                                    decoration: InputDecoration(
                                        label: const Text('Present address'),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        enabled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        prefixIcon: Icon(
                                          Icons.home_outlined,
                                          color: Colors.orange.shade100,
                                        )),
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // permanent address
                                  TextField(
                                    controller: permanentAddressController,
                                    decoration: InputDecoration(
                                        label: const Text('permanent address'),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        enabled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        prefixIcon: Icon(
                                          Icons.home_outlined,
                                          color: Colors.orange.shade100,
                                        )),
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // nid card number
                                  TextField(
                                    controller: nidNumberController,
                                    decoration: InputDecoration(
                                        label: const Text('NID number'),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        enabled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        prefixIcon: Icon(
                                          Icons.credit_card_sharp,
                                          color: Colors.orange.shade100,
                                        )),
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // employee number
                                  TextField(
                                    controller: phoneNumberController,
                                    decoration: InputDecoration(
                                        label: const Text('Phone number'),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        enabled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        prefixIcon: Icon(
                                          Icons.phone_outlined,
                                          color: Colors.orange.shade100,
                                        )),
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // employee salary
                                  TextField(
                                    controller: salaryController,
                                    decoration: InputDecoration(
                                        label: const Text('Employee salary'),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        enabled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        prefixIcon: Icon(
                                          Icons.attach_money,
                                          color: Colors.orange.shade100,
                                        )),
                                  ),

                                  const SizedBox(
                                    height: 25,
                                  ),

                                  // add employee position
                                  const Text(
                                    'Position',
                                    style: TextStyle(
                                      fontSize: 19,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // employee positions
                                  Container(
                                    height: 200,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(
                                            color: Colors.orange.shade100)),
                                    child: BlocBuilder<
                                        SelectEmployeePositionCubit, String>(
                                      builder: (context, selectedItem) {
                                        selectedPosition = selectedItem;
                                        return BlocBuilder<
                                            EmployeePositionCubit,
                                            EmployeePositionState>(
                                          builder: (context, state) {
                                            if (state is EmployeePosition) {
                                              // get the data list from the state and store to employeePositionData
                                              List<dynamic>
                                                  employeePositionData = state
                                                      .employeePositionList
                                                      .toList();

                                              positionList =
                                                  employeePositionData.toList();

                                              if (employeePositionData
                                                  .isNotEmpty) {
                                                return ListView.builder(
                                                  itemCount:
                                                      employeePositionData
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return ListTile(
                                                      title: Text(
                                                          employeePositionData[
                                                              index]),
                                                      leading: Radio(
                                                        activeColor:
                                                            Colors.deepOrange,
                                                        value:
                                                            employeePositionData[
                                                                index],
                                                        groupValue:
                                                            selectedItem,
                                                        onChanged: (value) {
                                                          BlocProvider.of<
                                                                      SelectEmployeePositionCubit>(
                                                                  context)
                                                              .selectPosition(
                                                                  value: value
                                                                      .toString());
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                return Center(
                                                    child: Expanded(
                                                        child: Text(
                                                  'No position segment found',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .orange.shade100),
                                                )));
                                              }
                                            }

                                            return Container();
                                          },
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 25,
                                  ),

                                  // employee NID image
                                  Row(
                                    children: [
                                      const Expanded(
                                          child: Text(
                                        'Employee NID image :',
                                        style: TextStyle(fontSize: 17),
                                      )),

                                      // employee NID image
                                      InkWell(
                                        onTap: () {
                                          BlocProvider.of<PickNidImage>(context)
                                              .pickImage();
                                        },
                                        child:
                                            BlocBuilder<PickNidImage, String>(
                                          builder: (context, imageLink) {
                                            // this local string variable is for store the static default image link
                                            String imgUrl =
                                                'assets/icons/id-card.png';

                                            // this ternary logic decide that picked image link will store or not
                                            pickedNIDCardImagePath =
                                                imageLink.isNotEmpty
                                                    ? imageLink
                                                    : '';
                                            return Container(
                                                height: 200,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors
                                                          .orange.shade100),
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    child: Image.asset(
                                                      pickedNIDCardImagePath!
                                                              .isNotEmpty
                                                          ? pickedNIDCardImagePath!
                                                          : imgUrl,
                                                      fit: BoxFit.cover,
                                                      color:
                                                          imageLink.isNotEmpty
                                                              ? null
                                                              : Colors.grey
                                                                  .shade800,
                                                    ),
                                                  ),
                                                ));
                                          },
                                        ),
                                      )
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // employee image
                                  Row(
                                    children: [
                                      const Expanded(
                                          child: Text(
                                        'Employee image :',
                                        style: TextStyle(fontSize: 17),
                                      )),
                                      InkWell(
                                        onTap: () {
                                          BlocProvider.of<PickEmployeeImage>(
                                                  context)
                                              .pickImage();
                                        },
                                        child: BlocBuilder<PickEmployeeImage,
                                            String>(
                                          builder: (context, imageLink) {
                                            const String imgUrl =
                                                'assets/icons/people.png';
                                            // this ternary logic decide that picked image link will store or not
                                            pickedEmployeeImagePath =
                                                imageLink.isNotEmpty
                                                    ? imageLink
                                                    : '';
                                            return Container(
                                                height: 200,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors
                                                          .orange.shade100),
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    child: Image.asset(
                                                      imageLink.isNotEmpty
                                                          ? imageLink
                                                          : imgUrl,
                                                      fit: BoxFit.cover,
                                                      color:
                                                          imageLink.isNotEmpty
                                                              ? null
                                                              : Colors.grey
                                                                  .shade800,
                                                    ),
                                                  ),
                                                ));
                                          },
                                        ),
                                      )
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // employee cv
                                  Row(
                                    children: [
                                      const Expanded(
                                          child: Text(
                                        'Employee CV :',
                                        style: TextStyle(fontSize: 17),
                                      )),
                                      InkWell(
                                        onTap: () {
                                          BlocProvider.of<PickEmployeeCvImage>(
                                                  context)
                                              .pickImage();
                                        },
                                        child: BlocBuilder<PickEmployeeCvImage,
                                            String>(
                                          builder: (context, imageLink) {
                                            const String imgUrl =
                                                'assets/icons/personal-information.png';
                                            // this ternary logic decide that picked image link will store or not
                                            pickedEmployeeCVImagePath =
                                                imageLink.isNotEmpty
                                                    ? imageLink
                                                    : '';
                                            return Container(
                                                height: 200,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors
                                                          .orange.shade100),
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    child: Image.asset(
                                                      imageLink.isNotEmpty
                                                          ? imageLink
                                                          : imgUrl,
                                                      fit: BoxFit.cover,
                                                      color:
                                                          imageLink.isNotEmpty
                                                              ? null
                                                              : Colors.grey
                                                                  .shade800,
                                                    ),
                                                  ),
                                                ));
                                          },
                                        ),
                                      )
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // add employee button
                                  SizedBox(
                                      height: 50,
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            if (
                                                // check all the image url variable and text-fields are not empty or not
                                                // if empty then show error message
                                                firstNameController.text.isEmpty ||
                                                    lastNameController
                                                        .text.isEmpty ||
                                                    dateOfBirthController
                                                        .text.isEmpty ||
                                                    presentAddressController
                                                        .text.isEmpty ||
                                                    permanentAddressController
                                                        .text.isEmpty ||
                                                    nidNumberController
                                                        .text.isEmpty ||
                                                    phoneNumberController
                                                        .text.isEmpty ||
                                                    salaryController
                                                        .text.isEmpty ||
                                                    selectedPosition!.isEmpty ||
                                                    pickedNIDCardImagePath!
                                                        .isEmpty ||
                                                    pickedEmployeeCVImagePath!
                                                        .isEmpty ||
                                                    pickedEmployeeImagePath!
                                                        .isEmpty) {
                                              // emit a new message
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                  'Some field are missing!',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Colors.redAccent,
                                              ));
                                            } else {
                                              // call add employee function and filled the parameters
                                              BlocProvider.of<EmployeeCubit>(
                                                      context)
                                                  .addEmployee(
                                                firstName:
                                                    firstNameController.text,
                                                lastName:
                                                    lastNameController.text,
                                                dateOfBirth:
                                                    dateOfBirthController.text,
                                                presentAddress:
                                                    presentAddressController
                                                        .text,
                                                permanentAddress:
                                                    permanentAddressController
                                                        .text,
                                                nid: nidNumberController.text,
                                                phone:
                                                    phoneNumberController.text,
                                                salary: salaryController.text,
                                                position: selectedPosition!,
                                                nidImageUrl:
                                                    pickedNIDCardImagePath!,
                                                employeeImageUrl:
                                                    pickedEmployeeImagePath!,
                                                employeeCvImageUrl:
                                                    pickedEmployeeCVImagePath!,
                                              );

                                              // clear the image path
                                              BlocProvider.of<PickNidImage>(
                                                      context)
                                                  .clearImage();
                                              BlocProvider.of<
                                                          PickEmployeeImage>(
                                                      context)
                                                  .clearImage();
                                              BlocProvider.of<
                                                          PickEmployeeCvImage>(
                                                      context)
                                                  .clearImage();

                                              // clear the position radio button selection
                                              BlocProvider.of<
                                                          SelectEmployeePositionCubit>(
                                                      context)
                                                  .selectPositionClear();

                                              // clear all the text fields
                                              firstNameController.clear();
                                              lastNameController.clear();
                                              dateOfBirthController.clear();
                                              presentAddressController.clear();
                                              permanentAddressController
                                                  .clear();
                                              nidNumberController.clear();
                                              phoneNumberController.clear();
                                              salaryController.clear();

                                              // emit a new message
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                  'Employee added successfully',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Colors.greenAccent,
                                              ));
                                            }
                                          },
                                          child: const Text(
                                            'Add employee',
                                            style: TextStyle(fontSize: 17),
                                          ))),
                                ],
                              ),
                            ),

                            // position tabBar
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // boiler text
                                  const Text(
                                    '+ Add New Position',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 30,
                                  ),

                                  // list of positions
                                  Container(
                                    height: 500,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.orange.shade100),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: BlocBuilder<EmployeePositionCubit,
                                        EmployeePositionState>(
                                      builder: (context, state) {
                                        if (state is EmployeePosition) {
                                          // get the employeePositionData from the state
                                          List<dynamic> employeePositionData =
                                              state.employeePositionList
                                                  .toList();

                                          // check if employeePositionData is empty or not
                                          if (employeePositionData.isNotEmpty) {
                                            return ListView.builder(
                                              itemCount:
                                                  employeePositionData.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  title: Expanded(
                                                      child: Text(
                                                          employeePositionData[
                                                              index])),

                                                  // edit icon button
                                                  leading: IconButton(
                                                    onPressed: () {

                                                      TextEditingController editPositionName = TextEditingController();
                                                      editPositionName = TextEditingController(text: employeePositionData[index]);

                                                      // make a delete function
                                                      void updateFun({required String positionName}) {
                                                        BlocProvider.of<EmployeePositionCubit>(context).updatePosition(selectedPositionIndex: index, positionName: positionName);
                                                      }

                                                      // open a dialog box
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(

                                                            // edit section name
                                                            content:
                                                            TextField(
                                                              controller: editPositionName,
                                                              decoration: InputDecoration(
                                                                  label: const Text('Position name'),
                                                                  border: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(12),
                                                                      borderSide: BorderSide(color: Colors.orange.shade100)),
                                                                  enabled: true,
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(12),
                                                                      borderSide: BorderSide(color: Colors.orange.shade100)),
                                                                  prefixIcon: Icon(
                                                                    Icons.work_outline,
                                                                    color: Colors.orange.shade100,
                                                                  )),
                                                            ),

                                                            // update and done button
                                                            actions: [
                                                              ElevatedButton(
                                                                onPressed: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                child: const Text('Done'),
                                                              ),

                                                              ElevatedButton(
                                                                onPressed: (){
                                                                  updateFun(positionName: editPositionName.text);
                                                                  Navigator.pop(context);
                                                                },
                                                                child: const Text('Update'),
                                                              )
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.edit_outlined,
                                                      size: 17,
                                                      color: Colors.deepOrange,
                                                    ),
                                                  ),
                                                  trailing: OutlinedButton(
                                                      onPressed: () {
                                                        // local delete function
                                                        void deleteFun() {
                                                          // call the delete function
                                                          BlocProvider.of<
                                                                      EmployeePositionCubit>(
                                                                  context)
                                                              .deletePosition(
                                                                  selectedPositionIndex:
                                                                      index);
                                                        }

                                                        // open dialog box
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Delete box'),
                                                              content: const Text(
                                                                  'Do you want to delete this position section?'),
                                                              actions: [
                                                                // delete yes button
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    // call the local delete function to avoid 2 context coalition
                                                                    deleteFun();
                                                                    // remove the dialog box
                                                                    Navigator.pop(
                                                                        context);

                                                                    // emit a new message
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            SnackBar(
                                                                      content:
                                                                          const Text(
                                                                        'Position delete successfully',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      backgroundColor: Colors
                                                                          .grey
                                                                          .shade800,
                                                                    ));
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Yes'),
                                                                ),

                                                                // delete no button
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'No'),
                                                                )
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      style: ButtonStyle(
                                                        side: MaterialStateProperty.all<
                                                                BorderSide>(
                                                            const BorderSide(
                                                                color: Colors
                                                                    .transparent)),
                                                      ),
                                                      child: const Icon(
                                                        Icons.delete_outline,
                                                        color: Colors.redAccent,
                                                      )),
                                                );
                                              },
                                            );
                                          } else {
                                            return Center(
                                                child: Expanded(
                                              child: Text(
                                                'No position segment found',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.orange.shade100),
                                              ),
                                            ));
                                          }
                                        }

                                        return Container();
                                      },
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  TextField(
                                    controller: positionNameController,
                                    decoration: InputDecoration(
                                        label: const Text('Position name'),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        enabled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.orange.shade100)),
                                        prefixIcon: Icon(
                                          Icons.attach_money,
                                          color: Colors.orange.shade100,
                                        )),
                                  ),

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  // add position add button
                                  SizedBox(
                                      height: 50,
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            if (positionNameController
                                                .text.isNotEmpty) {
                                              // call the addPosition function
                                              BlocProvider.of<
                                                          EmployeePositionCubit>(
                                                      context)
                                                  .addPosition(
                                                      positionName:
                                                          positionNameController
                                                              .text);

                                              // clear the positionNameController
                                              positionNameController.clear();

                                              // emit a new message
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                  'Position added successfully',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                backgroundColor: Colors.green,
                                              ));
                                            }
                                          },
                                          child: const Text(
                                            'Add position',
                                            style: TextStyle(fontSize: 17),
                                          ))),
                                ],
                              ),
                            )
                          ]),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
