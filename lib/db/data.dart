
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list/data/task.dart';

mixin Data {

  List<Task> getCurrentTasks() {
    var box = Hive.box<Task>('tasks');
    return box.values.toList();
  }

  void insertTask(Task task)  {
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
    insertTask(editedTask);
  }
}