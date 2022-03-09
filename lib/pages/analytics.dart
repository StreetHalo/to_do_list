
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/assets/strings.dart';
import 'package:to_do_list/db/data.dart';
import 'package:to_do_list/pages/TaskList.dart';

class Analytics extends StatefulWidget{

  @override
  State createState() => AnalyticsState();
}

class AnalyticsState extends State<Analytics> with Data{

  var _radiusSize = 100.0;
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Strings.appbar_title_analytics),
        ),
        body: Column(
          children: [
            Expanded(
              child: _getPieChart(),
            ),
            _getLegend()
          ],
        ));
  }

  Widget _getPieChart() {
    return PieChart(
      PieChartData(
          startDegreeOffset: 90,
          sectionsSpace: 0.1,
          centerSpaceRadius: 0,
          pieTouchData: PieTouchData(touchCallback:
              (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
            if(touchedIndex != -1) _openTaskListByIndex(touchedIndex);
          }),
        sections: _showingSections()
      )
    );
  }

  Widget _getLegend(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          Indicator(
            color: Color(0xff0293ee),
            text: "Выполненные задачи",
            isSquare: false,
          ),
          SizedBox(
            height: 4,
          ),
          Indicator(
            color: Color(0xfff8b250),
            text: "Отмененные задачи",
            isSquare: false,
          ),
          SizedBox(
            height: 32,
          ),
        ]),
    );
  }
List<PieChartSectionData> _showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? _radiusSize + 10 : _radiusSize;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: getFinishedTasks().length.toDouble(),
            title: getPercentByType(TaskStatusType.DONE),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: getRemovedTasks().length.toDouble(),
            title: getPercentByType(TaskStatusType.CANCEL),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }

  String getPercentByType(TaskStatusType taskType){
    switch(taskType){
      case TaskStatusType.DONE: {
       int percent = ((getFinishedTasks().length / (getFinishedTasks().length + getRemovedTasks().length)) * 100.0).toInt();
       return "$percent%";
      }
      case TaskStatusType.CANCEL: {
        int percent = ((getRemovedTasks().length / (getFinishedTasks().length + getRemovedTasks().length)) * 100.0).toInt();
        return "$percent%";
      }
      case TaskStatusType.CURRENT: return "";
    }
  }

  void _openTaskListByIndex(int touchedIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FinishedTasksPage(TaskStatusType.values[touchedIndex])),
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 16,
        ),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16, color: textColor),
        )
      ],
    );
  }
}