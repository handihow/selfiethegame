import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/team.dart';

class GameAdminTeams extends StatefulWidget {
  final String gameId;
  GameAdminTeams(this.gameId);

  @override
  State<StatefulWidget> createState() {
    return _GameAdminTeamsState();
  }
}

class _GameAdminTeamsState extends State<GameAdminTeams> {

  Widget _makeNewTeams(BuildContext context, AppModel model){
    return Text("I don't have teams");
  }

  Widget _displayExistingTeams(BuildContext context, AppModel model, List<Team> teams){
    return Text("I do have teams");
  }
  

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return StreamBuilder(
            stream: model.fetchTeams(widget.gameId),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData ||
                  snapshot.data.documents.length == 0) {
                return _makeNewTeams(context, model);
              } else {
                List<Team> returnedTeams = [];
                snapshot.data.documents.forEach((DocumentSnapshot document) {
                  final String teamId = document.documentID;
                  final Map<String, dynamic> teamData = document.data;
                  teamData['id'] = teamId;
                  final Team returnedTeam =
                      Team.fromJson(teamData);
                  returnedTeams.add(returnedTeam);
                });
                return _displayExistingTeams(
                    context, model, returnedTeams);
              }
            });
      },
    );
  }
}
