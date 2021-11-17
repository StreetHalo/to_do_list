import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:uuid/uuid.dart';

class Task{
  String title;
  String about;
  String date;
  IconData icon;
  String id = Uuid().v4();

  Task(this.title, this.about, this.date, this.icon);
}