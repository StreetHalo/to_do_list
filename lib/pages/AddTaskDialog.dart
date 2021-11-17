import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget{
  createState() => AddTaskState();
}

class AddTaskState extends State<AddTaskDialog>{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Укажите задачу",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: 8),
          TextField(
            style: TextStyle(
              fontSize: 18
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              )
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Укажите дату",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: 8),
          TextField(
            style: TextStyle(
                fontSize: 18
            ),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                )
            ),
            onTap: _showDatePicker,
          ),

        ],
      ),
    );
  }

  void _showDatePicker(){
    var currentYear = DateTime.now().year;

      showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(currentYear),
          lastDate: DateTime(currentYear + 1));
  }
}