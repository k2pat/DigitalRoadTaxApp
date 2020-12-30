import 'package:drt_app/model/model.dart';
import 'package:drt_app/util/server_driver.dart';
import 'package:drt_app/view/home_page.dart';
import 'package:drt_app/view/login_page.dart';

mixin DRTAccountModel on DRTBaseModel {
  bool loggedIn;
  String accessToken;

  void initialize() {
    accessToken = sharedPreferences.getString('access_token');
    loggedIn = (accessToken == null || accessToken.isEmpty) ? false : true;
    if (loggedIn) sync();
  }

  void sync() async {
    Map params = {
      'access_token': accessToken,
    };
    Map response = await fetch('sync', params);
    if (!response['success']) throw 'Server returned: ' + response['errorMsg'];

    Map data = response['data'];
  }

  void login(mobileNum, password) async {
    Map params = {
      'mobile_num': mobileNum,
      'password': password
    };
    Map response = await fetch('login', params);
    if (!response['success']) throw 'Server returned: ' + response['errorMsg'];

    Map data = response['data'];
    accessToken = data['u_access_token'];
    sharedPreferences.setString('access_token', accessToken);
    loggedIn = true;

    navigatorKey.currentState.pushReplacementNamed(DRTHomePage.routeName);
  }

  void logout() {
    loggedIn = false;
    accessToken = null;
    sharedPreferences.remove('access_token');
    navigatorKey.currentState.pushNamedAndRemoveUntil(DRTLoginPage.routeName, (route) => false);
  }
}