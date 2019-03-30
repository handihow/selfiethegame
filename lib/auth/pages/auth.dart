import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../scoped-models/main.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {'email': null, 'password': null};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _loading = false;
  AppModel _model = AppModel();

  @override
  initState() {
    super.initState();
    _model.loading.listen((state) => setState(() => _loading = state));
  }

  Widget _buildUsernameTextField() {
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

  void _onSubmit(
      BuildContext context, Function signInWithEmailAndPassword) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    FocusScope.of(context).requestFocus(new FocusNode());
    _formKey.currentState.save();
    FirebaseUser user = await signInWithEmailAndPassword(
        _formData['email'], _formData['password']);
    if (user == null) {
      final snackBar = SnackBar(
        content: Text('Login niet succesvol'),
        action: SnackBarAction(
          label: 'Opnieuw',
          onPressed: () {
            _formKey.currentState.reset();
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Widget _buildEmailPasswordForm(
      BuildContext context, Function signInWithEmailAndPassword) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildUsernameTextField(),
          SizedBox(height: 10.0),
          _buildPasswordTextField(),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.signInAlt),
                SizedBox(width: 10.0),
                Text('INLOGGEN MET EMAIL'),
              ],
            ),
            onPressed: () => _onSubmit(context, signInWithEmailAndPassword),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationButton() {
    return RaisedButton(
      color: Colors.grey,
      textColor: Colors.white,
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.userPlus),
          SizedBox(width: 10.0),
          Text('REGISTREREN'),
        ],
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/register');
      },
    );
  }

  Widget _buildGoogleLoginButton(Function googleSignIn) {
    return RaisedButton(
      color: Colors.red,
      textColor: Colors.white,
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.google),
          SizedBox(width: 10.0),
          Text('INLOGGEN MET GOOGLE'),
        ],
      ),
      onPressed: () => googleSignIn(),
    );
  }

  Widget _buildFacebookLoginButton(Function facebookSignIn) {
    return RaisedButton(
      color: Colors.blue,
      textColor: Colors.white,
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.facebook),
          SizedBox(width: 10.0),
          Text('INLOGGEN MET FACEBOOK'),
        ],
      ),
      onPressed: () => facebookSignIn(),
    );
  }

  Widget _buildTwitterLoginButton() {
    return RaisedButton(
      color: Colors.lightBlue,
      textColor: Colors.white,
      child: Row(
        children: <Widget>[
          Icon(FontAwesomeIcons.twitter),
          SizedBox(width: 10.0),
          Text('INLOGGEN MET TWITTER'),
        ],
      ),
      onPressed: () {},
    );
  }

  Widget _buildLoginPage() {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return _loading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: targetWidth,
                    child: ScopedModelDescendant<AppModel>(
                      builder:
                          (BuildContext context, Widget child, AppModel model) {
                        return Column(
                          children: <Widget>[
                            Image.asset('assets/selfie_the_game_text.png'),
                            Divider(),
                            _buildEmailPasswordForm(
                                context, model.signInWithEmailAndPassword),
                            _buildRegistrationButton(),
                            Divider(),
                            _buildGoogleLoginButton(model.googleSignIn),
                            _buildFacebookLoginButton(model.facebookSignIn),
                            // _buildTwitterLoginButton(),
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
        title: Text('Login'),
      ),
      body: _loading ? CircularProgressIndicator() : _buildLoginPage(),
    );
  }
}
