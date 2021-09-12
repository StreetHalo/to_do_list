import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:to_do_list/pages/CurrentTasks.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Azaza Title",
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
    Text("data")
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
      log('position $index');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gucci flip-flap"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings")
        ],
        backgroundColor: Colors.blue,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber,
        onTap: _onItemTapped,
      ),
    );
  }
}
