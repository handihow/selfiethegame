import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
// import 'package:share/share.dart';

import '../../scoped-models/main.dart';
import '../../models/image.dart';
import '../../models/reaction.dart';
import '../../models/reaction-type.dart';
import '../widgets/image_like_comment_buttons.dart';
import '../widgets/image_rating_buttons.dart';
import '../share/constants.dart';

class ImageViewer extends StatelessWidget {
  final ImageRef image;
  final String placeholder;
  final bool canEdit;
  final bool isJudging;

  ImageViewer(this.image, this.placeholder, this.canEdit, this.isJudging);

  final Key _buttonsAndInfoKey = new Key('buttonsAndInfo');
  final Key _imageReactionsListKey = new Key('imageReactionsList');

  _showWarningDialog(BuildContext context, AppModel model) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Selfie verwijderen"),
          content: Text("Je wilt deze selfie verwijderen. Wil je doorgaan?"),
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('ANNULEREN'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              textColor: Theme.of(context).errorColor,
              child: Text('VERWIJDEREN'),
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
          await model.deleteImage(image);
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _showButtonBar(AppModel model, BuildContext context) {
    Widget buttons;
    if (canEdit) {
      buttons = ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            color: Theme.of(context).errorColor,
            textColor: Colors.white,
            child: Text('VERWIJDEREN'),
            onPressed: () {
              _showWarningDialog(context, model);
            },
          ),
        ],
      );
    } else {
      buttons = isJudging
          ? ImageRatingButtons(image)
          : ImageLikeCommentButtons(image);
    }
    return buttons;
  }

  Widget _showImageInformation(AppModel model) {
    return StreamBuilder(
      stream: model.getImageReactions(image.id),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
        return SliverList(
          key: _imageReactionsListKey,
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              String subtitle = 'Leuk';
              IconData listIcon = Icons.thumb_up;
              bool hasWarningColor = false;
              if (returnedReactions[index].reactionType ==
                  ReactionType.comment) {
                subtitle = returnedReactions[index].comment;
                listIcon = Icons.comment;
              } else if (returnedReactions[index].reactionType ==
                  ReactionType.rating) {
                subtitle = returnedReactions[index].rating.index.toString() +
                    ' punt(en)';
                listIcon = Icons.assessment;
              } else if (returnedReactions[index].reactionType ==
                  ReactionType.inappropriate) {
                subtitle = 'Ongepast';
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
            childCount: returnedReactions.length,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('building image viewer');
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Scaffold(
          body: image == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      actions: <Widget>[
                        PopupMenuButton<String>(
                          onSelected: (String choice) {
                            if (choice == Constants.Report) {
                              model.reactOnImage(
                                  image,
                                  model.authenticatedUser,
                                  ReactionType.inappropriate,
                                  null,
                                  null);
                            } else {
                              print('other functionality coming soon...');
                              // Share.share('Deze selfie is gemaakt met SelfieTheGame! Bekijk via de link: ' + _url);
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
                      ],
                      expandedHeight: MediaQuery.of(context).size.width > 600 ? 500.0 : 256.0,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text('Team ' + image.teamName),
                        background: Hero(
                          tag: image.id,
                          child: FadeInImage(
                            image: NetworkImage(image.downloadUrl),
                            height: 500,
                            fit: MediaQuery.of(context).size.width > 600 ? null : BoxFit.cover,
                            placeholder: NetworkImage(placeholder),
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      key: _buttonsAndInfoKey,
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Selfie met ' + image.assignment,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          _showButtonBar(model, context),
                        ],
                      ),
                    ),
                    _showImageInformation(model)
                  ],
                ),
        );
      },
    );
  }
}
