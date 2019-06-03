import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/image.dart';
import '../models/reaction-type.dart';
import '../models/user.dart';
import '../models/reaction.dart';
import '../models/rating.dart';
import 'package:random_string/random_string.dart';

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
  Stream<QuerySnapshot> fetchGameImageReferences(String gameId) {
    return _db
        .collection('images')
        .where('gameId', isEqualTo: gameId)
        .orderBy('created', descending: true)
        .snapshots();
  }

  //fetch image references for a team
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

  //delete single image
  Future<void> deleteImage(ImageRef image) async {
    print('deleting ' + image.path);
    await _db.collection('images').document(image.id).delete();
    await _storage.ref().child(image.path).delete();
    await _storage.ref().child(image.pathOriginal).delete();
    return _storage.ref().child(image.pathTN).delete();
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
