import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/game.dart';

class GameAdminReady extends StatelessWidget {
  final Game game;
  GameAdminReady(this.game);

  bool _checkIsReady() {
    bool isReady = false;
    if (game.status.invited &&
        game.status.assigned &&
        game.status.judgesAssigned &&
        game.status.teamsCreated) {
      isReady = true;
    }
    return isReady;
  }

  Widget _buildReadyContent() {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.done),
              title: Text('Klaar met instellen'),
              subtitle: Text('Bevestig dat je klaar bent om te beginnen'),
            ),
            RaisedButton(
                onPressed: () {
                  _showWarningDialog(context, model);
                },
                child: Text('IK WIL SPEL BEGINNEN'))
          ],
        );
      },
    );
  }

  _showWarningDialog(BuildContext context, AppModel model) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Spel beginnen"),
          content: Text(
              "Spelers kunnen zich hierna niet meer aanmelden voor dit spel. Teams en opdrachten kunnen niet meer worden aangepast. Wil je doorgaan?"),
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).errorColor,
              child: Text('ANNULEREN'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('BEGINNEN'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((bool isCanceled) async {
      if (!isCanceled) {
        model.updateGameStatus(game.id, 'closedAdmin', true);
      }
    });
  }

  Widget _buildNotReadyContent(BuildContext context) {
    List<String> missingSettings = [];
    if (!game.status.invited) {
      missingSettings.add('geen aanmeldingen');
    }
    if (!game.status.assigned) {
      missingSettings.add('geen opdrachten');
    }
    if (!game.status.judgesAssigned) {
      missingSettings.add('geen juryleden');
    }
    if (!game.status.teamsCreated) {
      missingSettings.add('geen teams');
    }
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('Je bent nog niet klaar met instellen'),
          leading: Icon(Icons.clear, color: Theme.of(context).errorColor),
        ),
        Text(
          'Het spel heeft ' + missingSettings.join(', '),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _checkIsReady()
        ? _buildReadyContent()
        : _buildNotReadyContent(context);
  }
}
