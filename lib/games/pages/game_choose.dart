import 'package:flutter/material.dart';

class GameChoosePage extends StatelessWidget {

  Widget _buildNewGameOption(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text('Spel maken'),
            subtitle: Text('Jij wordt de beheerder van het spel'),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
                'Kies deze optie als je een nieuw spel wilt beginnen als beheerder.'),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
                'Andere spelers kunnen zich aanmelden voor het spel met de code die wordt gegenereerd.'),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text('Spel toevoegen'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/new');
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
            title: Text('Meespelen'),
            subtitle: Text('Je gaat meespelen met een bestaand spel'),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('Kies deze optie als je mee wilt doen aan een spel.'),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
                'Je kunt je dan aanmelden voor het spel met de code die je hebt ontvangen.'),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text('Registreer met code'),
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
        title: Text('Nieuw spel'),
      ),
      body: ListView(
        children: <Widget>[
          _buildNewGameOption(context),
          _buildRegisterGameOption(context)
        ],
      ),
    );
  }
}
