
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../ghost_icons.dart';
import '../strings.dart';

enum PageType{
  CURRENT_DAY,
  CALENDAR,
  ANALYTIC
}

class EmptyStatus extends StatelessWidget{
  final PageType pageType;

  const EmptyStatus(this.pageType);

  @override
  Widget build(BuildContext context) {
    return getEmptyText();
  }

  Widget getEmptyText() {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _getIconByType(pageType),
          size: 54,
          color: Colors.blue[800]?.withAlpha(95),
        ),
        Container(
          margin: EdgeInsets.all(8),
          child: Text(
            _getTextByType(pageType),
            maxLines: 2,
            style: TextStyle(
                color: Colors.blue[800],
                fontSize: 16
            ),
          ),
        ),
      ],
    ));
  }

  String _getTextByType(PageType pageType){
    switch(pageType){
      case PageType.ANALYTIC: return Strings.not_tasks_for_analytic;
      case PageType.CURRENT_DAY: return Strings.not_tasks_for_today;
      case PageType.CALENDAR: return Strings.not_tasks;
    }
  }

  IconData _getIconByType(PageType pageType){
    switch(pageType){
      case PageType.ANALYTIC: return Icons.calendar_today_sharp;
      case PageType.CURRENT_DAY: return Ghost.enemy_ghost;
      case PageType.CALENDAR: return FontAwesome5.sad_cry;
    }
  }
}