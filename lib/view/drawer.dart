import 'package:drt_app/model/model.dart';
import 'package:drt_app/view/login_page.dart';
import 'package:drt_app/view/notification_settings_page.dart';
import 'package:drt_app/view/payment_methods_page.dart';
import 'package:drt_app/view/saved_drivers_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:share/share.dart';

class DRTDrawer extends StatelessWidget {
  final model = GetIt.I<DRTModel>();

  void _logout(BuildContext context) {
    model.handleLogout();
    //Navigator.pushNamedAndRemoveUntil(context, DRTLoginPage.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListTileTheme(
        style: ListTileStyle.drawer,
        iconColor: Colors.black87,
        textColor: Colors.black87,
        child: ListView(
          children: [
            // DrawerHeader(
            //   decoration: BoxDecoration(
            //     color: Theme.of(context).primaryColor,
            //   ),
            //   child: Text('Abdul Hakeem Bin Yamin')
            // ),
            ListTile(
              title: Text(
                model.name,
                style: TextStyle(fontWeight: FontWeight.w300),
                textScaleFactor: 1.25,
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Your driver tag'),
              trailing: IconButton(icon: Icon(Icons.info), onPressed: () {  },),
            ),
            ListTile(
              title: Text(
                model.driverTag,
                style: TextStyle(fontWeight: FontWeight.w200),
                textScaleFactor: 2.5,
              ),
              trailing: IconButton(icon: Icon(Icons.share), onPressed: () =>
                  Share.share('Add me as a driver on Digital Road Tax with driver tag ' + model.driverTag, subject: model.driverTag + ' - Driver Tag')
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Saved drivers'),
              onTap: () => Navigator.pushNamed(context, DRTSavedDriversPage.routeName),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Account settings'),
              onTap: () {}//=> Navigator.pushNamed(context, DRTRegisterVehiclePage.routeName),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notification settings'),
              onTap: () => Navigator.pushNamed(context, DRTNotificationSettingsPage.routeName),
            ),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Payment methods'),
              onTap: () {
                GetIt.I<DRTModel>().fetchCards();
                Navigator.pushNamed(context, DRTPaymentMethodsPage.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Sign out', style: TextStyle(color: Colors.red)),
              onTap: () => _logout(context),
            ),
          ],
        )
      )
    );
  }
}