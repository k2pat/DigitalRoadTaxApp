import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class DRTSnackBar extends Flushbar {
  final message;
  final icon;

  DRTSnackBar({this.message, this.icon}) : super(
    message: message,
    icon: icon,
    margin: EdgeInsets.all(8),
    borderRadius: 8,
    duration: Duration(seconds: 5),
    forwardAnimationCurve: Curves.linear,
    reverseAnimationCurve: Curves.linear
  );
}

void errorSnackBar(BuildContext context, String e) {
  DRTSnackBar(
    message: 'Error:' + e,
    icon: null,
  ).show(context);
}