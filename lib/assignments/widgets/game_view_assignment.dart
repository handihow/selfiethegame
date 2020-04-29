import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math' as math;

import '../../scoped-models/main.dart';
import '../../models/image.dart';
import '../../models/assignment.dart';
import '../../models/team.dart';
import '../../models/user.dart';
import '../pages/assignment.dart';
import '../../images/pages/image_viewer.dart';

class GameViewAssignment extends StatefulWidget {
  final Assignment assignment;
  final ImageRef image;
  final Team team;
  final User user;
  final bool isPlaying;
  GameViewAssignment(
      this.assignment, this.image, this.team, this.user, this.isPlaying);

  @override
  State<StatefulWidget> createState() {
    return _GameViewAssignmentState();
  }
}

class _GameViewAssignmentState extends State<GameViewAssignment> {
  String _url = 'https://via.placeholder.com/70x70.png?text=processing...';
  double _angle = 0;

  @override
  void initState() {
    super.initState();
    if (widget.image != null && widget.image.pathTN != null) {
      StorageReference ref =
          FirebaseStorage.instance.ref().child(widget.image.pathTN);
      ref.getDownloadURL().then((value) {
        double angle;
        switch (widget.image.imageState) {
          case '90':
            angle = math.pi / 2;
            break;
          case '180':
            angle = math.pi;
            break;
          case '270':
            angle = math.pi * 3 / 2;
            break;
          default:
            angle = 0;
            break;
        }
        if (mounted) {
          setState(() {
            _url = value;
            _angle = angle;
          });
        }
      }).catchError((error) => print(error.message));
    }
  }

  Widget _createHeroImage() {
    return Hero(
      child: Transform.rotate(
        angle: _angle,
        child: Image(
          image: NetworkImage(_url),
          height: 70.0,
          width: 70.0,
          fit: BoxFit.fitWidth,
        ),
      ),
      tag: widget.image.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return ListTile(
          leading: widget.image == null
              ? Icon(
                  Icons.assignment,
                  color: Theme.of(context).primaryColor,
                )
              : Icon(
                  Icons.assignment_turned_in,
                  color: Theme.of(context).primaryColor,
                ),
          title: Text(widget.assignment.assignment),
          subtitle: Text(
              'Maximum score: ' + widget.assignment.maxPoints.index.toString()),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return widget.image == null
                    ? AssignmentPage(widget.assignment, widget.image,
                        widget.team, widget.user, widget.isPlaying)
                    : ImageViewer(widget.image, true, false, true);
              }),
            );
          },
          trailing: widget.image == null ? null : _createHeroImage(),
        );
      },
    );
  }
}
