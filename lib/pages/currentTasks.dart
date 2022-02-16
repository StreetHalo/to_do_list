
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list/assets/colors.dart';
import 'package:to_do_list/assets/strings.dart';
import 'package:to_do_list/data/task.dart';
import 'package:to_do_list/db/data.dart';

import 'addTaskDialog.dart';

class CurrentTasks extends StatefulWidget {
  @override
  createState() => TaskList();
}

class TaskList extends State<CurrentTasks> with Data {
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
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: getSlide(_task),
          );
        });
  }

  Slidable getSlide(Task _task) => Slidable(
        key: const ValueKey(0),
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          children: [
            SlidableAction(
              flex: 2,
              onPressed: (_) {
                removeTask(_task);
                setState(() {});
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_forever,
              label: Strings.remove,
            ),
            SlidableAction(
              flex: 2,
              onPressed: (_) {},
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
              icon: Icons.done,
              label: Strings.done,
            ),
          ],
        ),
        child: getTaskByCard(_task),
      );
  InkWell getTaskByCard(Task _task){
    return InkWell(
      onTap: (){
        openTaskDialog(context, Task(
            _task.about,
            _task.timestamp,
            _task.id,
            _task.rangIndex
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: UserColors.getTaskBackground(UserColors.rangColors.values.elementAt(_task.rangIndex)),
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.all(Radius.circular(0))
        ),

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
                            fontSize: 16, fontWeight: FontWeight.bold
                        )
                    ),
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
      ),
    );
  }

  Widget getBody() {
    if(getCurrentTasks().isNotEmpty) return getListView(getCurrentTasks());
    else return getEmptyText();
  }

  openTaskDialog(BuildContext context, [Task? task]) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context){
      return AddTaskDialog(task: task,);
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

