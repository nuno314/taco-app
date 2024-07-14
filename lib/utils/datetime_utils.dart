DateTime firstDateOfWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday - 1));
}

DateTime lastDateOfWeek(DateTime dateTime) {
  return dateTime
      .add(
        Duration(days: DateTime.daysPerWeek - dateTime.weekday),
      )
      .copyWith(
        hour: 23,
        minute: 59,
        second: 59,
      );
}

extension DateTimeExt on DateTime {
  String? timeLeft(DateTime dt) {
    if (dt.isAfter(this)) {
      return null;
    }

    final dif = difference(dt);
    if (dif.inDays > 0) {
      if (dif.inDays > 1) return '${dif.inDays} days left';

      return '${dif.inDays} day left';
    }

    return '${dif.inHours} hours left';
  }
}
