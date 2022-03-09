
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list/assets/formatter.dart';
import 'package:to_do_list/data/task.dart';

mixin Data {

  List<Task> getAllTasks() {
    var box = Hive.box<Task>('tasks');
    return box.values.toList();
  }

  List<Task> getRemovedTasks() {
    var box = Hive.box<Task>('removed_tasks');
    return box.values.toList();
  }

  List<Task> getFinishedTasks() {
    var box = Hive.box<Task>('finished_tasks');
    return box.values.toList();
  }

  List<Task> getCurrentDayTasks() =>
      getAllTasks().where((task) =>
      task.getFormattedDate() ==
          Formatter.getFormattedDateByTimestamp(DateTime.now().millisecondsSinceEpoch))
          .toList();

  void insertFinishedTask(Task task){
    var box = Hive.box<Task>('finished_tasks');
    box.add(task);
  }

  void insertRemovedTask(Task task){
    var box = Hive.box<Task>('removed_tasks');
    box.add(task);
  }

  void insertNewTask(Task task, )  {
    var box = Hive.box<Task>('tasks');
    box.add(task);
  }

  void removeTask(Task task)  {
    var box = Hive.box<Task>('tasks');
    box.deleteAt(box.values.toList().indexOf(task));
  }

  Task getTaskById(String id){
  var box = Hive.box<Task>('tasks');
  return box.values.toList().firstWhere((element) => element.id == id);
  }

  void editTask(Task editedTask){
    var task = getTaskById(editedTask.id);
    removeTask(task);
    insertNewTask(editedTask);
  }
}