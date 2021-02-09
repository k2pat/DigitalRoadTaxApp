import 'package:drt_app/main.dart';
import 'package:drt_app/model/model.dart';
import 'package:drt_app/model/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stripe_payment/stripe_payment.dart';

const String EMAIL = '000000002@mail.my';
const String MOBILE_NUM = '0000000002';
const String PASSWORD = 'unhashed';
const String ID_NUM = '000000000002';
const String ID_TYPE = 'MYKAD';

void main() {
  group('end-to-end test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    DRT app;
    DRTModel model;

    setUpAll(() async {
      app = await initializeTest();
      model = app.model;
      //runApp(app);
    });

    // testWidgets('register', (WidgetTester tester) async {
    //   await model.register(MOBILE_NUM, EMAIL, PASSWORD, ID_NUM, ID_TYPE);
    // });

    testWidgets('login', (WidgetTester tester) async {
      await model.login(MOBILE_NUM, PASSWORD);
      expect(model.data['u_mobile_num'], equals(MOBILE_NUM));
      expect(model.data['u_id_num'], equals(ID_NUM));
      expect(model.data['u_id_type'], equals(ID_TYPE));
      expect(model.data['u_vehicles'], isNot(equals(null)));
      expect(model.data['u_vehicles'], isNot(equals([])));
    });

    testWidgets('initialize and sync', (WidgetTester tester) async {
      model.data = {};
      await model.initialize();
      expect(model.data['u_mobile_num'], equals(MOBILE_NUM));
      expect(model.data['u_id_num'], equals(ID_NUM));
      expect(model.data['u_id_type'], equals(ID_TYPE));
      expect(model.data['u_vehicles'], isNot(equals(null)));
      expect(model.data['u_vehicles'], isNot(equals([])));
    });

    // testWidgets('add credit card', (WidgetTester tester) async {
    //   try {
    //     var token = await StripePayment.createTokenWithCard(CreditCard(number: '4242424242424242', expMonth: 12, expYear: 32, cvc: '123'));
    //     PaymentMethod paymentMethod = await StripePayment.createPaymentMethod(PaymentMethodRequest(card: token.card, token: token));
    //     await model.addCreditCard(paymentMethod);
    //   }
    //   catch (e) {
    //
    //   }
    // });

    testWidgets('fetch cards', (WidgetTester tester) async {
      await model.fetchCards();
      expect(model.cards, isNot(equals([])));
    });

    testWidgets('renew road tax', (WidgetTester tester) async {
      Map cardData = model.cards[0];
      DRTPaymentMethod paymentMethod = DRTPaymentMethod();
      paymentMethod.setPaymentMethod('CARD', paymentMethod: cardData);
      Map transaction = await model.renew(model.data['u_vehicles'][0], '1Y', false, paymentMethod);
      expect(transaction['tr_id'], isNot(equals(null)));
    });

    testWidgets('remove credit card', (WidgetTester tester) async {

    });

    testWidgets('logout', (WidgetTester tester) async {
      await model.logout();
    });
  });
}