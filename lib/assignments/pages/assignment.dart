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
  final bool isPlaying;
  AssignmentPage(
      this.assignment, this.image, this.team, this.user, this.isPlaying);

  @override
  State<StatefulWidget> createState() {
    return _AssignmentPageState();
  }
}

class _AssignmentPageState extends State<AssignmentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isImageButtonDisabled = false;
  bool _isUploading = false;
  bool _doneUploading = false;
  File _image;

  Future getImage(BuildContext context) async {

    if(mounted){
      setState(() {
        _isImageButtonDisabled = true;
      });
    }

    final File image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 500.0, maxHeight: 500.0);

    if (mounted && image != null) {
      setState(() {
        _isUploading = true;
        _image = image;
      });
      uploadImage(context, image);
    } else if(mounted) {
      setState(() {
        _isImageButtonDisabled = false;
      });
    }
  }

  void uploadImage(BuildContext context, File image) {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('/images/' + randomAlphaNumeric(20) + '.jpg');
    final StorageUploadTask task = firebaseStorageRef.putFile(
      image,
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
      if (event.snapshot.bytesTransferred == event.snapshot.totalByteCount &&
          mounted) {
        setState(() {
          _isUploading = false;
          _doneUploading = true;
        });
      }
    }, onError: (error) {
      if (mounted) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(error.toString()),
          backgroundColor: Theme.of(context).errorColor,
        ));
        setState(() {
          _isUploading = false;
        });
      }
    });
  }

  Widget _showWaitingIndicator(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _showImage(BuildContext context) {
    return Stack(children: <Widget>[
      Image.file(_image),
      Center(
        child: Text(
          "Je bent klaar met uploaden!",
          style: TextStyle(fontSize: 14.0, color: Colors.white),
        ),
      ),
    ]);
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

  Widget _buildAssignmentPage(BuildContext context) {
    final String text = widget.isPlaying
        ? 'Maak een selfie met ' + widget.assignment.assignment
        : 'Spel is niet actief. Je kunt nu geen selfies uploaden.';
    Widget pageContent = Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 14.0),
      ),
    );
    if (_isUploading) {
      pageContent = _showWaitingIndicator(context);
    }
    if (_doneUploading) {
      pageContent = _showImage(context);
    }
    return pageContent;
  }

  FloatingActionButton _takeImageFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _isImageButtonDisabled ? null : () => getImage(context),
      tooltip: 'Maak selfie',
      icon: Icon(Icons.add_a_photo),
      label: Text('Maak selfie'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: _isUploading
                ? Text('Selfie upload..')
                : Text('Selfie met ' + widget.assignment.assignment),
          ),
          body: _buildAssignmentPage(context),
          floatingActionButton: !widget.isPlaying || _isUploading
              ? null
              : _doneUploading
                  ? _doneActionButton(context)
                  : _takeImageFloatingActionButton(context),
        );
      },
    );
  }
}
