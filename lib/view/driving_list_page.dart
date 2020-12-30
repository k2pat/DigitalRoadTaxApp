import 'package:drt_app/main.dart';
import 'package:drt_app/model/vehicle.dart';
import 'package:drt_app/view/driving_page.dart';
import 'package:flutter/material.dart';

class DRTDrivingListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DRTDrivingListPageState();
}

class _DRTDrivingListPageState extends State<DRTDrivingListPage> {
  @override
  Widget build(BuildContext context) {
    List<DRTVehicle> drivingList = [];
    return Stack(
      children: [
        ListView.separated(
          padding: EdgeInsets.only(top: 8),
          itemCount: drivingList.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            DRTVehicle vehicle = drivingList[index];
            int daysLeft = vehicle.daysLeft();
            Text subtitleText;
            Icon trailingIcon;
            if (daysLeft <= 0) {
              subtitleText = Text('Expired', style: TextStyle(color: Colors.red));
              trailingIcon = Icon(Icons.error, color: Colors.red);
            } else if (daysLeft == 1) {
              subtitleText = Text('Expiring in $daysLeft day', style: TextStyle(color: Colors.orange));
              trailingIcon = Icon(Icons.warning, color: Colors.orange);
            } else if (daysLeft <= 10) {
              subtitleText = Text('Expiring in $daysLeft days', style: TextStyle(color: Colors.orange));
              trailingIcon = Icon(Icons.warning, color: Colors.orange);
            } else {
              subtitleText = Text('Valid until ' + DRT.dateFormat.format(vehicle.expiryDate));
              trailingIcon = Icon(Icons.chevron_right);
            }
            return ListTile(
              title: Text(drivingList[index].regNum),
              subtitle: subtitleText,
              trailing: Icon(Icons.qr_code),
              onTap: () => Navigator.pushNamed(context, DRTDrivingPage.routeName, arguments: drivingList[index]),
            );
          }
        ),
        // Positioned(
        //   bottom: 16,
        //   right: 16,
        //   child: FloatingActionButton(
        //     child: Icon(Icons.label),
        //     onPressed: () {},
        //   )
        // ),
      ],
    );
  }

}