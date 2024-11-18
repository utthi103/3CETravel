import 'package:flutter/material.dart';
import 'package:travelwith3ce/controllers/roomController.dart';
import 'package:travelwith3ce/models/bottom_bar.dart';
import 'package:travelwith3ce/models/roomModel.dart';
import 'package:travelwith3ce/views/home/home_header.dart';
import 'package:travelwith3ce/views/home/search_bar.dart';
import 'package:travelwith3ce/views/home/chips.dart';
import 'package:travelwith3ce/views/home/popular_list.dart';
import 'package:travelwith3ce/views/home/explore_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<List<RoomModel>> fetchRoomData() async {
    RoomController roomController = RoomController();
    try {
      return await roomController.fetchAllRoom(); // Fetching room data
    } catch (e) {
      return []; // Return an empty list if there's an error
    }
  }

  Future<List<RoomModel>> fetchNewRoomData() async {
    RoomController roomController = RoomController();
    try {
      return await roomController.fetchNewRoom(); // Fetching room data
    } catch (e) {
      return []; // Return an empty list if there's an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const HomeHeader(),
            const SearchBarr(),
            const Chips(),
            // Popular List Section
            FutureBuilder<List<RoomModel>>(
              future: fetchRoomData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No popular rooms available'));
                } else {
                  return PopularList(
                    items: snapshot.data!,
                  );
                }
              },
            ),
            // Explore Grid Section
            FutureBuilder<List<RoomModel>>(
              future: fetchNewRoomData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No rooms available'));
                } else {
                  return ExploreList(rooms: snapshot.data!); // Show ExploreList
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
