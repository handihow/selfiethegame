import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

import '../models/user.dart';
import '../models/contact-list.dart';

mixin UserModel on Model {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;
  PublishSubject loading = PublishSubject();

  User _authenticatedUser;

  //set the custom user data as the authenticated user in the app
  Future<void> setAuthenticatedUser() async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      loading.add(true);
      DocumentSnapshot userSnap =
          await _db.collection('users').document(user.uid).get();
      Map<String, dynamic> userData = userSnap.data;
      _authenticatedUser = User(
          uid: userData['uid'],
          email: userData['email'],
          authMethod: userData['authMethod'] != null
              ? AuthMethod.values[userData['authMethod']]
              : AuthMethod.unknown,
          displayName: userData['displayName'] != null
              ? userData['displayName']
              : 'Anoniem',
          photoURL: userData['photoURL'] != null ? userData['photoURL'] : null);
      loading.add(false);
    } else {
      _authenticatedUser = null;
    }
    notifyListeners();
    return;
  }

  //get the authenticated user
  User get authenticatedUser {
    if (_authenticatedUser == null) {
      return null;
    }
    return _authenticatedUser;
  }

  Future<FirebaseUser> registerWithEmailAndPassword(
      String email, String password, String displayName) async {
    loading.add(true);
    try {
      final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await updateUserData(user, AuthMethod.email, displayName);
      loading.add(false);
      print("signed in: " + user.email);
      return user;
    } catch (err) {
      print('registration unsuccessful');
      return null;
    }
  }

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    loading.add(true);
    try {
      final FirebaseUser user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await updateUserData(user, AuthMethod.email, null);
      loading.add(false);
      print("signed in: " + user.email);
      return user;
    } catch (err) {
      print('login unsuccessful');
      return null;
    }
  }

  Future<FirebaseUser> googleSignIn() async {
    loading.add(true);
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = await _auth.signInWithCredential(credential);
      await updateUserData(user, AuthMethod.google, null);
      loading.add(false);
      print("signed in " + user.displayName);
      return user;
    } catch (err) {
      print('login with google unsuccessful');
      return null;
    }
  }

  Future<FirebaseUser> facebookSignIn() async {
    loading.add(true);
    FacebookLoginResult result = await _facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        // final graphResponse = await http.get(
        //     'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
        // final profile = json.decode(graphResponse.body);
        // print(profile);
        AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: token);
        final FirebaseUser user =
            await FirebaseAuth.instance.signInWithCredential(credential);
        await updateUserData(user, AuthMethod.facebook, null);
        loading.add(false);
        print("signed in " + user.displayName);
        return user;
        break;
      case FacebookLoginStatus.cancelledByUser:
        loading.add(false);
        print('cancelled by user');
        break;
      case FacebookLoginStatus.error:
        loading.add(false);
        print(result.errorMessage);
        break;
    }
    return null;
  }

  Future<void> updateUserData(
      FirebaseUser user, AuthMethod method, String displayName) async {
    if (user == null) {
      return print('no user');
    }

    DocumentReference ref = _db.collection('users').document(user.uid);
    print(method);

    Map<String, dynamic> userData = {
      'uid': user.uid,
      'email': user.email,
      'lastSeen': DateTime.now(),
      'authMethod': method.index
    };

    if (user.photoUrl != null) {
      userData['photoURL'] = user.photoUrl;
    }

    if (user.displayName != null) {
      userData['displayName'] = user.displayName;
    }

    //register with email and password, we set the display name of the user
    if (displayName != null) {
      userData['displayName'] = displayName;
    }

    return ref.setData(userData, merge: true).then((doc) {
      _createContactList(user.uid);
    });
  }

  void _createContactList(String userId) async {
    final contactListRef = _db.collection('contacts').document(userId);
    final contactListSnap = await contactListRef.get();
    final contactListExists = contactListSnap.exists;
    print(contactListExists);
    if (!contactListExists) {
      _addContactList(userId);
      return print('creating contact list');
    } else {
      print('contact list already exists');
      return;
    }
  }

  //add contact list to the database
  Future<void> _addContactList(String userId) {
    ContactList newList = ContactList(
      count: 0,
      uid: userId,
      createdAt: DateTime.now(),
      contacts: [],
    );
    return _db
        .collection('contacts')
        .document(userId)
        .setData(newList.toJson());
  }

  void signOut() {
    _auth.signOut();
  }

  Future<String> getUserDisplayName(String userId) async {
    DocumentSnapshot userSnap =
        await _db.collection('users').document(userId).get();
    if (userSnap.exists) {
      return userSnap.data['displayName'];
    }
    return null;
  }
}
