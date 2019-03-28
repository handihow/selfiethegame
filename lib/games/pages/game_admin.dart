import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/game.dart';

import '../widgets/game_admin_signup.dart';
import '../../assignments/widgets/game_admin_assignments.dart';
import '../widgets/game_admin_jurymembers.dart';
import '../../teams/widgets/game_admin_teams.dart';

class GameAdminPage extends StatefulWidget {
  final String gameId;
  GameAdminPage(this.gameId);

  @override
  _GameAdminPageState createState() => _GameAdminPageState();
}

class _GameAdminPageState extends State<GameAdminPage> {
  int _currentStep = 0;

  List<Step> _mySteps(Game game) {
    return [
      Step(
          title: Text('Aanmelden'),
          content: GameAdminSignUp(
            game.code,
            participants: game.participants.length,
          ),
          state: game.status.invited ? StepState.complete : StepState.indexed),
      Step(
          title: Text('Opdrachten'),
          content: GameAdminAssignments(game.id),
          state: game.status.assigned ? StepState.complete : StepState.indexed),
      Step(
          title: Text('Juryleden'),
          content: GameAdminJuryMembers(game),
          state: game.status.judgesAssigned
              ? StepState.complete
              : StepState.indexed),
      Step(
          title: Text('Teams'),
          content: GameAdminTeams(game),
          state: game.status.teamsCreated
              ? StepState.complete
              : StepState.indexed),
      Step(
          title: Text('Klaar'),
          content: Text('step 3'),
          state: StepState.indexed),
    ];
  }

  Widget _buildAdminStepper(BuildContext context, Game game) {
    return Stepper(
      currentStep: this._currentStep,
      onStepTapped: (step) {
        setState(() {
          _currentStep = step;
        });
      },
      onStepCancel: () {
        setState(() {
          if (_currentStep > 0) {
            _currentStep = _currentStep - 1;
          } else {
            _currentStep = 0;
          }
        });
      },
      onStepContinue: () {
        setState(() {
          if (_currentStep < 4) {
            _currentStep = _currentStep + 1;
          } else {
            _currentStep = 0;
          }
        });
      },
      type: StepperType.vertical,
      steps: _mySteps(game),
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Row(
          children: <Widget>[
            Container(
              child: null,
            ),
            Container(
              child: null,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beheer spel'),
      ),
      body: ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
          return StreamBuilder(
            stream: model.fetchGame(widget.gameId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              } else if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final Map<String, dynamic> gameData = snapshot.data.data;
                gameData['id'] = widget.gameId;
                final Game _game = Game.fromJson(gameData);
                return _buildAdminStepper(context, _game);
              }
            },
          );
        },
      ),
    );
  }
}
