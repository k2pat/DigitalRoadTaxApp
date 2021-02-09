import 'package:drt_app/model/model.dart';
import 'package:drt_app/model/payment_method.dart';
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
  RenewalStatus _renewalStatus;

  RenewalStatus get renewalStatus => _renewalStatus;

  Future<Map> renew(Map vehicle, String validityDuration, bool doAutoRenew, DRTPaymentMethod paymentMethod) async {
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
        'device_token': deviceToken,
        'reg_num': vehicle['ve_reg_num'],
        'validity_duration': validityDuration,
        'expiry_dt': DateFormat('yyyy-MM-dd').format(newExpiryDate),
        'roadtax_amount': roadTaxAmount,
        'auto_renew': doAutoRenew,
      };
      Map response = await fetch('payment/pay_roadtax', params);
      String clientSecret = response['client_secret'];

      var result = await StripePayment.confirmPaymentIntent(PaymentIntent(paymentMethodId: paymentMethod.paymentMethodId, clientSecret: clientSecret));
      return response['transaction'];
    }
    catch (e) {
      _renewalStatus = null;
      throw e;
    }
  }

  void handleRenew(Map vehicle, String validityDuration, bool doAutoRenew, DRTPaymentMethod paymentMethod) async {
    try {
      Map transaction = await renew(vehicle, validityDuration, doAutoRenew, paymentMethod);

      await waitWhile(() => _renewalStatus == RenewalStatus.PENDING);
      // if (_renewalStatus != RenewalStatus.SUCCESS) throw 'Failed to renew road tax';

      for (int i = 0; i < data['u_vehicles'].length; i++) {
        if (data['u_vehicles'][i]['ve_reg_num'] == vehicle['ve_reg_num']) {
          vehicle = data['u_vehicles'][i];
          break;
        }
      }
      _renewalStatus = null;

      navigatorKey.currentState.pushNamedAndRemoveUntil(DRTVehiclePage.routeName, ModalRoute.withName(DRTHomePage.routeName), arguments: vehicle);
      navigatorKey.currentState.pushNamed(DRTRenewalSuccessPage.routeName, arguments: transaction);
    }
    catch (e) {
      throw e;
    }
  }

  void renewalSuccess() async {
    _renewalStatus = RenewalStatus.SUCCESS;
  }

  void renewalFail() {
    _renewalStatus = RenewalStatus.FAIL;
  }
}