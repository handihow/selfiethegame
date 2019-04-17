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
            color: imageRef.userLikeId != null
            ? Theme.of(context).accentColor
            : Theme.of(context).primaryColor,
            child: 
            MaterialButton(
              height: 30,
              minWidth: 30,
              // color: imageRef.userAwardedPoints == Rating.invalid
              //   ? Theme.of(context).accentColor
              //   : Theme.of(context).primaryColor,
              child: Image.asset('assets/thumb_up.png'),
              onPressed: () => _updateLike(model, imageRef),
            ),
          ),
        ),
      // IconButton(
      //   color: imageRef.userLikeId != null
      //       ? Theme.of(context).accentColor
      //       : Colors.white,
      //   icon: Icon(Icons.thumb_up),
      //   onPressed: () => _updateLike(model, imageRef),
      // ),
    );
    return Wrap(
      alignment: WrapAlignment.center,
      children: buttons,
    );
  }

  void _updateLike(AppModel model, ImageRef imageRef) {
    print(imageRef.userLikeId);
    if (imageRef.userLikeId == null) {
      model.reactOnImage(
          imageRef, model.authenticatedUser, ReactionType.like, null, null);
    } else {
      model.removeReactionFromImage(imageRef.userLikeId);
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
