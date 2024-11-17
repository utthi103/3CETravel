import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String roomId; // Thêm roomId
  final VoidCallback onPressed; // Thêm hàm callback

  const CustomButton({
    Key? key,
    required this.roomId,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 1500),
          child: SizedBox(
            height: 52,
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextButton(
              onPressed: onPressed,
              
              child: const Text('Book Now'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueAccent,
                textStyle: const TextStyle(fontSize: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
