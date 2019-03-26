import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTag extends StatelessWidget {
  final DateTime date;
  final format = new DateFormat('dd-MM-yyyy');

  DateTag(this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(format.format(date), style: TextStyle(color: Colors.white)),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(5.0)),
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
        margin: EdgeInsets.only(left: 10.0));
  }
}
