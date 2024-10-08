import 'package:drt_app/view/page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DRTRenewalSuccessPage extends StatelessWidget {
  static final routeName = '/renewal_success';

  Widget _buildBody(BuildContext context, transaction) {
    String validityDuration;
    if (transaction['roadtax']['rt_validity_duration'] == '1Y')
      validityDuration = '1 year';
    else if (transaction['roadtax']['rt_validity_duration'] == '6M')
      validityDuration = '6 months';
    else
      validityDuration = transaction['roadtax']['rt_validity_duration'];

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      children: [
        SizedBox(height: 32),
        Text(
          'Renewal Successful',
          textScaleFactor: 2,
          style: TextStyle(fontWeight: FontWeight.w300),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Icon(Icons.check_circle, size: 64, color: Colors.green),
        SizedBox(height: 32),
        Divider(color: Colors.black),
        SizedBox(height: 16),
        Text(
          'Transaction details',
          textScaleFactor: 1.4,
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        ListTile(
          title: Text('Date'),
          subtitle: Text(DateFormat('d MMMM yyyy, HH:mm:ss').format(DateTime.parse(transaction['tr_dt'])), textScaleFactor: 1.25),
        ),
        ListTile(
          title: Text('Transaction ID'),
          subtitle: Text(transaction['tr_id'], textScaleFactor: 1.25),
        ),
        ListTile(
          title: Text('Payment Amount'),
          subtitle: Text('RM ' + transaction['tr_amount'].toStringAsFixed(2), textScaleFactor: 1.25),
        ),
        ListTile(
          title: Text('Vehicle Registration No.'),
          subtitle: Text(transaction['roadtax']['ve_reg_num'], textScaleFactor: 1.25),
        ),
        ListTile(
          title: Text('Validity Duration'),
          subtitle: Text(validityDuration, textScaleFactor: 1.25),
        ),
        ListTile(
          title: Text('Expiry Date'),
          subtitle: Text(DateFormat('d MMMM yyyy').format(DateTime.parse(transaction['roadtax']['rt_expiry_dt'])), textScaleFactor: 1.25),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map transaction = ModalRoute.of(context).settings.arguments;
    return DRTPage('Receipt', _buildBody(context, transaction), iconData: Icons.close);
  }

}