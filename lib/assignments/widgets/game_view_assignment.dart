import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/image.dart';
import '../../models/assignment.dart';
import '../../models/team.dart';
import '../../models/user.dart';
import '../pages/assignment.dart';

class GameViewAssignment extends StatefulWidget {
  final Assignment assignment;
  final ImageRef image;
  final Team team;
  final User user;
  GameViewAssignment(this.assignment, this.image, this.team, this.user);

  @override
  State<StatefulWidget> createState() {
    return _GameViewAssignmentState();
  }
}

class _GameViewAssignmentState extends State<GameViewAssignment> {
  String _url = 'https://via.placeholder.com/50x50.png?text=STG.com';

  @override
  void initState() {
    super.initState();
    if (widget.image != null) {
      StorageReference ref =
          FirebaseStorage.instance.ref().child(widget.image.pathTN);
      ref.getDownloadURL().then((value) {
        setState(() {
          _url = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(_url),
      ),
      title: Text(widget.assignment.assignment),
      subtitle: Text(
          'Maximum score: ' + widget.assignment.maxPoints.index.toString()),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return AssignmentPage(widget.assignment, widget.image, widget.team, widget.user);
          }),
        );
      },
      trailing:
          widget.image == null ? Icon(Icons.camera_alt) : Icon(Icons.done),
    );
  }
}
