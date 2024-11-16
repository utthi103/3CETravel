import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Thêm thư viện để xử lý base64
import 'dart:typed_data';

import 'package:travelwith3ce/controllers/roomController.dart'; // Để sử dụng Uint8List

class RoomListScreen extends StatefulWidget {
  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  late Future<List<Map<String, dynamic>>> _roomFuture;
  String? userId;

  Future<String?> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userStoreId');
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Lấy userId từ SharedPreferences
    userId = await _loadUserId();

    // Gọi hàm fetchRooms với userId
    if (userId != null) {
      setState(() {
        _roomFuture = RoomController().fetchRoomsByHotelId(userId!);
      });
    } else {
      // Xử lý khi không tìm thấy userId
      setState(() {
        _roomFuture = Future.value([]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room List'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _roomFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Khi dữ liệu đang tải
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Nếu có lỗi xảy ra
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Nếu không có dữ liệu
            return Center(child: Text('No rooms found.'));
          } else {
            // Khi có dữ liệu, hiển thị danh sách các phòng
            List<Map<String, dynamic>> rooms = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> room = rooms[index];

                // Hiển thị các ảnh phòng từ base64
                List<Widget> roomImages =
                    (room['room_images'] ?? []).map<Widget>((base64Image) {
                  Uint8List bytes = base64Decode(base64Image);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        bytes,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList();

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room['room_name'] ?? 'N/A',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Type: ${room['room_type'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Price: \$${room['room_price'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Capacity: ${room['room_capacity']?.toString() ?? 'N/A'}",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Status: ${room['room_status'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Description: ${room['room_description'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Amenities: ${(room['room_amenities'] ?? []).join(', ')}",
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: roomImages),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
