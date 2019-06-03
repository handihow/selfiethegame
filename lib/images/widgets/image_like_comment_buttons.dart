import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/image.dart';
import '../../models/reaction-type.dart';

class ImageLikeCommentButtons extends StatefulWidget {
  final ImageRef imageRef;
  ImageLikeCommentButtons(this.imageRef);

  @override
  State<StatefulWidget> createState() {
    return _ImageLikeCommentButtonsState();
  }
}

class _ImageLikeCommentButtonsState extends State<ImageLikeCommentButtons> {
  Widget _buildButtonRow(
      BuildContext context, AppModel model, ImageRef imageRef) {
    List<Widget> buttons = [];
    buttons.add(
      Padding(
        padding: EdgeInsets.all(2.0),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: imageRef.likes != null &&
                  imageRef.likes.contains(model.authenticatedUser.uid)
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryColor,
          child: MaterialButton(
            height: 30,
            minWidth: 30,
            child: Image.asset('assets/thumb_up.png'),
            onPressed: () => _updateLike(model, imageRef),
          ),
        ),
      ),
    );
    return Wrap(
      alignment: WrapAlignment.center,
      children: buttons,
    );
  }

  void _updateLike(AppModel model, ImageRef imageRef) {
    if (imageRef.likes != null &&
        imageRef.likes.contains(model.authenticatedUser.uid)) {
      final reactionId = ReactionType.like.index.toString() +
          "_" +
          imageRef.id +
          "_" +
          model.authenticatedUser.uid;
      model.removeReactionFromImage(reactionId);
    } else {
      model.reactOnImage(
          imageRef, model.authenticatedUser, ReactionType.like, null, null);
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
