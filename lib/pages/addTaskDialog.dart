
import 'package:flutter/material.dart';
import 'package:to_do_list/assets/colors.dart';
import 'package:to_do_list/assets/strings.dart';
import 'package:to_do_list/data/task.dart';
import 'package:to_do_list/db/data.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddTaskDialog extends StatefulWidget{
  Task? currentTask;
  AddTaskDialog({Task? task}){
   currentTask = task ?? Task.getDefTask();
  }
  createState() => AddTaskState();
}

class AddTaskState extends State<AddTaskDialog> with Data{

  FocusNode _myFocusNode = new FocusNode();
  Color _focusedTextColor = Colors.black;
  Color _unfocusedTextColor = Colors.blue;
  Color _errorTextColor = Colors.red;
  TextEditingController aboutTxtController = TextEditingController();
  TextEditingController dataTxtController = TextEditingController();
  DateTime _selectedDate = DateTime(DateTime.now().year);
  String dateFormat = "dd/MM/yyyy";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(.0),
              child: Container(
                  child: TitleWidget()
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    child: TextButton.icon(
                      icon: Icon(Icons.calendar_today),
                      label: Text(
                          DateFormat(dateFormat).format(_selectedDate)
                    ),
                      onPressed: _showDatePicker,
                    ),
                  ),
                ),
                Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        showRangDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(width: 1, color: UserColors.main),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.circle,
                            color: Task.getTaskRangColor(widget.currentTask),
                            size: 20,
                          ),
                          Text(
                            getTaskRangText(widget.currentTask),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return Strings.msg_empty_about;
                }
                return null;
              },
              controller: aboutTxtController,
              focusNode: _myFocusNode,
              maxLines: 3,
              style: TextStyle(
                fontSize: 14
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                labelText: Strings.add_task_what_need_to_do,
                errorText: validateAboutText(aboutTxtController.text),
                labelStyle: TextStyle(
                  color: _focusedTextColor
                ),
                contentPadding: EdgeInsets.all(6),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: _focusedTextColor,
                  )
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                    color: _unfocusedTextColor,
                    width: 1
                  )
                ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: _errorTextColor, width: 1))),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                  onPressed: (){
                    addNewTask();
                  },
                  child: Text(
                      Strings.add_title.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white
                    ),
                  )
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    },
                  child: Text(Strings.cancel_title.toUpperCase())
              ),
            )
          ],
        ),
      ),
    );
  }

  Color getTaskRangColorByIndex(int index) => UserColors.rangColors.values.elementAt(index);

  String getTaskRangText(Task? task){
    int index = task?.rangIndex ?? UserColors.getDefaultRangIndex();
    return UserColors.rangColors.keys.elementAt(index);
  }

  void _showDatePicker(){
    var currentYear = DateTime.now().year;
    showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(currentYear),
          lastDate: DateTime(currentYear + 1)).then((value) => {
            if(value != null) _selectedDate = value,
            setState(() {})
    });
  }

  void showRangDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(Strings.dialog_rang_title),
              contentPadding: EdgeInsets.zero,
              content: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < UserColors.rangColors.length; i++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: RadioListTile(
                              title: Text(
                                UserColors.rangColors.keys.elementAt(i),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                              value: i,
                              groupValue: widget.currentTask?.rangIndex,
                              onChanged: (newValue) =>
                                  setState(() => widget.currentTask?.rangIndex = newValue as int),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.circle,
                              color: getTaskRangColorByIndex(i),
                              size: 20,
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(Strings.dialog_cancel.toUpperCase()),
                ),
                TextButton(
                  onPressed: () => {
                    Navigator.pop(context),
                    this.setState(() {}),
                  },
                  child: Text(Strings.dialog_ok.toUpperCase()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void addNewTask() {
    if(aboutTxtController.text.isEmpty) {
      return;
    }

    Task newTask = Task(
          aboutTxtController.text,
          _selectedDate.microsecondsSinceEpoch,
          Uuid().v4(),
          1
      );
      insertTask(newTask);
      Navigator.pop(context);
    }
}

String? validateAboutText(String text) {
    if(text.isNotEmpty) return null;
      else return "etretertert";
}


class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Strings.add_task_title,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}