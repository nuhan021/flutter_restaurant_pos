abstract class MenuTabState {}

class MenuTabInitialState extends MenuTabState {}

class MenuTabGetFoodSectionState extends MenuTabState {
  final List<dynamic> foodSection;
  final List<dynamic> foodList;
  final List<dynamic> tableList;
  MenuTabGetFoodSectionState({required this.foodSection, required this.foodList, required this.tableList});
}


