import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/services.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

import '../../shared-widgets/helpers/ensure-visible.dart';
import '../../scoped-models/main.dart';

class GameRegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameRegisterState();
  }
}

class _GameRegisterState extends State<GameRegisterPage> {
  bool _isButtonDisabled = false;

  final Map<String, dynamic> _formData = {'code': null};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _codeFocusNode = FocusNode();

  bool _isVisibleQrCodeScanner = false;

  Widget _buildCodeField() {
    return EnsureVisibleWhenFocused(
      focusNode: _codeFocusNode,
      child: ListTile(
        leading: Icon(Icons.code),
        title: TextFormField(
            focusNode: _codeFocusNode,
            keyboardType: TextInputType.text,
            initialValue: _formData['code'],
            validator: (String value) {
              if (value.isEmpty || value.length < 6 || value.length > 6) {
                return 'Game code has 6 characters.';
              }
              return null;
            },
            decoration: InputDecoration(labelText: 'Game code'),
            onSaved: (String value) {
              _formData['code'] = value;
            }),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, AppModel model) {
    return Center(
      child: RaisedButton(
        child: Text(_isButtonDisabled ? 'Please wait...' : 'Join game'),
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

  Widget _buildFormContent(BuildContext context, AppModel model) {
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
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildCodeField(),
              SizedBox(height: 20.0),
              _buildSubmitButton(context, model)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQRCodeScannerContent(BuildContext context, AppModel model) {
    return Center(
      child: SizedBox(
        width: 300.0,
        height: 300.0,
        child: new QrCamera(
          qrCodeCallback: (code) {
            if (code.length < 6 || code.length > 6) {
              return;
            }
            setState(() {
              _formData['code'] = code;
              _isVisibleQrCodeScanner = false;
            });
          },
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
    bool success = await model.registerWithCode(
        _formData['code'], model.authenticatedUser);
    if (success & mounted) {
      Navigator.pushReplacementNamed(context, '/games');
    } else {
      print('no game found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Join a game'),
          ),
          body: _isVisibleQrCodeScanner
              ? _buildQRCodeScannerContent(context, model)
              : _buildFormContent(context, model),
          floatingActionButton: FloatingActionButton.extended(
            // onPressed: _scanQR,
            onPressed: () {
              setState(() {
                _isVisibleQrCodeScanner = !_isVisibleQrCodeScanner;
              });
            },
            label: _isVisibleQrCodeScanner ? Text('Enter') : Text('Scan'),
            icon: _isVisibleQrCodeScanner
                ? Icon(Icons.edit)
                : Icon(Icons.camera_alt),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
