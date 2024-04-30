const String defaultBoard = "TODO";
Map<String, int> priorityStates = {'LOW': 0, 'MID': 1, 'HIGH': 2};

String getPriority(int value) {
  String key = 'LOW';
  priorityStates.forEach((k, v) {
    if (v == value) {
      key = k;
    }
  });
  return key;
}
