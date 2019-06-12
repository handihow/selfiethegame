import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';

import '../../models/game.dart';
import '../widgets/game_card.dart';

import '../../shared-widgets/ui_elements/side_drawer.dart';

class GamesPage extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Widget _buildPage(BuildContext context, AppModel model) {
    return StreamBuilder(
      stream: model.fetchGames(model.authenticatedUser),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data.documents.length == 0) {
          return Center(
            child: Text('Nog geen spellen, voeg een spel toe'),
          );
        } else {
          return new ListView(
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              final String gameId = document.documentID;
              final Map<String, dynamic> gameData = document.data;
              gameData['id'] = gameId;
              final Game game = Game.fromJson(gameData);
              return new GameCard(game, model);
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildGamesPage(BuildContext context, AppModel model) {
    Widget gamesPage;
    if (model.authenticatedUser != null) {
      gamesPage = Scaffold(
        drawer: MainSideDrawer(),
        appBar: AppBar(
          title: Text('Spellen'),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          child: _buildPage(context, model),
          onRefresh: () => model.setAuthenticatedUser(),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/choose');
          },
        ),
      );
    } else {
      model.setAuthenticatedUser();
      gamesPage = Scaffold(
        drawer: MainSideDrawer(),
        appBar: AppBar(
          title: Text('Spellen'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return gamesPage;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
      return _buildGamesPage(context, model);
    });
  }
}
