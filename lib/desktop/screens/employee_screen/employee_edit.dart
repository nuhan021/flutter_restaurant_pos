import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_pos/cubits/employee_cubit/employee_cubit.dart';

class EmployeeEdit extends StatelessWidget {
  // position list from employee screen
  final List<dynamic> positionList;
  // employee position name from employee screen
  final String employeePosition;
  // employee first name
  final String firstName;
  // employee last name
  final String lastName;
  // employee date of birth
  final String dateOfBirth;
  // employee present address
  final String presentAddress;
  // employee permanent address
  final String permanentAddress;
  // employee nid number
  final String nidNumber;
  // employee phone number
  final String phoneNumber;
  // employee salary
  final String salary;
  // selected index number
  final int selectedIndex;

  EmployeeEdit(
      {super.key,
      required this.positionList,
      required this.employeePosition,
      required this.firstName,
      required this.lastName,
      required this.dateOfBirth,
      required this.presentAddress,
      required this.permanentAddress,
      required this.nidNumber,
      required this.phoneNumber,
      required this.salary,
      required this.selectedIndex});

  // select position radio button variable
  String? selectedItem;

  // all text field controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController presentAddressController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController nidNumberController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController salaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // change the value of all textEditController with dynamic values
    firstNameController = TextEditingController(text: firstName);
    lastNameController = TextEditingController(text: lastName);
    dateOfBirthController = TextEditingController(text: dateOfBirth);
    presentAddressController = TextEditingController(text: presentAddress);
    permanentAddressController = TextEditingController(text: permanentAddress);
    nidNumberController = TextEditingController(text: nidNumber);
    phoneNumberController = TextEditingController(text: phoneNumber);
    salaryController = TextEditingController(text: salary);

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: double.infinity,
        width: 500,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade600,
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // boiler text
              const Text(
                'Edit your employee details',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),

              const SizedBox(
                height: 35,
              ),

              // edit first name
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                    label: const Text('First name'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    prefixIcon: Icon(
                      Icons.attach_money,
                      color: Colors.orange.shade100,
                    )),
              ),

              const SizedBox(
                height: 15,
              ),

              // edit last name
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                    label: const Text('First name'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    prefixIcon: Icon(
                      Icons.attach_money,
                      color: Colors.orange.shade100,
                    )),
              ),

              const SizedBox(
                height: 15,
              ),

              // edit date of birth
              TextField(
                controller: dateOfBirthController,
                decoration: InputDecoration(
                    label: const Text('Date of birth'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    prefixIcon: Icon(
                      Icons.date_range_outlined,
                      color: Colors.orange.shade100,
                    )),
              ),

              const SizedBox(
                height: 15,
              ),

              // edit present address
              TextField(
                controller: presentAddressController,
                decoration: InputDecoration(
                    label: const Text('Present address'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    prefixIcon: Icon(
                      Icons.home_outlined,
                      color: Colors.orange.shade100,
                    )),
              ),

              const SizedBox(
                height: 15,
              ),

              // edit permanent address
              TextField(
                controller: permanentAddressController,
                decoration: InputDecoration(
                    label: const Text('Permanent address'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    prefixIcon: Icon(
                      Icons.home_outlined,
                      color: Colors.orange.shade100,
                    )),
              ),

              const SizedBox(
                height: 15,
              ),

              // edit NID number
              TextField(
                controller: nidNumberController,
                decoration: InputDecoration(
                    label: const Text('NID number'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    prefixIcon: Icon(
                      Icons.credit_card_sharp,
                      color: Colors.orange.shade100,
                    )),
              ),

              const SizedBox(
                height: 15,
              ),

              // edit phone number
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                    label: const Text('Phone number'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      color: Colors.orange.shade100,
                    )),
              ),

              const SizedBox(
                height: 15,
              ),

              // edit employee salary
              TextField(
                controller: salaryController,
                decoration: InputDecoration(
                    label: const Text('Employee salary'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    enabled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade100)),
                    prefixIcon: Icon(
                      Icons.attach_money,
                      color: Colors.orange.shade100,
                    )),
              ),

              const SizedBox(
                height: 25,
              ),

              const Text(
                'Position',
                style: TextStyle(fontSize: 21),
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
                    border: Border.all(color: Colors.orange.shade100)),
                child: BlocBuilder<SelectEditEmployeePositionCubit, String>(
                  builder: (context, editSelectedItem) {
                    if (editSelectedItem == '') {
                      selectedItem = employeePosition;
                    } else {
                      selectedItem = editSelectedItem;
                    }

                    return ListView.builder(
                      itemCount: positionList.length,
                      itemBuilder: (context, index) {
                        if (positionList.isNotEmpty) {
                          return ListTile(
                            title: Text(positionList[index]),
                            leading: Radio(
                              activeColor: Colors.deepOrange,
                              value: positionList[index],
                              groupValue: selectedItem,
                              onChanged: (value) {
                                BlocProvider.of<
                                            SelectEditEmployeePositionCubit>(
                                        context)
                                    .selectPosition(value: value);
                              },
                            ),
                          );
                        } else {
                          return Center(
                              child: Expanded(
                                  child: Text(
                            'No position segment found',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade100),
                          )));
                        }
                      },
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              // update and done button
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          BlocProvider.of<EmployeeCubit>(context)
                              .getEmployeeData();
                        },
                        child: const Text('Done')),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<EmployeeCubit>(context)
                              .updateEmployeeData(
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  dateOfBirth: dateOfBirthController.text,
                                  presentAddress: presentAddressController.text,
                                  permanentAddress:
                                      permanentAddressController.text,
                                  nid: nidNumberController.text,
                                  phone: phoneNumberController.text,
                                  salary: salaryController.text,
                                  position: selectedItem!,
                                  selectedIndex: selectedIndex);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Center(
                                child: Text('Update successful',style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold
                                ),),
                              ),
                              backgroundColor: Colors.green,
                            )
                          );
                        },
                        child: const Text('Update')),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
