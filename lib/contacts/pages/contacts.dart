import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/contact-list.dart';
import '../../shared-widgets/ui_elements/side_drawer.dart';

class ContactsPage extends StatelessWidget {
  _showWarningDialog(BuildContext context, AppModel model) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Contacten verwijderen"),
          content: Text(
              "Je wilt al jouw contacten verwijderen. Je kunt dit niet herstellen. Wil je doorgaan?"),
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).primaryColor,
              child: Text('ANNULEREN'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              textColor: Theme.of(context).errorColor,
              child: Text('VERWIJDEREN'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then(
      (bool isCanceled) async {
        if (!isCanceled) {
          await model.deleteAllUserContacts(model.authenticatedUser);
        }
      },
    );
  }

  Widget _buildContactsPage(BuildContext context, AppModel model) {
    Widget contactsPage;
    if (model.authenticatedUser != null) {
      contactsPage = Scaffold(
        drawer: MainSideDrawer(),
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showWarningDialog(context, model);
              },
            ),
          ],
          title: Text('Contacten'),
        ),
        body: _displayContactListTiles(context, model),
      );
    } else {
      model.setAuthenticatedUser();
      contactsPage = Scaffold(
        drawer: MainSideDrawer(),
        appBar: AppBar(
          title: Text('Contacten'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return contactsPage;
  }

  Widget _displayContactListTiles(BuildContext context, AppModel model) {
    return StreamBuilder(
        stream: model.getUserContacts(model.authenticatedUser),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData ||
              snapshot.data['contacts'].length == 0) {
            return Center(
              child: Text('Nog geen contacten'),
            );
          } else {
            List<Contact> returnedContacts = [];
            snapshot.data['contacts'].forEach((contact) {
              final Contact returnedContact = Contact(
                  email: contact['email'],
                  name: contact['name'],
                  photoURL: contact['photoURL']);
              returnedContacts.add(returnedContact);
            });
            returnedContacts.sort((a,b) => a.name.compareTo(b.name));
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: _createLeading(returnedContacts[index]),
                  title: Text(returnedContacts[index].name),
                  subtitle: Text(returnedContacts[index].email),
                );
              },
              itemCount: returnedContacts.length,
            );
          }
        });
  }

  _createLeading(Contact contact) {
    if (contact.photoURL != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(contact.photoURL),
        backgroundColor: Colors.transparent,
      );
    } else {
      return CircleAvatar(
        child: Text(
          contact.name[0].toUpperCase(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return _buildContactsPage(context, model);
      },
    );
  }
}
