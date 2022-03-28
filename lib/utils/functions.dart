// ignore_for_file: prefer_const_constructors

import 'package:jiffy/jiffy.dart';

int value = 1;

void setvalue(int val){
  value = val;
}

int pendingIssues(List<Map<String, dynamic>> map) {
  int pending = 0;
  for (var i = 0; i < map.length; i++) {
    if (map[i]['status'] == 'Pending') {
      pending++;
    }
  }
  return pending;
}

int resolvedIssues(List<Map<String, dynamic>> map) {
  int resolve = 0;
  for (var i = 0; i < map.length; i++) {
    if (map[i]['status'] == 'Done/Resolved') {
      resolve++;
    }
  }
  return resolve;
}

String validate() {
  if (value == 2) {
    return 'Done/Resolved';
  } else {
    return 'Pending';
  }
}

int notifCount(List<Map<String, dynamic>> map) {
  int count = 0;
  for (var i = 0; i < map.length; i++) {
    var date1 = Jiffy(map[i]['date']);
    var date2 = Jiffy(DateTime.now());
    num diff = date2.diff(date1, Units.HOUR);
    if (map[i]['status'] == 'Pending' && diff >= 72) {
      count++;
    }
  }
  return count;
}