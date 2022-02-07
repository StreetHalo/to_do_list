import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/assets/colors.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task {
  @HiveField(0)
  String about;
  @HiveField(1)
  int timestamp;
  @HiveField(2)
  String id;
  @HiveField(3)
  int rangIndex;
  String dateFormat = "dd/MM/yyyy";

  static Task _defTask = Task(
      "",
      DateTime(DateTime.now().year).microsecondsSinceEpoch,
      "",
      UserColors.getDefaultRangIndex()
  );

  Task(this.about, this.timestamp, this.id, this.rangIndex);

  String getFormattedDate() =>
      DateFormat(dateFormat).format(
          new DateTime.fromMicrosecondsSinceEpoch(timestamp));

  static Task getDefTask() => _defTask;

  static Color getTaskRangColor(Task? task){
    int index = task?.rangIndex ?? UserColors.getDefaultRangIndex();
    return UserColors.rangColors.values.elementAt(index);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
