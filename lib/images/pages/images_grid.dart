import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:selfiespel_mobile/images/widgets/rotated_image.dart';

import '../../scoped-models/main.dart';
import '../../models/image.dart';
import '../pages/image_viewer.dart';
import '../../shared-widgets/ui_elements/side_drawer.dart';

class ImagesGridView extends StatelessWidget {
  ImagesGridView();

    _showWarningDialog(BuildContext context, AppModel model) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove selfies"),
          content: Text("You want to remove all your selfies. You cannot undo this. Do you want to continue?"),
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
          await model.deleteAllUserImages(model.authenticatedUser);
        }
      },
    );
  }

  Widget _buildImagesPage(BuildContext context, AppModel model) {
    Widget imagesPage;
    if (model.authenticatedUser != null) {
      imagesPage = Scaffold(
        drawer: MainSideDrawer(),
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showWarningDialog(context, model);
              },
            ),
          ],
          title: Text('Your Selfies'),
        ),
        body: _displayGridOfImages(context, model),
      );
    } else {
      model.setAuthenticatedUser();
      imagesPage = Scaffold(
        drawer: MainSideDrawer(),
        appBar: AppBar(
          title: Text('Your Selfies'),
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
              child: Text('No selfies yet'),
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
              crossAxisCount: 2,
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
                  child: RotatedImage(returnedImages[index], 500, false),
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
