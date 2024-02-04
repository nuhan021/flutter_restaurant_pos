abstract class DbState {}

class InitialState extends DbState{}

class GetData extends DbState{
  final List<dynamic> tableDatas;
  GetData({required this.tableDatas});
}

