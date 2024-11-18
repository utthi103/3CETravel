import 'package:flutter/material.dart';
import 'package:travelwith3ce/models/roomModel.dart';
import 'package:travelwith3ce/views/home/popular_item.dart'; // Import PopularItem

class SearchPage extends StatelessWidget {
  final List<RoomModel> rooms;

  const SearchPage({super.key, required this.rooms});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: rooms.isEmpty
              ? const Center(child: Text('No rooms found'))
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 0.7, // Adjust the size of items
                  ),
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    var room = rooms[index];
                    return PopularItem(
                      roomId: room.roomId,
                      imageUrl: room.roomImages[
                          0], // Assuming it's a valid image URL or base64
                      name: room.roomName,
                      price: room.roomPrice.toString(),
                      rating: '4.5', // Static rating, adjust as needed
                      amenities: room.roomAmenities,
                      decription: room.roomDescription,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
