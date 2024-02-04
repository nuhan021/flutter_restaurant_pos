abstract class SheetHomeState {}

class SheetHomeInitial extends SheetHomeState {}

class SheetHomeLoaded extends SheetHomeState {
  final List<dynamic> posSheetHomeData;
  SheetHomeLoaded({required this.posSheetHomeData});
}