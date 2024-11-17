import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:travelwith3ce/views/detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Để kiểm tra trạng thái đăng nhập

import '../../constant.dart';

class PopularItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String rating;
  final List<String> amenities;
  final String roomId;
  final String hotelId;

  const PopularItem({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rating,
    required this.amenities,
    required this.roomId,
    required this.hotelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: SizedBox(
        height: 239,
        width: 178,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailScreen(
                  imageUrl: imageUrl,
                  title: name,
                  price: price,
                  rawRating: rating,
                  amenities: amenities,
                  roomId: roomId,
                  hotelId: hotelId,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Hero(
                tag: imageUrl,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: Image.memory(
                        base64Decode(
                            imageUrl), // Giải mã base64 thành mảng byte
                        scale: 4,
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: ClipOval(
                  child: GestureDetector(
                    onTap: () async {
                      // Kiểm tra trạng thái đăng nhập
                      final prefs = await SharedPreferences.getInstance();
                      String? userId = prefs.getString('userId');

                      if (userId == null) {
                        _showLoginPrompt(context);
                      } else {
                        // Thực hiện hành động cho người dùng đã đăng nhập
                        // Ví dụ: thêm vào danh sách yêu thích
                      }
                    },
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
              Positioned(
                bottom: 15,
                left: 15,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${price} VNĐ',
                          style: nunito14.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.star,
                              size: 20,
                              color: const Color.fromARGB(255, 241, 221, 41),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating,
                              style: nunito8.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
