import 'package:drt_app/model/vehicle.dart';
import 'package:drt_app/view/manage_auto_renew_page.dart';
import 'package:drt_app/view/manage_drivers_page.dart';
import 'package:drt_app/view/page.dart';
import 'package:drt_app/view/renew_road_tax_page.dart';
import 'package:drt_app/view/road_tax_widget.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class DRTVehiclePage extends StatefulWidget {
  static const routeName = '/vehicle';

  @override
  _DRTVehiclePageState createState() => _DRTVehiclePageState();
}

class _DRTVehiclePageState extends State<DRTVehiclePage> {
  Widget _buildBody(BuildContext context, Map vehicle) {
    bool renewDisabled = Jiffy(vehicle['rt_expiry_dt']).diff(Jiffy(), Units.MONTH, true) > 2;

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
            onPressed: renewDisabled ? null : () => Navigator.pushNamed(context, DRTRenewRoadTaxPage.routeName, arguments: vehicle),
          ),
        ),
        SizedBox(height: 16),
        ListTile(
          title: RaisedButton.icon(
            icon: Icon(Icons.autorenew_rounded, color: Colors.white),
            padding: EdgeInsets.symmetric(vertical: 16),
            color: Theme.of(context).primaryColor,
            label: Text(
              (vehicle['ve_auto_renew'] == true) ? 'Manage auto-renew' : 'Enable auto-renew',
              textScaleFactor: 1.25,
              style: TextStyle(color: Colors.white),
            ),
            onPressed:
              Jiffy().isAfter(Jiffy(vehicle['rt_expiry_dt']).endOf(Units.DAY))
                  ? null : () => Navigator.pushNamed(context, DRTManageAutoRenewPage.routeName, arguments: vehicle),
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