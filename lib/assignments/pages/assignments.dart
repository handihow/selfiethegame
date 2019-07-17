import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/assignment.dart';
import '../pages/assignment_edit.dart';

class AssignmentsPage extends StatefulWidget {
  final String gameId;
  AssignmentsPage(this.gameId);

  @override
  State<StatefulWidget> createState() {
    return _AssignmentsPageState();
  }
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  Widget _displayExistingAssignments(BuildContext context, AppModel model,
      List<Assignment> returnedAssignments) {
    return ListView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: returnedAssignments.length,
      itemBuilder: (BuildContext context, int index) {
        String subtitle = returnedAssignments[index].maxPoints.index.toString() +
                ' punt(en) ';
        if(returnedAssignments[index].description != null){
          subtitle += returnedAssignments[index].description + ' ';
        }
        if(returnedAssignments[index].location != null){
          subtitle += returnedAssignments[index].location;
        }
        return ListTile(
          isThreeLine: true,
          leading: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return AssignmentEditPage(widget.gameId,
                        assignment: returnedAssignments[index]);
                  },
                ),
              );
            },
          ),
          title: Text(returnedAssignments[index].assignment),
          subtitle: Text(subtitle),
          trailing: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              model.deleteAssignment(returnedAssignments[index]);
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
          title: Text("Opdrachten verwijderen"),
          content:
              Text("Je verwijdert hiermee alle opdrachten. Wil je doorgaan?"),
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
        await model.updateGameStatus(widget.gameId, 'assigned', false);
        model.deleteAssignments(widget.gameId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Maak een selfie met...'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.redo),
                onPressed: () => _showWarningDialog(context, model),
              )
            ],
          ),
          body: StreamBuilder(
            stream: model.fetchAssignments(widget.gameId),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData ||
                  snapshot.data.documents.length == 0) {
                return Center(
                  child: Text('Nog geen opdrachten'),
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
                return _displayExistingAssignments(
                    context, model, returnedAssignments);
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
                    return AssignmentEditPage(
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
