
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list/data/task.dart';
import 'package:flutter/foundation.dart';
import 'package:to_do_list/db/data.dart';

import 'addTaskDialog.dart';

class CurrentTasks extends StatefulWidget {
  @override
  createState() => TaskList();
}

class TaskList extends State<CurrentTasks> with Data {
  var _addTaskDialog = AddTaskDialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Задачи на сегодня"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: (){
                openTaskDialog(context);
              },
              child: Icon(
                Icons.add
              ),
            ),
          ),
        ],
      ),
    body: getBody());
  }

  ListView getListView(List<Task> tasks){
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          Task _task = tasks[index];
          return Dismissible(
            key: Key(_task.id.toString()),
            child: getSlide(_task),
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

  Slidable getSlide(Task _task) => Slidable(
        key: const ValueKey(0),

        endActionPane: const ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              flex: 2,
              onPressed: doNothing,
              backgroundColor: Color(0xFF7BC043),
              foregroundColor: Colors.white,
              icon: Icons.archive,
              label: 'Archive',
            ),
            SlidableAction(
              flex: 2,
              onPressed: doNothing,
              backgroundColor: Color(0xFF0392CF),
              foregroundColor: Colors.white,
              icon: Icons.save,
              label: 'Save',
            ),
          ],
        ),
        child: getTaskByCard(_task),
      );

  Card getTaskByCard(Task _task){
    return Card(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 12),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(_task.about,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Spacer(),
                  Icon(
                    Icons.circle,
                    color: Task.getTaskRangColor(_task),
                    size: 24,
                  )
                ],
              ),
              SizedBox(height: 12),
            ],
          )),
    );
  }

  Widget getBody() {
    if(getCurrentTasks().isNotEmpty) return getListView(getCurrentTasks());
    else return getEmptyText();
  }

  openTaskDialog(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context){
      return _addTaskDialog;
    }).whenComplete(() =>
        {
          setState(() {})
        }
    );
  }
}

Widget getEmptyText() {
  return Center(child: Text("Нет ни одной таски"));
}

void doNothing(BuildContext context) {}


