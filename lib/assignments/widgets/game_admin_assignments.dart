import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import "dart:math";
import 'package:random_string/random_string.dart';

import '../../scoped-models/main.dart';
import '../../models/assignment.dart';
import '../../settings/settings.dart';
import '../../assignments/pages/assignment_edit.dart';

class GameAdminAssignments extends StatefulWidget {
  final String gameId;
  GameAdminAssignments(this.gameId);

  @override
  State<StatefulWidget> createState() {
    return _GameAdminAssignmentsState();
  }
}

class _GameAdminAssignmentsState extends State<GameAdminAssignments> {
  double _numberOfAssignments = 12.0;
  String _typeOfAssignments = 'Mix';
  int _levelOfAssignments = 0;
  final _random = new Random();

  _createNewAssignments(AppModel model) async {
    List<Map<String, dynamic>> assignments;
    List<Assignment> newAssignments = [];
    int order = 0;
    List<int> usedIndeces = [];
    if (_levelOfAssignments > 0) {
      assignments =
          ASSIGNMENTS.where((a) => a['level'] == _levelOfAssignments).toList();
    } else {
      assignments = ASSIGNMENTS;
    }
    while (newAssignments.length < _numberOfAssignments) {
      final index = _random.nextInt(assignments.length);
      if (!usedIndeces.contains(index)) {
        final Map<String, dynamic> assignment = assignments[index];
        newAssignments.add(Assignment(
            id: randomAlphaNumeric(20),
            created: DateTime.now(),
            updated: DateTime.now(),
            gameId: widget.gameId,
            order: order,
            maxPoints: Rating.values[assignment['maxPoints']],
            assignment: assignment['assignment'],
            level: assignment['level']));
        order += 1;
        usedIndeces.add(index);
      }
    }
    await model.addAssignments(widget.gameId, newAssignments);
    model.updateGameStatus(widget.gameId, 'assigned', true);
  }

  Widget _makeNewAssignments(BuildContext context, AppModel model) {
    return Column(
      children: <Widget>[
        Text('Maak automatisch opdrachten voor het spel!'),
        SizedBox(
          height: 10.0,
        ),
        Text("Selecteer het aantal opdrachten"),
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Slider(
                min: 6.0,
                max: 18.0,
                divisions: 12,
                value: _numberOfAssignments,
                onChanged: (value) {
                  setState(() {
                    _numberOfAssignments = value;
                  });
                },
              ),
            ),
            Container(
              width: 50.0,
              alignment: Alignment.center,
              child: Text('${_numberOfAssignments.toInt()}',
                  style: Theme.of(context).textTheme.display1),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text("Selecteer het niveau"),
        ),
        DropdownButton<String>(
          // isExpanded: true,
          value: _typeOfAssignments,
          items: <String>['Mix', 'Makkelijk', 'Gemiddeld', 'Moeilijk']
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: _handleTypeOfAssignmentsChange,
        ),
        Divider(),
        RaisedButton(
          onPressed: () => _createNewAssignments(model),
          child: Text('Maak opdrachten'),
        ),
      ],
    );
  }

  _handleTypeOfAssignmentsChange(value) {
    setState(() {
      _typeOfAssignments = value;
      switch (value) {
        case 'Makkelijk':
          _levelOfAssignments = 1;
          break;
        case 'Gemiddeld':
          _levelOfAssignments = 3;
          break;
        case 'Moeilijk':
          _levelOfAssignments = 5;
          break;
        default:
          _levelOfAssignments = 0;
      }
    });
  }

  Widget _displayExistingAssignments(BuildContext context, AppModel model,
      List<Assignment> returnedAssignments) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Text(
                'Maak een selfie met...',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _showWarningDialog(context, model),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return AssignmentEditPage(
                            widget.gameId,
                            order: returnedAssignments.length,
                          );
                        },
                      ),
                    );
                  },
                )
              ],
            )
          ],
        ),
        Container(
          height: 250.0,
          child: Scrollbar(
            child: ListView.builder(
              itemCount: returnedAssignments.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
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
                  subtitle: Text('max. score: ' +
                      returnedAssignments[index].maxPoints.index.toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      model.deleteAssignment(returnedAssignments[index]);
                    },
                  ),
                );
              },
            ),
          ),
        )
      ],
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
            RaisedButton(
              child: Text('Annuleren'),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            RaisedButton(
              child: Text('Verwijderen'),
              color: Theme.of(context).errorColor,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((bool isCanceled) {
      if (!isCanceled) {
        model.deleteAssignments(widget.gameId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return StreamBuilder(
            stream: model.fetchAssignments(widget.gameId),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData ||
                  snapshot.data.documents.length == 0) {
                return _makeNewAssignments(context, model);
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
            });
      },
    );
  }
}
