import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travelwith3ce/views/detail/image_reviews.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm import để kiểm tra trạng thái đăng nhập

import '../../constant.dart';

class ImageContainer extends StatelessWidget {
  final String imageUrl;

  const ImageContainer({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.58,
          width: MediaQuery.of(context).size.width,
          child: Align(
            alignment: Alignment.topCenter,
            child: FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: Hero(
                tag: imageUrl,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    child: Image.asset(
                      imageUrl,
                      scale: 4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 30,
          right: 35,
          child: FadeInUp(
            duration: const Duration(milliseconds: 500),
            child: GestureDetector(
              // Thêm GestureDetector để xử lý sự kiện nhấn
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                String? userId = prefs.getString('userId');

                if (userId == null) {
                  _showLoginPrompt(context);
                } else {
                  // Thực hiện hành động cho người dùng đã đăng nhập
                }
              },
              child: ClipOval(
                child: Container(
                  height: 23,
                  width: 23,
                  color: kTextColor,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: SvgPicture.asset(
                      'assets/icons/heart.svg',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const ImageReviews(),
      ],
    );
  }

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notification"),
          content: const Text("You must log in first."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                Navigator.pushNamed(
                    context, '/login'); // Điều hướng đến màn hình đăng nhập
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
