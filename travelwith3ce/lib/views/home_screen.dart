import 'package:flutter/material.dart';
import 'package:travelwith3ce/controllers/roomController.dart';
import 'package:travelwith3ce/models/roomModel.dart';
import 'package:travelwith3ce/views/home/home_header.dart';
import 'package:travelwith3ce/views/home/search_bar.dart';
import 'package:travelwith3ce/views/home/chips.dart';
import 'package:travelwith3ce/views/home/popular_list.dart';
import 'package:travelwith3ce/views/home/nearby_grid.dart';

import '../dummy.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<RoomModel> allRooms = []; // Danh sách tất cả phòng
  List<RoomModel> filteredRooms = []; // Danh sách đã lọc
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchRoomData();
  }

  Future<void> fetchRoomData() async {
    RoomController roomController = RoomController();
    try {
      allRooms = await roomController.fetchAllRoom(); // Lấy tất cả phòng
      setState(() {
        filteredRooms = allRooms; // Khởi tạo danh sách đã lọc
      });
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error fetching data: $e');
    }
  }

  void filterRooms(String query) {
    setState(() {
      searchQuery = query;
      filteredRooms = allRooms
          .where((room) =>
              room.roomName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const HomeHeader(),
            SearchBarr(
                onSearchChanged:
                    filterRooms), // Cập nhật để nhận callback tìm kiếm
            const Chips(),
            filteredRooms.isEmpty
                ? const Center(child: Text('No rooms available'))
                : PopularList(items: filteredRooms), // Sử dụng danh sách đã lọc
            NearbyGrid(data: nearby),
          ],
        ),
      ),
    );
  }
}
