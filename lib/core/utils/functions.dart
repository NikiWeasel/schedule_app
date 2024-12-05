import 'package:schedule_app/core/models/regulation.dart';

Map<String, int> regToServicesList(List<Regulation> regList) {
  Map<String, int> map = {};
  for (var e in regList) {
    map[e.name] = e.duration;
  }
  return map;
}
