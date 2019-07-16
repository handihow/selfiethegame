import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../shared-widgets/helpers/ensure-visible.dart';
import 'package:random_string/random_string.dart';
import "dart:math";

import '../../scoped-models/main.dart';
import '../../models/team.dart';
import '../../models/hexcolor.dart';
import '../../settings/settings.dart';

class TeamEditPage extends StatefulWidget {
  final String gameId;
  final Team team;
  final int order;

  TeamEditPage(this.gameId, {this.team, this.order});

  @override
  State<StatefulWidget> createState() {
    return _TeamEditPageState();
  }
}

class _TeamEditPageState extends State<TeamEditPage> {
  bool _isButtonDisabled = false;
  final _random = new Random();

  final Map<String, dynamic> _formData = {'name': null, 'color': null};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _colorFocusNode = FocusNode();

  @override
  initState() {
    super.initState();
    setState(() {
      if (widget.team != null) {
        _formData['name'] = widget.team.name;
        _formData['color'] = widget.team.color;
      } else {
        _formData['color'] =
            TEAM_COLORS[_random.nextInt(TEAM_COLORS.length)]['color'];
      }
    });
  }

  Widget _buildTeamNameTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _nameFocusNode,
      child: ListTile(
        leading: Icon(Icons.edit),
        title: TextFormField(
            focusNode: _nameFocusNode,
            keyboardType: TextInputType.text,
            initialValue: widget.team == null ? null : widget.team.name,
            validator: (String value) {
              return value.isEmpty ? 'Team naam is verplicht' : null;
            },
            decoration: InputDecoration(labelText: 'Team naam'),
            onSaved: (String value) {
              _formData['name'] = value;
            }),
      ),
    );
  }

  Widget _buildDropdownField() {
    return EnsureVisibleWhenFocused(
      focusNode: _colorFocusNode,
      child: ListTile(
        leading: Icon(
          Icons.colorize,
          color: HexColor(_formData['color']),
        ),
        title: DropdownButton<String>(
          isExpanded: true,
          value: _formData['color'],
          items: TEAM_COLORS.map((Map<String, dynamic> color) {
            return DropdownMenuItem<String>(
              value: color['color'],
              child: Text(color['colorLabel']),
            );
          }).toList(),
          onChanged: _handleColorChange,
        ),
      ),
    );
  }

  _handleColorChange(String color) {
    setState(() {
      _formData['color'] = color;
    });
  }

  Widget _buildSubmitButton(BuildContext context, AppModel model) {
    return Center(
      child: RaisedButton(
        child: Text(_isButtonDisabled ? 'Bewaren...' : 'Bewaar'),
        onPressed: _isButtonDisabled
            ? null
            : () {
                setState(() {
                  _isButtonDisabled = true;
                });
                _submitForm(context, model);
              },
      ),
    );
  }

  void _submitForm(BuildContext context, AppModel model) async {
    if (!_formKey.currentState.validate() || _formData['color'] == null) {
      setState(() {
        _isButtonDisabled = false;
      });
      return;
    }
    _formKey.currentState.save();
    Team updatedTeam = Team(
        id: widget.team == null ? randomAlphaNumeric(20) : widget.team.id,
        name: _formData['name'],
        color: _formData['color'],
        gameId: widget.gameId,
        members: widget.team == null ? [] : widget.team.members,
        order: widget.team == null ? widget.order : widget.team.order,
        progress: 0,
        rating: 0);
    await model.updateGameStatus(widget.gameId, 'teamsCreated', true);
    model.updateTeam(updatedTeam).then((_) {
      Navigator.pop(context);
    });
  }

  Widget _buildPageContent(BuildContext context, AppModel model) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return Container(
      alignment: Alignment(0.0, 0.0),
      margin: EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
              children: <Widget>[
                _buildTeamNameTextField(),
                _buildDropdownField(),
                SizedBox(height: 20.0),
                _buildSubmitButton(context, model)
              ],
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
        title: widget.team == null ? Text('Nieuw team') : Text('Team bewerken'),
      ),
      body: ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
          return _buildPageContent(context, model);
        },
      ),
    );
  }
}
