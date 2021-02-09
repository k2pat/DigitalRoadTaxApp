import 'package:drt_app/main.dart';
import 'package:drt_app/model/model.dart';
import 'package:drt_app/model/payment_method.dart';
import 'package:drt_app/model/renew_road_tax_model.dart';
import 'package:drt_app/util/process.dart';
import 'package:drt_app/util/server_driver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:stripe_payment/stripe_payment.dart';

void main() {
  group('integration test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    DRT app;
    DRTModel model;
    String TEST_NUM;
    String EMAIL;
    String MOBILE_NUM;
    String PASSWORD;
    String ID_NUM;
    String ID_TYPE;

    String REG_NUM;
    String REGION;
    String MAKE;
    String MODEL;
    String ENGINE_CAPACITY;
    String TYPE;

    setUpAll(() async {
      app = await initialize();
      model = app.model;
      runApp(app);
      Map params = {};
      Map response = await fetch('test/test_num', params, overrideBaseRoute: true);
      TEST_NUM = response['test_num'];

      EMAIL = '00000000$TEST_NUM@mail.my';
      MOBILE_NUM = '000000000$TEST_NUM';
      PASSWORD = 'unhashed';
      ID_NUM = '00000000000$TEST_NUM';
      ID_TYPE = 'MYKAD';

      REG_NUM = 'TEST000$TEST_NUM';
      REGION = 'PENINSULAR';
      MAKE = 'Proton';
      MODEL = 'Iriz';
      ENGINE_CAPACITY = '1600';
      TYPE = 'SALOON';

      print('>>> TEST DATA: USER');
      print('email: $EMAIL');
      print('mobile number: $MOBILE_NUM');
      print('password: $PASSWORD');
      print('id number: $ID_NUM');
      print('id type: $ID_TYPE');
      print('>>> TEST DATA: VEHICLE');
      print('registration number: $REG_NUM, $REG_NUM' + 'B');
      print('region: $REGION');
      print('make: $MAKE');
      print('model: $MODEL');
      print('engine capacity: $ENGINE_CAPACITY');
      print('type: $TYPE');
    });

    testWidgets('register', (WidgetTester tester) async {
      await model.register(MOBILE_NUM, EMAIL, PASSWORD, ID_NUM, ID_TYPE);
    });

    testWidgets('prepare test vehicle to renew', (WidgetTester tester) async {
      Map params = {
        've_reg_num': REG_NUM,
        'u_id_num': ID_NUM,
        'u_id_type': ID_TYPE,
        've_region': REGION,
        've_make': MAKE,
        've_model': MODEL,
        've_engine_capacity': ENGINE_CAPACITY,
        've_type': TYPE
      };
      await fetch('add_vehicle', params);
      params['ve_reg_num'] = params['ve_reg_num'] + 'B';
      await fetch('add_vehicle', params);
    });

    testWidgets('login: user does not exist', (WidgetTester tester) async {
      expect(() async => await model.login('0000000000000000', PASSWORD), throwsA('Unauthorized'));
    });

    testWidgets('login: bad password', (WidgetTester tester) async {
      expect(() async => await model.login(MOBILE_NUM, 'BAD PASSWORD'), throwsA('Unauthorized'));
    });

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

    testWidgets('add credit card', (WidgetTester tester) async {
      // var token = await StripePayment.createTokenWithCard(CreditCard(number: '4242424242424242', expMonth: 12, expYear: 32, cvc: '123'));
      var card = CreditCard(number: '4242424242424242', expMonth: 12, expYear: 32, cvc: '123');
      PaymentMethod paymentMethod = await StripePayment.createPaymentMethod(PaymentMethodRequest(card: card));
      await model.addCreditCard(paymentMethod);
    });

    testWidgets('fetch cards', (WidgetTester tester) async {
      await model.fetchCards();
      expect(model.cards, isNot(equals([])));
    });

    testWidgets('renew road tax: 1 year', (WidgetTester tester) async {
      Map cardData = model.cards[0];
      DRTPaymentMethod paymentMethod = DRTPaymentMethod();
      paymentMethod.setPaymentMethod('CARD', paymentMethod: cardData);
      Map transaction = await model.renew(model.vehicles[0], '1Y', false, paymentMethod);
      expect(transaction['tr_id'], isNot(equals(null)));
    });

    testWidgets('verify renewal: 1 year', (WidgetTester tester) async {
      await Future.delayed(const Duration(seconds: 5), null);
      await model.syncVehicles();
      expect(model.vehicles[0]['rt_is_valid'], equals(true));
    });

    testWidgets('renew road tax: 6 months', (WidgetTester tester) async {
      Map cardData = model.cards[0];
      DRTPaymentMethod paymentMethod = DRTPaymentMethod();
      paymentMethod.setPaymentMethod('CARD', paymentMethod: cardData);
      Map transaction = await model.renew(model.vehicles[1], '6M', false, paymentMethod);
      expect(transaction['tr_id'], isNot(equals(null)));
    });

    testWidgets('verify renewal: 6 months', (WidgetTester tester) async {
      await Future.delayed(const Duration(seconds: 5), null);
      await model.syncVehicles();
      expect(model.vehicles[1]['rt_is_valid'], equals(true));
    });

    testWidgets('renewal: too early', (WidgetTester tester) async {
      await Future.delayed(const Duration(seconds: 30), null);
      Map cardData = model.cards[0];
      DRTPaymentMethod paymentMethod = DRTPaymentMethod();
      paymentMethod.setPaymentMethod('CARD', paymentMethod: cardData);
      expect(() async => await model.renew(model.vehicles[0], '1Y', false, paymentMethod), throwsA('Renewal too early'));
    });

    testWidgets('logout', (WidgetTester tester) async {
      await model.logout();
    });

    tearDownAll(() async {
      Map params = {};
      await fetch('test/shutdown', params, overrideBaseRoute: true);
    });
  });
}