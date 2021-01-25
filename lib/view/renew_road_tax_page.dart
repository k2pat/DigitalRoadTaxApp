import 'package:drt_app/main.dart';
import 'package:drt_app/model/model.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:drt_app/view/page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class DRTRenewRoadTaxPage extends StatefulWidget {
  static final routeName = '/renew_road_tax';

  @override
  _DRTRenewRoadTaxPageState createState() => _DRTRenewRoadTaxPageState();
}

class _DRTRenewRoadTaxPageState extends State<DRTRenewRoadTaxPage> {
  final _formKey = GlobalKey<FormState>();
  Map vehicle;
  String validityDuration = '1Y';
  bool doAutoRenew = false;
  int paymentMethod = 0;
  //int effectiveDate = 0;

  void _renew() async {
    try {
      await GetIt.I<DRTModel>().renew(vehicle, validityDuration, doAutoRenew);
    } catch (e) {
      errorSnackBar(context, e);
    }
  }

  Widget _buildBody(BuildContext context, Map vehicle) {
    Color primaryColor = Theme.of(context).primaryColor;

    DateTime expiryDate = DateTime.parse(vehicle['rt_expiry_dt']);
    DateTime effectiveDate = (DateTime.now().isBefore(expiryDate)) ? expiryDate : DateTime.now();
    DateTime newExpiryDate;
    int _validityFactor;
    if (validityDuration == '1Y') {
      newExpiryDate = DateTime(effectiveDate.year + 1, effectiveDate.month, effectiveDate.day);
      _validityFactor = 2;
    } else if (validityDuration == '6M') {
      newExpiryDate = DateTime(effectiveDate.year, effectiveDate.month + 6, effectiveDate.day);
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
            value: '1Y',
            groupValue: validityDuration,
            onChanged: (value) => setState(() => validityDuration = value),
          ),
          RadioListTile(
            title: Text('6 months'),
            value: '6M',
            groupValue: validityDuration,
            onChanged: (value) => setState(() => validityDuration = value),
          ),
          // ListTile(
          //   title: Text('Select effective date', textScaleFactor: 0.95,),
          // ),
          // RadioListTile(
          //   title: Text('Today'),
          //   value: 1,
          //   groupValue: effectiveDate,
          //   onChanged: (value) => setState(() => effectiveDate = value),
          // ),
          // RadioListTile(
          //   title: Text('Later'),
          //   value: 2,
          //   groupValue: effectiveDate,
          //   onChanged: (value) => setState(() => effectiveDate = value),
          // ),
          SizedBox(height: 16),
          CheckboxListTile(
            title: Text('Enable auto-renew'),
            // subtitle: Text('Road tax will be automatically 1 week before expiry date.'),
            value: doAutoRenew,
            onChanged: (value) => setState(() => doAutoRenew = !doAutoRenew),
          ),
          Divider(),
          ListTile(
            title: Text(
              'New expiry date',
              //textScaleFactor: 1,
            ),
            trailing: Text(DRT.dateFormat.format(newExpiryDate),
              textScaleFactor: 1.25,
            ),
          ),
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
            child: Text('Proceed', style: TextStyle(color: Colors.white)),
            color: Theme.of(context).accentColor,
            onPressed: _renew,
          ),
          SizedBox(height: 32),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    vehicle = ModalRoute.of(context).settings.arguments;
    return DRTPage('Renew road tax for ' + vehicle['ve_reg_num'], _buildBody(context, vehicle));
  }
}