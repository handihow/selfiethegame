import 'package:flutter/material.dart';
import '../../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class TeamMemberListTile extends StatelessWidget {
  final String displayName;
  final String userId;
  final int currentTeamIndex;

  TeamMemberListTile(this.displayName, this.userId, this.currentTeamIndex);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Draggable(
            child: Material(
              child: ListTile(
                leading: Icon(Icons.drag_handle),
                title: Text(displayName),
              ),
            ),
            feedback: Icon(
              Icons.face,
              size: 90.0,
            ),
            childWhenDragging: ListTile(
              leading: Icon(Icons.face),
              title: Text(displayName + ' is getting moved...'),
            ),
            data: currentTeamIndex.toString() + '_' + userId);
      },
    );
  }
}
