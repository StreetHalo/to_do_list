import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list/assets/colors.dart';
import 'package:to_do_list/assets/strings.dart';
import 'package:to_do_list/data/task.dart';
import 'package:to_do_list/db/data.dart';

class FinishedTasksPage extends StatefulWidget{
   final TaskType currentType;

  const FinishedTasksPage(this.currentType);

@override
  State<StatefulWidget> createState() => TaskListState();
}

class TaskListState extends State<FinishedTasksPage> with Data{



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
      ),
      body: getTaskList(_getTasksByType(widget.currentType)),
    );
  }


  String _getTitle(){
    if(widget.currentType == TaskType.DONE) return Strings.title_done_tasks;
    else return Strings.title_canceled_tasks;
  }

  Widget getTaskList(List<Task> tasks){
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext context, int index) {
        Task _task = tasks[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: getSlide(_task),
        );
      },
    );
  }

  List<Task> _getTasksByType(TaskType type){
    if(type == TaskType.REMOVED) return getRemovedTasks();
    else return getFinishedTasks();
  }

  Slidable getSlide(Task _task) => Slidable(
    key: const ValueKey(0),
    endActionPane: ActionPane(
      motion: DrawerMotion(),
      children: [
        SlidableAction(
          flex: 2,
          onPressed: (_) {
            _showRepeatDialog(context, _task);
            },
          backgroundColor: UserColors.taskRepeat,
          foregroundColor: Colors.white,
          icon: Icons.replay,
          label: Strings.repeat,
        ),
      ],
    ),
    child: getTaskByCard(_task),
  );

  InkWell getTaskByCard(Task _task){
    return InkWell(
      onTap: (){
        _showRepeatDialog(context, _task);
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

  void _showRepeatDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(Strings.dialog_rang_title),
              contentPadding: EdgeInsets.zero,
              content: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      Text(Strings.dialog_repeat_task)
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(Strings.dialog_cancel.toUpperCase()),
                ),
                TextButton(
                  onPressed: () => {
                    Navigator.pop(context),
                    insertCurrentTask(task),
                    this.setState(() {
                      if(_getTasksByType(widget.currentType).isEmpty)
                        Navigator.pop(context);
                    }),
                  },
                  child: Text(Strings.dialog_ok.toUpperCase()),
                ),
              ],
            );
          },
        );
      },
    );
  }
}