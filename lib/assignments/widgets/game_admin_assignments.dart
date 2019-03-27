import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import "dart:math";
import 'package:random_string/random_string.dart';

import '../../scoped-models/main.dart';
import '../../models/assignment.dart';
import '../../settings/settings.dart';
import '../pages/assignment_edit.dart';

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
    await model.updateGameStatus(widget.gameId, 'assigned', true);
    model.addAssignments(widget.gameId, newAssignments);
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
        ButtonBar(
          children: <Widget>[
            FlatButton(child: Text('HANDMATIG') ,onPressed: () {
            Navigator.pushNamed(context, '/assignments/' + widget.gameId);
          } ,),
            RaisedButton(
              onPressed: () => _createNewAssignments(model),
              child: Text('AUTOMATISCH'),
            ),
          ],
        )
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

  Widget _displayExistingAssignments(BuildContext context, int numberOfAssignments) {
    return ListTile(
        // leading: Icon(Icons.done),
        title: Text('Opdrachten zijn klaar!'),
        subtitle: Text('Spel heeft $numberOfAssignments opdrachten'),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, '/assignments/' + widget.gameId);
          },
        ));
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
                return _displayExistingAssignments(context, snapshot.data.documents.length);
              }
            });
      },
    );
  }
}
