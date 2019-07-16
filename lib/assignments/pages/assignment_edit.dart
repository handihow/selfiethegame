import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../shared-widgets/helpers/ensure-visible.dart';
import 'package:random_string/random_string.dart';

import '../../scoped-models/main.dart';
import '../../models/assignment.dart';
import '../../models/rating.dart';

class AssignmentEditPage extends StatefulWidget {
  final String gameId;
  final Assignment assignment;
  final int order;

  AssignmentEditPage(this.gameId, {this.assignment, this.order});

  @override
  State<StatefulWidget> createState() {
    return _AssignmentEditPageState();
  }
}

class _AssignmentEditPageState extends State<AssignmentEditPage> {
  bool _isButtonDisabled = false;

  final Map<String, dynamic> _formData = {'assignment': null, 'maxPoints': 0, 'description': null, 'location': null};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _assignmentFocusNode = FocusNode();
  final _maxPointsFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();

  @override
  initState() {
    super.initState();
    setState(() {
      if (widget.assignment != null) {
        _formData['assignment'] = widget.assignment.assignment;
        _formData['maxPoints'] = widget.assignment.maxPoints;
      }
    });
  }

  Widget _buildAssignmentTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _assignmentFocusNode,
      child: ListTile(
        leading: Icon(Icons.edit),
        title: TextFormField(
            focusNode: _assignmentFocusNode,
            keyboardType: TextInputType.text,
            initialValue:
                widget.assignment == null ? null : widget.assignment.assignment,
            validator: (String value) {
              return value.isEmpty ? 'Opdracht is vereist.' : null;
            },
            decoration: InputDecoration(labelText: 'Opdracht'),
            onSaved: (String value) {
              _formData['assignment'] = value;
            }),
      ),
    );
  }

  Widget _buildRadioOptionsField() {
    return EnsureVisibleWhenFocused(
      focusNode: _maxPointsFocusNode,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Radio(
                value: Rating.easy,
                groupValue: _formData['maxPoints'],
                onChanged: (value) => _assignMaximumPoints(value),
              ),
              Text(
                'Makkelijk - 1 punt',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                value: Rating.medium,
                groupValue: _formData['maxPoints'],
                onChanged: (value) => _assignMaximumPoints(value),
              ),
              Text(
                'Gemiddeld - 3 punten',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Radio(
                value: Rating.hard,
                groupValue: _formData['maxPoints'],
                onChanged: (value) => _assignMaximumPoints(value),
              ),
              Text(
                'Moeilijk - 5 punten',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _assignMaximumPoints(Rating value) {
    setState(() {
      _formData['maxPoints'] = value;
    });
  }

  Widget _buildDescriptionTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: ListTile(
        leading: Icon(Icons.comment),
        title: TextFormField(
            focusNode: _descriptionFocusNode,
            keyboardType: TextInputType.multiline,
            maxLines: 2,
            initialValue:
                widget.assignment == null || widget.assignment.description == null ? null : widget.assignment.description,
            decoration: InputDecoration(labelText: 'Omschrijving'),
            onSaved: (String value) {
              _formData['description'] = value;
            }),
      ),
    );
  }

  Widget _buildLocationTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _locationFocusNode,
      child: ListTile(
        leading: Icon(Icons.location_on),
        title: TextFormField(
            focusNode: _locationFocusNode,
            keyboardType: TextInputType.text,
            initialValue:
                widget.assignment == null || widget.assignment.location == null ? null : widget.assignment.location,
            decoration: InputDecoration(labelText: 'Locatie'),
            onSaved: (String value) {
              _formData['location'] = value;
            }),
      ),
    );
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
    if (!_formKey.currentState.validate() || _formData['maxPoints'] == 0) {
      setState(() {
        _isButtonDisabled = false;
      });
      return;
    }
    _formKey.currentState.save();
    Assignment updatedAssignment = Assignment(
      id: widget.assignment == null
          ? randomAlphaNumeric(20)
          : widget.assignment.id,
      gameId: widget.gameId,
      maxPoints: _formData['maxPoints'] == 0 ? 3 : _formData['maxPoints'],
      created: widget.assignment == null
          ? DateTime.now()
          : widget.assignment.created,
      updated: DateTime.now(),
      assignment: _formData['assignment'],
      order: widget.assignment == null ? widget.order : widget.assignment.order,
      location: _formData['location'],
      description: _formData['description']
    );
    await model.updateGameStatus(widget.gameId, 'assigned', true);
    model.updateAssignment(updatedAssignment).then((_) {
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
                Text(
                  'Maak een selfie met...',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                _buildAssignmentTextField(),
                _buildRadioOptionsField(),
                _buildDescriptionTextField(),
                _buildLocationTextField(),
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
        title: widget.assignment == null
            ? Text('Nieuwe opdracht')
            : Text('Opdracht bewerken'),
      ),
      body: ScopedModelDescendant<AppModel>(
        builder: (BuildContext context, Widget child, AppModel model) {
          return _buildPageContent(context, model);
        },
      ),
    );
  }
}
