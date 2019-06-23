import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/game.dart';
import '../../models/team.dart';
import '../../assignments/widgets/game_view_assignments.dart';
import '../../images/widgets/image_list_view.dart';
import '../../teams/pages/team_scores.dart';

import '../share/constants.dart';

class GameViewPage extends StatefulWidget {
  final String gameId;

  GameViewPage(this.gameId);

  @override
  _GameViewPageState createState() => _GameViewPageState();
}

class _GameViewPageState extends State<GameViewPage>
    with SingleTickerProviderStateMixin {
  Team _team = Team(
      color: "#607D8B",
      name: ' - ',
      gameId: null,
      id: 'NOTEAM',
      members: null,
      order: 100,
      progress: 0,
      rating: 0);
  bool _hasTeam = false;
  TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(vsync: this, length: 3);
  }

  Widget _buildGamePage(BuildContext context, Game game, AppModel model) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: game.administrator == model.authenticatedUser.uid
              ? _buildAppbarActions(game, model)
              : null,
          title: Text(_hasTeam ? _team.name : game.name),
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                icon: Icon(Icons.camera),
              ),
              Tab(
                icon: Icon(Icons.image),
              ),
              Tab(
                icon: Icon(Icons.assessment),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            _team.id == 'NOTEAM'
                ? Center(
                    child: Text('Je speelt niet mee'),
                  )
                : GameViewAssignments(game, _team),
            ImageListView(game),
            TeamScoresPage(game, _team)
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Image.asset(
            'assets/chat.png',
            height: 22.0,
          ),
          // child: Icon(Icons.chat),
          onPressed: () {
            Navigator.pushNamed(context, '/chat/' + widget.gameId);
          },
        ),
      ),
    );
  }

  List<Widget> _buildAppbarActions(Game game, AppModel model) {
    return <Widget>[
      PopupMenuButton<String>(
        onSelected: (String choice) async {
          if (choice == Constants.Play) {
            _playButtonFunction(game, model);
          } else if (choice == Constants.Pauze) {
            _pauzeButtonFunction(game, model);
          } else if (choice == Constants.Stop) {
            _finishedButtonFunction(context, game, model);
          } else if (choice == Constants.Timer) {
            _showTimerDialog(context, game);
          } else if (choice == Constants.Notify) {
            _showNotificationDialog(context);
          }
        },
        itemBuilder: (BuildContext context) {
          return Constants.choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ),
    ];
  }

  _showTimerDialog(BuildContext context, Game game) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final now = DateTime.now();
        final Duration difference = game.date.isAfter(now)
            ? Duration(minutes: 0)
            : now.difference(game.date);
        int remaining;
        if (game.duration != null) {
          remaining = (game.duration - difference.inMinutes) < 0
              ? 0
              : game.duration - difference.inMinutes;
        }
        return AlertDialog(
          title: Text("Resterende tijd"),
          content: Text(remaining != null
              ? remaining.toString() + " minuten"
              : 'Geen looptijd ingesteld'),
        );
      },
    );
  }

  _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Meldingen"),
          content: Text(
              'Meldingen naar alle spelers komen pas in volgende releases van SelfieTheGame app beschikbaar'),
        );
      },
    );
  }

  Function _playButtonFunction(Game game, AppModel model) {
    if (!game.status.playing && !game.status.finished) {
      Map<String, dynamic> status = game.toJson()['status'];
      status['pauzed'] = false;
      status['playing'] = true;
      status['finished'] = false;
      print(status);
      model.updateCompleteStatus(game.id, status);
    }
    return null;
  }

  Function _pauzeButtonFunction(Game game, AppModel model) {
    if (game.status.playing && !game.status.finished) {
      Map<String, dynamic> status = game.toJson()['status'];
      status['pauzed'] = true;
      status['playing'] = false;
      status['finished'] = false;
      model.updateCompleteStatus(game.id, status);
    }
    return null;
  }

  Function _finishedButtonFunction(
      BuildContext context, Game game, AppModel model) {
    if (game.status.playing) {
      _showWarningDialog(context, model, game);
    }
    return null;
  }

  _showWarningDialog(BuildContext context, AppModel model, Game game) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Spel stoppen"),
          content: Text(
              "Je wilt het spel stoppen. Daarna kun je niet meer spelen. Wil je doorgaan?"),
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
              child: Text('STOPPEN'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((bool isCanceled) {
      if (!isCanceled) {
        Map<String, dynamic> status = game.toJson()['status'];
        status['pauzed'] = false;
        status['playing'] = false;
        status['finished'] = true;
        model.updateCompleteStatus(game.id, status);
      }
    });
  }

  Widget _buildProgressIndicatorWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spel wordt geladen...'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  _fetchTeam(AppModel model) async {
    print(model.authenticatedUser.uid);
    print(widget.gameId);
    Team returnedTeam =
        await model.fetchTeam(widget.gameId, model.authenticatedUser.uid);
    setState(() {
      if (returnedTeam != null) {
        _team = returnedTeam;
      }
      _hasTeam = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return StreamBuilder(
          stream: model.fetchGame(widget.gameId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData ||
                model.authenticatedUser == null) {
              return _buildProgressIndicatorWidget();
            } else if (!_hasTeam) {
              _fetchTeam(model);
              return _buildProgressIndicatorWidget();
            } else {
              final Map<String, dynamic> gameData = snapshot.data.data;
              gameData['id'] = widget.gameId;
              final Game _game = Game.fromJson(gameData);
              return _buildGamePage(context, _game, model);
            }
          },
        );
      },
    );
  }
}
