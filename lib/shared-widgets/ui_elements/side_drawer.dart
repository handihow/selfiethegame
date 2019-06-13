import 'package:flutter/material.dart';

class MainSideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Menu'),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Spellen'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/games');
            },
          ),
          ListTile(
            leading: Icon(Icons.face),
            title: Text('Profiel'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('Selfies'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/images');
            },
          ),
          ListTile(
            leading: Icon(Icons.contacts),
            title: Text('Contacten'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/contacts');
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Info'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/about');
            },
          )
        ],
      ),
    );
  }
}
