int getMinuteDiff(int epoch) {
  final current = DateTime.now();
  final start = DateTime.fromMillisecondsSinceEpoch(epoch);

  return current.difference(start).inMinutes;
}
