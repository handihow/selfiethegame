import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/game.dart';

import '../../shared-widgets/ui_elements/title_default.dart';

class GameViewPage extends StatelessWidget {
  final String gameId;
  final format = new DateFormat('dd-MM-yyyy');

  GameViewPage(this.gameId);

  Widget _buildAddressDateTagRow(DateTime date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Union Square San Francisco',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        Container(
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
          margin: EdgeInsets.symmetric(horizontal: 5.0),
        ),
        Text(
          format.format(date),
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('Back button pressed');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
          final Game game = null;
          return Scaffold(
            appBar: AppBar(
              title: Text(game.name),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(game.imageUrl),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TitleDefault(game.name),
                ),
                _buildAddressDateTagRow(game.date)
              ],
            ),
          );
        },
      ),
    );
  }
}
