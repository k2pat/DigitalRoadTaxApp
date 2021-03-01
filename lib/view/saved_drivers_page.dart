import 'package:drt_app/view/page.dart';
import 'package:drt_app/view/select_drivers_widget.dart';
import 'package:flutter/material.dart';

class DRTSavedDriversPage extends StatefulWidget {
  static final routeName = '/saved_drivers';

  @override
  _DRTSavedDriversPageState createState() => _DRTSavedDriversPageState();
}

class _DRTSavedDriversPageState extends State<DRTSavedDriversPage> {
  bool _loading = false;

  Widget _build(BuildContext context) {

  }

  @override
  Widget build(BuildContext context) {
    return DRTPage('Saved drivers', _build(context));
  }
}