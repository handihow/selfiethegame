import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  GameViewAssignment(this.assignment, this.image, this.team, this.user);

  @override
  State<StatefulWidget> createState() {
    return _GameViewAssignmentState();
  }
}

class _GameViewAssignmentState extends State<GameViewAssignment> {
  String _url = 'https://via.placeholder.com/80x80.png?text=processing..';

  void _downloadThumbnail(){
     StorageReference ref =
          FirebaseStorage.instance.ref().child(widget.image.pathTN);
      ref.getDownloadURL().then((value) {
        setState(() {
          _url = value;
        });
      });
  }

  Widget _createHeroImage() {
    _downloadThumbnail();
    return Hero(
      child: Image(
        image: NetworkImage(_url),
        height: 80.0,
        width: 80.0,
        fit: BoxFit.fitWidth,
      ),
      tag: widget.image.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.image == null
          ? Icon(Icons.assignment)
          : Icon(Icons.assignment_turned_in),
      title: Text(widget.assignment.assignment),
      subtitle: Text(
          'Maximum score: ' + widget.assignment.maxPoints.index.toString()),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) {
            return widget.image == null
                ? AssignmentPage(
                    widget.assignment, widget.image, widget.team, widget.user)
                : ImageViewer(widget.image, _url);
          }),
        );
      },
      trailing: widget.image == null ? null : _createHeroImage(),
    );
  }
}
