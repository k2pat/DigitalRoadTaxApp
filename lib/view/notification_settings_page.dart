import 'package:drt_app/view/page.dart';
import 'package:flutter/material.dart';

class DRTNotificationSettingsPage extends StatefulWidget {
  static const routeName = '/notification_settings';

  @override
  State<StatefulWidget> createState() => _DRTNotificationSettingsPageState();
}

class _DRTNotificationSettingsPageState extends State<DRTNotificationSettingsPage> {
  bool checkPushNotification = true;
  bool checkSMS = true;
  bool checkEmail = true;

  Widget _buildBody() {
    return ListView(
      padding: EdgeInsets.only(top: 8),
      children: [
        CheckboxListTile(
          title: Text('Push notifications'),
          subtitle: Text('Notify me through push notifications'),
          value: checkPushNotification, // TODO: Based on user saved setting
          onChanged: (value) => setState(() {
            checkPushNotification = !checkPushNotification;
          }),
        ),
        CheckboxListTile(
          title: Text('SMS'),
          subtitle: Text('Notify me through SMS'),
          value: checkSMS, // TODO: Based on user saved setting
          onChanged: (value) => setState(() {
            checkSMS = !checkSMS;
          }),
        ),
        CheckboxListTile(
          title: Text('Email'),
          subtitle: Text('Notify me through email'),
          value: checkEmail, // TODO: Based on user saved setting
          onChanged: (value) => setState(() {
            checkEmail = !checkEmail;
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DRTPage('Notification settings', _buildBody());
  }
}