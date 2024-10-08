import 'package:drt_app/model/model.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:drt_app/view/page.dart';
import 'package:get_it/get_it.dart';

class DRTRegistrationPage extends StatefulWidget {
  static final routeName = '/register';

  @override
  _DRTRegistrationPageState createState() => _DRTRegistrationPageState();
}

class _DRTRegistrationPageState extends State<DRTRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String _idType = 'MyKad';
  final _mobileNumController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _idNumController = TextEditingController();

  void _register() async {
    try {
      await GetIt.I<DRTModel>().register(_mobileNumController.text, _emailController.text, _passwordController.text, _idNumController.text, _idType);
    } catch (e) {
      errorSnackBar(context, e);
    }
  }

  Widget _buildBody() {
    return Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.only(left: 16, right: 16, top: 8),
          children: [
            TextFormField(
              controller: _idNumController,
              decoration: const InputDecoration(
                labelText: 'Identification number',
                hintText: 'Enter your identification number',
              ),
              onSaved: (value) {},
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
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email address',
              ),
              onSaved: (value) {},
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _mobileNumController,
              decoration: const InputDecoration(
                labelText: 'Mobile number',
                hintText: 'Enter your mobile number',
              ),
              onSaved: (value) {},
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
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Confirm password',
                hintText: 'Enter your the same password as above',
              ),
              onSaved: (value) {},
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
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

  @override
  Widget build(BuildContext context) {
    return DRTPage('Registration', _buildBody());
  }
}