import 'package:drt_app/main.dart';
import 'package:drt_app/model/vehicle.dart';
import 'package:drt_app/view/page.dart';
import 'package:flutter/material.dart';

class DRTRenewRoadTaxWidget extends StatefulWidget {
  static final routeName = '/renew_road_tax';

  @override
  _DRTRenewRoadTaxWidgetState createState() => _DRTRenewRoadTaxWidgetState();
}

class _DRTRenewRoadTaxWidgetState extends State<DRTRenewRoadTaxWidget> {
  final _formKey = GlobalKey<FormState>();
  int validityDuration = 1;
  int paymentMethod = 0;
  //int effectiveDate = 0;

  Widget _buildBody(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        children: [
          ListTile(
            title: Text('Select validity duration', textScaleFactor: 0.95,),
          ),
          RadioListTile(
            title: Text('6 months'),
            value: 1,
            groupValue: validityDuration,
            onChanged: (value) => setState(() => validityDuration = value),
          ),
          RadioListTile(
            title: Text('1 year'),
            value: 2,
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
          Divider(),
          ListTile(
            title: Text(
              'Road tax will expire on ' + DRT.dateFormat.format(DateTime.now().add(Duration(days: 182 * validityDuration))),
              textScaleFactor: 1,
            ),
          ),
          ListTile(
            title: Text('Road tax amount:', textScaleFactor: 1.25),
            trailing:Text(
              'RM ' + (80 * validityDuration).toString(),
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
            onPressed: () {
              //DRT.vehicleList[1].expiryDate = DateTime.parse('2021-11-17');
            },
          ),
          SizedBox(height: 24),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map vehicle = ModalRoute.of(context).settings.arguments;
    return DRTPage('Renew road tax for ' + vehicle['ve_reg_num'], _buildBody(context));
  }
}