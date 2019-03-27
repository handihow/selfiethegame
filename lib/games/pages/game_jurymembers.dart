import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/user.dart';
import '../../models/game.dart';

class GameJuryMembersPage extends StatefulWidget {
  final Game game;
  GameJuryMembersPage(this.game);

  @override
  State<StatefulWidget> createState() {
    return _GameJuryMembersPageState();
  }
}

class _GameJuryMembersPageState extends State<GameJuryMembersPage> {
  Widget _createLeadingIcon(User user) {
    Widget leadingIcon;
    if (widget.game.administrator == user.uid) {
      leadingIcon = Icon(
        Icons.label,
        color: Theme.of(context).primaryColor,
      );
    } else if (widget.game.judges != null &&
        widget.game.judges.contains(user.uid)) {
      leadingIcon = Icon(
        Icons.label,
        color: Theme.of(context).primaryColor,
      );
    } else {
      leadingIcon = Icon(Icons.label_outline);
    }
    return leadingIcon;
  }

  Widget _createTrailingIconButton(User user, AppModel model) {
    Widget trailingIconButton;
    if (widget.game.administrator == user.uid) {
      trailingIconButton = IconButton(
        icon: Icon(Icons.check),
        onPressed: null,
      );
    } else if (widget.game.judges != null &&
        widget.game.judges.contains(user.uid)) {
      trailingIconButton = IconButton(
        icon: Icon(Icons.remove),
        onPressed: () {
          model.manageGameParticipants(user, widget.game.id, 'judge', false);
        },
      );
    } else {
      trailingIconButton = IconButton(
        icon: Icon(Icons.add),
        onPressed: () async {
          await model.manageGameParticipants(
              user, widget.game.id, 'judge', true);
          model.updateGameStatus(widget.game.id, 'judgesAssigned', true);
        },
      );
    }
    return trailingIconButton;
  }

  Widget _createSubtitle(User user) {
    Widget subtitle;
    if (widget.game.administrator == user.uid) {
      subtitle = Text('Beheerder');
    } else if (widget.game.judges != null &&
        widget.game.judges.contains(user.uid)) {
      subtitle = Text('Speler en jurylid');
    } else {
      subtitle = Text('Speler');
    }
    return subtitle;
  }

  Widget _displayGameParticipants(
      BuildContext context, AppModel model, List<User> returnedUsers) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: returnedUsers.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: _createLeadingIcon(returnedUsers[index]),
          title: Text(returnedUsers[index].displayName),
          subtitle: _createSubtitle(returnedUsers[index]),
          trailing: _createTrailingIconButton(returnedUsers[index], model),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Juryleden instellen'),
          ),
          body: StreamBuilder(
            stream: model.fetchGameParticipants(widget.game.id, 'participant'),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData ||
                  snapshot.data.documents.length == 0) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                List<User> returnedUsers = [];
                snapshot.data.documents.forEach((DocumentSnapshot document) {
                  final String userId = document.documentID;
                  final Map<String, dynamic> userData = document.data;
                  userData['id'] = userId;
                  final User returnedUser = User.fromJson(userData);
                  returnedUsers.add(returnedUser);
                });
                return _displayGameParticipants(context, model, returnedUsers);
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.done),
            onPressed: () async {
              await model.updateGameStatus(
                  widget.game.id, 'judgesAssigned', true);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
