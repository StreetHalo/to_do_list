import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list/assets/colors.dart';
import 'package:to_do_list/assets/formatter.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
enum TaskType {
  @HiveField(0)
  CURRENT,
  @HiveField(1)
  DONE,
  @HiveField(2)
  REMOVED
}

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
  @HiveField(4)
  TaskType type;

  static Task _defTask = Task(
      "",
      DateTime(DateTime.now().year).microsecondsSinceEpoch,
      "",
      UserColors.getDefaultRangIndex(),
      TaskType.CURRENT
  );

  Task(
     this.about,
     this.timestamp,
     this.id,
     this.rangIndex,
     this.type
  );

  String getFormattedDate() => Formatter.getFormattedDateByTimestamp(timestamp);

  int getMonthOfDate() => DateTime.fromMillisecondsSinceEpoch(timestamp).month;

  int getYearOfDate() => DateTime.fromMillisecondsSinceEpoch(timestamp).year;

  int getDayOfDate() => DateTime.fromMillisecondsSinceEpoch(timestamp).day;

  bool isCurrentDayTask() => DateTime.now().day == getDayOfDate() &&
                              DateTime.now().month == getMonthOfDate() &&
                                DateTime.now().year == getYearOfDate();

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
