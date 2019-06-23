import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

class GameAdminSignUp extends StatelessWidget {
  final String code;
  final int participants;

  GameAdminSignUp(this.code, {this.participants: 1});

  
  ButtonBar _buildButtonRow(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.end,
      children: <Widget>[
        RaisedButton(
          color: Colors.white,
          child: Text("Deel code"),
          onPressed: () {
            share("Speel mee met SelfieTheGame! Spelcode is: " + code);
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Spelers melden zich aan via hun app',
          style: TextStyle(
            // fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Text("Aanmelden kan met de code: "),
        Text(
          code,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildButtonRow(context),
        Text("of door de QR code te scannen"),
        SizedBox(height: 10.0),
        QrImage(
          data: code,
          size: 150.0,
        ),
        Divider(),
        Text("Aantal aanmeldingen: "),
        Text(
          participants.toString(),
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
