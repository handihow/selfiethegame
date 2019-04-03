import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../scoped-models/main.dart';
import '../../models/image.dart';
import './image_thumbnail.dart';
import '../pages/image_viewer.dart';

class ImageListView extends StatefulWidget {
  final String gameId;
  ImageListView(this.gameId);

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
                      return ImageViewer(imageRef,
                          'https://via.placeholder.com/500x500.png?text=SelfieTheGame.com');
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
                    //     Theme.of(context).accentColor,
                    //   ],
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    // ),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 11.0, horizontal: 20.0),
                  child: Text(
                    returnedImages[index].teamName +
                        ' met ' +
                        returnedImages[index].assignment,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
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
                    //     Color.fromARGB(150, 0, 0, 0),
                    //     Theme.of(context).accentColor,
                    //   ],
                    //   begin: Alignment.bottomCenter,
                    //   end: Alignment.topCenter,
                    // ),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                  child: _buildButtonRow(context, model),
                ),
              ),
            ]),
          ),
        );
      },
    ).toList();
  }

  Widget _buildButtonRow(BuildContext context, AppModel model) {
    return Row(
      // alignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.thumb_up),
          onPressed: () {},
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.comment),
          onPressed: () {},
        ),
        IconButton(
          color: Colors.white,
          icon: Icon(Icons.assessment),
          onPressed: () {},
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }

  Widget _displayCarouselImages(
      BuildContext context, List<ImageRef> returnedImages, AppModel model) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Selfies van alle teams',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        CarouselSlider(
          items: _buildCarouselList(context, returnedImages, model),
          autoPlay: false,
          enlargeCenterPage: true,
          aspectRatio: 1.0,
        ),
      ],
    );
  }

  Widget _buildImageViewerPage(
      BuildContext context, List<ImageRef> returnedImages, AppModel model) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
      ),
      child: ListView(
        children: <Widget>[
          _displayCarouselImages(context, returnedImages, model),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
      return StreamBuilder(
        stream: model.fetchGameImageReferences(widget.gameId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<ImageRef> returnedImages = [];
            if (snapshot.hasData) {
              snapshot.data.documents.forEach((DocumentSnapshot document) {
                final String imageId = document.documentID;
                final Map<String, dynamic> imageData = document.data;
                imageData['id'] = imageId;
                final ImageRef returnedImage = ImageRef.fromJson(imageData);
                returnedImages.add(returnedImage);
              });
            }
            return _buildImageViewerPage(context, returnedImages, model);
          }
        },
      );
    });
  }
}
