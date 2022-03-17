
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:to_do_list/assets/colors.dart';
import 'package:to_do_list/assets/formatter.dart';
import 'package:to_do_list/assets/strings.dart';
import 'package:to_do_list/assets/widgets/empty_status.dart';
import 'package:to_do_list/assets/widgets/snack.dart';
import 'package:to_do_list/assets/widgets/task_card.dart';
import 'package:to_do_list/data/task.dart';
import 'package:to_do_list/db/data.dart';
import 'addTaskDialog.dart';

enum CalendarTaskType{
    MONTH_TITLE,
    DAY_TITLE,
    TASK
}

class TaskItem{
  CalendarTaskType type;
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

  class CalendarState extends State<Calendar> with Data implements WorkWithTasks{
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

  Widget getBody() {
    if(getCurrentTasks().isNotEmpty) return getListView(getTaskItems());
    else return EmptyStatus(PageType.CALENDAR);
  }

  void setRemovedTask(_task){
    callSnackbar(context, SnackType.TASK_REMOVED);
    insertRemovedTask(_task);
    setState(() {});
  }

  void setFinishedTask(_task){
    callSnackbar(context, SnackType.TASK_DONE);
    insertFinishedTask(_task);
    setState(() {});
  }

  void editTaskByDialog(_task) => openTaskDialog(context, _task);

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
      case CalendarTaskType.TASK: return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: getTaskCard(item.task ?? Task.getDefTask()),
      );
      case CalendarTaskType.MONTH_TITLE: return Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
        child: getMonthTitle(item.task ?? Task.getDefTask()),
      );
      case CalendarTaskType.DAY_TITLE: return Padding(
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

  Widget getTaskCard(Task _task) => TaskCard(_task, this);

  List<TaskItem> getTaskItems() {
    Task? _task;
    List _sortedList = getCurrentTasks();

    _sortedList.sort((a,b) =>
        a.timestamp.compareTo(b.timestamp)
    );
    List<TaskItem> taskItems = [];
    _sortedList.forEach((element) {
      Task task = element;
      if(_task?.getMonthOfDate() != task.getMonthOfDate() ||
          _task?.getYearOfDate() != task.getYearOfDate()){
        taskItems.add(TaskItem(CalendarTaskType.MONTH_TITLE, task));
      }
      if(!taskItems.contains(TaskItem(CalendarTaskType.DAY_TITLE, task)))
        taskItems.add(TaskItem(CalendarTaskType.DAY_TITLE, task));
      taskItems.add(TaskItem(CalendarTaskType.TASK, task));
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

