import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/Task.dart';

class Settings{
  SharedPreferences? prefs;
  Settings(){
    SharedPreferences.getInstance().then((value) => prefs = value);
  }

  List<Task> getCurrentTasks(){
    return jsonDecode(prefs?.getString("current_tasks") ?? "");
  }

  void setCurrentTasks(List<Task> tasks){
    prefs?.setString("current_tasks", jsonEncode(tasks));
  }
  
  void addTask(Task task){
    var currentTasks = getCurrentTasks();
    currentTasks.add(task);
    setCurrentTasks(currentTasks);
  }

  void removeTask(Task task){
    var currentTasks = getCurrentTasks();
    currentTasks.remove(task);
    setCurrentTasks(currentTasks);
  }
}