import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../scoped-models/main.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final Map<String, dynamic> _formData = {
    'displayName': null,
    'email': null,
    'password': null,
    'confirm': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();

  Widget _buildNameTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Vul je naam in';
        }
      },
      decoration: InputDecoration(
          labelText: 'Volledige naam', filled: true, fillColor: Colors.white),
      onSaved: (String value) {
        _formData['displayName'] = value;
      },
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        RegExp regex = RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");
        if (value.isEmpty || !regex.hasMatch(value)) {
          return 'Voer een geldig email adres in';
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: 'Email', filled: true, fillColor: Colors.white),
      onSaved: (String value) {
        _formData['email'] = value.trim().toLowerCase();
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 8) {
          return 'Wachtwoord ongeldig. Minimaal 8 tekens.';
        }
      },
      decoration: InputDecoration(
          labelText: 'Wachtwoord', filled: true, fillColor: Colors.white),
      obscureText: true,
      onSaved: (String value) {
        _formData['password'] = value.trim();
      },
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Wachtwoord is niet hetzelfde';
        }
      },
      decoration: InputDecoration(
          labelText: 'Herhaal wachtwoord',
          filled: true,
          fillColor: Colors.white),
      obscureText: true,
      onSaved: (String value) {
        _formData['confirm'] = value.trim();
      },
    );
  }

  void _onSubmit(
      BuildContext context, Function registerWithEmailAndPassword) async {
    if (!_formKey.currentState.validate()) {
      return;
    } else if (!_formData['acceptTerms']) {
      final snackBar = SnackBar(
        content: Text('Accepteer de voorwaarden'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      _formKey.currentState.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      FirebaseUser user = await registerWithEmailAndPassword(
          _formData['email'], _formData['password'], _formData['displayName']);
      if (user == null) {
        final snackBar = SnackBar(
          content: Text('Registratie niet succesvol'),
          action: SnackBarAction(
            label: 'Opnieuw',
            onPressed: () {
              _formKey.currentState.reset();
            },
          ),
        );
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accepteer voorwaarden'),
    );
  }

  Widget _buildRegistrationForm(
      BuildContext context, Function registerWithEmailAndPassword) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildNameTextField(),
          SizedBox(height: 10.0),
          _buildEmailTextField(),
          SizedBox(height: 10.0),
          _buildPasswordTextField(),
          SizedBox(height: 10.0),
          _buildConfirmPasswordTextField(),
          SizedBox(height: 10.0),
          _buildAcceptSwitch(),
          SizedBox(height: 10.0),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.signInAlt),
                SizedBox(width: 10.0),
                Text('REGISTREREN'),
              ],
            ),
            onPressed: () => _onSubmit(context, registerWithEmailAndPassword),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationPage() {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return Center(
      child: Container(
        padding: EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: ScopedModelDescendant<AppModel>(
                builder: (BuildContext context, Widget child, AppModel model) {
                  return Column(
                    children: <Widget>[
                      Image.asset('assets/selfie_the_game_text.png'),
                      Divider(),
                      _buildRegistrationForm(
                          context, model.registerWithEmailAndPassword)
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registreren'),
      ),
      body: _buildRegistrationPage(),
    );
  }
}
