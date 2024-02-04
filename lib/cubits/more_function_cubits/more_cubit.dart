import 'package:flutter_bloc/flutter_bloc.dart';


class HoverCubit extends Cubit<bool> {
  HoverCubit(): super(false);

  void onHoverChange({required bool isHovered}) {
    emit(isHovered);
  }
}