

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:to_do_list/assets/colors.dart';
import 'package:to_do_list/assets/formatter.dart';
import 'package:to_do_list/assets/ghost_icons.dart';
import 'package:to_do_list/assets/strings.dart';
import 'package:to_do_list/data/task.dart';
import 'package:to_do_list/db/data.dart';
import 'addTaskDialog.dart';

enum TaskType{
    MONTH_TITLE,
    DAY_TITLE,
    TASK
}

class TaskItem{
  TaskType type;
  Task? task;

  TaskItem(this.type, this.task);

  @override
  bool operator ==(Object other) =>
      other is TaskItem &&
          type == other.type &&
          task?.getMonthOfDate() == other.task?.getMonthOfDate() &&
          task?.getYearOfDate() == other.task?.getYearOfDate() &&
          task?.getDayOfDate() == other.task?.getDayOfDate();

  @override
  int get hashCode => type.hashCode ^ task.hashCode;
}

class Calendar extends StatefulWidget{
  @override
  createState() => CalendarState();
}

  class CalendarState extends State<Calendar> with Data{
  final ItemScrollController _itemScrollController = ItemScrollController();
  int _currentDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appbar_title_calendar),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: (){
                openTaskDialog(context, null);
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: getBody(),
    );
}

  openTaskDialog(BuildContext context, Task? _task) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context){
      return AddTaskDialog(AddTaskType.ANY_DAY);
    }).whenComplete(() =>
    {
      setState(() {})}
    );
  }

  Widget getBody() {
    if(getAllTasks().isNotEmpty) return getListView(getTaskItems());
    else return getEmptyText();
  }

  Widget getEmptyText() {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.calendar_today_sharp,
          size: 54,
          color: Colors.blue[800]?.withAlpha(95),
        ),
        Container(
          margin: EdgeInsets.all(8),
          child: Text(
            Strings.not_tasks,
            maxLines: 2,
            style: TextStyle(
                color: Colors.blue[800],
                fontSize: 16
            ),),
        ),
      ],
    ));
  }

  ScrollablePositionedList getListView(List<TaskItem> tasks){
    return ScrollablePositionedList.builder(
        itemCount: tasks.length,
        itemScrollController: _itemScrollController,
        itemBuilder: (context, index) {
          return getTaskTitle(tasks[index]);
        });
  }



  Widget getTaskTitle(TaskItem item){
    switch(item.type){
      case TaskType.TASK: return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: getSlide(item.task ?? Task.getDefTask()),
      );
      case TaskType.MONTH_TITLE: return Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
        child: getMonthTitle(item.task ?? Task.getDefTask()),
      );
      case TaskType.DAY_TITLE: return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
        child: getDayTitle(item.task ?? Task.getDefTask()),
      );
    }
  }

  Widget getMonthTitle(Task task) => Text(
      Formatter.getTitleMonthByTimestamp(task.timestamp),
      style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black
  ));

  Widget getDayTitle(Task task) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(Formatter.getTitleDayByTimestamp(task.timestamp),
      style: TextStyle(
          fontSize: 15,
          color: task.isCurrentDayTask() == true ? Colors.red[900] : Colors.black54,
      ),
      ),
      Visibility(
        visible: task.isCurrentDayTask(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
            Icons.event_available,
              color: Colors.red[900],
      ),
          ))
    ],
  );



  Slidable getSlide(Task _task) => Slidable(
    key: const ValueKey(0),
    endActionPane: ActionPane(
      motion: DrawerMotion(),
      children: [
        SlidableAction(
          flex: 2,
          onPressed: (_) {
            removeTask(_task);
            insertRemovedTask(_task);
            setState(() {});
          },
          backgroundColor: UserColors.taskRemove,
          foregroundColor: Colors.white,
          icon: Icons.delete_forever,
          label: Strings.remove,
        ),
        SlidableAction(
          flex: 2,
          onPressed: (_) {
            removeTask(_task);
            insertFinishedTask(_task);
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

  List<TaskItem> getTaskItems() {
    Task? _task;
    List _sortedList = getAllTasks();

    _sortedList.sort((a,b) =>
        a.timestamp.compareTo(b.timestamp)
    );
    List<TaskItem> taskItems = [];
    _sortedList.forEach((element) {
      Task task = element;
      if(_task?.getMonthOfDate() != task.getMonthOfDate() ||
          _task?.getYearOfDate() != task.getYearOfDate()){
        taskItems.add(TaskItem(TaskType.MONTH_TITLE, task));
      }
      if(!taskItems.contains(TaskItem(TaskType.DAY_TITLE, task)))
        taskItems.add(TaskItem(TaskType.DAY_TITLE, task));
      taskItems.add(TaskItem(TaskType.TASK, task));
      if(_currentDayIndex == 0 && task.isCurrentDayTask()) {
        _currentDayIndex = taskItems.length;
      }
      _task = task;

    });
    return taskItems;
  }

  void _scrollToCurrentDay(int scroll) {
    _itemScrollController.scrollTo(
        index: scroll,
        duration: Duration(milliseconds: 850),
        );
  }
}

