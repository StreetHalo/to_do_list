
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/assets/colors.dart';

enum SnackType{
  TASK_DONE,
  TASK_REMOVED,
  TASK_ADDED,
  TASK_RESET
}


void callSnackbar(BuildContext context, SnackType type) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 2000),
        content: Text(_getSnackTitle(type),
          style: TextStyle(
              color: Colors.white
          ),),
        backgroundColor: _getSnackColor(type),
      )
  );
}


  String _getSnackTitle(SnackType type){
    switch(type){
      case SnackType.TASK_ADDED: return "Задача добавлена 🦈";
      case SnackType.TASK_DONE: return "Уху! Задача выполнена 🚀";
      case SnackType.TASK_RESET: return "Задача возвращена ⛄";
      case SnackType.TASK_REMOVED: return "Задача удалена 🥺";
    }
  }

  MaterialColor _getSnackColor(SnackType type) {
    switch(type){
      case SnackType.TASK_ADDED: return UserColors.taskAdded;
      case SnackType.TASK_DONE: return UserColors.taskDone;
      case SnackType.TASK_RESET: return UserColors.taskRepeat;
      case SnackType.TASK_REMOVED: return UserColors.taskRemove;
    }
  }
