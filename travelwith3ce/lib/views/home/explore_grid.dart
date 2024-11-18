import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:travelwith3ce/models/roomModel.dart';
import 'package:travelwith3ce/views/detail_screen.dart';
import 'package:travelwith3ce/views/home/section_title.dart';

class ExploreList extends StatelessWidget {
  final List<RoomModel> rooms;

  const ExploreList({Key? key, required this.rooms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1300),
      child: Column(
        children: [
          const SectionTitle(title: 'Explore'),
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 8,
                ),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  var room = rooms[index];
                  String imageUrl = room.roomImages[0];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            imageUrl: imageUrl,
                            title: room.roomName,
                            rawRating: "4.5", // Giá trị mẫu
                            price: room.roomPrice.toString(),
                            amenities: room.roomAmenities,
                            description: room
                                .roomDescription, // Đảm bảo RoomModel có trường này
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Hero(
                          tag: room,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              child: Image.memory(
                                base64Decode(imageUrl),
                                scale: 4,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          room.roomName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
