import 'package:flutter/material.dart';
import '../../shared-widgets/ui_elements/side_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  _launchURL(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final snackBar = SnackBar(
        content: Text('Kon deze url niet openen: $url'),
        action: SnackBarAction(
          label: 'Opnieuw',
          onPressed: () {
            _launchURL(context, url);
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainSideDrawer(),
      appBar: AppBar(
        title: Text('Over SelfieTheGame'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('SelfieTheGame'),
            subtitle: Text('Versie nummer 1.06'),
          ),
          ListTile(
            leading: Icon(
              Icons.copyright,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Maker'),
            subtitle: Text('Gemaakt door HandiHow'),
            trailing: IconButton(
              icon: Icon(
                Icons.info,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                _launchURL(context, 'https://handihow.com');
              },
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.feedback,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Feedback'),
            subtitle: Text('Stuur feedback naar office@handihow.com'),
          ),
          ListTile(
            leading: Icon(
              Icons.school,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Hoe werkt het?'),
            subtitle: Text('Open webpagina met uitleg'),
            trailing: IconButton(
              icon: Icon(
                Icons.info,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                _launchURL(context, 'https://selfiethegame.com/info');
              },
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.security,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Privacy'),
            subtitle: Text('Open het privacybeleid'),
            trailing: IconButton(
              icon: Icon(
                Icons.info,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                _launchURL(context, 'https://selfiethegame.com/privacy');
              },
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Gebruiksvoorwaarden'),
            subtitle: Text('Open de gebruiksvoorwaarden'),
            trailing: IconButton(
              icon: Icon(
                Icons.info,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                _launchURL(context, 'https://selfiethegame.com/tos');
              },
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.question_answer,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Veelgestelde vragen'),
            subtitle: Text('Open de veelgestelde vragen'),
            trailing: IconButton(
              icon: Icon(
                Icons.info,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                _launchURL(context, 'https://selfiethegame.com/faq');
              },
            ),
          ),
        ],
      ),
    );
  }
}
