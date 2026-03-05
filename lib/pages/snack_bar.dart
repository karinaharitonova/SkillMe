import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['API_KEY'];

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