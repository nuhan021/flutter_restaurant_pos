abstract class SalesRegisterState {}

class SalesRegisterInitialState extends SalesRegisterState {}

class SalesRegisterGetHistoryState extends SalesRegisterState {
  List<dynamic> historyData;
  int filterSelectedItem;
  SalesRegisterGetHistoryState({required this.historyData, required this.filterSelectedItem});
}