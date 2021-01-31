import 'package:drt_app/model/model.dart';
import 'package:drt_app/util/server_driver.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stripe_payment/stripe_payment.dart';

mixin DRTPaymentModel on DRTBaseModel {
  List cards = [];
  Map autoRenewPaymentMethods = {};

  void fetchCards() async {
    try {
      Map params = {
        'access_token': accessToken
      };
      Map response = await fetch('payment/get_cards', params);
      cards = response['cards'];
      autoRenewPaymentMethods = response['auto_renew_payment_methods'];
      notifyListeners();
    }
    catch (e) {
      errorSnackBar(navigatorKey.currentContext, e);
    }
  }

  Future<Map> addCreditCard() async {
    try {
      Map params = {
        'access_token': accessToken
      };
      Map response = await fetch('payment/setup_intent', params);
      String clientSecret = response['client_secret'];

      var paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
      var result = await StripePayment.confirmSetupIntent(PaymentIntent(paymentMethodId: paymentMethod.id, clientSecret: clientSecret));

      fetchCards();

      DRTSnackBar(message: 'Card saved successfully!', icon: Icon(Icons.check, color: Colors.green)).show(navigatorKey.currentContext);
      return paymentMethod.toJson();
    }
    catch (e) {
      if (e.toString() != "PlatformException(cancelled, cancelled, null, null)")
      errorSnackBar(navigatorKey.currentContext, e);
      return null;
    }
  }

  void removeCreditCard(Map cardData) async {
    try {
      if ((autoRenewPaymentMethods[cardData['id']] ?? []).length > 0) {
        throw 'Card in use for auto-renew';
      }

      Map params = {
        'access_token': accessToken,
        'payment_method_id': cardData['id'],
        'customer_id': cardData['customer'],
      };
      Map response = await fetch('payment/remove_card', params);

      fetchCards();

      DRTSnackBar(message: 'Card removed successfully!', icon: Icon(Icons.check, color: Colors.green)).show(navigatorKey.currentContext);
    }
    catch (e) {
      errorSnackBar(navigatorKey.currentContext, e);
    }
  }
}