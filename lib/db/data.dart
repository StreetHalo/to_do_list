
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list/assets/formatter.dart';
import 'package:to_do_list/data/task.dart';

mixin Data {

  List<Task> getAllTasks() {
    var box = Hive.box<Task>('tasks');
    return box.values.toList();
  }

  List<Task> getRemovedTasks() => getAllTasks().where((element) => element.type == TaskType.REMOVED).toList();

  List<Task> getFinishedTasks() => getAllTasks().where((element) => element.type == TaskType.DONE).toList();

  List<Task> getCurrentTasks() => getAllTasks().where((element) => element.type == TaskType.CURRENT).toList();


  List<Task> getCurrentDayTasks() =>
      getCurrentTasks().where((task) =>
      task.getFormattedDate() ==
          Formatter.getFormattedDateByTimestamp(DateTime.now().millisecondsSinceEpoch))
          .toList();

  void insertFinishedTask(Task task){
      task.type = TaskType.DONE;
      editTask(task);
  }

  void insertRemovedTask(Task task){
      task.type = TaskType.REMOVED;
      editTask(task);
  }

  void insertCurrentTask(Task task){
    task.type = TaskType.CURRENT;
    editTask(task);
  }

  void insertNewTask(Task task,)  {
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