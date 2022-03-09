import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:to_do_list/assets/colors.dart';
import 'package:to_do_list/data/task.dart';
import 'package:to_do_list/pages/analytics.dart';
import 'package:to_do_list/pages/calendar.dart';
import 'package:to_do_list/pages/currentTasks.dart';

import 'assets/strings.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Task>('removed_tasks');
  await Hive.openBox<Task>('finished_tasks');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    log("widget");
    return MaterialApp(
      title: "To-do",
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatefulWidget{
  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = [
    CurrentTasks(),
    Calendar(),
    Analytics()
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  _MainWidgetState(){
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.event_available),
              label: Strings.bottomBar_title_current_day),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_sharp),
              label: Strings.bottomBar_title_calendar),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: Strings.bottomBar_title_analytics)
        ],
        backgroundColor: UserColors.main,
        currentIndex: _selectedIndex,
        selectedItemColor: UserColors.selected,
        onTap: _onItemTapped,
      ),
    );
  }
}
