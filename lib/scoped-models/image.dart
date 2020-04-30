import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/image.dart';
import '../models/reaction-type.dart';
import '../models/user.dart';
import '../models/reaction.dart';
import '../models/rating.dart';

mixin ImageModel on Model {
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<DocumentSnapshot> fetchImageReference(
      String assignmentId, String teamId) {
    return _db
        .collection('images')
        .document(assignmentId + '_' + teamId)
        .snapshots();
  }

  //fetch image references for a game
  Future<List<ImageRef>> fetchGameImageReferences(String gameId) async {
    List<ImageRef> imageReferences = [];
    await _db
        .collection('images')
        .where('gameId', isEqualTo: gameId)
        .orderBy('created', descending: true)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((DocumentSnapshot document) {
        final ImageRef _returnedImage = ImageRef.fromJson(document.data);
        imageReferences.add(_returnedImage);
      });
    }).catchError((err) {
      print("Error: " + err);
    });
    return imageReferences;
  }

  Future<List<ImageRef>> fetchTeamListImageReferences(String teamId) async {
    List<ImageRef> imageReferences = [];
    await _db
        .collection('images')
        .where('teamId', isEqualTo: teamId)
        .orderBy('created', descending: true)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((DocumentSnapshot document) {
        final ImageRef _returnedImage = ImageRef.fromJson(document.data);
        imageReferences.add(_returnedImage);
      });
    }).catchError((err) {
      print("Error: " + err);
    });
    return imageReferences;
  }

  //fetch image references for a team as stream
  Stream<QuerySnapshot> fetchTeamImageReferences(String teamId) {
    return _db
        .collection('images')
        .where('teamId', isEqualTo: teamId)
        .orderBy('created', descending: true)
        .snapshots();
  }

  //fetch image references for a user
  Stream<QuerySnapshot> fetchUserImageReferences(String userId) {
    return _db
        .collection('images')
        .where('userId', isEqualTo: userId)
        .orderBy('created', descending: true)
        .snapshots();
  }

  //update single image
  Future<void> updateImageReference(ImageRef image) {
    return _db
        .collection('images')
        .document(image.id)
        .setData(image.toJson(), merge: true);
  }

  Future<void> updateImageRotation(String imageId, String imageState) {
    return _db.collection('images').document(imageId).updateData(
      {
        'imageState': imageState,
        'updated': DateTime.now(),
      },
    );
  }

  //delete single image
  Future<void> deleteImage(ImageRef image) async {
    if(image.id == null){
      print('could not delete image with no id number');
      return false;
    }
    await _db.collection('images').document(image.id).delete();
    if(image.path != null){
      await _storage.ref().child(image.path).delete();
    }
    if(image.pathOriginal != null){
      await _storage.ref().child(image.pathOriginal).delete();
    }
    if(image.pathTN != null){
      await _storage.ref().child(image.pathTN).delete();
    }
    //delete any reactions that have been given to the image
    return _db
        .collection('reactions')
        .where('imageId', isEqualTo: image.id)
        .getDocuments()
        .then((snapshot) {
      if (snapshot.documents != null && snapshot.documents.length > 0) {
        final _batch = _db.batch();
        snapshot.documents.forEach((DocumentSnapshot document) {
          final DocumentReference _reactionRef =
              _db.collection('reactions').document(document.documentID);
          _batch.delete(_reactionRef);
        });
        _batch.commit();
      }
    });
  }

  Future<void> deleteAllUserImages(User user) async {
    _db
        .collection('images')
        .where('userId', isEqualTo: user.uid)
        .getDocuments()
           .then((snapshot) {
      if (snapshot.documents != null && snapshot.documents.length > 0) {
        snapshot.documents.forEach((DocumentSnapshot document) async {
          final ImageRef imageRef = ImageRef.fromJson(document.data);
          await deleteImage(imageRef);
        });
      }
    });
  }

  Stream<QuerySnapshot> getUserGameReactions(String gameId, String userId) {
    return _db
        .collection('reactions')
        .where('gameId', isEqualTo: gameId)
        .where('userId', isEqualTo: userId)
        .orderBy('created', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getImageReactions(String imageId) {
    return _db
        .collection('reactions')
        .where('imageId', isEqualTo: imageId)
        .orderBy('created', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getImageReactionsForReactionType(
      String imageId, ReactionType reactionType) {
    return _db
        .collection('reactions')
        .where('imageId', isEqualTo: imageId)
        .where('reactionType', isEqualTo: reactionType)
        .orderBy('created', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getTeamRatingReactions(String teamId) {
    return _db
        .collection('reactions')
        .where('teamId', isEqualTo: teamId)
        .where('reactionType', isEqualTo: ReactionType.rating.index)
        .snapshots();
  }

  Future<void> reactOnImage(ImageRef image, User user,
      ReactionType reactionType, String comment, Rating rating) {
    final Reaction reaction = Reaction(
      id: reactionType.index.toString() + '_' + image.id + '_' + user.uid,
      userDisplayName: user.displayName,
      userId: user.uid,
      imageId: image.id,
      created: DateTime.now(),
      updated: DateTime.now(),
      gameId: image.gameId,
      teamId: image.teamId,
      assignmentId: image.assignmentId,
      reactionType: reactionType,
      comment: reactionType == ReactionType.comment ? comment : null,
      rating: reactionType == ReactionType.rating ? rating : null,
      assignment: image.assignment,
      teamName: image.teamName,
    );
    return _db
        .collection('reactions')
        .document(reaction.id)
        .setData(reaction.toJson());
  }

  Future<void> updateAwardedPoints(String reactionId, int newRating) {
    return _db.collection('reactions').document(reactionId).updateData(
      {
        'rating': newRating,
        'updated': DateTime.now(),
      },
    );
  }

  void removeReactionFromImage(String reactionId) async {
    await _db.collection('reactions').document(reactionId).delete();
    return notifyListeners();
  }
}
