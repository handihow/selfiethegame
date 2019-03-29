import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/team.dart';
import '../../models/hexcolor.dart';
import '../pages/team_edit.dart';
import '../widgets/team_member.dart';
import '../../models/user.dart';

class TeamsPage extends StatefulWidget {
  final String gameId;
  TeamsPage(this.gameId);

  @override
  State<StatefulWidget> createState() {
    return _TeamsPageState();
  }
}

class _TeamsPageState extends State<TeamsPage> {
  Widget _createTeamPage(
      BuildContext context, AppModel model, List<Team> returnedTeams) {
    return StreamBuilder(
      stream: model.fetchGameParticipants(widget.gameId, 'participant'),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data.documents.length == 0) {
          return Center(
            child: Text('Nog geen teams'),
          );
        } else {
          List<User> returnedUsers = [];
          snapshot.data.documents.forEach(
            (DocumentSnapshot document) {
              final String userId = document.documentID;
              final Map<String, dynamic> userData = document.data;
              userData['id'] = userId;
              final User returnedUser = User.fromJson(userData);
              returnedUsers.add(returnedUser);
            },
          );
          return _displayExistingTeams(
              context, model, returnedTeams, returnedUsers);
        }
      },
    );
  }

  Widget _displayExistingTeams(BuildContext context, AppModel model,
      List<Team> returnedTeams, List<User> returnedUsers) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: returnedTeams.length,
      itemBuilder: (BuildContext context, int index) {
        return DragTarget(
          builder: (BuildContext context, List<String> members, rejectedData) {
            return Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.group,
                      color: HexColor(returnedTeams[index].color),
                    ),
                    title: Text('Team ' + returnedTeams[index].name),
                    trailing:
                        _makeTrailingIconButton(returnedTeams[index], model),
                  ),
                  Container(
                    height: returnedTeams[index].members.length * 60.0,
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int userIndex) {
                        final String userId =
                            returnedTeams[index].members[userIndex];
                        final String displayName = returnedUsers
                            .firstWhere((u) => u.uid == userId)
                            .displayName;
                        return TeamMemberListTile(displayName, userId, index);
                      },
                      itemCount: returnedTeams[index].members.length,
                    ),
                  ),
                ],
              ),
            );
          },
          onWillAccept: (data){
            return _checkWillAccept(data, index);
          },
          onAccept: (data) {
            _acceptPlayer(data, index, returnedTeams, model);
          },
        );
      },
    );
  }

  bool _checkWillAccept(String data, int acceptingTeamIndex){
    bool willAccept = false;
    int playerTeamIndex = int.parse(data.substring(0,1));
    if(acceptingTeamIndex != playerTeamIndex){
      willAccept = true;
    }
    return willAccept;
  }

  _acceptPlayer(String data, int acceptingTeamIndex, List<Team> teams, AppModel model){
    int playerTeamIndex = int.parse(data.substring(0,1));
    String playerId = data.substring(2);
    teams[playerTeamIndex].members.remove(playerId);
    teams[acceptingTeamIndex].members.add(playerId);
    model.updateTeams(widget.gameId, teams);
  }

  Widget _makeTrailingIconButton(Team team, AppModel model) {
    return team.members.length == 0
        ? IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              model.deleteTeam(team);
            },
          )
        : IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return TeamEditPage(widget.gameId, team: team);
                  },
                ),
              );
            },
          );
  }

  _showWarningDialog(BuildContext context, AppModel model) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Teams verwijderen"),
          content: Text("Je verwijdert hiermee alle teams. Wil je doorgaan?"),
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('ANNULEREN'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              textColor: Theme.of(context).errorColor,
              child: Text('VERWIJDEREN'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((bool isCanceled) async {
      if (!isCanceled) {
        await model.updateGameStatus(widget.gameId, 'teamsCreated', false);
        await model.deleteTeams(widget.gameId);
        Navigator.of(context).pop(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Teams instellen'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.redo),
                onPressed: () => _showWarningDialog(context, model),
              )
            ],
          ),
          body: StreamBuilder(
            stream: model.fetchTeams(widget.gameId),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData ||
                  snapshot.data.documents.length == 0) {
                return Center(
                  child: Text('Nog geen teams'),
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
                return _createTeamPage(context, model, returnedTeams);
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return TeamEditPage(
                      widget.gameId,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
