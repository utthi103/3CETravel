import 'package:flutter/material.dart';
import 'package:travelwith3ce/controllers/roomController.dart';
import 'package:travelwith3ce/models/bottom_bar.dart';
import 'package:travelwith3ce/models/roomModel.dart';
import 'package:travelwith3ce/views/home/home_header.dart';
import 'package:travelwith3ce/views/home/search_bar.dart';
import 'package:travelwith3ce/views/home/chips.dart';
import 'package:travelwith3ce/views/home/popular_list.dart';
import 'package:travelwith3ce/views/home/nearby_grid.dart';

import '../dummy.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<List<RoomModel>> fetchRoomData() async {
      RoomController roomController = RoomController();
      try {
        return await roomController
            .fetchAllRoom(); // Assuming fetchAllRoom is asynchronous
      } catch (e) {
        // Handle the error (e.g., log it or return an empty list)
        return [];
      }
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const HomeHeader(),
            const SearchBarr(),
            const Chips(),
            FutureBuilder<List<RoomModel>>(
              future: fetchRoomData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching data'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No rooms available'));
                } else {
                  return PopularList(
                      items: snapshot.data!); // Use the fetched room data
                }
              },
            ),
            NearbyGrid(data: nearby),
          ],
        ),
      ),
    );
  }
}
