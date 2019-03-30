import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_string/random_string.dart';

import '../../scoped-models/main.dart';
import '../../models/assignment.dart';
import '../../models/image.dart';
import '../../models/team.dart';
import '../../models/user.dart';

import 'dart:async';
import 'dart:io';

class AssignmentPage extends StatefulWidget {
  final Assignment assignment;
  final ImageRef image;
  final Team team;
  final User user;
  AssignmentPage(this.assignment, this.image, this.team, this.user);

  @override
  State<StatefulWidget> createState() {
    return _AssignmentPageState();
  }
}

class _AssignmentPageState extends State<AssignmentPage> {
  File _image;
  bool _isLoading = false;
  double _progress;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Widget _enableUpload(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Center(
            child: Image.file(_image),
          ),
          RaisedButton(
            elevation: 7.0,
            child: Text('Upload'),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              final StorageReference firebaseStorageRef = FirebaseStorage
                  .instance
                  .ref()
                  .child('/images/' + randomAlphaNumeric(20) + '.jpg');
              final StorageUploadTask task = firebaseStorageRef.putFile(
                _image,
                StorageMetadata(
                  customMetadata: {
                    'teamId': widget.team.id,
                    'assignmentId': widget.assignment.id,
                    'userId': widget.user.uid,
                    'gameId': widget.assignment.gameId,
                    'teamName': widget.team.name,
                    'assignment': widget.assignment.assignment,
                    'maxPoints': widget.assignment.maxPoints.index.toString()
                  },
                  contentType: 'image/jpeg',
                ),
              );
              task.events.listen((event) {
                setState(() {
                  _isLoading = true;
                  _progress = event.snapshot.bytesTransferred.toDouble() /
                      event.snapshot.totalByteCount.toDouble();
                });
              }).onError((error) {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(error.toString()),
                  backgroundColor: Theme.of(context).errorColor,
                ));
              });
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Selfie met ' + widget.assignment.assignment),
            bottom: _isLoading
                ? PreferredSize(
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.white,
                    ),
                    preferredSize: Size(MediaQuery.of(context).size.width, 5.0),
                  )
                : null,
          ),
          body: Center(
            child: _image == null
                ? Text('Nog geen selfie.')
                : _enableUpload(context),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: getImage,
            tooltip: 'Pick Image',
            child: Icon(Icons.add_a_photo),
          ),
        );
      },
    );
  }
}
