import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_string/random_string.dart';

import '../models/game.dart';
import '../models/user.dart';
import '../settings/settings.dart';

mixin GameModel on Model {
  final Firestore _db = Firestore.instance;

  //fetch games where user is participating
  Stream<QuerySnapshot> fetchGames(User user) {
    return _db
        .collection('games')
        .where('participants', arrayContains: user.uid)
        .orderBy('created', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> fetchGame(String gameId) {
    return _db.collection('games').document(gameId).snapshots();
  }

  //add game to the database
  Future<String> addGame(String name, DateTime date, bool isPlaying,
      String image, User user) async {
    Game newGame = Game(
      id: randomAlphaNumeric(20),
      name: name,
      date: date,
      code: randomAlphaNumeric(6),
      created: DateTime.now(),
      updated: DateTime.now(),
      status: Status(
        created: true,
        finished: false,
        pauzed: false,
        invited: false,
        closedAdmin: false,
        judgesAssigned: false,
        assigned: false,
        teamsCreated: false,
        playing: false,
      ),
      administrator: user.uid,
      imageUrl: image,
    );
    await _db
        .collection('games')
        .document(newGame.id)
        .setData(newGame.toJson());
    await manageGameParticipants(user, newGame.id, 'participant', true);
    if (isPlaying) {
      await manageGameParticipants(user, newGame.id, 'player', true);
    }
    return newGame.id;
  }

  Future<String> manageGameParticipants(
      User user, String gameId, String userLevel, bool add) async {
    final String userVariable = USERLEVEL[userLevel]['userVariable'];
    final String gameVariable = USERLEVEL[userLevel]['gameVariable'];
    final DocumentReference userRef =
        _db.collection('users').document(user.uid);
    final DocumentReference gameRef = _db.collection('games').document(gameId);
    if (add) {
      await userRef.updateData({
        userVariable: FieldValue.arrayUnion([gameId])
      });
      await gameRef.updateData({
        gameVariable: FieldValue.arrayUnion([user.uid])
      });
    } else {
      await userRef.updateData({
        userVariable: FieldValue.arrayRemove([gameId])
      });
      await gameRef.updateData({
        gameVariable: FieldValue.arrayRemove([user.uid])
      });
    }
    String message;
    if (add) {
      message = user.displayName +
          " doet mee aan het spel als " +
          USERLEVEL[userLevel]['level'] +
          " !";
    } else {
      message = user.displayName +
          " is verwijderd van het spel als " +
          USERLEVEL[userLevel]['level'] +
          " !";
    }
    return message;
  }

  //register for a game with a code
  Future<bool> registerWithCode(String code, User user) async {
    bool _success = false;
    final _gameData = await _db
        .collection('games')
        .where('code', isEqualTo: code)
        .snapshots()
        .first;
    if (_gameData.documents.isNotEmpty) {
      String _gameId = _gameData.documents[0].documentID;
      await manageGameParticipants(user, _gameId, 'participant', true);
      await manageGameParticipants(user, _gameId, 'player', true);
      await updateGameStatus(_gameId, 'invited', true);
      _success = true;
    }
    return _success;
  }

  //fetch game participants
  Stream<QuerySnapshot> fetchGameParticipants(String gameId, String userLevel) {
    final String userVariable = USERLEVEL[userLevel]['userVariable'];
    return _db
        .collection('users')
        .where(userVariable, arrayContains: gameId)
        .orderBy('displayName')
        .snapshots();
  }

  Future<void> updateGameStatus(
      String gameId, String statusProperty, bool statusValue) {
    DocumentReference gameRef = _db.collection('games').document(gameId);
    return Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot gameSnapshot = await tx.get(gameRef);
      if (gameSnapshot.exists) {
        await tx.update(gameRef, {
          'status.$statusProperty': statusValue,
          'updated': DateTime.now(),
        });
      }
    });
  }
}
