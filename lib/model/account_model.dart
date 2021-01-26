import 'package:drt_app/model/model.dart';
import 'package:drt_app/util/server_driver.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:drt_app/view/home_page.dart';
import 'package:drt_app/view/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';

mixin DRTAccountModel on DRTBaseModel {
  void initialize() async {
    accessToken = sharedPreferences.getString('access_token');
    loggedIn = (accessToken == null || accessToken.isEmpty) ? false : true;
    if (loggedIn) await sync();
  }

  void sync() async {
    try {
      Map params = {
        'access_token': accessToken,
      };
      Map response = await fetch('sync', params);
      data = response;
      await store.record('data').put(db, data);
    }
    catch (e) {
      logout();
    }
  }

  void login(mobileNum, password) async {
    try {
      Map params = {
        'mobile_num': mobileNum,
        'password': password,
        'device_token': deviceToken
      };
      Map response = await fetch('login', params);

      data = response;
      accessToken = data['u_access_token'];
      sharedPreferences.setString('access_token', accessToken);
      loggedIn = true;

      await store.record('data').put(db, data);

      navigatorKey.currentState.pushReplacementNamed(DRTHomePage.routeName);
    }
    catch (e) {
      throw e;
    }
  }

  void register(mobileNum, email, password, idNum, idType) async {
    try {
      Map params = {
        'mobile_num': mobileNum,
        'email': email,
        'password': password,
        'id_num': idNum,
        'id_type': idType,
      };
      Map response = await fetch('register', params);

      navigatorKey.currentState.pushNamedAndRemoveUntil(DRTLoginPage.routeName, (route) => false);
      DRTSnackBar(message: 'Account registered successfully!', icon: Icon(Icons.check, color: Colors.green)).show(navigatorKey.currentContext);
    }
    catch (e) {
      throw e;
    }
  }

  void logout() async {
    loggedIn = false;
    accessToken = null;
    sharedPreferences.remove('access_token');
    await store.record('data').delete(db);

    navigatorKey.currentState.pushNamedAndRemoveUntil(DRTLoginPage.routeName, (route) => false);
  }
}