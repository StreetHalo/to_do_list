import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CurrentTasks extends StatefulWidget{
  @override
  createState() => TaskList();
}

class TaskList extends State<CurrentTasks> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: 12,
      itemBuilder: (context, index){
      return ListTile(title: Text("ddd"));
      });
  }
}