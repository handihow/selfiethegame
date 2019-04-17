import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/image.dart';
import '../../models/rating.dart';
import '../../models/reaction-type.dart';

class ImageRatingButtons extends StatefulWidget {
  final ImageRef imageRef;
  ImageRatingButtons(this.imageRef);

  @override
  State<StatefulWidget> createState() {
    return _ImageRatingButtonsState();
  }
}

class _ImageRatingButtonsState extends State<ImageRatingButtons> {
  Widget _buildButtonRow(
      BuildContext context, AppModel model, ImageRef imageRef) {
    List<Widget> buttons = [];
    buttons.add(
      MaterialButton(
        height: 35.0,
        minWidth: 35.0,
        color: imageRef.userAwardedPoints == Rating.invalid
            ? Colors.white30
            : Theme.of(context).primaryColor,
        child: Image.asset(
          'assets/points_zero.png',
          height: 22.0,
        ),
        onPressed: () {
          _updateScore(model, imageRef, imageRef.userRatingId, Rating.invalid);
        },
      ),
    );
    buttons.add(
      MaterialButton(
        height: 35.0,
        minWidth: 35.0,
        color: imageRef.userAwardedPoints == Rating.easy
            ? Colors.white30
            : Theme.of(context).primaryColor,
        child: Image.asset(
          'assets/points_one.png',
          height: 22.0,
        ),
        onPressed: () {
          _updateScore(model, imageRef, imageRef.userRatingId, Rating.easy);
        },
      ),
    );
    buttons.add(
      MaterialButton(
        height: 35.0,
        minWidth: 35.0,
        color: imageRef.userAwardedPoints == Rating.medium
            ? Colors.white30
            : Theme.of(context).primaryColor,
        child: imageRef.maxPoints.index > Rating.easy.index
            ? Image.asset(
                'assets/points_three.png',
                height: 22.0,
              )
            : Image.asset(
                'assets/points_three_disabled.png',
                height: 22.0,
              ),
        onPressed: imageRef.maxPoints.index > Rating.easy.index
            ? () {
                _updateScore(
                    model, imageRef, imageRef.userRatingId, Rating.medium);
              }
            : null,
      ),
    );
    buttons.add(
      MaterialButton(
        height: 35.0,
        minWidth: 35.0,
        color: imageRef.userAwardedPoints == Rating.hard
            ? Colors.white30
            : Theme.of(context).primaryColor,
        child: imageRef.maxPoints.index > Rating.medium.index
            ? Image.asset(
                'assets/points_five.png',
                height: 22.0,
              )
            : Image.asset(
                'assets/points_five_disabled.png',
                height: 22.0,
              ),
        onPressed: imageRef.maxPoints.index > Rating.medium.index
            ? () {
                _updateScore(
                    model, imageRef, imageRef.userRatingId, Rating.hard);
              }
            : null,
      ),
    );
    return Wrap(
      alignment: WrapAlignment.center,
      children: buttons,
    );
    // return Row(children: buttons,);
  }

  Future<void> _updateScore(AppModel model, ImageRef imageRef,
      String reactionId, Rating updatedScore) {
    if (reactionId != null) {
      return model.updateAwardedPoints(reactionId, updatedScore.index);
    } else {
      return model.reactOnImage(imageRef, model.authenticatedUser,
          ReactionType.rating, null, updatedScore);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return _buildButtonRow(context, model, widget.imageRef);
      },
    );
  }
}
