abstract class SheetState {}

class SheetInitial extends SheetState {}

class SheetLoading extends SheetState {}

class SheetLoaded extends SheetState {
  final List<dynamic> sheetData;
  final List sheetRowData;
  final String sheetName;
  SheetLoaded({required this.sheetRowData, required this.sheetData, required this.sheetName});
}