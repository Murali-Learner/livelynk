import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showSuccessToast({String message = ""}) {
  if (message.isNotEmpty) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: const Color(0xFF4CAF50),
      webBgColor: "green",
    );
  }
}

void showErrorToast({String message = ""}) {
  if (message.isNotEmpty) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: const Color(0xFFF44336),
      webBgColor: "red",
    );
  }
}
