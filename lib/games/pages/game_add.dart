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
                  ? 'Naam spel is vereist en moet minimaal 5 letters hebben.'
                  : null;
            },
            decoration: InputDecoration(labelText: 'Naam spel'),
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
          format: DateFormat("dd-MM-yyyy 'om' H:mm"),
          // initialValue: DateTime.now(),
          validator: (DateTime dt) {
            if (dt == null) {
              return 'Datum en tijd spel is verplicht.';
            }
            final now = DateTime.now();
            if (dt.isBefore(now)) {
              return 'Datum en tijd van het spel moet in de toekomst liggen.';
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
                InputDecoration(labelText: 'Hoeveel minuten duurt het spel?'),
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
          title: Text('Ik speel mee'),
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
        title: Text('Nieuw spel'),
      ),
      body: _buildPageContent(context),
    );
  }
}
