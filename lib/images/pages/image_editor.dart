import 'dart:async';
import 'dart:typed_data';
import 'package:scoped_model/scoped_model.dart';
import 'package:selfiespel_mobile/models/mask.dart';
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
  bool _doneLoading = false;
  bool _hasRotated = false;
  bool _hasNoImage = false;
  double _angle = 0;
  bool _hasMasks = false;
  List<Mask> _masks;
  List<ui.Image> _images;

  @override
  initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    if (widget.image.downloadUrl == null) {
      setState(() {
        _doneLoading = true;
        _hasNoImage = true;
      });
    } else {
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
      List<ui.Image> images;
      if(widget.image.hasMasks){
        images = await _loadImages(widget.image.masks);
      }
      if (mounted) {
        setState(
          () {
            _imageFile = imageFile;
            _doneLoading = true;
            _angle = angle;
            _imageState = widget.image.imageState;
            _images = images != null ? images : null;
            _masks = widget.image.masks != null ? widget.image.masks : null;
            _hasMasks = widget.image.hasMasks != null ? widget.image.hasMasks : false;
          },
        );
      }
    }
  }

  void _detectFaces(String selectedAsset) async {
    final image = FirebaseVisionImage.fromFile(_imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
      ),
    );
    List<Mask> masks = []; 
    final faces = await faceDetector.processImage(image);
    if (faces != null) {
      for (var i = 0; i < faces.length; i++) {
        final String asset =
          'assets/' + selectedAsset + '/' + i.toString() + '.png';
        final Mask mask = new Mask(
          asset: asset,
          left: faces[i].boundingBox.left,
          top: faces[i].boundingBox.top,
          right: faces[i].boundingBox.right,
          bottom: faces[i].boundingBox.bottom,
        );
        masks.add(mask);
      }
    }
    List<ui.Image> images = await _loadImages(masks);
    if (mounted) {
      setState(
        () {
          _masks = masks;
          _hasMasks = true;
          _images = images;
        },
      );
    }
  }

  Future<List<ui.Image>> _loadImages(List<Mask> masks) async {
    List<ui.Image> images = [];
    for (var i = 0; i < masks.length; i++) {
      final ui.Image image = await loadUiImage(masks[i].asset);
      images.add(image);
    }
    return images;
  }

  Future<ui.Image> loadUiImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final list = Uint8List.view(data.buffer);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(list, completer.complete);
    return completer.future;
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
    List<String> listItems = ['dog', 'hairy', 'sun', 'zoo'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select mask'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: listItems.length,
              itemBuilder: (BuildContext ctxt, int index) {
                final String asset = 'assets/' + listItems[index] + '/1.png';
                return new ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(asset),
                  ),
                  title: Text(listItems[index][0].toUpperCase() +
                      listItems[index].substring(1)),
                  trailing: IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: () =>
                        Navigator.of(context).pop(listItems[index]),
                  ),
                );
              },
            ),
          ),
        );
      },
    ).then(
      (result) => _detectFaces(result),
    );
  }

  Widget _imageContainer() {
    return Transform.rotate(
      angle: _angle,
      child: Container(
        alignment: Alignment(0, 0),
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              widget.image.downloadUrl != null
                  ? widget.image.downloadUrl
                  : 'https://via.placeholder.com/500x500.png?text=Image not available...',
            ),
          ),
        ),
        child: _hasMasks
            ? FittedBox(
                fit: BoxFit.contain,
                child: CustomPaint(
                  size: Size(500, 500),
                  painter: FacePainter(_masks, _images),
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
  
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return WillPopScope(
          onWillPop: () async {
            await model.updateEditedImage(widget.image.id, _imageState, _hasMasks, _masks);
            return Navigator.of(context).pop(false);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('Edit'),
            ),
            body: _doneLoading && !_hasNoImage
                ? _displayImage(context)
                : Center(
                    child: _hasNoImage
                        ? Text('Could not download image')
                        : CircularProgressIndicator(),
                  ),
          ),
        );
      },
    );
  }
}
