int getCurrentUnixTimestamp() {
  return (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).round();
}

int getUnixTimestampAfter(Duration duration) {
  return (DateTime.now().add(duration).toUtc().millisecondsSinceEpoch / 1000)
      .round();
}
