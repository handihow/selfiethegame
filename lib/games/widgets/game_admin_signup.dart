import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GameAdminSignUp extends StatelessWidget {
  final String code;
  final int participants;

  GameAdminSignUp(this.code, {this.participants: 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Spelers kunnen zich aanmelden met de code: "),
        Text(
          code,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(),
        Text("Of scan om de code automatisch te vullen"),
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
