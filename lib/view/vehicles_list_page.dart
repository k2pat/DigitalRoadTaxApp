import 'package:drt_app/main.dart';
import 'package:drt_app/model/model.dart';
import 'package:drt_app/model/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class DRTVehiclesListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DRTVehiclesListPageState();
}

class _DRTVehiclesListPageState extends State<DRTVehiclesListPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DRTModel>(
      builder: (context, child, model) {
        List vehicles = model.data['u_vehicles'] ?? [];
        if (vehicles.length == 0) {
          return Text('You have no vehicles');
        }
        return ListView.separated(
            padding: EdgeInsets.only(top: 8),
            itemCount: vehicles.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              Map vehicle = vehicles[index];
              DateTime expiryDate = DateTime.parse(vehicle['rt_expiry_dt']);
              int daysLeft = expiryDate.difference(DateTime.now()).inDays;
              Text subtitleText;
              Icon trailingIcon;
              if (daysLeft <= 0) {
                subtitleText = Text('Expired', style: TextStyle(color: Colors.red));
                trailingIcon = Icon(Icons.error, color: Colors.red);
              } else if (daysLeft == 1) {
                subtitleText = Text('Expiring in $daysLeft day', style: TextStyle(color: Colors.orange));
                trailingIcon = Icon(Icons.warning, color: Colors.orange);
              } else if (daysLeft <= 10) {
                subtitleText = Text('Expiring in $daysLeft days', style: TextStyle(color: Colors.orange)
                );
                trailingIcon = Icon(Icons.warning, color: Colors.orange);
              } else {
                subtitleText = Text('Valid until ' + DRT.dateFormat.format(expiryDate));
                trailingIcon = Icon(Icons.chevron_right);
              }
              return ListTile(
                title: Text(vehicle['ve_reg_num']),
                subtitle: subtitleText,
                trailing: trailingIcon,
                onTap: () =>
                    Navigator.pushNamed(
                        context, '/vehicle', arguments: vehicle),
              );
            }
        );
      },
    );
  }

}