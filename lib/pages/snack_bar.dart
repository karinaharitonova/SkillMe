import 'package:flutter/material.dart';
class SnackBarService {
  // статический помощник для показа snackbar
  static void showSnackBar(
    BuildContext context,
    String message, [
    bool isError = false,
  ]) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}