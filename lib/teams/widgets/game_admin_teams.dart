import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import "dart:math";
import 'package:random_string/random_string.dart';

import '../../scoped-models/main.dart';
import '../../models/team.dart';
import '../../models/game.dart';
import '../../settings/settings.dart';

class GameAdminTeams extends StatefulWidget {
  final Game game;
  GameAdminTeams(this.game);

  @override
  State<StatefulWidget> createState() {
    return _GameAdminTeamsState();
  }
}

class _GameAdminTeamsState extends State<GameAdminTeams> {
  double _numberOfPlayersPerTeam = 2;
  final _random = new Random();

  Widget _makeNewTeams(BuildContext context, AppModel model) {
    return widget.game.status.invited
        ? Column(
            children: <Widget>[
              Text(
                'Deel de teams in',
                style: TextStyle(
                  // fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text("Selecteer het aantal spelers per team"),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Slider(
                      min: 1.0,
                      max: 5.0,
                      divisions: 4,
                      value: _numberOfPlayersPerTeam,
                      onChanged: (value) {
                        setState(() {
                          _numberOfPlayersPerTeam = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 50.0,
                    alignment: Alignment.center,
                    child: Text('${_numberOfPlayersPerTeam.toInt()}',
                        style: Theme.of(context).textTheme.display1),
                  ),
                ],
              ),
              Divider(),
              RaisedButton(
                onPressed: () => _createNewTeams(model),
                child: Text('MAAK TEAMS'),
              ),
            ],
          )
        : ListTile(
            title: Text('Geen spelers'),
            subtitle: Text('Je kunt nog geen teams indelen'),
          );
  }

  _createNewTeams(AppModel model) async {
    List<Team> teams = [];
    List<int> randomIndices = [];
    List<String> returnedUserIds = widget.game.players;
    returnedUserIds.shuffle();
    for (var i = 0;
        i < returnedUserIds.length;
        i += _numberOfPlayersPerTeam.toInt()) {
      int randomIndex = _pickRandomIndex(TEAM_NAMES, randomIndices);
      randomIndices.add(randomIndex);
      List<String> members;
      try {
        members = returnedUserIds
          .sublist(i, i + _numberOfPlayersPerTeam.toInt()).toList();
      } catch (e) {
        //there are not enough players left, sublist to end of list
        members = returnedUserIds
          .sublist(i).toList();
      } 
      print(members);
      Team newTeam = Team(
        id: randomAlphaNumeric(20),
        gameId: widget.game.id,
        members: members,
        name: TEAM_NAMES[randomIndex],
        order: i,
        color: TEAM_COLORS[randomIndex]['color'],
        progress: 0,
        rating: 0
      );

      teams.add(newTeam);
    }
    await model.updateGameStatus(widget.game.id, 'teamsCreated', true);
    model.addTeams(widget.game.id, teams);
  }

  int _pickRandomIndex(List<String> array, List<int> randomIndices) {
    int num = 0;
    while (num == 0) {
      num = _random.nextInt(array.length);
      if (randomIndices.contains(num)) {
        num = 0;
      }
    }
    return num;
  }


  Widget _displayExistingTeams(
      BuildContext context, AppModel model, int numberOfTeams) {
    return ListTile(
      title: Text('Teams zijn gevormd!'),
      subtitle: Text('Spel heeft $numberOfTeams teams'),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.pushNamed(context, '/teams/' + widget.game.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return StreamBuilder(
            stream: model.fetchTeams(widget.game.id),
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
                  final Team returnedTeam = Team.fromJson(teamData);
                  returnedTeams.add(returnedTeam);
                });
                return _displayExistingTeams(context, model, returnedTeams.length);
              }
            });
      },
    );
  }
}
