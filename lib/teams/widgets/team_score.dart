import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/game.dart';
import '../../models/team.dart';
import '../../models/reaction.dart';

class TeamScore extends StatelessWidget {
  final Game game;
  final Team team;
  TeamScore(this.game, this.team);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return StreamBuilder(
          stream: model.getTeamRatingReactions(team.id),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData ||
                snapshot.data.documents.length == 0) {
              return ListTile(
                leading: Icon(Icons.assessment),
                title: Text('Totale score'),
                subtitle: Text('0 punten'),
              );
            } else {
              int totalScore = 0;
              snapshot.data.documents.forEach((DocumentSnapshot document) {
                final Map<String, dynamic> reactionData = document.data;
                final Reaction returnedReaction =
                    Reaction.fromJson(reactionData);
                totalScore += returnedReaction.rating.index;
              });
              return ListTile(
                leading: Icon(Icons.assessment),
                title: Text('Totale score'),
                subtitle: Text(totalScore.toString() + ' punten'),
              );
            }
          },
        );
      },
    );
  }
}
