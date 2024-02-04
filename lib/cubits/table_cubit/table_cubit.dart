import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedItemCubit extends Cubit<int> {
  SelectedItemCubit() : super(-1);

  void selectItem(int index) {
    emit(state == index ? -1 : index);
  }

  bool isSelected(int index) {
    return state == index;
  }


}