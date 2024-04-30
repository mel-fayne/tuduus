import 'package:tuduus/utils/constants.dart';

String getPriority(int value) {
  String key = 'LOW';
  priorityStates.forEach((k, v) {
    if (v == value) {
      key = k;
    }
  });
  return key;
}
