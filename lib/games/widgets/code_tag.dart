import 'package:flutter/material.dart';

class CodeTag extends StatelessWidget {
  
  final String code;

  CodeTag(this.code);
  
  @override
  Widget build(BuildContext context) {
    return Container(
            child: Text('Code: ' + code),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(4.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
          );
  }
}