import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('One moment please..'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
