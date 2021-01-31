import 'package:drt_app/main.dart';
import 'package:drt_app/model/model.dart';
import 'package:drt_app/model/payment_method.dart';
import 'package:drt_app/util/input_formatter.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:drt_app/view/page.dart';
import 'package:drt_app/view/payment_methods_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';

class DRTManageAutoRenewPage extends StatefulWidget {
  static final routeName = '/manage_auto_renew';

  @override
  _DRTManageAutoRenewPageState createState() => _DRTManageAutoRenewPageState();
}

class _DRTManageAutoRenewPageState extends State<DRTManageAutoRenewPage> {
  final _formKey = GlobalKey<FormState>();
  Map vehicle;
  String validityDuration;
  int paymentMethod = 0;
  DRTPaymentMethod _paymentMethod;

  String _getPaymentMethodLabel() {
    if (_paymentMethod.paymentMethodType == 'CARD') {
      return capitalize(_paymentMethod.paymentMethod['card']['brand']) + ' •••• ' + _paymentMethod.paymentMethod['card']['last4'];
    }
    else if (_paymentMethod.paymentMethodType == 'BANK') {
      return 'Online banking';
    }
    else if (_paymentMethod.paymentMethodType == 'MOBILE') {
      return 'Mobile billing';
    }
    else {
      return 'Select a payment method';
    }
  }

  void _updateAutoRenew(bool autoRenew, {String duration}) async {
    try {
      await GetIt.I<DRTModel>().updateAutoRenew(vehicle, autoRenew, duration, _paymentMethod);
    } catch (e) {
      errorSnackBar(context, e);
    }
  }

  Widget _buildBody(BuildContext context, Map vehicle) {
    Color primaryColor = Theme.of(context).primaryColor;

    if (validityDuration == null) {
      validityDuration = vehicle['ve_auto_renew_duration'] ?? '1Y';
    }

    int _validityFactor;
    if (validityDuration == '1Y') {
      _validityFactor = 2;
    } else if (validityDuration == '6M') {
      _validityFactor = 1;
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        children: [
          ListTile(
            title: Text('Select validity duration', textScaleFactor: 0.95,),
          ),
          RadioListTile(
            title: Text('1 year'),
            subtitle: (vehicle['ve_auto_renew_duration'] == '1Y') ? Text('Current validity') : Text(''),
            value: '1Y',
            groupValue: validityDuration,
            onChanged: (value) => setState(() => validityDuration = value),
          ),
          RadioListTile(
            title: Text('6 months'),
            subtitle: (vehicle['ve_auto_renew_duration'] == '6M') ? Text('Current validity') : Text(''),
            value: '6M',
            groupValue: validityDuration,
            onChanged: (value) => setState(() => validityDuration = value),
          ),
          Divider(),
          ListTile(
            title: Text('Road tax amount'),//, textScaleFactor: 1.25),
            trailing:Text(
              'RM ' + (vehicle['ve_roadtax_rate'] * _validityFactor * 0.5).toStringAsFixed(2),
              textScaleFactor: 2,
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
          Divider(),
          ScopedModelDescendant<DRTPaymentMethod>(
              builder: (context, child, model) {
                return ListTile(
                  title: Text('Payment method', textScaleFactor: 0.95,),
                  onTap: () => Navigator.pushNamed(context, DRTPaymentMethodsPage.routeName, arguments: _paymentMethod),
                  trailing: Text('Change', style: TextStyle(color: primaryColor)),
                  subtitle: Text(_getPaymentMethodLabel(),
                      textScaleFactor: 1.2,
                      style: TextStyle(fontWeight: FontWeight.w500)
                  ),
                );
              }
          ),
          SizedBox(height: 16),
          RaisedButton(
            child: Text((vehicle['ve_auto_renew'] == true) ? 'Update auto-renew settings' : 'Enable auto-renew', style: TextStyle(color: Colors.white)),
            color: Theme.of(context).accentColor,
            onPressed: () => _updateAutoRenew(true, duration: validityDuration),
          ),
          SizedBox(height: 16),
          (vehicle['ve_auto_renew'] == true) ? RaisedButton(
            child: Text('Disable auto-renew', style: TextStyle(color: Colors.white)),
            color: Colors.redAccent[700],
            onPressed: () => _updateAutoRenew(false),
          ) : SizedBox(height: 0),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    vehicle = ModalRoute.of(context).settings.arguments;
    String title = (vehicle['ve_auto_renew'] == true) ? 'Manage auto-renew' : 'Enable auto-renew';
    GetIt.I<DRTModel>().fetchCards();
    _paymentMethod = DRTPaymentMethod();
    return ScopedModel<DRTPaymentMethod>(
        model: _paymentMethod,
        child: ScopedModelDescendant<DRTModel>(
          builder: (context, child, model) {
            Map paymentMethod;
            for (Map cardData in model.cards) {
              if (cardData['id'] == vehicle['ve_auto_renew_payment_method']) {
                paymentMethod = cardData;print(cardData);
                break;
              }
            }
            if (paymentMethod != null) _paymentMethod.setPaymentMethod('CARD', paymentMethod: paymentMethod);

            return DRTPage('Manage auto-renew', _buildBody(context, vehicle));
          }
        )
    );
  }
}