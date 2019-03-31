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
  String _url =
      'https://via.placeholder.com/500x500.png?text=SelfieTheGame.com';

  @override
  void initState() {
    super.initState();
    if (widget.image != null) {
      StorageReference ref =
          FirebaseStorage.instance.ref().child(widget.image.path);
      ref.getDownloadURL().then((value) {
        setState(() {
          _url = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Scaffold(
          body: CustomScrollView(
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
                          onPressed: () async {
                            await model.deleteImage(widget.image);
                            Navigator.pop(context);
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
