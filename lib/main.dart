import 'dart:io';

import 'package:drt_app/model/model.dart';
import 'package:drt_app/view/add_driver_page.dart';
import 'package:drt_app/view/driving_page.dart';
import 'package:drt_app/view/home_page.dart';
import 'package:drt_app/view/login_page.dart';
import 'package:drt_app/view/manage_auto_renew_page.dart';
import 'package:drt_app/view/manage_drivers_page.dart';
import 'package:drt_app/view/notification_settings_page.dart';
import 'package:drt_app/view/payment_methods_page.dart';
import 'package:drt_app/view/registration_page.dart';
import 'package:drt_app/view/renew_road_tax_page.dart';
import 'package:drt_app/view/renewal_success_page.dart';
import 'package:drt_app/view/vehicle_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';

Future<DRT> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String deviceToken = await firebaseMessaging.getToken();

  StripePayment.setOptions(StripeOptions(
    publishableKey: 'pk_test_51IDtdsCFbMmCdmOJ3jHD8cN0K9gYJPjnyTPQUHxarFHXEN0iQLGPLt6s4ptfEK7kJelybeSCyJh3mdHOW5gyHyG700A8mM3TTP',
    androidPayMode: 'test', // Android only
  ));

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Directory appDocDir = await getApplicationDocumentsDirectory();
  Database db = await databaseFactoryIo.openDatabase(appDocDir.path + '/drt.db');

  GetIt.I.registerSingleton<SharedPreferences>(sharedPreferences);
  GetIt.I.registerSingleton<Database>(db);

  GetIt.I.registerSingleton<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>());

  //DRTModel model = DRTModel(sharedPreferences, db);
  DRTModel model = DRTModel(deviceToken);
  GetIt.I.registerSingleton<DRTModel>(model);

  DRT app = DRT(model);

  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      // print("onMessage: $message");
      app.handleMessage(message);
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      //_navigateToItemDetail(message);
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
      //_navigateToItemDetail(message);
    },
  );

  await model.initialize();
  return app;
}

void main({bool testMode = false}) async {
  runApp(await initialize());
}

class DRT extends StatelessWidget {
  static const APP_TITLE = 'Digital Road Tax';
  static const DAYS_LEFT_EXPIRING = 14;
  static final dateFormat = DateFormat('d MMMM y');
  final GlobalKey<NavigatorState> navigatorKey = GetIt.I<GlobalKey<NavigatorState>>();
  final DRTModel model;

  DRT(this.model);

  @override
  Widget build(BuildContext context) {
    var initialRoute = model.loggedIn ? DRTHomePage.routeName : DRTLoginPage.routeName;
    model.fetchCards();
    return ScopedModel(
        model: model,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: APP_TITLE,
            theme: ThemeData(
              primaryColor: new Color(0xff2b2b8e),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            navigatorKey: navigatorKey,
            initialRoute: initialRoute,
            routes: {
              DRTLoginPage.routeName: (context) => DRTLoginPage(),
              DRTRegistrationPage.routeName: (context) => DRTRegistrationPage(),
              DRTHomePage.routeName: (context) => DRTHomePage(title: APP_TITLE),
              DRTNotificationSettingsPage.routeName: (context) => DRTNotificationSettingsPage(),
              DRTVehiclePage.routeName: (context) => DRTVehiclePage(),
              DRTDrivingPage.routeName: (context) => DRTDrivingPage(),
              DRTPaymentMethodsPage.routeName: (context) => DRTPaymentMethodsPage(),
              DRTRenewRoadTaxPage.routeName: (context) => DRTRenewRoadTaxPage(),
              DRTRenewalSuccessPage.routeName: (context) => DRTRenewalSuccessPage(),
              DRTManageAutoRenewPage.routeName: (context) => DRTManageAutoRenewPage(),
              DRTManageDriversPage.routeName: (context) => DRTManageDriversPage(),
              DRTAddDriverPage.routeName: (context) => DRTAddDriverPage(),
            }
        )
    );
  }

  void handleMessage(Map message) async {
    Map data = message['data'] ?? null;
    if (data == null) return;

    String type = data['type'];
    switch (type) {
      case 'RENEWAL_SUCCESS':
        await model.syncVehicles();
        model.renewalSuccess();
        break;

      case 'RENEWAL_FAIL':
        model.renewalFail();
        break;
    }
  }
}
