import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/image.dart';
import '../models/reaction-type.dart';

mixin ImageModel on Model {
  final Firestore _db = Firestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<DocumentSnapshot> fetchImageReference(String assignmentId, String teamId){
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
  Future<void> updateImageReference(ImageRef image){
    return _db.collection('images').document(image.id).setData(image.toJson(), merge: true);
  }

 
  //delete single image
	Future<void> deleteImage(ImageRef image) async {
    print('deleting ' + image.path);
    await _storage.ref().child(image.path).delete();
    await _storage.ref().child(image.pathOriginal).delete();
    await _storage.ref().child(image.pathTN).delete();
		await _db.collection('images').document(image.id).delete();
	}

  Stream<QuerySnapshot> getUserGameReactions(String gameId, String userId){
    return _db
        .collection('images')
        .where('gameId', isEqualTo: gameId)
        .where('userId', isEqualTo: userId)
        .orderBy('created', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getImageReactions(String imageId){
    return _db
        .collection('reactions')
        .where('imageId', isEqualTo: imageId)
        .orderBy('created', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getImageReactionsForReactionType(String imageId, ReactionType reactionType){
    return _db
        .collection('reactions')
        .where('imageId', isEqualTo: imageId)
        .where('reactionType', isEqualTo: reactionType)
        .orderBy('created', descending: false)
        .snapshots();
  }

  

}
