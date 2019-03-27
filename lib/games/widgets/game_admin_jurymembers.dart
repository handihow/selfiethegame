import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/game.dart';
import '../pages/game_jurymembers.dart';

class GameAdminJuryMembers extends StatelessWidget {
  final Game game;
  GameAdminJuryMembers(this.game);

  Widget _buildDoneAssigningJudgesView(AppModel model) {
    return ListTile(
      title: Text('Klaar met instellen juryleden'),
      trailing: IconButton(
        icon: Icon(Icons.redo),
        onPressed: () {
          model.updateGameStatus(game.id, 'judgesAssigned', false);
        },
      ),
    );
  }

  Widget _buildNotAssignedJudgesView(BuildContext context, AppModel model) {
    return Column(
      children: <Widget>[
        Text(
          'Juryleden kunnen punten geven aan selfies',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'De beheerder is automatisch jurylid',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          'Met deze knop kun je extra juryleden instellen',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        SizedBox(height: 10.0),
        ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text('NEE BEDANKT'),
              onPressed: () {
                model.updateGameStatus(game.id, 'judgesAssigned', true);
              },
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<bool>(
                    builder: (BuildContext context) =>
                        GameJuryMembersPage(game),
                  ),
                );
              },
              child: Text('INSTELLEN'),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return game.status.judgesAssigned
            ? _buildDoneAssigningJudgesView(model)
            : _buildNotAssignedJudgesView(context, model);
      },
    );
  }
}
