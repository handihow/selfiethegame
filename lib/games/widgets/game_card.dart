import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import './date_tag.dart';
import './code_tag.dart';

import '../../models/game.dart';
import '../../models/user.dart';

class GameCard extends StatefulWidget {
  final Game game;
  final User user;

  GameCard(this.game, this.user);

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
      setState(() {
        _url = value;
      });
    });
    if (widget.game.administrator == widget.user.uid) {
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
          onPressed: () =>
              Navigator.pushNamed<bool>(context, '/games/' + widget.game.id + '/view'),
        ),
      );
    } else if(widget.game.administrator == widget.user.uid) {
       buttons.add(
        RaisedButton(
          child: Text('ADMIN'),
          color: Theme.of(context).accentColor,
          onPressed: () =>
              Navigator.pushNamed(context, '/games/' + widget.game.id + '/admin'),
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
    // if(widget.game.administrator == widget.user.uid) {
    //   buttons.add(
    //     RaisedButton(
    //       child: Text('DELETE'),
    //       color: Colors.white,
    //       textColor: Theme.of(context).errorColor,
    //       onPressed: () =>
    //           Navigator.pushNamed<bool>(context, '/games/' + widget.game.id + '/delete'),
    //     ),
    //   );
    // }
    return buttons;
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
