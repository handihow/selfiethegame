import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/game.dart';
import '../../models/assignment.dart';
import '../../models/team.dart';
import '../../models/image.dart';
import './game_view_assignment.dart';

class GameViewAssignments extends StatefulWidget {
  final Game game;
  final Team team;
  GameViewAssignments(this.game, this.team);

  @override
  State<StatefulWidget> createState() {
    return _GameViewAssignmentsState();
  }
}

class _GameViewAssignmentsState extends State<GameViewAssignments> {
  Widget _displayExistingAssignments(BuildContext context, AppModel model,
      List<Assignment> returnedAssignments, List<ImageRef> returnedImages) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      padding: const EdgeInsets.all(10.0),
      itemCount: returnedAssignments.length,
      itemBuilder: (BuildContext context, int index) {
        final ImageRef assignmentImage = returnedImages.firstWhere((ai) {
          bool hasImage = false;
          if (ai.teamId == widget.team.id &&
              ai.assignmentId == returnedAssignments[index].id &&
              ai.downloadUrl != null) {
            hasImage = true;
          }
          return hasImage;
        }, orElse: () => null);
        return GameViewAssignment(returnedAssignments[index], assignmentImage,
            widget.team, model.authenticatedUser, widget.game.status.playing);
      },
    );
  }

  Widget _buildAssignmentViewPage(BuildContext context, AppModel model,
      List<Assignment> returnedAssignments) {
    return StreamBuilder(
      stream: model.fetchTeamImageReferences(widget.team.id),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<ImageRef> returnedImages = [];
          if (snapshot.hasData) {
            snapshot.data.documents.forEach((DocumentSnapshot document) {
              final String imageId = document.documentID;
              final Map<String, dynamic> imageData = document.data;
              imageData['id'] = imageId;
              final ImageRef returnedImage = ImageRef.fromJson(imageData);
              returnedImages.add(returnedImage);
            });
          }
          return _displayExistingAssignments(
              context, model, returnedAssignments, returnedImages);
        }
      },
    );
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
