import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/image.dart';
import '../../models/game.dart';
import './image_card.dart';

class ImageListView extends StatefulWidget {
  final Game game;
  ImageListView(this.game);

  @override
  _ImageListViewState createState() => _ImageListViewState();
}

class _ImageListViewState extends State<ImageListView> {
  List<ImageRef> _imageReferences;
  bool _finishedLoading = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  Widget _displayImageCards(
      BuildContext context, List<ImageRef> returnedImages, AppModel model) {
    return returnedImages.length > 0
        ? ListView(
            children: returnedImages.map((ImageRef image) {
              return ImageCard(image, widget.game, model);
            }).toList(),
          )
        : Center(child: Text('Nog geen selfies'));
  }

  void _loadImages(AppModel model) async {
    List<ImageRef> imageRefs =
        await model.fetchGameImageReferences(widget.game.id);
    if (mounted) {
      setState(() {
        _imageReferences = imageRefs;
        _finishedLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
      if (!_finishedLoading) {
        _loadImages(model);
      }
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        child: _finishedLoading
            ? _displayImageCards(context, _imageReferences, model)
            : Center(
                child: CircularProgressIndicator(),
              ),
        onRefresh: () => model.setAuthenticatedUser(),
      );
    });
  }
}
