import 'package:flutter/material.dart';
import 'package:travelwith3ce/controllers/roomController.dart';
import 'package:travelwith3ce/models/favouriteRoomModel.dart';
import 'package:travelwith3ce/views/home/popular_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<favouriteRoomModel>>(
      future: _fetchFavouriteRooms(), // Fetch the data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          return _buildErrorState(context, snapshot.error); // Handle errors
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Favourite Rooms')); // No data found
        } else {
          List<favouriteRoomModel> favouriteRooms = snapshot.data!;

          // Display the list of rooms in a 2-column grid
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              crossAxisSpacing: 10, // Space between columns
              mainAxisSpacing: 10, // Space between rows
              childAspectRatio:
                  0.75, // Adjust the aspect ratio of the grid items
            ),
            itemCount: favouriteRooms.length,
            itemBuilder: (context, index) {
              favouriteRoomModel room = favouriteRooms[index];

              // Return PopularItem for each room
              return PopularItem(
                roomId: room.roomId,
                imageUrl: room.roomImage,
                name: room.roomName,
                price: room.roomPrice.toString(),
                rating: '4.5',
                amenities: [], // You can pass a list of amenities here if available
                description: room
                    .roomName, // You can use roomName or another field as description
                like: '1', // If the room is liked, set like to '1'
              );
            },
          );
        }
      },
    );
  }

  // Helper function to fetch favourite rooms using RoomController
  Future<List<favouriteRoomModel>> _fetchFavouriteRooms() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      _showLoginPrompt(); // Show login prompt
      throw Exception('User not logged in');
    }

    RoomController roomController = RoomController();
    print("Fetching favourite rooms for user: $userId");
    return roomController.fetchFavouriteRoomByUserId(userId);
  }

  // Build an error state to display more detailed messages
  Widget _buildErrorState(BuildContext context, Object? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, color: Colors.red, size: 48),
          SizedBox(height: 10),
          Text('Error: $error', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Optionally retry the fetching
              // Reload the screen or handle retry logic
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  // Function to show login prompt if the user is not logged in
  void _showLoginPrompt() {
    // You can display an alert or navigate to login screen
    print('User not logged in. Prompting login.');
  }
}
