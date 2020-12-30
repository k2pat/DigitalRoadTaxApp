import 'package:drt_app/model/vehicle.dart';
import 'package:drt_app/view/page.dart';
import 'package:drt_app/view/road_tax_widget.dart';
import 'package:flutter/material.dart';

class DRTDrivingPage extends StatelessWidget {
  static const routeName = '/driving';

  Widget _buildBody(BuildContext context, DRTVehicle vehicle) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 32),
      children: [
        DRTRoadTaxWidget(vehicle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final DRTVehicle vehicle = ModalRoute.of(context).settings.arguments;
    return DRTBlankPage(_buildBody(context, vehicle));
  }
}