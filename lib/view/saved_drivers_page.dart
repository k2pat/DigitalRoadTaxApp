import 'package:drt_app/model/model.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:drt_app/view/add_driver_page.dart';
import 'package:drt_app/view/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:get_it/get_it.dart';

class DRTSavedDriversPage extends StatefulWidget {
  static final routeName = '/saved_drivers';

  @override
  _DRTSavedDriversPageState createState() => _DRTSavedDriversPageState();
}

class _DRTSavedDriversPageState extends State<DRTSavedDriversPage> {
  final model = GetIt.I<DRTModel>();

  bool _loading = false;

  void _removeDriver(driver) async {
    try {
      setState(() => _loading = true);
      await model.handleRemoveDriver(driver);
    }
    catch (e) {
      errorSnackBar(context, e);
    }
    setState(() => _loading = false);
  }

  Widget _buildRemoveButton(Map driver) {
    String nickname = driver['dr_nickname'];
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text('Confirm remove'),
                  content: Text('Are you sure you want to remove $nickname'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel')
                    ),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _removeDriver(driver);
                        },
                        child: Text('Remove')
                    ),
                  ]
              );
            }
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return ScopedModelDescendant<DRTModel>(
      builder: (context, child, model) {
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
              Map driver = drivers[index];

              return ListTile(
                title: Text(driver['dr_nickname']),
                trailing: Wrap(
                  spacing: 12,
                  children: [
                    _buildRemoveButton(driver)
                  ],
                )
              );
            }
        );
      }
    );
  }

  Widget _build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Stack(
      children: [
        Container(
          height: double.infinity,
          child: _buildBody(context),
        ),
        _loading == true ? Align(alignment: Alignment.center, child: SpinKitRing(color: primaryColor)) : SizedBox(height: 0),
        Positioned(
          bottom: 50,
          right: 24,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, DRTAddDriverPage.routeName),
            heroTag: null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DRTPage('Saved drivers', _build(context));
  }
}