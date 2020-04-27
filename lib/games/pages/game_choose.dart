import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GameChoosePage extends StatelessWidget {

  _launchURL(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final snackBar = SnackBar(
        content: Text('Could not open this url: $url'),
        action: SnackBarAction(
          label: 'Again',
          onPressed: () {
            _launchURL(context, url);
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Widget _buildNewGameOption(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text('Create game'),
            subtitle: Text('You will be the administrator of the game'),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
                'You start a new game in administration mode. Go to the website www.selfiethegame.com to create a game! For optimal experience, use a computer for this.'),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              color: Theme.of(context).accentColor,
              // textColor: Colors.white,
              child: Text('Open website'),
              onPressed: () {
                _launchURL(context, 'https://selfiethegame.com');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterGameOption(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text('Play a game'),
            subtitle: Text('Register for a game'),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('You are going to play with an existing game. Push the button below to scan a QR code or enter a game code.'),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text('Play along'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/register-game');
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New game'),
      ),
      body: ListView(
        children: <Widget>[
          _buildRegisterGameOption(context),
          _buildNewGameOption(context)
        ],
      ),
    );
  }
}
