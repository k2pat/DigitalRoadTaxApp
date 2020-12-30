import 'package:drt_app/model/vehicle.dart';
import 'package:drt_app/view/manage_drivers_page.dart';
import 'package:drt_app/view/page.dart';
import 'package:drt_app/view/road_tax_widget.dart';
import 'package:flutter/material.dart';

class DRTVehiclePage extends StatelessWidget {
  static const routeName = '/vehicle';

  Widget _buildBody(BuildContext context, Map vehicle) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 32),
      children: [
        DRTRoadTaxWidget(vehicle),
        SizedBox(height: 40),
        ListTile(
          title: RaisedButton.icon(
            icon: Icon(Icons.update, color: Colors.white),
            padding: EdgeInsets.symmetric(vertical: 16),
            color: Theme.of(context).primaryColor,
            label: Text(
              'Renew road tax',
              textScaleFactor: 1.25,
              style: TextStyle(color: Colors.white),
            ),

            onPressed: null,//() => Navigator.pushNamed(context, DRTRenewRoadTaxWidget.routeName, arguments: vehicle),
          ),
        ),
        SizedBox(height: 16),
        ListTile(
          title: RaisedButton.icon(
            icon: Icon(Icons.people),
            padding: EdgeInsets.symmetric(vertical: 16),
            label: Text(
              'Manage drivers',
              textScaleFactor: 1.25,
            ),
            onPressed: () => Navigator.pushNamed(context, DRTManageDriversPage.routeName),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map vehicle = ModalRoute.of(context).settings.arguments;
    return DRTBlankPage(_buildBody(context, vehicle));
  }
}