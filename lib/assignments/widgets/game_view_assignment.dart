import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:selfiespel_mobile/images/widgets/rotated_image.dart';

import '../../scoped-models/main.dart';
import '../../models/image.dart';
import '../../models/assignment.dart';
import '../../models/team.dart';
import '../../models/user.dart';
import '../pages/assignment.dart';
import '../../images/pages/image_viewer.dart';

class GameViewAssignment extends StatelessWidget {
  final Assignment assignment;
  final ImageRef image;
  final Team team;
  final User user;
  final bool isPlaying;
  GameViewAssignment(
      this.assignment, this.image, this.team, this.user, this.isPlaying);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return ListTile(
          leading: image == null
              ? Icon(
                  Icons.assignment,
                  color: Theme.of(context).primaryColor,
                )
              : Icon(
                  Icons.assignment_turned_in,
                  color: Theme.of(context).primaryColor,
                ),
          title: Text(assignment.assignment),
          subtitle: Text(
              'Maximum score: ' + assignment.maxPoints.index.toString()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return image == null
                    ? AssignmentPage(assignment, image,
                        team, user, isPlaying)
                    : ImageViewer(image, true, false, true);
              }),
            );
          },
          trailing: image == null ? null : RotatedImage(image, 70, true),
        );
      },
    );
  }
}
