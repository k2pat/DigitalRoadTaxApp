import 'package:drt_app/model/model.dart';
import 'package:drt_app/model/payment_method.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:drt_app/util/input_formatter.dart';
import 'package:drt_app/view/page.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:get_it/get_it.dart';

class DRTPaymentMethodsPage extends StatefulWidget {
  static final routeName = '/payment_methods';

  @override
  _DRTPaymentMethodsPageState createState() => _DRTPaymentMethodsPageState();
}

class _DRTPaymentMethodsPageState extends State<DRTPaymentMethodsPage> {
  DRTModel drtModel = GetIt.I<DRTModel>();
  DRTPaymentMethod _paymentMethod;

  @override
  initState() {
    super.initState();
    StripePayment.setOptions(
        StripeOptions(
            publishableKey:"pk_test_51IDtdsCFbMmCdmOJ3jHD8cN0K9gYJPjnyTPQUHxarFHXEN0iQLGPLt6s4ptfEK7kJelybeSCyJh3mdHOW5gyHyG700A8mM3TTP",
            androidPayMode: 'test'
        ));
  }

  void _setPaymentMethod(String type, {Map paymentMethod}) {
    setState(() => _paymentMethod.setPaymentMethod(type, paymentMethod: paymentMethod));
  }

  void _addCreditCard() async {
    Map paymentMethod = await drtModel.addCreditCard();
    if (paymentMethod != null)
      _setPaymentMethod('CARD', paymentMethod: paymentMethod);
  }

  void _removeCreditCard(cardData) async {
    await drtModel.removeCreditCard(cardData);
  }

  Widget _buildSavedPaymentMethods(BuildContext context, cards) {
    Color primaryColor = Theme.of(context).primaryColor;
    return ListView.separated(
      shrinkWrap: true,
      itemCount: cards.length,
      separatorBuilder: (context, index) => SizedBox(height: 0),
      itemBuilder: (context, index) {
        Map cardData = cards[index];
        Map card = cardData['card'];

        if (_paymentMethod != null) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Radio(
                value: cardData['id'],
                groupValue: _paymentMethod.paymentMethodId,
                onChanged: (value) => _setPaymentMethod('CARD', paymentMethod: cardData),
              ),
              title: Text(capitalize(card['brand']) + ' •••• ' + card['last4']),
              trailing: Icon(Icons.credit_card, color: primaryColor),
            )
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(Icons.credit_card, color: primaryColor),
              title: Text(capitalize(card['brand']) + ' •••• ' + capitalize(card['last4'])),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeCreditCard(cardData),
              ),
            )
          );
        }
      },
    );
  }

  Widget _buildAddPaymentMethods() {
    return Column(
      children: [
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 8),
        //   child: ListTile(
        //     title: Text('Add payment method', textScaleFactor: 0.95,),
        //   )
        // ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Add credit or debit card'),
            onTap: _addCreditCard,
          )
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 8),
        //   child: ListTile(
        //     leading: Icon(Icons.account_balance),
        //     title: Text('Add bank account'),
        //   )
        // ),
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 8),
        //   child: ListTile(
        //     leading: Icon(Icons.speaker_phone),
        //     title: Text('Use unifi Mobile billing'),
        //   )
        // ),
      ],
    );
  }

  Widget _buildAddPaymentMethodsCheckout() {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Radio(
                value: 'NEWCARD',
                groupValue: _paymentMethod.paymentMethodType,
                onChanged: (value) {
                  _addCreditCard();
                },
              ),
              trailing: Icon(Icons.credit_card),
              title: Text('Credit or debit card'),
              onTap: _addCreditCard,
            )
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Radio(
                value: 'BANK',
                groupValue: _paymentMethod.paymentMethodType,
                onChanged: (value) => _setPaymentMethod(value),
              ),
              trailing: Icon(Icons.account_balance),
              title: Text('Online Banking'),
            )
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Radio(
                value: 'MOBILE',
                groupValue: _paymentMethod.paymentMethodType,
                onChanged: (value) => _setPaymentMethod(value),
              ),
              trailing: Icon(Icons.speaker_phone),
              title: Text('unifi Mobile billing'),
            )
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return ScopedModelDescendant<DRTModel>(
      builder: (context, child, model) {
        List cards = model.cards ?? [];
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          children: [
            SizedBox(height: 8),
            cards.length > 0 ? _buildSavedPaymentMethods(context, cards) : SizedBox(height: 0),
            cards.length > 0 ? Divider() : SizedBox(height: 0),
            _paymentMethod != null ? _buildAddPaymentMethodsCheckout() : _buildAddPaymentMethods(),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    _paymentMethod = ModalRoute.of(context).settings.arguments ?? null;
    GetIt.I<DRTModel>().fetchCards();
    return DRTPage('Payment methods', _buildBody(context));
  }
}