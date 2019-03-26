import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../shared-widgets/ui_elements/side_drawer.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  bool _loading = false;
  AppModel _model = AppModel();

  @override
  initState() {
    super.initState();
    _model.loading.listen((state) => setState(() => _loading = state));
  }
  

  Widget _buildLogoutButton(AppModel model) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
         RaisedButton(
          child: Text('BEWERK'),
          onPressed: () {},
        ),
        RaisedButton(
          color: Theme.of(context).errorColor,
          textColor: Colors.white,
          child: Text('LOG UIT'),
          onPressed: () {
             model.signOut();
             Navigator.pushReplacementNamed(context, '/');
          },
        )
      ],
    );
  }

  Widget _avatarBuilder(model) {
    return Center(
      child: CircleAvatar(
        radius: 30.0,
        backgroundImage: NetworkImage(model.authenticatedUser.photoURL),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _profilePageWithAuthenticatedUser(model) {
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
          _buildLogoutButton(model)
        ],
      ),
    );
  }

  Widget _loadingProfilePage(AppModel model) {
    Widget profilePage;
    if (model.authenticatedUser != null) {
      if (_loading) {
        profilePage = Center(
          child: CircularProgressIndicator(),
        );
      } else {
        profilePage = _profilePageWithAuthenticatedUser(model);
      }
    } else {
      model.setAuthenticatedUser();
      profilePage = Center(
        child: Column(
          children: <Widget>[
            Text('no user info'),
            _buildLogoutButton(model),
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
          return _loadingProfilePage(model);
        },
      ),
    );
  }
}
