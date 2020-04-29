import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:selfiespel_mobile/images/widgets/image_face_painter.dart';
import 'dart:math' as math;
import '../../models/image.dart';

class ImageEditor extends StatefulWidget {
  final ImageRef image;
  ImageEditor(this.image);

  @override
  _ImageEditorState createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  File _imageFile;
  String _imageState;
  List<Face> _faces;
  bool _doneLoading = false;
  bool _hasRotated = false;
  double _angle = 0;
  ui.Image _mask;
  bool _hasMasks = false;
  List<Color> _colors;

  @override
  initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    final imageFile =
        await DefaultCacheManager().getSingleFile(widget.image.downloadUrl);
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
      setState(
        () {
          _imageFile = imageFile;
          _doneLoading = true;
          _angle = angle;
          _imageState = widget.image.imageState;
        },
      );
    }
  }

  void _detectFaces(ui.Image selectedMask) async {
    final image = FirebaseVisionImage.fromFile(_imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
      ),
    );
    final faces = await faceDetector.processImage(image);
    if (mounted) {
      setState(
        () {
          _faces = faces;
          _mask = selectedMask;
          _colors = _faces
              .map((f) =>
                  Colors.accents[Random().nextInt(Colors.accents.length)])
              .toList();
          _hasMasks = true;
        },
      );
    }
  }

  void _rotateImage() {
    String imageState = '';
    switch (_imageState) {
      case '90':
        imageState = '180';
        break;
      case '180':
        imageState = '270';
        break;
      case '270':
        imageState = null;
        break;
      default:
        imageState = '90';
        break;
    }
    setState(() {
      _angle = _angle + math.pi / 2;
      _imageState = imageState;
      _hasRotated = true;
    });
  }

  void _openMaskSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select mask'),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/dog.png'),
                  ),
                  title: Text('Dog'),
                  trailing: IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: () =>
                        Navigator.of(context).pop('assets/dog.png'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then(
      (result) => _selectMask(result),
    );
  }

  Future<ui.Image> loadUiImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final list = Uint8List.view(data.buffer);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(list, completer.complete);
    return completer.future;
  }

  void _selectMask(String selectedAsset) async {
    final image = await loadUiImage(selectedAsset);
    _detectFaces(image);
  }

  Widget _imageContainer() {
    return Transform.rotate(
      angle: _angle,
      child: Container(
        alignment: Alignment(0, 0),
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.image.downloadUrl),
          ),
        ),
        child: _hasMasks
            ? FittedBox(
                fit: BoxFit.contain,
                child: CustomPaint(
                  size: Size(500, 500),
                  painter: FacePainter(_faces, _mask, _colors),
                ),
              )
            : SizedBox(),
      ),
    );
  }

  _removeMasks(BuildContext context) {
    setState(() {
      _hasMasks = false;
    });
  }

  Widget _displayImage(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: _imageContainer(),
        ),
        Flexible(
          flex: 1,
          child: ButtonBar(
            children: <Widget>[
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text('ROTATE'),
                onPressed: () => _rotateImage(),
              ),
              RaisedButton(
                color: _hasMasks
                    ? Theme.of(context).errorColor
                    : Theme.of(context).accentColor,
                child: Text(_hasMasks ? 'REMOVE MASKS' : 'MASK FACES'),
                onPressed: _hasMasks
                    ? () => _removeMasks(context)
                    : () => _openMaskSelector(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> _saveChangesToImage(BuildContext context, AppModel model) async {
    if(_hasRotated){
      print(_imageState);
      await model.updateImageRotation(widget.image.id, _imageState);
      return Navigator.of(context).pop(_angle);
    } else {
      return Navigator.of(context).pop(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return WillPopScope(
          onWillPop: () async {
            return _saveChangesToImage(context, model);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('Edit'),
            ),
            body: _doneLoading
                ? _displayImage(context)
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        );
      },
    );
  }
}
