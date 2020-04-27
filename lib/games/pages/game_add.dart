import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:scoped_model/scoped_model.dart';
import "dart:math";

import '../../shared-widgets/helpers/ensure-visible.dart';
import '../../scoped-models/main.dart';
import '../../settings/settings.dart';

class GameAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameAddState();
  }
}

class _GameAddState extends State<GameAddPage> {
  final _random = new Random();
  bool _isButtonDisabled = false;

  final Map<String, dynamic> _formData = {
    'name': null,
    'date': DateTime.now(),
    'duration': null,
    'isPlaying': true,
    'image': ''
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _dateFocusNode = FocusNode();
  final _durationFocusNode = FocusNode();
  final _switchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _formData['name'] = GAME_NAMES[_random.nextInt(GAME_NAMES.length)];
    _formData['image'] = GAME_IMAGES[_random.nextInt(GAME_IMAGES.length)];
  }

  Widget _buildNameTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _nameFocusNode,
      child: ListTile(
        leading: Icon(Icons.edit),
        title: TextFormField(
            focusNode: _nameFocusNode,
            keyboardType: TextInputType.text,
            initialValue: _formData['name'],
            validator: (String value) {
              return value.isEmpty || value.length < 5
                  ? 'Game name is required and must have at least 5 letters.'
                  : null;
            },
            decoration: InputDecoration(labelText: 'Name of game'),
            onSaved: (String value) {
              _formData['name'] = value;
            }),
      ),
    );
  }

  Widget _buildDatepickerField() {
    return EnsureVisibleWhenFocused(
      focusNode: _dateFocusNode,
      child: ListTile(
        leading: Icon(Icons.today),
        title: DateTimeField(
          format: DateFormat("MM-dd-yyyy 'at' H:mm"),
          // initialValue: DateTime.now(),
          validator: (DateTime dt) {
            if (dt == null) {
              return 'Date and time of game are mandatory.';
            }
            final now = DateTime.now();
            if (dt.isBefore(now)) {
              return 'The date and time of the game must be in the future.';
            }
            return null;
          },
          onShowPicker: (context, currentValue) {
            return showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2030));
          },
          onSaved: (DateTime dt) {
            _formData['date'] = dt;
          },
        ),
      ),
    );
  }

  Widget _buildDurationField() {
    return EnsureVisibleWhenFocused(
      focusNode: _dateFocusNode,
      child: ListTile(
        leading: Icon(Icons.timer),
        title: TextFormField(
            focusNode: _durationFocusNode,
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            decoration:
                InputDecoration(labelText: 'How many minutes does the game last?'),
            onSaved: (String value) {
              if (value.isNotEmpty) {
                _formData['duration'] = int.parse(value);
              } else {
                _formData['duration'] = null;
              }
            }),
      ),
    );
  }

  Widget _buildCheckboxField() {
    return EnsureVisibleWhenFocused(
      focusNode: _switchFocusNode,
      child: ListTile(
        leading: Icon(Icons.face),
        title: CheckboxListTile(
          title: Text('I play along'),
          value: _formData['isPlaying'],
          onChanged: (bool value) {
            setState(() {
              _formData['isPlaying'] = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Center(
          child: RaisedButton(
            child: Text(_isButtonDisabled ? 'Saving...' : 'Save'),
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
      },
    );
  }

  Widget _buildPageContent(BuildContext context) {
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
                _buildNameTextField(),
                _buildDatepickerField(),
                _buildDurationField(),
                _buildCheckboxField(),
                SizedBox(height: 20.0),
                _buildSubmitButton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, AppModel model) async {
    if (!_formKey.currentState.validate()) {
      setState(() {
        _isButtonDisabled = false;
      });
      return;
    }
    _formKey.currentState.save();
    String gameId = await model.addGame(
        _formData['name'],
        _formData['date'],
        _formData['isPlaying'],
        _formData['image'],
        model.authenticatedUser,
        _formData['duration']);
    if (gameId != null) {
      await model.addChat(gameId, model.authenticatedUser.uid);
    }
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/games/' + gameId + '/admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New game'),
      ),
      body: _buildPageContent(context),
    );
  }
}
