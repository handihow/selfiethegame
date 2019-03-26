import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Even geduld aub..'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
