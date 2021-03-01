import 'package:drt_app/main.dart';
import 'package:drt_app/model/model.dart';
import 'package:drt_app/model/vehicle.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:drt_app/view/driving_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:jiffy/jiffy.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:get_it/get_it.dart';

class DRTDrivingListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DRTDrivingListPageState();
}

class _DRTDrivingListPageState extends State<DRTDrivingListPage> {
  Future<void> _refresh() async {
    try {
      await GetIt.I<DRTModel>().syncDrivingVehicles();
    } catch (e) {
      errorSnackBar(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<DRTModel>(
      builder: (context, child, model) {
        List vehicles = model.drivingVehicles ?? [];
        if (vehicles.length == 0) {
          return EasyRefresh(
              onRefresh: _refresh,
              child: ListTile(
                  title: Text('You are not a driver of any vehicle.')
              )
          );
        }
        return EasyRefresh(
            onRefresh: _refresh,
            child: ListView.separated(
                padding: EdgeInsets.only(top: 8),
                itemCount: vehicles.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  Map vehicle = vehicles[index];
                  DateTime expiryDate = DateTime.parse(vehicle['rt_expiry_dt']);
                  int daysLeft = expiryDate.add(Duration(days: 1)).difference(DateTime.now()).inDays; // end of expiry day
                  Text subtitleText;
                  Icon trailingIcon;
                  if (Jiffy().isAfter(Jiffy(vehicle['rt_expiry_dt']).endOf(Units.DAY))) {
                    subtitleText = Text('Expired', style: TextStyle(color: Colors.red));
                    trailingIcon = Icon(Icons.error, color: Colors.red);
                  } else if (daysLeft == 0) {
                    subtitleText = Text('Expires today', style: TextStyle(color: Colors.orange));
                    trailingIcon = Icon(Icons.warning, color: Colors.orange);
                  } else if (daysLeft == 1) {
                    subtitleText = Text('Expires tomorrow', style: TextStyle(color: Colors.orange));
                    trailingIcon = Icon(Icons.warning, color: Colors.orange);
                  } else if (daysLeft <= DRT.DAYS_LEFT_EXPIRING) {
                    subtitleText = Text('Expires in $daysLeft days', style: TextStyle(color: Colors.orange));
                    trailingIcon = Icon(Icons.warning, color: Colors.orange);
                  } else {
                    subtitleText = Text('Valid until ' + DRT.dateFormat.format(expiryDate));
                    trailingIcon = Icon(Icons.chevron_right);
                  }
                  return ListTile(
                    title: Text(vehicle['ve_reg_num']),
                    subtitle: subtitleText,
                    trailing: Icon(Icons.qr_code),
                    onTap: () => Navigator.pushNamed(context, DRTDrivingPage.routeName, arguments: vehicle),
                  );
                }
            )
        );
      },
    );
  }

}