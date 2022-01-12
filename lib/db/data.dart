
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
    box.delete(task);
  }
}