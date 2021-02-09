import 'dart:convert';
import 'package:drt_app/model/model.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:drt_app/view/home_page.dart';
import 'package:drt_app/view/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';

class DRTLoginPage extends StatefulWidget {
  static final routeName = '/login';

  @override
  _DRTLoginPageState createState() => _DRTLoginPageState();
}

class _DRTLoginPageState extends State<DRTLoginPage> {
  final _mobileNumController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    try {
      await GetIt.I<DRTModel>().handleLogin(_mobileNumController.text, _passwordController.text);
    } catch (e) {
      errorSnackBar(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
          body: Stack(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Digital Road Tax', style: TextStyle(fontWeight: FontWeight.w200, color: Colors.white, fontSize: 40)),
                      SizedBox(height:40),
                      TextFormField(
                        controller: _mobileNumController,
                        decoration: const InputDecoration(
                          labelText: 'Mobile number',
                          hintText: 'Enter your mobile number',
                          fillColor: Colors.white,
                          filled: true
                        )
                      ),
                      SizedBox(height:10),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          fillColor: Colors.white,
                          filled: true
                        ),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),

                      SizedBox(height:40),

                      ButtonTheme(
                        minWidth: 180.0,
                        height: 48.0,
                        child: RaisedButton(
                          child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 18)),
                          color: Theme.of(context).accentColor,
                          onPressed: _login,
                        ),
                      )
                    ],
                  )
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  child: Text('No account? Register here', style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.underline)),
                  onPressed: () => Navigator.pushNamed(context, DRTRegistrationPage.routeName),
                )
              ),
            ],
          )
      )
    );
  }
}