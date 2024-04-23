import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String toastMessage) {
  Fluttertoast.showToast(
    msg: toastMessage,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.blue,
    textColor: Colors.white,
    fontSize: 24.0,
  );
}
