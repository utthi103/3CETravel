import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelwith3ce/constant.dart';
import 'package:travelwith3ce/controllers/roomController.dart';
import 'package:travelwith3ce/models/bottom_bar.dart';
import 'package:travelwith3ce/views/detail_screen.dart';

class PopularItem extends StatelessWidget {
  final String roomId;
  final String imageUrl;
  final String name;
  final String price;
  final String rating;
  final List<String> amenities;
  final String description;
  final String? like;

  const PopularItem({
    Key? key,
    required this.roomId,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rating,
    required this.amenities,
    required this.description,
    this.like,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void likeAction(String roomId, String roomImage, String roomName, String roomPrice) {
      RoomController roomController = RoomController();
      roomController.like(roomId, roomImage, roomName, roomPrice);
    }

    void unLikeAction(String roomId) {
      RoomController roomController = RoomController();
      roomController.unLike(roomId);
    }

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
                  description: description,
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
                      base64Decode(imageUrl), // Decode the base64 image
                      scale: 4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: ClipOval(
                  child: GestureDetector(
                    onTap: () async {
                      // Check login status
                      final prefs = await SharedPreferences.getInstance();
                      String? userId = prefs.getString('userId');

                      if (userId == null) {
                        _showLoginPrompt(context);
                      } else {
                        // If logged in, handle the like/unlike action
                        like == "1" ? unLikeAction(roomId) : likeAction(roomId, imageUrl, name, price);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomBar(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 23,
                      width: 23,
                      color: kTextColor,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          Icons.favorite,
                          color: like == "1" ? Colors.red : null, // Set color to red if liked
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
                      '${price} VND',
                      style: nunito14.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
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
                          style: nunito8.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
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
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushNamed(context, '/login'); // Navigate to login screen
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
