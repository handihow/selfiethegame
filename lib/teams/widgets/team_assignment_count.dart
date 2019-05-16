import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/game.dart';
import '../../models/team.dart';
import '../../models/reaction.dart';

class TeamAssignmentCount extends StatelessWidget {
  final Game game;
  final Team team;
  TeamAssignmentCount(this.game, this.team);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return StreamBuilder(
          stream: model.fetchTeamImageReferences(team.id),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData ||
                snapshot.data.documents.length == 0) {
              return ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Opdrachten uitgevoerd'),
                subtitle: Text('0 opdrachten'),
              );
            } else {
              int totalAssignments = snapshot.data.documents.length;
              return ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Opdrachten uitgevoerd'),
                subtitle: Text(totalAssignments.toString() + ' opdrachten'),
              );
            }
          },
        );
      },
    );
  }
}
