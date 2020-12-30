import 'package:drt_app/model/model.dart';
import 'package:drt_app/view/login_page.dart';
import 'package:drt_app/view/notification_settings_page.dart';
import 'package:drt_app/view/payment_methods_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class DRTDrawer extends StatelessWidget {
  void _logout(BuildContext context) {
    GetIt.I<DRTModel>().logout();
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
                'ABDUL HAKEEM BIN YAMIN',
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
                'Z32 E1P',
                style: TextStyle(fontWeight: FontWeight.w200),
                textScaleFactor: 2.5,
              ),
              trailing: IconButton(icon: Icon(Icons.share), onPressed: () {  },),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Saved drivers'),
              onTap: () {}//=> Navigator.pushNamed(context, DRTRegisterVehiclePage.routeName),
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
              onTap: () => Navigator.pushNamed(context, DRTPaymentMethodsPage.routeName),
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