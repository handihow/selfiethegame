import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../shared-widgets/ui_elements/side_drawer.dart';

class ProfilePage extends StatelessWidget {

  Widget _buildLogoutButton(BuildContext context, AppModel model) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        child: Text('LOG UIT'),
        onPressed: () {
          model.signOut();
          Navigator.pushReplacementNamed(context, '/');
        },
      ),
    );
  }

  Widget _avatarBuilder(model) {
    return Hero(
      tag: model.authenticatedUser.displayName,
      child: CircleAvatar(
        radius: 50.0,
        backgroundImage: NetworkImage(model.authenticatedUser.photoURL),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _profilePageWithAuthenticatedUser(BuildContext context, AppModel model) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          model.authenticatedUser.photoURL != null
              ? _avatarBuilder(model)
              : SizedBox(height: 0),
          Divider(),
          Text('Email adres'),
          Text(
            model.authenticatedUser.email,
            style: TextStyle(fontSize: 16.0),
          ),
          Divider(),
          Text('Naam'),
          Text(
            model.authenticatedUser.displayName,
            style: TextStyle(fontSize: 16.0),
          ),
          Divider(),
          Text('Unieke ID'),
          Text(
            model.authenticatedUser.uid,
            style: TextStyle(fontSize: 16.0),
          ),
          Divider(),
          Text('Authenticatie methode'),
          Text(
            model.authenticatedUser.authMethod.toString().split('.').last,
            style: TextStyle(fontSize: 16.0),
          ),
          _buildLogoutButton(context, model)
        ],
      ),
    );
  }

  Widget _loadingProfilePage(BuildContext context, AppModel model) {
    Widget profilePage;
    if (model.authenticatedUser != null) {
      profilePage = _profilePageWithAuthenticatedUser(context, model);
    } else {
      model.setAuthenticatedUser();
      profilePage = Center(
        child: Column(
          children: <Widget>[
            Text('no user info'),
            _buildLogoutButton(context, model),
          ],
        ),
      );
    }
    return profilePage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainSideDrawer(),
      appBar: AppBar(
        title: Text('Profiel'),
      ),
      body: ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
          return _loadingProfilePage(context, model);
        },
      ),
    );
  }
}
