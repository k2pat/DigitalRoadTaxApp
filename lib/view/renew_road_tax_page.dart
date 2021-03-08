import 'package:drt_app/main.dart';
import 'package:drt_app/model/model.dart';
import 'package:drt_app/model/payment_method.dart';
import 'package:drt_app/util/input_formatter.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:drt_app/view/page.dart';
import 'package:drt_app/view/payment_methods_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';

class DRTRenewRoadTaxPage extends StatefulWidget {
  static final routeName = '/renew_road_tax';

  @override
  _DRTRenewRoadTaxPageState createState() => _DRTRenewRoadTaxPageState();
}

class _DRTRenewRoadTaxPageState extends State<DRTRenewRoadTaxPage> {
  final _formKey = GlobalKey<FormState>();
  Map vehicle;
  String validityDuration = '1Y';
  bool doAutoRenew = false;
  int paymentMethod = 0;
  DRTModel drtModel = GetIt.I<DRTModel>();
  bool _loading = false;
  DRTPaymentMethod _paymentMethod;

  bool _validatePaymentMethod = true;

  void _renew() async {
    try {
      if (_paymentMethod.paymentMethodType != null) {
        setState(() => _loading = true);
        await GetIt.I<DRTModel>().handleRenew(vehicle, validityDuration, doAutoRenew, _paymentMethod);
      }
      else {
        setState(() => _validatePaymentMethod = false);
      }
    } catch (e) {
      errorSnackBar(context, e);
    }
    setState(() => _loading = false);
  }

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
    else if (_paymentMethod.paymentMethodType == 'JOMPAY') {
      return 'JomPAY';
    }
    else if (_paymentMethod.paymentMethodType == 'GRABPAY') {
      return 'GrabPay';
    }
    else if (_paymentMethod.paymentMethodType == 'TNG') {
      return "Touch 'n Go eWallet";
    }
    else if (_paymentMethod.paymentMethodType == 'BOOST') {
      return 'Boost';
    }
    else {
      return 'Select a payment method';
    }
  }
  
  Widget _buildStack(BuildContext context, Map vehicle) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Stack(
      children: [
        _loading ? Align(alignment: Alignment.center, child: SpinKitRing(color: primaryColor)) : _buildBody(context, vehicle)
      ],
    );
  }

  Widget _buildBody(BuildContext context, Map vehicle) {
    Color primaryColor = Theme.of(context).primaryColor;

    DateTime expiryDate = DateTime.parse(vehicle['rt_expiry_dt']);
    DateTime effectiveDate = (DateTime.now().isBefore(expiryDate)) ? expiryDate : DateTime.now();
    DateTime newExpiryDate;
    int _validityFactor;
    if (validityDuration == '1Y') {
      newExpiryDate = DateTime(effectiveDate.year + 1, effectiveDate.month, effectiveDate.day);
      _validityFactor = 2;
    } else if (validityDuration == '6M') {
      newExpiryDate = DateTime(effectiveDate.year, effectiveDate.month + 6, effectiveDate.day);
      _validityFactor = 1;
    }


    // return ScopedModelDescendant<DRTPaymentMethod>(
    //   builder: (context, child, model) {
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
                  value: '1Y',
                  groupValue: validityDuration,
                  onChanged: (value) => setState(() => validityDuration = value),
                ),
                RadioListTile(
                  title: Text('6 months'),
                  value: '6M',
                  groupValue: validityDuration,
                  onChanged: (value) => setState(() => validityDuration = value),
                ),
                SizedBox(height: 16),
                CheckboxListTile(
                  title: Text('Enable auto-renew'),
                  // subtitle: Text('Road tax will be automatically 1 week before expiry date.'),
                  value: doAutoRenew,
                  onChanged: (value) => setState(() => doAutoRenew = !doAutoRenew),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'New expiry date',
                    //textScaleFactor: 1,
                  ),
                  trailing: Text(DRT.dateFormat.format(newExpiryDate),
                    textScaleFactor: 1.25,
                  ),
                ),
                ListTile(
                  title: Text('Road tax amount'),//, textScaleFactor: 1.25),
                  trailing: Text(
                    'RM ' + ((vehicle['ve_roadtax_rate'] * _validityFactor * 0.5 * 100).roundToDouble() / 100).toStringAsFixed(2),
                    textScaleFactor: 2,
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                ),
                Divider(),
                ScopedModelDescendant<DRTPaymentMethod>(
                  builder: (context, child, model) {
                    TextStyle style;
                    if (_validatePaymentMethod == false && _paymentMethod.paymentMethodType == null) style = TextStyle(fontWeight: FontWeight.w500, color: Colors.red);
                    return ListTile(
                      title: Text('Payment method', textScaleFactor: 0.95,),
                      onTap: () => Navigator.pushNamed(context, DRTPaymentMethodsPage.routeName, arguments: _paymentMethod),
                      trailing: Text('Change', style: TextStyle(color: primaryColor)),
                      subtitle: Text(_getPaymentMethodLabel(),
                          textScaleFactor: 1.2,
                          style: style ?? TextStyle(fontWeight: FontWeight.w500)
                      ),
                    );
                  }
                ),
                SizedBox(height: 16),
                RaisedButton(
                  child: Text('Proceed', style: TextStyle(color: Colors.white)),
                  color: Theme.of(context).accentColor,
                  onPressed: _renew,
                ),
                SizedBox(height: 32),
              ],
            )
        );
    //   }
    // );
  }

  @override
  Widget build(BuildContext context) {
    vehicle = ModalRoute.of(context).settings.arguments;
    _paymentMethod = DRTPaymentMethod();
    return ScopedModel<DRTPaymentMethod>(
        model: _paymentMethod,
        child: DRTPage('Renew road tax for ' + vehicle['ve_reg_num'], _buildStack(context, vehicle))
    );
  }
}