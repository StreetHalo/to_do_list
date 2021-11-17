
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:to_do_list/Settings.dart';
import 'package:to_do_list/Task.dart';
import 'package:flutter/foundation.dart';

class CurrentTasks extends StatefulWidget{
  @override
  createState() => TaskList();
}

class TaskList extends State<CurrentTasks> {
  var settings = Settings();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: Settings().getCurrentTasks().length,
        itemBuilder: (context, index) {
          Task _task = settings.getCurrentTasks()[index];
          return Dismissible(
            key: Key(_task.id),
            child: getTaskByCard(_task),

            onDismissed: (_){

            },
            direction: DismissDirection.endToStart,
            background:  Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                        Icons.delete,
                    color: Colors.white),
                  ),
                  color: Colors.red,
                )
            ),
          );
        });
  }


  Card getTaskByCard(Task _task){
    return Card(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Text(_task.title,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Icon(_task.icon)
                ],
              ),
              SizedBox(height: 4),
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text(
                    _task.about,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(_task.date,
                    style:
                    TextStyle(fontSize: 12, color: Colors.blueGrey)),
              )
            ],
          )),
    );
  }
}

