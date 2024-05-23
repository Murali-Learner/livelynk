import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  void pushReplacement({required Widget navigateTo}) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(
        builder: (context) => navigateTo,
      ),
    );
  }

  void push({required Widget navigateTo}) {
    Navigator.push(
      this,
      MaterialPageRoute(
        builder: (context) => navigateTo,
      ),
    );
  }

  void pop() => Navigator.pop(this);
  void pushRemoveUntil({required Widget to}) => Navigator.pushAndRemoveUntil(
        this,
        MaterialPageRoute(
          builder: (context) {
            return to;
          },
        ),
        (route) => false,
      );
  void hideKeyBoard() => FocusScope.of(this).unfocus();
}
