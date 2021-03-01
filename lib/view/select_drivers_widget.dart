import 'package:drt_app/model/model.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:drt_app/view/add_driver_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:get_it/get_it.dart';

class DRTSelectDriversWidget extends StatefulWidget {
  @override
  _DRTSelectDriversWidgetState createState() => _DRTSelectDriversWidgetState();
}

class _DRTSelectDriversWidgetState extends State<DRTSelectDriversWidget> {
  final model = GetIt.I<DRTModel>();
  Map vehicle;
  Map selectedDrivers;

  bool _loading = false;

  void _updateDrivers() async {
    try {
      setState(() => _loading = true);
      await model.handleUpdateDrivers(selectedDrivers, vehicle['ve_reg_num']);
    } catch (e) {
      errorSnackBar(context, e);
    }
    setState(() => _loading = false);
  }

  Widget _buildDriverList(model) {
    List drivers = model.drivers ?? [];

    if (drivers.length == 0) {
      return ListTile(
          title: Text('You have no drivers saved.')
      );
    }
    return ListView.separated(
      padding: EdgeInsets.only(top: 8),
      shrinkWrap: true,
      itemCount: drivers.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        if (drivers.length == 0) {
          return ListTile(
              title: Text('You have no drivers saved.')
          );
        }
        Map driver = drivers[index];
        selectedDrivers[driver['u_driver_tag']] = selectedDrivers[driver['u_driver_tag']] == null ? false : selectedDrivers[driver['u_driver_tag']];
        return CheckboxListTile(
          title: Text(driver['dr_nickname']),
          value: selectedDrivers[driver['u_driver_tag']],
          onChanged: (value) => setState(() => selectedDrivers[driver['u_driver_tag']] = !selectedDrivers[driver['u_driver_tag']]),
        );
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    vehicle = ModalRoute.of(context).settings.arguments;
    if (selectedDrivers == null)
      selectedDrivers = model.getDriversForVehicle(vehicle['ve_reg_num']);

    return ScopedModelDescendant<DRTModel>(
      builder: (context, child, model) {
        return Stack(
          children: [
            Container(
              height: double.infinity,
              child: _buildDriverList(model),
            ),
            Positioned(
              bottom: 150,
              right: 24,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => Navigator.pushNamed(context, DRTAddDriverPage.routeName),
                heroTag: null,
              ),
            ),
            Positioned(
                bottom: 50,
                right: 24,
                child: FloatingActionButton(
                  child: Icon(Icons.save),
                  onPressed: _updateDrivers,
                  heroTag: null,
                )
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return _loading ? Align(alignment: Alignment.center, child: SpinKitRing(color: primaryColor)) : _buildBody(context);
  }
}