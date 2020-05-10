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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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
  Completer<GoogleMapController> _controller = Completer();
  bool _isImageButtonDisabled = false;
  bool _isUploading = false;
  bool _doneUploading = false;
  File _image;
  Position _currentPosition;
  final Set<Marker> _markers = Set();

  @override
  initState() {
    super.initState();
    if (widget.assignment.hasGooglePlacesLocation) {
      final Marker assignmentMarker = Marker(
        markerId: MarkerId('assignment'),
        position:
            LatLng(widget.assignment.latitude, widget.assignment.longitude),
        infoWindow: InfoWindow(
            title: widget.assignment.name,
            snippet: 'Take a selfie with ' + widget.assignment.assignment),
      );
      setState(() {
        _markers.add(assignmentMarker);
      });
    }
  }

  void _getImage(BuildContext context) async {
    await _getCurrentLocation();

    if (mounted) {
      setState(() {
        _isImageButtonDisabled = true;
      });
    }

    try {
      final File image = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 500.0,
        maxHeight: 500.0,
      );

      if (mounted && image != null) {
        setState(() {
          _isUploading = true;
          _image = image;
        });
        uploadImage(context, image);
      } else if (mounted) {
        setState(() {
          _isImageButtonDisabled = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    print('getting current location');
    return geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      print(position.latitude);
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
  }

  void uploadImage(BuildContext context, File image) {
    final StorageReference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('/media/' +
            widget.user.uid +
            '/' +
            randomAlphaNumeric(20) +
            '.jpg');
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
          'maxPoints': widget.assignment.maxPoints.index.toString(),
          'hasLocation': _currentPosition != null ? 'true' : 'false',
          'latitude': _currentPosition != null ? _currentPosition.latitude.toString() : null,
          'longitude': _currentPosition != null? _currentPosition.longitude.toString() : null
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
          "You're done uploading!",
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
        tooltip: 'Done',
        icon: Icon(Icons.done),
        label: Text('Done'));
  }

  Widget _buildAssignmentPage(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double containerSize = width > height ? height : width;
    Widget pageContent = Padding(
      padding: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text(widget.assignment.assignment),
            subtitle:
                Text('Take a selfie with ' + widget.assignment.assignment),
          ),
          ListTile(
            leading: Icon(Icons.assessment),
            title: Text('Maximum ' +
                widget.assignment.maxPoints.index.toString() +
                ' point(s)'),
            subtitle: Text('You can get maximum ' +
                widget.assignment.maxPoints.index.toString() +
                ' point(s) for this assignment.'),
          ),
          widget.assignment.description == null
              ? SizedBox(height: 0)
              : ListTile(
                  leading: Icon(Icons.comment),
                  title: Text('Description'),
                  subtitle: Text(widget.assignment.description),
                ),
          widget.assignment.location == null
              ? SizedBox(height: 0.0)
              : ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Location'),
                  subtitle: Text(widget.assignment.location),
                ),
          widget.assignment.hasGooglePlacesLocation
              ? ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(widget.assignment.name),
                  subtitle:
                      Text('Assignment location is ' + widget.assignment.name),
                )
              : SizedBox(height: 0.0),
          widget.assignment.hasGooglePlacesLocation
              ? SizedBox(
                  width: containerSize,
                  height: containerSize,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.assignment.latitude,
                          widget.assignment.longitude),
                      zoom: 15,
                    ),
                    onMapCreated: _onMapCreated,
                    markers: _markers,
                  ),
                )
              : SizedBox(height: 0.0),
          widget.assignment.hasGooglePlacesLocation
              ? ListTile(
                  leading: Icon(Icons.info),
                  title: Text('More information'),
                  subtitle: Text(widget.assignment.website != null
                      ? widget.assignment.website
                      : 'No external website available'),
                )
              : SizedBox(height: 0.0),
          SizedBox(height: 150.0),
        ],
      ),
    );
    if (_isUploading) {
      pageContent = _showWaitingIndicator(context);
    }
    if (_doneUploading) {
      pageContent = _showImage(context);
    }
    if (!widget.isPlaying) {
      return Center(
        child: Text('Game is not active. You cannot upload selfies.'),
      );
    }
    return pageContent;
  }

  FloatingActionButton _takeImageFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _isImageButtonDisabled ? null : () => _getImage(context),
      // onPressed: () => print('pressed'),
      tooltip: 'Take selfie',
      icon: Icon(Icons.add_a_photo),
      label: Text('Take selfie'),
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
                : Text('Selfie with ... '),
          ),
          body: _buildAssignmentPage(context),
          floatingActionButton: !widget.isPlaying || _isUploading
              ? null
              : _doneUploading
                  ? _doneActionButton(context)
                  : _takeImageFloatingActionButton(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
