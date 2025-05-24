import 'package:flutter/material.dart';
import 'package:frontend/utils/constants/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),

        backgroundColor: secondaryColor,
        elevation: 0,
        foregroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: color == null ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
