import 'package:flutter/material.dart';

class TitleDefault extends StatelessWidget {
  final String name;

  TitleDefault(this.name);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
          fontSize: 26.0, fontWeight: FontWeight.bold, fontFamily: 'Oswald'),
    );
  }
}
