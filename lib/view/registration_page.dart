import 'package:drt_app/model/model.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:drt_app/view/page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';

class DRTRegistrationPage extends StatefulWidget {
  static final routeName = '/register';

  @override
  _DRTRegistrationPageState createState() => _DRTRegistrationPageState();
}

class _DRTRegistrationPageState extends State<DRTRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String _idType = 'MyKad';
  final _nameController = TextEditingController();
  final _mobileNumController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _idNumController = TextEditingController();

  bool _loading = false;

  void _register() async {
    try {
      if (_formKey.currentState.validate()) {
        setState(() => _loading = true);
        await GetIt.I<DRTModel>().handleRegister(
            _nameController.text, _mobileNumController.text,
            _emailController.text, _passwordController.text,
            _idNumController.text, _idType);
      }
    } catch (e) {
      errorSnackBar(context, e);
    }
    setState(() => _loading = false);
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(left: 16, right: 16, top: 8),
          children: [
            TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full name',
              hintText: 'Enter your full name',
            ),
            onSaved: (value) {},
            enableSuggestions: false,
            autocorrect: false,
            validator: (value) {
              if (value.isEmpty) return 'Please enter your full name';
              else return null;
            },
          ),
            SizedBox(height: 16),
            TextFormField(
              controller: _idNumController,
              decoration: const InputDecoration(
                labelText: 'Identification number',
                hintText: 'Enter your identification number',
              ),
              onSaved: (value) {},
              enableSuggestions: false,
              autocorrect: false,
              validator: (value) {
                if (value.isEmpty) return 'Please select your identification number';
                else return null;
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _idType,
              decoration: const InputDecoration(
                labelText: 'Identification type',
                hintText: 'Select your identification type',
              ),
              icon: Icon(Icons.arrow_drop_down_outlined),
              iconSize: 24,
              elevation: 16,
              onChanged: (String newValue) {
                setState(() {
                  _idType = newValue;
                });
              },
              items: <String>['','MyKad']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) {
                if (value.isEmpty) return 'Please select your identification type';
                else return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email address',
              ),
              onSaved: (value) {},
              enableSuggestions: false,
              autocorrect: false,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _mobileNumController,
              decoration: const InputDecoration(
                labelText: 'Mobile number',
                hintText: 'Enter your mobile number',
              ),
              onSaved: (value) {},
              enableSuggestions: false,
              autocorrect: false,
              validator: (value) {
                if (value.isEmpty) return 'Please enter a mobile number';
                else return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
              onSaved: (value) {},
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              validator: (value) {
                if (value.isEmpty) return 'Please enter a password';
                else return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Confirm password',
                hintText: 'Enter the same password as above',
              ),
              onSaved: (value) {},
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              validator: (value) {
                if (value != _passwordController.text) return 'Does not match password';
                else return null;
              },
            ),
            SizedBox(height: 48),
            RaisedButton(
              child: Text('Register', style: TextStyle(color: Colors.white)),
              color: Theme.of(context).accentColor,
              onPressed: _register,
            ),
          ]
        )
    );
  }

  Widget _buildBody() {
    Color primaryColor = Theme.of(context).primaryColor;
    if (_loading) {
      return Align(alignment: Alignment.center, child: SpinKitRing(color: primaryColor));
    }
    else {
      return _buildForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DRTPage('Registration', _buildBody());
  }
}