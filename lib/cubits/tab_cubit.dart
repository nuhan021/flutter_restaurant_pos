import 'package:flutter_bloc/flutter_bloc.dart';

class MenuTabCubit extends Cubit<int> {
  MenuTabCubit() : super(0);

  void setTabIndex(int index) {
    emit(index);
  }
}
