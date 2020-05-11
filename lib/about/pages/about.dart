import 'package:flutter/material.dart';
import '../../shared-widgets/ui_elements/side_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
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
            subtitle: Text('Version number 1.11'),
          ),
          ListTile(
            leading: Icon(
              Icons.copyright,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Maker'),
            subtitle: Text('Made by HandiHow'),
            trailing: IconButton(
              icon: Icon(
                Icons.info,
                color: Theme.of(context).primaryColor,
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
            subtitle: Text('Send your feedback to office@handihow.com'),
          ),
          ListTile(
            leading: Icon(
              Icons.school,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('How does it work?'),
            subtitle: Text('Opens web page with explanations'),
            trailing: IconButton(
              icon: Icon(
                Icons.info,
                color: Theme.of(context).primaryColor,
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
            subtitle: Text('Opens the privacy policy'),
            trailing: IconButton(
              icon: Icon(
                Icons.info,
                color: Theme.of(context).primaryColor,
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
            title: Text('Terms of Use'),
            subtitle: Text('Opens the Terms of Use'),
            trailing: IconButton(
              icon: Icon(
                Icons.info,
                color: Theme.of(context).primaryColor,
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
            title: Text('Frequently Asked Questions'),
            subtitle: Text('Opens the FAQ section on the website'),
            trailing: IconButton(
              icon: Icon(
                Icons.info,
                color: Theme.of(context).primaryColor,
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
