import 'package:flutter/material.dart';
import 'package:travelwith3ce/constant.dart';

class EditButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  EditButtonWidget({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20, // Kích thước đầy đủ ngang
      height: 30, // Giảm chiều cao của nút
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Update Profile',
          style: TextStyle(
            fontSize: 16, // Kích thước chữ
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
