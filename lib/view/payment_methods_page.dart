import 'package:drt_app/view/page.dart';
import 'package:flutter/material.dart';

class DRTPaymentMethodsPage extends StatelessWidget {
  static final routeName = '/payment_methods';

  Widget _buildSavedPaymentMethods(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(Icons.credit_card, color: primaryColor),
            title: Text('Visa •••• 1234'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {},
            ),
          )
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(Icons.account_balance, color: primaryColor),
            title: Text('Maybank •••• 5678'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {},
            ),
          )
        )
      ],
    );
  }

  Widget _buildAddPaymentMethods() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text('Add payment method', textScaleFactor: 0.95,),
          )
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Add credit or debit card'),
          )
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(Icons.account_balance),
            title: Text('Add bank account'),
          )
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(Icons.speaker_phone),
            title: Text('Use unifi Mobile billing'),
          )
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      children: [
        SizedBox(height: 8),
        _buildSavedPaymentMethods(context),
        Divider(),
        _buildAddPaymentMethods(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DRTPage('Payment methods', _buildBody(context));
  }
}