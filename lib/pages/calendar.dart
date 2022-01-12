
import 'package:flutter/material.dart';
import 'addTaskDialog.dart';

class Calendar extends StatefulWidget{

  
  @override
  createState() => CalendarState();
}

class CalendarState extends State<Calendar>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(onPressed: (){openTaskDialog(context);},
              icon: Icon(Icons.add),
              label: Text("Добавить задачу"),
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  minimumSize: Size(double.infinity, 40),
                primary: Colors.cyanAccent
              )
          )

        ],
      ),
    );
}

  openTaskDialog(BuildContext context) {
    showModalBottomSheet(context: context, builder: (context){
      return AddTaskDialog();
    });
  }
}
