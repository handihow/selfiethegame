import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/image.dart';

class ImageViewer extends StatefulWidget {
  final ImageRef image;
  final String placeholder;

  ImageViewer(this.image, this.placeholder);

  @override
  State<StatefulWidget> createState() {
    return _ImageViewerState();
  }
}

class _ImageViewerState extends State<ImageViewer> {
  String _url;

  @override
  void initState() {
    super.initState();
    setState(() {
      _url = widget.placeholder;
    });
    StorageReference ref =
        FirebaseStorage.instance.ref().child(widget.image.path);
    ref.getDownloadURL().then((value) {
      setState(() {
        _url = value;
      });
    });
  }

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
          await model.deleteImage(widget.image);
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Scaffold(
          body: widget.image == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      expandedHeight: 256.0,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text('Team ' + widget.image.teamName),
                        background: Hero(
                          tag: widget.image.id,
                          child: FadeInImage(
                            image: NetworkImage(_url),
                            height: 500.0,
                            fit: BoxFit.cover,
                            placeholder: NetworkImage(widget.placeholder),
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            alignment: Alignment.center,
                            child: Text(
                              'Selfie met ' + widget.image.assignment,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                child: Text('BEWERKEN'),
                                onPressed: () {},
                              ),
                              RaisedButton(
                                color: Theme.of(context).errorColor,
                                textColor: Colors.white,
                                child: Text('VERWIJDEREN'),
                                onPressed: () {
                                  _showWarningDialog(context, model);
                                },
                              ),
                            ],
                          ),
                          // Container(
                          //   padding: EdgeInsets.all(10.0),
                          //   child: Column(
                          //     children: <Widget>[
                          //       Text('Likes: 3'),
                          //       Text('Comments: 4'),
                          //       Text('Total rating: 6'),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }
}
