import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/image.dart';

class ImageThumbnail extends StatefulWidget {
  final ImageRef image;
  final bool isThumbnail;
  final double height;
  final double width;
  ImageThumbnail(this.image, this.isThumbnail, this.height, this.width);

  @override
  State<StatefulWidget> createState() {
    return _ImageThumbnailState();
  }
}

class _ImageThumbnailState extends State<ImageThumbnail> {
  String _url = 'https://via.placeholder.com/80x80.png?text=processing..';

  initState() {
    super.initState();
    StorageReference ref =
        FirebaseStorage.instance.ref().child(widget.isThumbnail ? widget.image.pathTN : widget.image.path);
    ref.getDownloadURL().then((value) {
      setState(() {
        _url = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      child: Image(
        image: NetworkImage(_url),
        height: widget.height,
        width: widget.width,
        fit: BoxFit.fitWidth,
      ),
      tag: widget.image.id,
    );
  }
}
