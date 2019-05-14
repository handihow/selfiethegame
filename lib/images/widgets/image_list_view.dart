import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../scoped-models/main.dart';
import '../../models/image.dart';
import '../../models/game.dart';
import '../../models/reaction.dart';
import '../../models/reaction-type.dart';
import './image_thumbnail.dart';
import '../pages/image_viewer.dart';
import '../../shared-widgets/ui_elements/title_default.dart';
import './image_rating_buttons.dart';
import './image_like_comment_buttons.dart';

class ImageListView extends StatefulWidget {
  final Game game;
  ImageListView(this.game);

  @override
  State<StatefulWidget> createState() {
    return _ImageListViewState();
  }
}

class _ImageListViewState extends State<ImageListView> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  List<Widget> _buildCarouselList(
      BuildContext context, List<ImageRef> returnedImages, AppModel model) {
    return map<Widget>(
      returnedImages,
      (index, imageRef) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(children: <Widget>[
              GestureDetector(
                child: ImageThumbnail(imageRef, false, 500, 500),
                onDoubleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return ImageViewer(
                          imageRef,
                          'https://via.placeholder.com/500x500.png?text=SelfieTheGame.com',
                          false,
                          widget.game.judges
                                  .contains(model.authenticatedUser.uid) ||
                              widget.game.administrator ==
                                  model.authenticatedUser.uid);
                    }),
                  );
                },
              ),
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Color.fromARGB(150, 0, 0, 0),
                    //     Theme.of(context).primaryColor,
                    //   ],
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    // ),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 11.0, horizontal: 20.0),
                  child: Center(
                    child: Text(
                      returnedImages[index].teamName +
                          ' met ' +
                          returnedImages[index].assignment,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)
                    //     // Theme.of(context).primaryColor,
                    //     // Color.fromARGB(150, 0, 0, 0),
                    //   ],
                    //   begin: Alignment.bottomCenter,
                    //   end: Alignment.topCenter,
                    // ),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                  child: _buildButtonRow(context, model, returnedImages[index]),
                ),
              ),
            ]),
          ),
        );
      },
    ).toList();
  }

  Widget _buildButtonRow(
      BuildContext context, AppModel model, ImageRef imageRef) {
    if (widget.game.judges.contains(model.authenticatedUser.uid) ||
        widget.game.administrator == model.authenticatedUser.uid) {
      return ImageRatingButtons(imageRef);
    } else {
      return ImageLikeCommentButtons(imageRef);
    }
  }

  Widget _displayCarouselImages(
      BuildContext context, List<ImageRef> returnedImages, AppModel model) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TitleDefault('Selfies van alle teams'),
        ),
        CarouselSlider(
          items: _buildCarouselList(context, returnedImages, model),
          autoPlay: false,
          enlargeCenterPage: true,
          aspectRatio: 1.0,
          viewportFraction: 0.90,
          enableInfiniteScroll: false,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return StreamBuilder(
          stream: model.fetchGameImageReferences(widget.game.id),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return StreamBuilder(
                stream: model.getUserGameReactions(
                    widget.game.id, model.authenticatedUser.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> reactionSnap) {
                  if (reactionSnap.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    List<Reaction> returnedReactions = [];
                    List<ImageRef> returnedImages = [];
                    if (reactionSnap.hasData) {
                      reactionSnap.data.documents
                          .forEach((DocumentSnapshot reactionDoc) {
                        final String reactionId = reactionDoc.documentID;
                        final Map<String, dynamic> reactionData =
                            reactionDoc.data;
                        reactionData['id'] = reactionId;
                        returnedReactions.add(Reaction.fromJson(reactionData));
                      });
                    }
                    if (snapshot.hasData) {
                      snapshot.data.documents
                          .forEach((DocumentSnapshot document) {
                        final String imageId = document.documentID;
                        final Map<String, dynamic> imageData = document.data;
                        imageData['id'] = imageId;
                        final Reaction userLikeReaction =
                            returnedReactions.firstWhere(
                                (reaction) =>
                                    reaction.imageId == imageId &&
                                    reaction.reactionType == ReactionType.like,
                                orElse: () => null);
                        if (userLikeReaction != null) {
                          imageData['userLikeId'] = userLikeReaction.id;
                        }
                        final Reaction userRatingReaction =
                            returnedReactions.firstWhere(
                                (reaction) =>
                                    reaction.imageId == imageId &&
                                    reaction.reactionType ==
                                        ReactionType.rating,
                                orElse: () => null);
                        if (userRatingReaction != null) {
                          imageData['userRatingId'] = userRatingReaction.id;
                          imageData['userAwardedPoints'] =
                              userRatingReaction.rating.index;
                        }
                        final ImageRef returnedImage =
                            ImageRef.fromJson(imageData);
                        returnedImages.add(returnedImage);
                      });
                    }
                    return _displayCarouselImages(
                        context, returnedImages, model);
                  }
                },
              );
            }
          },
        );
      },
    );
  }
}
