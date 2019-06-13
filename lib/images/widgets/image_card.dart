import 'package:flutter/material.dart';

import '../pages/image_viewer.dart';
import '../../scoped-models/main.dart';

import '../../models/image.dart';
import '../../models/game.dart';

class ImageCard extends StatelessWidget {
  final ImageRef image;
  final Game game;
  final AppModel model;

  ImageCard(this.image, this.game, this.model);

  @override
  Widget build(BuildContext context) {
    bool isJudging = false;
    if (game.administrator == model.authenticatedUser.uid ||
        (game.judges != null &&
            game.judges.contains(model.authenticatedUser.uid))) {
      isJudging = true;
    }
    return GestureDetector(
      onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) {
              return ImageViewer(
                image,
                true,
                isJudging,
                false
              );
            }),
          ),
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: image.likes != null &&
                      image.likes.contains(model.authenticatedUser.uid)
                  ? Icon(Icons.thumb_up, color: Theme.of(context).accentColor)
                  : null,
              title: Text(image.teamName),
              subtitle: Text('Selfie met ' + image.assignment),
              trailing: image.ratings != null &&
                      image.ratings.contains(model.authenticatedUser.uid)
                  ? Icon(Icons.assessment, color: Theme.of(context).accentColor)
                  : null,
            ),
            Image.network(image.downloadUrl),
            ListTile(
              leading: Icon(Icons.assessment,
                  color: image.ratings != null && image.ratings.length > 0
                      ? Theme.of(context).primaryColor
                      : null),
              title: Text(image.ratings != null && image.ratings.length > 0
                  ? 'Selfie is ' +
                      image.ratings.length.toString() +
                      ' keer beoordeeld'
                  : 'Niet beoordeeld'),
              subtitle: Text(image.likes != null && image.likes.length > 0
                  ? 'Selfie is ' +
                      image.likes.length.toString() +
                      ' keer geliked'
                  : 'Geen likes'),
              trailing: Icon(Icons.thumb_up,
                  color: image.likes != null && image.likes.length > 0
                      ? Theme.of(context).primaryColor
                      : null),
            ),
          ],
        ),
      ),
    );
  }
}
