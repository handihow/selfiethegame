import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/image.dart';
import '../../models/game.dart';
import '../../models/team.dart';
import '../../images/widgets/image_card.dart';

class TeamImageListView extends StatefulWidget {
  final Game game;
  final Team team;
  TeamImageListView(this.game, this.team);

  @override
  _TeamImageListViewState createState() => _TeamImageListViewState();
}

class _TeamImageListViewState extends State<TeamImageListView> {
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
        : Center(child: Text('No selfies yet'));
  }

  void _loadImages(AppModel model) async {
    List<ImageRef> imageRefs =
        await model.fetchTeamListImageReferences(widget.team.id);
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
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.team.name),
          ),
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            child: _finishedLoading
                ? _displayImageCards(context, _imageReferences, model)
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            onRefresh: () => model.setAuthenticatedUser(),
          ),
        );
      },
    );
  }
}
