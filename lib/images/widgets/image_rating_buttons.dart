import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/image.dart';
import '../../models/user.dart';
import '../../models/rating.dart';
import '../../models/reaction-type.dart';

class ImageRatingButtons extends StatefulWidget {
  final ImageRef imageRef;
  final User user;
  ImageRatingButtons(this.imageRef, this.user);

  @override
  State<StatefulWidget> createState() {
    return _ImageRatingButtonsState();
  }
}

class _ImageRatingButtonsState extends State<ImageRatingButtons> {
  Rating optimisticRatingUpdate = Rating.donotusebut;

  Widget _buildButtonRow(
      BuildContext context, AppModel model) {
    final String reactionId = ReactionType.rating.index.toString() +
        '_' +
        widget.imageRef.id +
        '_' +
        widget.user.uid;
    List<Widget> buttons = [];
    buttons.add(
      MaterialButton(
        height: 35.0,
        minWidth: 35.0,
        // color: _buttonColor(Rating.invalid),
        child: Image.asset(
          'assets/points_zero.png',
          height: 22.0,
        ),
        onPressed: () {
          _updateScore(model, widget.imageRef, reactionId, Rating.invalid);
        },
      ),
    );
    buttons.add(
      MaterialButton(
        height: 35.0,
        minWidth: 35.0,
        // color: _buttonColor(Rating.easy),
        child: Image.asset(
          'assets/points_one.png',
          height: 22.0,
        ),
        onPressed: () {
          _updateScore(model, widget.imageRef, reactionId, Rating.easy);
        },
      ),
    );
    buttons.add(
      MaterialButton(
        height: 35.0,
        minWidth: 35.0,
        // color: _buttonColor(Rating.medium),
        child: widget.imageRef.maxPoints.index > Rating.easy.index
            ? Image.asset(
                'assets/points_three.png',
                height: 22.0,
              )
            : Image.asset(
                'assets/points_three_disabled.png',
                height: 22.0,
              ),
        onPressed: widget.imageRef.maxPoints.index > Rating.easy.index
            ? () {
                _updateScore(
                    model, widget.imageRef, reactionId, Rating.medium);
              }
            : null,
      ),
    );
    buttons.add(
      MaterialButton(
        height: 35.0,
        minWidth: 35.0,
        // color: _buttonColor(Rating.hard),
        child: widget.imageRef.maxPoints.index > Rating.medium.index
            ? Image.asset(
                'assets/points_five.png',
                height: 22.0,
              )
            : Image.asset(
                'assets/points_five_disabled.png',
                height: 22.0,
              ),
        onPressed: widget.imageRef.maxPoints.index > Rating.medium.index
            ? () {
                _updateScore(
                    model, widget.imageRef, reactionId, Rating.hard);
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

  // Color _buttonColor(Rating rating) {
  //   Color returnedColor;
  //   if (optimisticRatingUpdate == Rating.donotusebut) {
  //     //the initial state loaded
  //     returnedColor = widget.imageRef.userAwardedPoints == rating
  //         ? Colors.white30
  //         : Theme.of(context).primaryColor;
  //   } else {
  //     //use the optimistic updated color for the button
  //     returnedColor = optimisticRatingUpdate == rating
  //         ? Colors.white30
  //         : Theme.of(context).primaryColor;
  //   }
  //   return returnedColor;
  // }

  Future<void> _updateScore(AppModel model, ImageRef imageRef,
      String reactionId, Rating updatedScore) {
    //optimistic update of rating
    if (mounted) {
      setState(() {
        optimisticRatingUpdate = updatedScore;
      });
    }
    //update the database
    if (imageRef.ratings != null && imageRef.ratings.contains(model.authenticatedUser.uid)) {
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
        return _buildButtonRow(context, model);
      },
    );
  }
}
