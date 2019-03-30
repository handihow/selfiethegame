import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/game.dart';
import '../../models/team.dart';
import '../../assignments/widgets/game_view_assignments.dart';

class GameViewPage extends StatefulWidget {
  final String gameId;

  GameViewPage(this.gameId);

  @override
  _GameViewPageState createState() => _GameViewPageState();
}

class _GameViewPageState extends State<GameViewPage> {

  Team _team;
  bool _hasTeam = false;

  Widget _buildGamePage(BuildContext context, Game game, AppModel model) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: _buildAppBarActions(game, model),
          title: Text(game.name),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.camera)),
              Tab(icon: Icon(Icons.image)),
              Tab(icon: Icon(Icons.chat)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GameViewAssignments(game, _team),
            Icon(Icons.image),
            Icon(Icons.chat),
          ],
        ),
      ),
    );
  }

  List<IconButton> _buildAppBarActions(Game game, AppModel model) {
    List<IconButton> buttons = [];
    if (game.administrator == model.authenticatedUser.uid) {
      buttons.add(
        IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: _playButtonFunction(game, model),
        ),
      );
      buttons.add(
        IconButton(
          icon: Icon(Icons.pause),
          onPressed: _pauzeButtonFunction(game, model),
        ),
      );
      buttons.add(
        IconButton(
          icon: Icon(Icons.stop),
          onPressed: _finishedButtonFunction(context, game, model),
        ),
      );
    }
    return buttons;
  }

  Function _playButtonFunction(Game game, AppModel model) {
    if (game.status.playing || game.status.finished) {
      return null;
    } else {
      return () {
        Map<String, dynamic> status = game.toJson()['status'];
        status['pauzed'] = false;
        status['playing'] = true;
        status['finished'] = false;
        model.updateCompleteStatus(game.id, status);
      };
    }
  }

  Function _pauzeButtonFunction(Game game, AppModel model) {
    if (!game.status.playing || game.status.finished) {
      return null;
    } else {
      return () {
        Map<String, dynamic> status = game.toJson()['status'];
        status['pauzed'] = true;
        status['playing'] = false;
        status['finished'] = false;
        model.updateCompleteStatus(game.id, status);
      };
    }
  }

  Function _finishedButtonFunction(
      BuildContext context, Game game, AppModel model) {
    if (!game.status.playing) {
      return null;
    } else {
      return () {
        _showWarningDialog(context, model, game);
      };
    }
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

  Widget _buildProgressIndicatorWidget(){
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
    Team returnedTeam = await model.fetchTeam(widget.gameId, model.authenticatedUser.uid);
    setState(() {
      _team =returnedTeam;
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
