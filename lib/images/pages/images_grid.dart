import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/image.dart';
import '../widgets/image_thumbnail.dart';
import '../pages/image_viewer.dart';
import '../../shared-widgets/ui_elements/side_drawer.dart';

class ImagesGridView extends StatelessWidget {
  ImagesGridView();

  Widget _buildImagesPage(BuildContext context, AppModel model) {
    Widget imagesPage;
    if (model.authenticatedUser != null) {
      imagesPage = Scaffold(
        drawer: MainSideDrawer(),
        appBar: AppBar(
          title: Text('Jouw Selfies'),
        ),
        body: _displayGridOfImages(context, model),
      );
    } else {
      model.setAuthenticatedUser();
      imagesPage = Scaffold(
        drawer: MainSideDrawer(),
        appBar: AppBar(
          title: Text('Jouw Selfies'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return imagesPage;
  }

  Widget _displayGridOfImages(BuildContext context, AppModel model) {
    return StreamBuilder(
        stream: model.fetchUserImageReferences(model.authenticatedUser.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data.documents.length == 0) {
            return Center(
              child: Text('Nog geen selfies'),
            );
          } else {
            List<ImageRef> returnedImages = [];

            snapshot.data.documents.forEach((DocumentSnapshot document) {
              final String imageId = document.documentID;
              final Map<String, dynamic> imageData = document.data;
              imageData['id'] = imageId;

              final ImageRef returnedImage = ImageRef.fromJson(imageData);
              returnedImages.add(returnedImage);
            });
            return GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this would produce 2 rows.
              crossAxisCount: 2,
              // Generate 100 Widgets that display their index in the List
              children: List.generate(returnedImages.length, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return ImageViewer(
                            returnedImages[index], false, false, true);
                      }),
                    );
                  },
                  child: ImageThumbnail(returnedImages[index], false, 500, 500),
                );
              }),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return _buildImagesPage(context, model);
      },
    );
  }
}
