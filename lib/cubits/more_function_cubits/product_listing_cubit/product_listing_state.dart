abstract class ProductListingState {}
abstract class ProductSectionState {}

class InitialState extends ProductListingState {}

class ProductListingSuccessState extends ProductListingState {}

class ProductListingErrorState extends ProductListingState {}

class ProductDisplaySuccessState extends ProductListingState {
  final List productList;
  ProductDisplaySuccessState({required this.productList});
}



class SectionInitialState extends ProductSectionState {}

class SectionDisplaySuccessState extends ProductSectionState{
  final List sectionList;
  SectionDisplaySuccessState({required this.sectionList});
}