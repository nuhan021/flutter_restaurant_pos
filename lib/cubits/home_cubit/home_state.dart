abstract class HomeState {}

class InitialState extends HomeState{}

class OrderFoundState extends HomeState {
  final List<dynamic> tableData;
  final int selectedItem;
  OrderFoundState({required this.tableData, required this.selectedItem});
}

class OrderNotFoundState extends HomeState {}