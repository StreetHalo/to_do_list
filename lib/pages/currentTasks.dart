
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:to_do_list/assets/widgets/empty_status.dart';
import 'package:to_do_list/assets/widgets/task_card.dart';
import 'package:to_do_list/data/task.dart';
import 'package:to_do_list/db/data.dart';

import 'addTaskDialog.dart';

class CurrentTasks extends StatefulWidget {
  @override
  createState() => TaskList();
}

class TaskList extends State<CurrentTasks> with Data implements WorkWithTasks {
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

  Widget getBody() {
    if(getCurrentDayTasks().isNotEmpty) return getListView(getCurrentDayTasks());
    else return EmptyStatus(PageType.CURRENT_DAY);
  }

  Widget getSlide(Task _task) => TaskCard(_task, this);

  void setRemovedTask(_task){
    insertRemovedTask(_task);
    setState(() {});
  }

  void setFinishedTask(_task){
    insertFinishedTask(_task);
    setState(() {});
  }

  void editTaskByDialog(_task) => openTaskDialog(context, _task);

  openTaskDialog(BuildContext context, [Task? task]) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context){
      return AddTaskDialog(AddTaskType.CURRENT_DAY, task: task);
    }).whenComplete(() =>
        {
          setState(() {})
        }
    );
  }
}

