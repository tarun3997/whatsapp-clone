import 'package:flutter/material.dart';

class ErrorHandler{
  static void showError(BuildContext context, dynamic error){
    String errorMessage = _getErrorMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage),
      duration: const Duration(seconds: 3),
      )
    );
  }
  static String _getErrorMessage(dynamic error) {
    if (error is String) {
      return error;
    } else if (error is Exception) {
      return error.toString();
    } else {
      return 'An unknown error occurred';
    }
  }
}