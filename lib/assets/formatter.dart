import 'dart:io';

import 'package:intl/intl.dart';

class Formatter{
  static String dateFormat = "dd/MM/yyyy";

  static String getFormattedDateByTimestamp(int timestamp) =>
      DateFormat(dateFormat).format(DateTime.fromMillisecondsSinceEpoch(timestamp));

  static String getTitleMonthByTimestamp(int timestamp) =>
      DateFormat.yMMMM(Platform.localeName).format(DateTime.fromMillisecondsSinceEpoch(timestamp));

  static String getTitleDayByTimestamp(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp).day.toString() + ", " +
          DateFormat.EEEE(Platform.localeName).format(DateTime.fromMillisecondsSinceEpoch(timestamp));

}