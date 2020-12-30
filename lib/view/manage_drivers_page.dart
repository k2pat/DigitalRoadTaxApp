import 'package:drt_app/view/page.dart';
import 'package:drt_app/view/select_drivers_widget.dart';
import 'package:flutter/material.dart';

class DRTManageDriversPage extends StatelessWidget {
  static final routeName = '/manage_drivers';

  @override
  Widget build(BuildContext context) {
    return DRTPage('Select drivers', DRTSelectDriversWidget());
  }

}