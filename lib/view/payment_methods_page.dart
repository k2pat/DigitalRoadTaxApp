import 'package:drt_app/model/model.dart';
import 'package:drt_app/model/payment_method.dart';
import 'package:drt_app/util/snackbar.dart';
import 'package:drt_app/util/input_formatter.dart';
import 'package:drt_app/view/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  bool _loading = false;

  void _setPaymentMethod(String type, {Map paymentMethod}) {
    setState(() => _paymentMethod.setPaymentMethod(type, paymentMethod: paymentMethod));
  }

  void _addCreditCard() async {
    setState(() => _loading = true);
    Map paymentMethod = await drtModel.handleAddCreditCard();
    setState(() => _loading = false);
    if (paymentMethod != null)
      _setPaymentMethod('CARD', paymentMethod: paymentMethod);
  }

  void _removeCreditCard(cardData) async {
    setState(() => _loading = true);
    await drtModel.removeCreditCard(cardData);
    setState(() => _loading = false);
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

        String cardLabel = capitalize(card['brand']) + ' •••• ' + capitalize(card['last4']);

        if (_paymentMethod != null) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Radio(
                value: cardData['id'],
                groupValue: _paymentMethod.paymentMethodId,
                onChanged: (value) => _setPaymentMethod('CARD', paymentMethod: cardData),
              ),
              title: Text(cardLabel),
              trailing: Icon(Icons.credit_card, color: primaryColor),
            )
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(Icons.credit_card, color: primaryColor),
              title: Text(cardLabel),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Confirm remove'),
                        content: Text('Are you sure you want to remove $cardLabel'),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel')
                          ),
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _removeCreditCard(cardData);
                              },
                              child: Text('Remove')
                          ),
                        ]
                      );
                    }
                  );
                 ;
                },
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
    Color primaryColor = Theme.of(context).primaryColor;
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

  Widget _buildStack(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Stack(
      children: [
        _buildBody(context),
        _loading == true ? Align(alignment: Alignment.center, child: SpinKitRing(color: primaryColor)) : SizedBox(height: 0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _paymentMethod = ModalRoute.of(context).settings.arguments ?? null;
    return DRTPage('Payment methods', _buildStack(context));
  }
}