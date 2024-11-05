import 'package:flutter/material.dart';
import 'package:travelwith3ce/constant.dart';

class EditButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  EditButtonWidget({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        minimumSize: Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'Update Profile',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
