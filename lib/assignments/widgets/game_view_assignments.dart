import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/game.dart';
import '../../models/assignment.dart';

class GameViewAssignments extends StatefulWidget {
  final Game game;
  GameViewAssignments(this.game);

  @override
  State<StatefulWidget> createState() {
    return _GameViewAssignmentsState();
  }
}

class _GameViewAssignmentsState extends State<GameViewAssignments> {
  Widget _displayExistingAssignments(BuildContext context, AppModel model,
      List<Assignment> returnedAssignments) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      padding: const EdgeInsets.all(10.0),
      itemCount: returnedAssignments.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://cdn.pixabay.com/photo/2019/02/06/15/18/puppy-3979350_960_720.jpg'),
          ),
          title: Text(returnedAssignments[index].assignment),
          subtitle: Text('Maximum score: ' +
              returnedAssignments[index].maxPoints.index.toString()),
          onTap: () {},
        );
      },
    );
  }

  Widget _buildAssignmentViewPage(BuildContext context, AppModel model,
      List<Assignment> returnedAssignments) {
    Widget returnedContent = Center(
      child: Text('Spel is nog niet begonnen'),
    );
    if (widget.game.status.playing) {
      returnedContent =
          _displayExistingAssignments(context, model, returnedAssignments);
    } else if (widget.game.status.pauzed) {
      returnedContent = Center(
        child: Text('Spel is gepauzeerd'),
      );
    } else if (widget.game.status.finished) {
      returnedContent = Center(
        child: Text('Spel is afgelopen'),
      );
    }
    return returnedContent;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return StreamBuilder(
          stream: model.fetchAssignments(widget.game.id),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData ||
                snapshot.data.documents.length == 0) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<Assignment> returnedAssignments = [];
              snapshot.data.documents.forEach((DocumentSnapshot document) {
                final String assignmentId = document.documentID;
                final Map<String, dynamic> assignmentData = document.data;
                assignmentData['id'] = assignmentId;
                final Assignment returnedAssignment =
                    Assignment.fromJson(assignmentData);
                returnedAssignments.add(returnedAssignment);
              });
              return _buildAssignmentViewPage(
                  context, model, returnedAssignments);
            }
          },
        );
      },
    );
  }
}
