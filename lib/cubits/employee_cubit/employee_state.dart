abstract class EmployeeState {}
abstract class EmployeePositionState {}

// this state is the initial state of the EmployeeState
class EmployeeInitial extends EmployeeState {}

// this state is employee added success state
class Employee extends EmployeeState {
  final List employee;
  Employee({required this.employee});
}

// this state is the initial state of the employeePositionState
class EmployeePositionInitial extends EmployeePositionState{}

// this state is for employee position segment
class EmployeePosition extends EmployeePositionState {
  final List employeePositionList;
  EmployeePosition({required this.employeePositionList});
}
