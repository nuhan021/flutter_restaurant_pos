import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'employee_state.dart';

// this cubit is for the employee position select
class SelectEmployeePositionCubit extends Cubit<String> {
  SelectEmployeePositionCubit() : super('');

  void selectPosition({required String value}) {
    emit(value);
  }

  // clear radio button
  void selectPositionClear() {
    emit('');
  }
}

// this cubit is for take the employee NID card image
class PickNidImage extends Cubit<String> {
  PickNidImage() : super('');

  // this function is for take the image that user select for NID
  void pickImage() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg']);
    emit(result!.files.first.path.toString());
  }

  // Function to clear the picked image
  void clearImage() {
    emit('');
  }
}

// this cubit is for take the employee image
class PickEmployeeImage extends Cubit<String> {
  PickEmployeeImage() : super('');

  // this function is for take the image that user select for NID
  void pickImage() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg']);
    emit(result!.files.first.path.toString());
  }

  // Function to clear the picked image
  void clearImage() {
    emit('');
  }
}

// this cubit is for take the employee cv image
class PickEmployeeCvImage extends Cubit<String> {
  PickEmployeeCvImage() : super('');

  // this function is for take the image that user select for NID
  void pickImage() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowCompression: true,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg']);
    emit(result!.files.first.path.toString());
  }

  // Function to clear the picked image
  void clearImage() {
    emit('');
  }
}

// this cubit is for employee segment
class EmployeeCubit extends Cubit<EmployeeState> {
  EmployeeCubit() : super(EmployeeInitial()) {
    getEmployeeData();
  }

  // get the employee database ref
  var employeeDatabase = Hive.box('employee_data');

  // this function will get all the employee data from the database
  void getEmployeeData() async {
    // get the employee data from the database
    var employeeData = employeeDatabase.values.toList();
    // check if the employee data is not empty
    emit(Employee(employee: employeeData));
  }

  // this function will add new employee when user click on add button
  void addEmployee({
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    // required String gender,
    required String presentAddress,
    required String permanentAddress,
    required String nid,
    required String phone,
    required String salary,
    required String position,
    required String nidImageUrl,
    required String employeeImageUrl,
    required String employeeCvImageUrl,
  }) async {
    // Specify the destination directory for NID image, Employee image & Employee CV image
    String nidImageDestinationDirectory =
        '${Directory.current.path}/nid_images';
    String employeeImageDestinationDirectory =
        '${Directory.current.path}/employee_images';
    String cvImageDestinationDirectory = '${Directory.current.path}/cv_images';

    // Ensure the destination directory are exists
    await Directory(nidImageDestinationDirectory).create(recursive: true);
    await Directory(employeeImageDestinationDirectory).create(recursive: true);
    await Directory(cvImageDestinationDirectory).create(recursive: true);

    // Extract the file name from the nid, employee and cv image path
    final nidImageFileName = nidImageUrl.split('/').last;
    final employeeImageFileName = employeeImageUrl.split('/').last;
    final cvImageFileName = employeeCvImageUrl.split('/').last;

    // Construct the full destination path for NID image, Employee image & Employee CV image
    String nidImageDestinationPath =
        '$nidImageDestinationDirectory/$nidImageFileName';
    String employeeImageDestinationPath =
        '$employeeImageDestinationDirectory/$employeeImageFileName';
    String cvImageDestinationPath =
        '$cvImageDestinationDirectory/$cvImageFileName';

    // Copy the NID image, Employee image & Employee CV image to the destination directory
    await File(nidImageUrl).copy(nidImageDestinationPath);
    await File(employeeImageUrl).copy(employeeImageDestinationPath);
    await File(employeeCvImageUrl).copy(cvImageDestinationPath);

    // create map for store data
    Map<dynamic, dynamic> employeeMap = {
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth,
      'nid': nid,
      'phone': phone,
      'salary': salary,
      'position': position,
      'present_address': presentAddress,
      'permanent_address': permanentAddress,
      'nid_image_url': nidImageDestinationPath,
      'employee_image_url': employeeImageDestinationPath,
      'employee_cv_image_url': cvImageDestinationPath,
    };

    // Add the employee data to the database
    employeeDatabase.add(employeeMap);

    // emit the employee state
    emit(Employee(employee: employeeDatabase.values.toList()));
  }

  // delete employee
  void deleteEmployee({required int selectedEmployeeIndex}) async {
    // get the data of selected employee from the database
    Map<dynamic, dynamic> selectedEmployee =
        employeeDatabase.getAt(selectedEmployeeIndex);
    // get the nid image path
    String nidImgPath = selectedEmployee['nid_image_url'];
    // get the employee image path
    String employeeImgPath = selectedEmployee['nid_image_url'];
    // get the employee cv image path
    String cvImgPath = selectedEmployee['nid_image_url'];

    // delete selected employee data
    await employeeDatabase.deleteAt(selectedEmployeeIndex);

    try {
      // delete the nid image, employee image & employee cv image
      await File(nidImgPath).delete();
      await File(employeeImgPath).delete();
      await File(cvImgPath).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting image: $e');
      }
    }

    // emit the employee state with employeeDatabase data
    emit(Employee(employee: employeeDatabase.values.toList()));
  }

  // update employee data
  void updateEmployeeData({
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String presentAddress,
    required String permanentAddress,
    required String nid,
    required String phone,
    required String salary,
    required String position,
    required int selectedIndex
  }) {
    // get the employee data based on selectedIndex
    Map<dynamic, dynamic> employeeData = employeeDatabase.getAt(selectedIndex);


    // create map for update selected data
    Map<dynamic, dynamic> employeeMap = {
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth,
      'nid': nid,
      'phone': phone,
      'salary': salary,
      'position': position,
      'present_address': presentAddress,
      'permanent_address': permanentAddress,
      'nid_image_url': employeeData['nid_image_url'],
      'employee_image_url': employeeData['employee_image_url'],
      'employee_cv_image_url': employeeData['employee_cv_image_url'],
    };

    // update the employee data
    employeeDatabase.putAt(selectedIndex, employeeMap);
  }
}

// this cubit is for employee position segment

class EmployeePositionCubit extends Cubit<EmployeePositionState> {
  EmployeePositionCubit() : super(EmployeePositionInitial()) {
    // initially call the getPosition data for fetch all the data from the database
    getPosition();
  }

  // get the employee position data from the database
  var employeePositionDatabase = Hive.box('employee_position');

  // this function will get all the data from the position database
  void getPosition() {
    // take all value from employeePositionDatabase
    List employeePositionData = employeePositionDatabase.values.toList();
    emit(EmployeePosition(employeePositionList: employeePositionData));
  }

  // this function add new position segment to the database
  void addPosition({required String positionName}) async {
    // add positionName to the database
    employeePositionDatabase.add(positionName);

    // take all value from employeePositionDatabase
    List employeePositionData = employeePositionDatabase.values.toList();

    // emit the state with employeePositionDatabase data
    emit(EmployeePosition(employeePositionList: employeePositionData));
  }

  // this function delete the position segment from the database
  void deletePosition({required int selectedPositionIndex}) {
    // delete the position at the selectedPositionIndex
    employeePositionDatabase.deleteAt(selectedPositionIndex);

    // take all value from employeePositionDatabase
    List employeePositionData = employeePositionDatabase.values.toList();

    // emit the state with employeePositionDatabase data
    emit(EmployeePosition(employeePositionList: employeePositionData));
  }


  void updatePosition({required int selectedPositionIndex, required String positionName}) {
    // update the position name
    employeePositionDatabase.putAt(selectedPositionIndex, positionName);

    // take all value from employeePositionDatabase
    List employeePositionData = employeePositionDatabase.values.toList();

    // emit the state with employeePositionDatabase data
    emit(EmployeePosition(employeePositionList: employeePositionData));
  }
}

// this cubit is for the employee position select
class SelectEditEmployeePositionCubit extends Cubit<String> {
  SelectEditEmployeePositionCubit() : super('');

  void selectPosition({required String value}) {
    emit(value);
  }

  // clear radio button
  void selectPositionClear() {
    emit('');
  }
}
