import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './about/pages/about.dart';
import './auth/pages/auth.dart';
import './auth/pages/register.dart';
import './auth/pages/profile.dart';
import './auth/pages/loading.dart';

import './contacts/pages/contacts.dart';

import './games/pages/game_choose.dart';
import './games/pages/game_add.dart';
import './games/pages/games.dart';
import './games/pages/game_view.dart';
import './games/pages/game_admin.dart';
import './games/pages/game_register.dart';
import './images/pages/images_grid.dart';
import './scoped-models/main.dart';

import './assignments/pages/assignments.dart';
import './teams/pages/teams.dart';
import './chats/pages/chat.dart';
import './settings/settings.dart';

void main() => runApp(SelfieGameApp());

class SelfieGameApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelfieGameState();
  }
}

class _SelfieGameState extends State<SelfieGameApp> {


  Widget _loadingInitialScreen(AppModel model) {
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage();
          } else {
            if (snapshot.hasData) {
              if (model.authenticatedUser == null) {
                model.setAuthenticatedUser();
              }
              return GamesPage();
            }
            if (model.authenticatedUser != null) {
              model.setAuthenticatedUser();
            }
            return AuthPage();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: AppModel(),
      child: ScopedModelDescendant<AppModel>(
          builder: (BuildContext context, Widget child, AppModel model) {
        return MaterialApp(
          theme: ThemeData(
              primarySwatch: primaryColorShades,
              accentColor: accentColorShades,
              primaryColorLight: primaryColorShades[50],
              errorColor: Colors.red,
              buttonColor: Colors.amber),
          home: _loadingInitialScreen(model),
          routes: {
            '/register': (BuildContext context) => RegisterPage(),
            '/profile': (BuildContext context) => ProfilePage(),
            '/games': (BuildContext context) => GamesPage(),
            '/choose': (BuildContext context) => GameChoosePage(),
            '/new': (BuildContext context) => GameAddPage(),
            '/register-game': (BuildContext context) => GameRegisterPage(),
            '/images': (BuildContext context) => ImagesGridView(),
            '/about': (BuildContext context) => AboutPage(),
            '/contacts': (BuildContext context) => ContactsPage()
          },
          onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1] == 'games') {
              final String gameId = pathElements[2];
              if (pathElements[3] == 'admin') {
                return MaterialPageRoute<bool>(
                  builder: (BuildContext context) => GameAdminPage(gameId),
                );
              } else {
                return MaterialPageRoute<bool>(
                  builder: (BuildContext context) => GameViewPage(gameId),
                );
              }
            } else if(pathElements[1] == 'assignments') {
              final String gameId = pathElements[2];
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => AssignmentsPage(gameId),
              );
            } else if(pathElements[1] == 'teams') {
              final String gameId = pathElements[2];
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => TeamsPage(gameId),
              );
            } else if(pathElements[1] == 'chat') {
              final String gameId = pathElements[2];
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => ChatPage(gameId),
              );
            }
            return null; 
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
              builder: (BuildContext context) => GamesPage(),
            );
          },
        );
      }),
    );
  }
}
