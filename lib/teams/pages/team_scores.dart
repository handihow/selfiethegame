import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/game.dart';
import '../../models/team.dart';
import '../../models/hexcolor.dart';
import '../widgets/team_score.dart';
import '../widgets/team_assignment_count.dart';

class TeamScoresPage extends StatelessWidget {
  final Game game;
  final Team myTeam;
  TeamScoresPage(this.game, this.myTeam);

  Widget _displayScoreCards(BuildContext context, AppModel model,
      List<Team> returnedTeams) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: returnedTeams.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.group,
                  color: HexColor(returnedTeams[index].color),
                ),
                title: Text('Team ' + returnedTeams[index].name),
              ),
              TeamAssignmentCount(game, returnedTeams[index]),
              TeamScore(game, returnedTeams[index]),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return StreamBuilder(
          stream: model.fetchTeams(game.id),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData ||
                snapshot.data.documents.length == 0) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<Team> returnedTeams = [];
              snapshot.data.documents.forEach((DocumentSnapshot document) {
                final String teamId = document.documentID;
                final Map<String, dynamic> teamData = document.data;
                teamData['id'] = teamId;
                final Team returnedTeam = Team.fromJson(teamData);
                returnedTeams.add(returnedTeam);
              });
              return _displayScoreCards(context, model, returnedTeams);
            }
          },
        );
      },
    );
  }
}