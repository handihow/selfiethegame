import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';
import 'dart:math' as math;

import '../widgets/image_rating_buttons.dart';
import '../widgets/image_like_comment_buttons.dart';
import '../../scoped-models/main.dart';
import '../../models/image.dart';
import '../../models/reaction.dart';
import '../../models/reaction-type.dart';
import '../share/constants.dart';
import 'package:share_extend/share_extend.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import './image_editor.dart';

class ImageViewer extends StatefulWidget {
  final ImageRef image;
  final bool hasGame;
  final bool isJudging;
  final bool canEdit;
  ImageViewer(this.image, this.hasGame, this.isJudging, this.canEdit);

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  final _commentController = TextEditingController();
  double _angle = 0; 

  @override
  initState() {
    super.initState();
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
          _angle = angle;
        },
      );
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _commentController.dispose();
    super.dispose();
  }

  _informDialog(BuildContext context, String functionality) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(functionality + "selfie"),
          content: Text("You can only " +
              functionality +
              " from the assignments page or the page with your own selfies"),
        );
      },
    );
  }

  _showCommentDialog(BuildContext context, AppModel model) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).errorColor,
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('SAVE'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
          title: Text('Comment'),
          content: TextFormField(
            controller: _commentController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Your comment',
            ),
          ),
        );
      },
    ).then((bool isCanceled) {
      if (!isCanceled) {
        model.reactOnImage(widget.image, model.authenticatedUser,
            ReactionType.comment, _commentController.text, null);
      }
    });
  }

  _showWarningDialog(BuildContext context, AppModel model) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove selfie"),
          content:
              Text("You want to remove this selfie. Do you wish to continue?"),
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              textColor: Theme.of(context).errorColor,
              child: Text('REMOVE'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then(
      (bool isCanceled) async {
        if (!isCanceled) {
          await model.deleteImage(widget.image);
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _showImageInformation(AppModel model) {
    return StreamBuilder(
      stream: model.getImageReactions(widget.image.id),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data.documents.length == 0) {
          return ListTile(
            leading: Icon(Icons.announcement),
            title: Text('No reaction'),
            subtitle: Text('No reactions on this selfie yet'),
          );
        }
        List<Reaction> returnedReactions = [];
        if (snapshot.hasData) {
          snapshot.data.documents.forEach((DocumentSnapshot document) {
            final String reactionId = document.documentID;
            final Map<String, dynamic> reactionData = document.data;
            reactionData['id'] = reactionId;
            final Reaction returnedReaction = Reaction.fromJson(reactionData);
            returnedReactions.add(returnedReaction);
          });
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            String subtitle = 'Like';
            IconData listIcon = Icons.thumb_up;
            bool hasWarningColor = false;
            if (returnedReactions[index].reactionType == ReactionType.comment) {
              subtitle = returnedReactions[index].comment;
              listIcon = Icons.comment;
            } else if (returnedReactions[index].reactionType ==
                ReactionType.rating) {
              subtitle = returnedReactions[index].rating.index.toString() +
                  ' point(s)';
              listIcon = Icons.assessment;
            } else if (returnedReactions[index].reactionType ==
                ReactionType.inappropriate) {
              subtitle = 'Inappropriate';
              listIcon = Icons.report;
              hasWarningColor = true;
            }
            return ListTile(
              leading: Icon(listIcon,
                  color: hasWarningColor
                      ? Theme.of(context).errorColor
                      : Theme.of(context).primaryColor),
              title: Text(returnedReactions[index].userDisplayName),
              subtitle: Text(subtitle),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildAppbarActions(AppModel model) {
    return <Widget>[
      PopupMenuButton<String>(
        onSelected: (String choice) async {
          if (choice == Constants.Report) {
            model.reactOnImage(widget.image, model.authenticatedUser,
                ReactionType.inappropriate, null, null);
          } else if (choice == Constants.Delete) {
            if (widget.canEdit) {
              _showWarningDialog(context, model);
            } else {
              _informDialog(context, 'Remove');
            }
          } else if (choice == Constants.Like) {
            if (widget.image.likes != null &&
                widget.image.likes.contains(model.authenticatedUser.uid)) {
              final reactionId = ReactionType.like.index.toString() +
                  "_" +
                  widget.image.id +
                  "_" +
                  model.authenticatedUser.uid;
              model.removeReactionFromImage(reactionId);
            } else {
              model.reactOnImage(widget.image, model.authenticatedUser,
                  ReactionType.like, null, null);
            }
          } else if (choice == Constants.Comment) {
            _showCommentDialog(context, model);
          } else if (choice == Constants.Mask) {
            if (widget.canEdit) {
              _editImage(widget.image);
            } else {
              _informDialog(context, 'Edit');
            }
          } else {
            File f = await DefaultCacheManager()
                .getSingleFile(widget.image.downloadUrl);
            ShareExtend.share(f.path, "image");
          }
        },
        itemBuilder: (BuildContext context) {
          return Constants.choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ),
    ];
  }

  _editImage(ImageRef image) {
    Navigator.push<double>(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return ImageEditor(
          image,
        );
      }),
    ).then((double value) {
      if(value != null){
        setState(() {
          _angle = value;
        });
      }
    });
  }

  Widget _showMainActionButtons(AppModel model) {
    if (!widget.hasGame) {
      return SizedBox(height: 0.0);
    } else if (widget.isJudging) {
      return ImageRatingButtons(widget.image, model.authenticatedUser);
    } else {
      return ImageLikeCommentButtons(widget.image, model.authenticatedUser);
    }
  }

  Widget _buildImageViewerBody(AppModel model) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    double targetDimension = deviceWidth > 500.0 ? 500.0 : deviceWidth * 0.7;
    final Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      targetDimension = deviceHeight > 500.0 ? 500.0 : deviceHeight * 0.5;
    }
    return ListView(
      children: <Widget>[
        Center(
          child: Transform.rotate(
            angle: _angle,
            child: Image.network(
              widget.image.downloadUrl != null ? widget.image.downloadUrl : 'https://via.placeholder.com/500x500.png?text=Image not available...',
              fit: BoxFit.cover,
              width: targetDimension,
            ),
          ),
        ),
        Center(
          child: Text('Selfie with ' + widget.image.assignment),
        ),
        _showMainActionButtons(model),
        _showImageInformation(model),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Scaffold(
          appBar: AppBar(
            actions: _buildAppbarActions(model),
            title: Text(widget.image.teamName),
          ),
          body: _buildImageViewerBody(model),
        );
      },
    );
  }
}
