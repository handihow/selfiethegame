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
  bool _done = false;
  double _progress;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future getImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 512.0,
    );

    setState(() {
      _image = image;
    });
  }

  void uploadImage() {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
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
      if (event.snapshot.bytesTransferred == event.snapshot.totalByteCount) {
        setState(() {
          _done = true;
        });
      }
    }).onError((error) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(error.toString()),
        backgroundColor: Theme.of(context).errorColor,
      ));
    });
  }

  Widget _enableUpload(BuildContext context) {
    return Center(
      child: Image.file(_image),
    );
  }

  Widget _doneUploading(BuildContext context) {
    return Stack(children: <Widget>[
      Image.file(_image),
      Center(
        child: Text(
          "Je bent klaar met uploaden!",
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
      ),
    ]);
  }

  Widget _buildAssignmentPage() {
    Widget pageContent = Center(
      child: Text(
        'Maak een selfie met ' + widget.assignment.assignment,
        style: TextStyle(fontSize: 16.0),
      ),
    );
    if (_image != null) {
      pageContent = _enableUpload(context);
    }
    if (_done) {
      pageContent = _doneUploading(context);
    }
    return pageContent;
  }

  FloatingActionButton _uploadImageFloatingActionButton() {
    return FloatingActionButton.extended(
        onPressed: uploadImage,
        tooltip: 'Upload selfie',
        icon: Icon(Icons.cloud_upload),
        label: Text('Upload selfie'));
  }

  FloatingActionButton _takeImageFloatingActionButton() {
    return FloatingActionButton.extended(
        onPressed: getImage,
        tooltip: 'Maak selfie',
        icon: Icon(Icons.add_a_photo),
        label: Text('Maak selfie'));
  }

  FloatingActionButton _doneActionButton(BuildContext context) {
    return FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Klaar',
        icon: Icon(Icons.done),
        label: Text('Klaar'));
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
          body: _buildAssignmentPage(),
          floatingActionButton: _image == null
              ? _takeImageFloatingActionButton()
              : _done
                  ? _doneActionButton(context)
                  : _uploadImageFloatingActionButton(),
        );
      },
    );
  }
}
