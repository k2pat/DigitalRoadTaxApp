import 'package:scoped_model/scoped_model.dart';

class DRTPaymentMethod extends Model {
  String paymentMethodType;
  String paymentMethodId;
  Map paymentMethod;

  DRTPaymentMethod({this.paymentMethodId});

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
}