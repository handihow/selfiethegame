import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../scoped-models/main.dart';

import './date_tag.dart';
import './code_tag.dart';

import '../../models/game.dart';

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
    // } else if (widget.game.administrator == widget.model.authenticatedUser.uid) {
    //   buttons.add(
    //     RaisedButton(
    //       child: Text('ADMIN'),
    //       color: Theme.of(context).accentColor,
    //       onPressed: () => Navigator.pushNamed(
    //           context, '/games/' + widget.game.id + '/admin'),
    //     ),
    //   );
    } else {
      buttons.add(
        RaisedButton(
          child: Text('NOT YET STARTED'),
          color: Theme.of(context).accentColor,
          onPressed: null,
        ),
      );
    }
    if(widget.game.administrator == widget.model.authenticatedUser.uid) {
      buttons.add(
        RaisedButton(
          child: Text('REMOVE'),
          color: Colors.white,
          textColor: Theme.of(context).errorColor,
          onPressed: () => _showWarningDialogForGameRemoval(context),
        ),
      );
    } else {
      buttons.add(
        RaisedButton(
          child: Text('LEAVE'),
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
          title: Text("Remove game"),
          content: Text("You want to delete this game. Selfies from the game are not deleted. Do you want to continue?"),
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              textColor: Theme.of(context).errorColor,
              child: Text('REMOVE'),
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
          title: Text("Leave game"),
          content: Text("You want to leave this game. Selfies from the game are not deleted. Do you want to continue?"),
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              textColor: Theme.of(context).errorColor,
              child: Text('LEAVE'),
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
            subtitle: _isAdmin ? Text('Admin') : Text('Player'),
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
