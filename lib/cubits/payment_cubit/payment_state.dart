abstract class PaymentState {}

class PaymentInitialState extends PaymentState {}

class PaymentGetDataState extends PaymentState {
  final List<String> allTableNames;
  PaymentGetDataState({required this.allTableNames});
}

class PaymentSelectedTableData extends PaymentState {
  final Map<dynamic,dynamic> tableData;
  int payableAmount;
  int selectedTableIndex;
  PaymentSelectedTableData({required this.tableData, required this.payableAmount, required this.selectedTableIndex});
}