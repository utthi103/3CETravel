import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelwith3ce/controllers/roomController.dart';
import 'package:travelwith3ce/models/roomModel.dart';
import 'package:travelwith3ce/views/home/popular_item.dart';
import 'package:travelwith3ce/views/home/section_title.dart';

class PopularList extends StatelessWidget {
  final List<RoomModel> items;

  const PopularList({
    Key? key,
    required this.items,
  }) : super(key: key);

  Future<bool> checkLike(String roomId) async {
    try {
      RoomController roomController = RoomController();
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      // Fetch a single RoomModel instead of a list
      List<RoomModel>? favouriteRoom = await roomController.fetchFavouriteRooms(
        userId!,
        roomId,
      );
      print("check rooomid ${roomId} test : ${favouriteRoom}");
      // Check if the room is present (if favouriteRoom is not null)
      if (favouriteRoom.isNotEmpty) {
        return true; // If the room is found in favourites, return true
      }
    } catch (e) {
      print(e);
    }
    return false; // Return false if no matching room is found
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1100),
      child: Column(
        children: [
          const SectionTitle(title: 'Most Popular'),
          Container(
            height: 239,
            margin: const EdgeInsets.only(bottom: 25),
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: items.length, // Make sure to use the full item count
                itemBuilder: (context, index) {
                  var item = items[index];

                  return FutureBuilder<bool>(
                    future: checkLike(item.roomId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show loading while checking
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      bool check = snapshot.data ?? false;

                      return PopularItem(
                        roomId: item.roomId,
                        imageUrl: item.roomImages[0],
                        name: item.roomName,
                        price: item.roomPrice.toString(),
                        rating: '4.5',
                        amenities: item.roomAmenities,
                        like: check ? '1' : '0',
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
