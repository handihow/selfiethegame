import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/team.dart';

mixin TeamModel on Model {
  final Firestore _db = Firestore.instance;

  Future<void> addTeams(String gameId, List<Team> teams){
    final WriteBatch batch = _db.batch();
    teams.forEach((team){
      final teamRef = _db.collection('teams').document(team.id);
      batch.setData(teamRef, team.toJson());
    });
    return batch.commit();
  }

  Future<void> addTeam(Team team){
    return _db.collection('teams').add(team.toJson());
  }

  Future<Team> fetchTeam(String gameId, String userId) async {
    QuerySnapshot teamSnaps = await _db
      .collection('teams')
      .where('gameId', isEqualTo: gameId).where('members', arrayContains: userId)
      .snapshots().first;
    if(teamSnaps.documents.isEmpty){
      return null;
    }
    final Map<String, dynamic> teamData = teamSnaps.documents[0].data;
    teamData['id'] = teamSnaps.documents[0].documentID;
    final Team team = Team.fromJson(teamData);
    return team;
  }

   //fetch teams for a game
  Stream<QuerySnapshot> fetchTeams(String gameId) {
    return _db
        .collection('teams')
        .where('gameId', isEqualTo: gameId)
        .orderBy('rating', descending: true)
        .orderBy('order')
        .snapshots();
  }

  //update single team
  Future<void> updateTeam(Team team){
    return _db.collection('teams').document(team.id).setData(team.toJson(), merge: true);
  }

  //update multiple teams
  Future<void> updateTeams(String gameId, List<Team> teams){
    final WriteBatch batch = _db.batch();
    teams.forEach((team){
      final teamRef = _db.collection('teams').document(team.id);
      batch.updateData(teamRef, {'members': team.toJson()['members']});
    });
    return batch.commit();
  }

  //delete single team
	Future<void> deleteTeam(Team team){
		return _db.collection('teams').document(team.id)
			.delete();
	}

  //delete multiple teams
  Future<void> deleteTeams(String gameId) async {
    final QuerySnapshot teamSnaps = await fetchTeams(gameId).first;
    final WriteBatch batch = _db.batch();
    teamSnaps.documents.forEach((teamSnap){
      final teamRef = _db.collection('teams').document(teamSnap.documentID);
      batch.delete(teamRef);
    });
    return batch.commit();
  }

}
