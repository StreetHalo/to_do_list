
import 'package:flutter/material.dart';
import 'AddTaskDialog.dart';

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
          ElevatedButton.icon(onPressed: (){clickClack(context);},
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
  clickClack(BuildContext context) => openPage(context);

  openPage(BuildContext context) {
    showModalBottomSheet(context: context, builder: (context){
      return AddTaskDialog();
    });
  }
}