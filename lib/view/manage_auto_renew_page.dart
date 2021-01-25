import 'package:drt_app/main.dart';
import 'package:drt_app/model/model.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:drt_app/view/page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class DRTManageAutoRenewPage extends StatefulWidget {
  static final routeName = '/manage_auto_renew';

  @override
  _DRTManageAutoRenewPageState createState() => _DRTManageAutoRenewPageState();
}

class _DRTManageAutoRenewPageState extends State<DRTManageAutoRenewPage> {
  final _formKey = GlobalKey<FormState>();
  Map vehicle;
  String validityDuration;
  int paymentMethod = 0;

  void _updateAutoRenew(bool autoRenew, {String duration}) async {
    try {
      await GetIt.I<DRTModel>().updateAutoRenew(vehicle, autoRenew, duration);
    } catch (e) {
      errorSnackBar(context, e);
    }
  }

  Widget _buildBody(BuildContext context, Map vehicle) {
    Color primaryColor = Theme.of(context).primaryColor;

    if (validityDuration == null) {
      validityDuration = vehicle['ve_auto_renew_duration'] ?? '1Y';
    }

    int _validityFactor;
    if (validityDuration == '1Y') {
      _validityFactor = 2;
    } else if (validityDuration == '6M') {
      _validityFactor = 1;
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        children: [
          ListTile(
            title: Text('Select validity duration', textScaleFactor: 0.95,),
          ),
          RadioListTile(
            title: Text('1 year'),
            subtitle: (vehicle['ve_auto_renew_duration'] == '1Y') ? Text('Current validity') : Text(''),
            value: '1Y',
            groupValue: validityDuration,
            onChanged: (value) => setState(() => validityDuration = value),
          ),
          RadioListTile(
            title: Text('6 months'),
            subtitle: (vehicle['ve_auto_renew_duration'] == '6M') ? Text('Current validity') : Text(''),
            value: '6M',
            groupValue: validityDuration,
            onChanged: (value) => setState(() => validityDuration = value),
          ),
          Divider(),
          ListTile(
            title: Text('Road tax amount'),//, textScaleFactor: 1.25),
            trailing:Text(
              'RM ' + (vehicle['ve_roadtax_rate'] * _validityFactor * 0.5).toStringAsFixed(2),
              textScaleFactor: 2,
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Select payment method', textScaleFactor: 0.95,),
          ),
          ListTile(
            leading: Radio(value: 1,
              groupValue: paymentMethod,
              onChanged: (value) => setState(() => paymentMethod = value),
            ),
            title: Text('Visa •••• 1234'),
            trailing: Icon(Icons.credit_card, color: primaryColor),
          ),
          ListTile(
            leading: Radio(value: 2,
              groupValue: paymentMethod,
              onChanged: (value) => setState(() => paymentMethod = value),
            ),
            title: Text('Maybank •••• 5678'),
            trailing: Icon(Icons.account_balance, color: primaryColor),
          ),
          ListTile(
            leading: Radio(value: 3,
              groupValue: paymentMethod,
              onChanged: (value) => setState(() => paymentMethod = value),
            ),
            title: Text('New credit/debit card'),
            trailing: Icon(Icons.credit_card, color: primaryColor),
          ),
          ListTile(
            leading: Radio(value: 4,
              groupValue: paymentMethod,
              onChanged: (value) => setState(() => paymentMethod = value),
            ),
            title: Text('New bank account'),
            trailing: Icon(Icons.account_balance, color: primaryColor),
          ),
          ListTile(
            leading: Radio(value: 5,
              groupValue: paymentMethod,
              onChanged: (value) => setState(() => paymentMethod = value),
            ),
            title: Text('Use unifi Mobile billing'),
            trailing: Icon(Icons.speaker_phone, color: primaryColor),
          ),
          SizedBox(height: 16),
          RaisedButton(
            child: Text((vehicle['ve_auto_renew'] == true) ? 'Update auto-renew settings' : 'Enable auto-renew', style: TextStyle(color: Colors.white)),
            color: Theme.of(context).accentColor,
            onPressed: () => _updateAutoRenew(true, duration: validityDuration),
          ),
          SizedBox(height: 16),
          (vehicle['ve_auto_renew'] == true) ? RaisedButton(
            child: Text('Disable auto-renew', style: TextStyle(color: Colors.white)),
            color: Colors.redAccent[700],
            onPressed: () => _updateAutoRenew(false),
          ) : SizedBox(height: 0),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    vehicle = ModalRoute.of(context).settings.arguments;
    String title = (vehicle['ve_auto_renew'] == true) ? 'Manage auto-renew' : 'Enable auto-renew';
    return DRTPage('Manage auto-renew', _buildBody(context, vehicle));
  }
}