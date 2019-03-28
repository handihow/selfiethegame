import 'package:flutter/material.dart';
import '../../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class TeamMemberListTile extends StatelessWidget {
  final String displayName;

  TeamMemberListTile(this.displayName);

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
          feedback: Material(
            child: ListTile(
              leading: Icon(Icons.drag_handle),
              title: Text(displayName),
            ),
          ),
          childWhenDragging: Container(),
        );
      },
    );
  }
}
