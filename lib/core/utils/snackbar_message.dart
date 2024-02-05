import 'package:flutter/material.dart';

import '../../const.dart';

class SnackBarMessage {
  void showSuccessSnackBar(
      {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color3,
    ));
  }

  void showErrorSnackBar(
      {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: colorRed,
    ));
  }
}
