import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/utils/constants/colors.dart';

void showSnackBar(BuildContext context, String message) {
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: secondaryColor,
      duration: Duration(seconds: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1,

      behavior: SnackBarBehavior.floating,
      content: Text(message, style: TextStyle(color: Colors.white)),
    ),
  );
}
