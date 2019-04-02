import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../images/widgets/image_thumbnail.dart';

import '../../scoped-models/main.dart';
import '../../models/image.dart';

class ImageListView extends StatefulWidget {
  final String gameId;
  ImageListView(this.gameId);

  @override
  State<StatefulWidget> createState() {
    return _ImageListViewState();
  }
}

Widget _buildCarousel(List<ImageRef> returnedImages) {
  return CarouselSlider(
    height: 380.0,
    items: returnedImages.map((imageRef) {
      return Builder(builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment(0.0, -1.0),
              child: Text(imageRef.teamName + ' met ' + imageRef.assignment,
                  style: Theme.of(context).textTheme.subhead),
            ),
            ImageThumbnail(imageRef, false, 500.0, 500.0),
          ],
        );
      });
    }).toList(),
  );
}

class _ImageListViewState extends State<ImageListView> {
  Widget _displayListImages(
      BuildContext context, AppModel model, List<ImageRef> returnedImages) {
    return Column(
      children: [
        _buildCarousel(returnedImages),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.thumb_up),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.comment),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.assessment),
            ),
          ],
        )
      ],
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
            return _displayListImages(context, model, returnedImages);
          }
        },
      );
    });
  }
}
