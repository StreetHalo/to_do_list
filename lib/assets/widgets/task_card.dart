
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list/data/task.dart';

import '../colors.dart';
import '../strings.dart';

class TaskCard extends StatelessWidget {

  final Task _task;
  final WorkWithTasks workWithTasks;

  const TaskCard(this._task, this.workWithTasks);

  @override
  Widget build(BuildContext context) {
    return getSlide(_task);
  }

  Slidable getSlide(Task _task) => Slidable(
    key: const ValueKey(0),
    endActionPane: ActionPane(
      motion: DrawerMotion(),
      children: [
        SlidableAction(
          flex: 2,
          onPressed: (_) {
            workWithTasks.setRemovedTask(_task);
          },
          backgroundColor: UserColors.taskRemove,
          foregroundColor: Colors.white,
          icon: Icons.delete_forever,
          label: Strings.remove,
        ),
        SlidableAction(
          flex: 2,
          onPressed: (_) {
            workWithTasks.setFinishedTask(_task);
          },
          backgroundColor: UserColors.taskDone,
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
        workWithTasks.editTaskByDialog(Task(
            _task.about,
            _task.timestamp,
            _task.id,
            _task.rangIndex,
            _task.type
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

}

abstract class WorkWithTasks {
  void setRemovedTask(_task);

  void setFinishedTask(_task);

  void editTaskByDialog(_task);
}
