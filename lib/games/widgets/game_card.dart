import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../scoped-models/main.dart';

import './date_tag.dart';
import './code_tag.dart';

import '../../models/game.dart';
import '../../models/user.dart';

class GameCard extends StatefulWidget {
  final Game game;
  final AppModel model;

  GameCard(this.game, this.model);

  @override
  State<StatefulWidget> createState() {
    return GameCardState();
  }
}

class GameCardState extends State<GameCard> {
  String _url =
      'https://via.placeholder.com/500x350.png?text=SelfieTheGame.com';

  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    StorageReference ref =
        FirebaseStorage.instance.ref().child(widget.game.imageUrl);
    ref.getDownloadURL().then((value) {
      if (mounted) {
        setState(() {
          _url = value;
        });
      }
    });
    if (widget.game.administrator == widget.model.authenticatedUser.uid && mounted) {
      setState(() {
        _isAdmin = true;
      });
    }
  }

  Widget _buildCodeDateTagRow() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CodeTag(widget.game.code),
          DateTag(widget.game.date)
        ],
      ),
    );
  }

  Widget _buildActionButtonBar(BuildContext context) {
    return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: _buildActionButtons(context));
  }

  List<RaisedButton> _buildActionButtons(BuildContext context) {
    List<RaisedButton> buttons = [];
    if (widget.game.status.closedAdmin) {
      buttons.add(
        RaisedButton(
          child: Text('OPEN'),
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.pushNamed<bool>(
              context, '/games/' + widget.game.id + '/view'),
        ),
      );
    } else if (widget.game.administrator == widget.model.authenticatedUser.uid) {
      buttons.add(
        RaisedButton(
          child: Text('ADMIN'),
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.pushNamed(
              context, '/games/' + widget.game.id + '/admin'),
        ),
      );
    } else {
      buttons.add(
        RaisedButton(
          child: Text('NOG NIET BEGONNEN'),
          color: Theme.of(context).accentColor,
          onPressed: null,
        ),
      );
    }
    if(widget.game.administrator == widget.model.authenticatedUser.uid) {
      buttons.add(
        RaisedButton(
          child: Text('VERWIJDEREN'),
          color: Colors.white,
          textColor: Theme.of(context).errorColor,
          onPressed: () => _showWarningDialogForGameRemoval(context),
        ),
      );
    } else {
      buttons.add(
        RaisedButton(
          child: Text('VERLATEN'),
          color: Colors.white,
          textColor: Theme.of(context).errorColor,
          onPressed: () => _showWarningDialogForLeavingGame(context),
        ),
      );
    }
    return buttons;
  }

  _showWarningDialogForGameRemoval(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Spel verwijderen"),
          content: Text("Je wilt dit spel verwijderen. Selfies van het spel worden niet verwijderd. Wil je doorgaan?"),
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
    ).then(
      (bool isCanceled) {
        if (!isCanceled) {
          widget.model.deleteGame(widget.game);
        }
      },
    );
  }

  _showWarningDialogForLeavingGame(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Spel verlaten"),
          content: Text("Je wilt dit spel verlaten. Selfies van het spel worden niet verwijderd. Wil je doorgaan?"),
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
              child: Text('VERLATEN'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then(
      (bool isCanceled) async {
        if (!isCanceled) {
          await widget.model.manageGameParticipants(widget.model.authenticatedUser, widget.game.id, 'player',false);
          widget.model.manageGameParticipants(widget.model.authenticatedUser, widget.game.id, 'participant',false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(widget.game.name),
            subtitle: _isAdmin ? Text('Beheerder') : Text('Speler'),
          ),
          Image.network(_url),
          // TitleDefault(game.name),
          _buildCodeDateTagRow(),
          _buildActionButtonBar(context)
        ],
      ),
    );
  }
}
