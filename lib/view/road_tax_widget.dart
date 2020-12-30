import 'package:drt_app/main.dart';
import 'package:drt_app/model/vehicle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DRTRoadTaxWidget extends StatelessWidget {
  final Map vehicle;

  DRTRoadTaxWidget(this.vehicle, {Key key}) : super(key: key);

  Widget _buildValid(BuildContext context, DateTime expiryDate, int daysLeft) {
    return Column(
      children: [
        Text(
          'Road tax valid until',
          textScaleFactor: 1.25,
          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          DRT.dateFormat.format(expiryDate),
          textScaleFactor: 1.5,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildExpiring(BuildContext context, DateTime expiryDate, int daysLeft) {
    return Column(
      children: [
        Text(
          'Road tax valid until',
          textScaleFactor: 1.25,
          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          DRT.dateFormat.format(expiryDate),
          textScaleFactor: 1.5,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),
        ListTile(
          leading: Icon(Icons.warning, color: Colors.orange),
          title: Text(
            'Road tax expires in ' + daysLeft.toString() + ' days',
            textScaleFactor: 1.25,
            style: TextStyle(color: Colors.orange),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildExpired(BuildContext context, DateTime expiryDate, int daysLeft) {
    return Column(
      children: [
        Text(
          'Road tax expired on',
          textScaleFactor: 1.25,
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          DRT.dateFormat.format(expiryDate),
          textScaleFactor: 1.5,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),
        ListTile(
          leading: Icon(Icons.error, color: Colors.red),
          title: Text(
            'Road tax expired ' + (-1 * daysLeft).toString() + ' days ago',
            textScaleFactor: 1.2,
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime expiryDate = DateTime.parse(vehicle['rt_expiry_dt']);
    int daysLeft = expiryDate.difference(DateTime.now()).inDays;
    Widget validityWidget;
    if (daysLeft <= 0) {
      validityWidget = _buildExpired(context, expiryDate, daysLeft);
    } else if (daysLeft <= 10) {
      validityWidget = _buildExpiring(context, expiryDate, daysLeft);
    } else {
      validityWidget = _buildValid(context, expiryDate, daysLeft);
    }
    return Column(
      children: [
        Text(
          vehicle['ve_reg_num'],
          textScaleFactor: 3,
          style: TextStyle(fontWeight: FontWeight.w300),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            vehicle['ve_make'] + ' ' + vehicle['ve_model'],
            textScaleFactor: 1.8,
            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 40),
        Center(
          child: QrImage(
            data: vehicle['ve_proof_id'],
            version: QrVersions.auto,
            size: 200.0,
          )
        ),
        SizedBox(height: 40),
        validityWidget
      ],
    );
  }

}