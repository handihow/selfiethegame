import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/image.dart';
import '../../models/user.dart';
import '../../models/reaction-type.dart';

class ImageLikeCommentButtons extends StatefulWidget {
  final ImageRef imageRef;
  final User user;
  ImageLikeCommentButtons(this.imageRef, this.user);

  @override
  State<StatefulWidget> createState() {
    return _ImageLikeCommentButtonsState();
  }
}

class _ImageLikeCommentButtonsState extends State<ImageLikeCommentButtons> {
  bool _userHasLiked = false;

  @override
  void initState() {
    super.initState();
    if (widget.imageRef.likes != null &&
        widget.imageRef.likes.contains(widget.user.uid)) {
      if (mounted) {
        setState(() {
          _userHasLiked = true;
        });
      }
    }
  }

  void _updateLike(AppModel model, ImageRef imageRef) {
    if (_userHasLiked) {
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
    if (mounted) {
      setState(() {
        _userHasLiked = !_userHasLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Padding(
          padding: EdgeInsets.all(2.0),
          child: IconButton(
            icon: Icon(Icons.thumb_up),
            onPressed: () => _updateLike(model, widget.imageRef),
          ),
        );
      },
    );
  }
}
