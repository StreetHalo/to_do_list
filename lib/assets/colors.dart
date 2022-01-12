import 'package:flutter/material.dart';
import 'package:to_do_list/assets/strings.dart';

class UserColors{
  static const MaterialColor main = Colors.blue;

  static const MaterialColor selected = Colors.amber;

  static const MaterialColor lowTaskMark = Colors.blue;

  static const MaterialColor middleTaskMark = Colors.amber;

  static const MaterialColor highTaskMark = Colors.red;

  static const Map<String, MaterialColor> rangColors = {
      Strings.task_time_rang_h: highTaskMark,
      Strings.task_time_rang_m: middleTaskMark,
      Strings.task_time_rang_l: lowTaskMark,
  };

 static int getDefaultRangIndex(){
    return (rangColors.length / 2).ceil();
  }
}