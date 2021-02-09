import 'package:drt_app/model/model.dart';
import 'package:drt_app/model/payment_method.dart';
import 'package:drt_app/util/server_driver.dart';
import 'package:drt_app/view/vehicle_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:drt_app/view/home_page.dart';
import 'package:sembast/sembast.dart';

mixin DRTAutoRenewModel on DRTBaseModel {


  void updateAutoRenew(Map vehicle, bool autoRenew, String autoRenewDuration, DRTPaymentMethod paymentMethod) async {
    try {
      Map params = {
        'access_token': accessToken,
        'reg_num': vehicle['ve_reg_num'],
        'auto_renew': autoRenew,
        'auto_renew_duration': autoRenew ? autoRenewDuration : null,
        'payment_method': paymentMethod.paymentMethodId
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