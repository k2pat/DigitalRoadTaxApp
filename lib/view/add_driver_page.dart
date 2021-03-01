import 'package:drt_app/model/model.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:drt_app/view/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';

class DRTAddDriverPage extends StatefulWidget {
  static final routeName = '/add_driver';

  @override
  _DRTAddDriverPageState createState() => _DRTAddDriverPageState();
}

class _DRTAddDriverPageState extends State<DRTAddDriverPage> {
  final model = GetIt.I<DRTModel>();
  final _formKey = GlobalKey<FormState>();
  final _driverTagController = TextEditingController();
  final _nicknameController = TextEditingController();

  bool _loading = false;

  void _addDriver() async {
    try {
      if (_formKey.currentState.validate()) {
        setState(() => _loading = true);
        await model.handleAddDriver(_driverTagController.text, _nicknameController.text);
      }
    } catch (e) {
      errorSnackBar(context, e);
    }
    setState(() => _loading = false);
  }

  Widget _build() {
    Color primaryColor = Theme.of(context).primaryColor;
    return _loading == true ? Align(alignment: Alignment.center, child: SpinKitRing(color: primaryColor)) :
    Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.only(left: 16, right: 16, top: 8),
        children: [
          TextFormField(
            controller: _driverTagController,
            decoration: const InputDecoration(
              labelText: 'Driver tag',
              hintText: 'Enter driver\'s Driver Tag',
            ),
            textCapitalization: TextCapitalization.characters,
            validator: (value) {
              if (value.isEmpty) return 'Please enter a driver tag';
              else if (value == model.driverTag) return 'Please enter a different user\'s driver tag';
              else return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _nicknameController,
            decoration: const InputDecoration(
              labelText: 'Driver nickname',
              hintText: 'Enter a nickname for the driver',
            ),
            validator: (value) {
              if (value.isEmpty) return 'Please enter a nickname for the driver';
              else return null;
            },
          ),
          SizedBox(height: 48),
          RaisedButton(
            child: Text('Add driver', style: TextStyle(color: Colors.white)),
            color: Theme.of(context).accentColor,
            onPressed: _addDriver,
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return DRTPage('Add driver', _build());
  }
}