import 'package:flutter/material.dart';
import 'package:travelwith3ce/constant.dart';

class EditButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const EditButtonWidget({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Set a fixed width for the button
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          minimumSize: const Size.fromHeight(50), // Minimum height
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Update Profile',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
