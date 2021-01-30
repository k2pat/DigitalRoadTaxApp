import 'package:drt_app/model/model.dart';
import 'package:drt_app/util/input_formatter.dart';
import 'package:drt_app/util/process.dart';
import 'package:drt_app/util/server_driver.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:drt_app/view/home_page.dart';
import 'package:drt_app/view/renewal_success_page.dart';
import 'package:drt_app/view/vehicle_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sembast/sembast.dart';
import 'package:stripe_payment/stripe_payment.dart';

enum RenewalStatus {
  PENDING,
  SUCCESS,
  FAIL
}

mixin DRTRenewRoadTaxModel on DRTBaseModel {
  String paymentMethodType;
  String paymentMethodId;
  Map paymentMethod;
  RenewalStatus _renewalStatus;

  void setPaymentMethod(type, {Map paymentMethod}) {
    paymentMethodType = type;
    if (paymentMethod != null && paymentMethodType == 'CARD') {
      paymentMethodId = paymentMethod['id'];
      this.paymentMethod = paymentMethod;
    } else {
      paymentMethodId = '';
      this.paymentMethod = {};
    }
    notifyListeners();
  }

  void renew2(Map vehicle, String validityDuration, bool doAutoRenew) async {
    try {
      DateTime expiryDate = DateTime.parse(vehicle['rt_expiry_dt']);
      DateTime effectiveDate = (DateTime.now().isBefore(expiryDate)) ? expiryDate : DateTime.now();
      DateTime newExpiryDate;
      double roadTaxAmount;

      if (validityDuration == '1Y') {
        newExpiryDate = DateTime(effectiveDate.year + 1, effectiveDate.month, effectiveDate.day);
        roadTaxAmount = vehicle['ve_roadtax_rate'].toDouble();
      } else if (validityDuration == '6M') {
        newExpiryDate = DateTime(effectiveDate.year, effectiveDate.month + 6, effectiveDate.day);
        roadTaxAmount = vehicle['ve_roadtax_rate'].toDouble() / 2;
      }

      Map params = {
        'access_token': accessToken,
        'reg_num': vehicle['ve_reg_num'],
        'validity_duration': validityDuration,
        'expiry_dt': DateFormat('yyyy-MM-dd').format(newExpiryDate),
        'roadtax_amount': roadTaxAmount,
        'auto_renew': doAutoRenew,
      };
      Map response = await fetch('renew_roadtax', params);
      Map roadtax = response['roadtax'];

      for (int i = 0; i < data['u_vehicles'].length; i++) {
        if (data['u_vehicles'][i]['ve_reg_num'] == roadtax['ve_reg_num']) {
          data['u_vehicles'][i] = { ...data['u_vehicles'][i], ...roadtax };
          vehicle = data['u_vehicles'][i];
          break;
        }
      }
      await store.record('data').put(db, data);
      notifyListeners();
      navigatorKey.currentState.pushNamedAndRemoveUntil(DRTVehiclePage.routeName, ModalRoute.withName(DRTHomePage.routeName), arguments: vehicle);
      navigatorKey.currentState.pushNamed(DRTRenewalSuccessPage.routeName, arguments: response['receipt']);
    }
    catch (e) {
      throw e;
    }
  }

  void renew(Map vehicle, String validityDuration, bool doAutoRenew) async {
    try {
      _renewalStatus = RenewalStatus.PENDING;

      DateTime expiryDate = DateTime.parse(vehicle['rt_expiry_dt']);
      DateTime effectiveDate = (DateTime.now().isBefore(expiryDate)) ? expiryDate : DateTime.now();
      DateTime newExpiryDate;
      double roadTaxAmount;

      if (validityDuration == '1Y') {
        newExpiryDate = DateTime(effectiveDate.year + 1, effectiveDate.month, effectiveDate.day);
        roadTaxAmount = vehicle['ve_roadtax_rate'].toDouble();
      } else if (validityDuration == '6M') {
        newExpiryDate = DateTime(effectiveDate.year, effectiveDate.month + 6, effectiveDate.day);
        roadTaxAmount = vehicle['ve_roadtax_rate'].toDouble() / 2;
      }

      Map params = {
        'access_token': accessToken,
        'reg_num': vehicle['ve_reg_num'],
        'validity_duration': validityDuration,
        'expiry_dt': DateFormat('yyyy-MM-dd').format(newExpiryDate),
        'roadtax_amount': roadTaxAmount,
        'auto_renew': doAutoRenew,
      };
      Map response = await fetch('payment/pay_roadtax', params);
      String clientSecret = response['client_secret'];

      var result = await StripePayment.confirmPaymentIntent(PaymentIntent(paymentMethodId: paymentMethodId, clientSecret: clientSecret));

      await waitWhile(() => _renewalStatus == RenewalStatus.PENDING);
      if (_renewalStatus != RenewalStatus.SUCCESS) throw 'Error: Failed to renew road tax';

      for (int i = 0; i < data['u_vehicles'].length; i++) {
        if (data['u_vehicles'][i]['ve_reg_num'] == vehicle['ve_reg_num']) {
          vehicle = data['u_vehicles'][i];
          break;
        }
      }

      navigatorKey.currentState.pushNamedAndRemoveUntil(DRTVehiclePage.routeName, ModalRoute.withName(DRTHomePage.routeName), arguments: vehicle);
      navigatorKey.currentState.pushNamed(DRTRenewalSuccessPage.routeName, arguments: response['transaction']);

      _renewalStatus = null;
    }
    catch (e) {
      _renewalStatus = null;
      throw e;
    }
  }

  void renewalSuccess() async {
    _renewalStatus = RenewalStatus.SUCCESS;
  }

  void renewalFail() {
    _renewalStatus = RenewalStatus.FAIL;
  }

  void updateAutoRenew(Map vehicle, bool autoRenew, String autoRenewDuration) async {
    try {
      Map params = {
        'access_token': accessToken,
        'reg_num': vehicle['ve_reg_num'],
        'auto_renew': autoRenew,
        'auto_renew_duration': autoRenew ? autoRenewDuration : null
      };
      Map response = await fetch('update_auto_renew', params);
      for (int i = 0; i < data['u_vehicles'].length; i++) {
        if (data['u_vehicles'][i]['ve_reg_num'] == response['ve_reg_num']) {
          data['u_vehicles'][i] = { ...data['u_vehicles'][i], ...response };
          vehicle = data['u_vehicles'][i];
          break;
        }
      }
      await store.record('data').put(db, data);
      notifyListeners();
      navigatorKey.currentState.pushNamedAndRemoveUntil(DRTVehiclePage.routeName, ModalRoute.withName(DRTHomePage.routeName), arguments: vehicle);
      DRTSnackBar(message: 'Auto-renew settings updated successfully', icon: Icon(Icons.check, color: Colors.green)).show(navigatorKey.currentContext);
    }
    catch (e) {
      throw e;
    }
  }
}