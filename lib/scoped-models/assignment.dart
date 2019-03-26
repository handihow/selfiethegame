import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/assignment.dart';

mixin AssignmentModel on Model {
  final Firestore _db = Firestore.instance;

  Future<void> addAssignments(String gameId, List<Assignment> assignments){
    final WriteBatch batch = _db.batch();
    assignments.forEach((assignment){
      final assignmentRef = _db.collection('assignments').document(assignment.id);
      batch.setData(assignmentRef, assignment.toJson());
    });
    return batch.commit();
  }

  Future<void> addAssignment(Assignment assignment){
    return _db.collection('assignments').add(assignment.toJson());
  }


  Stream<DocumentSnapshot> fetchAssignment(String assignmentId){
    return _db
      .collection('assignments')
      .document(assignmentId)
      .snapshots();
  }

   //fetch assignments for a game
  Stream<QuerySnapshot> fetchAssignments(String gameId) {
    return _db
        .collection('assignments')
        .where('gameId', isEqualTo: gameId)
        .orderBy('order')
        .snapshots();
  }

  //update single assignment
  Future<void> updateAssignment(Assignment assignment){
    return _db.collection('assignments').document(assignment.id).setData(assignment.toJson(), merge: true);
  }

  //update multiple assignments
  Future<void> updateAssignments(String gameId, List<Assignment> assignments){
    final WriteBatch batch = _db.batch();
    assignments.forEach((assignment){
      final assignmentRef = _db.collection('assignments').document(assignment.id);
      batch.setData(assignmentRef, assignment.toJson(), merge: true);
    });
    return batch.commit();
  }

  //delete single assignment
	Future<void> deleteAssignment(Assignment assignment){
		return _db.collection('assignments').document(assignment.id)
			.delete();
	}

  //delete multiple assignments
  Future<void> deleteAssignments(String gameId) async {
    final QuerySnapshot assignmentSnaps = await fetchAssignments(gameId).first;
    final WriteBatch batch = _db.batch();
    assignmentSnaps.documents.forEach((assignmentSnap){
      final assignmentRef = _db.collection('assignments').document(assignmentSnap.documentID);
      batch.delete(assignmentRef);
    });
    return batch.commit();
  }

}
