import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Thêm thư viện để xử lý base64
import 'dart:typed_data';

import 'package:travelwith3ce/controllers/roomController.dart';
import 'package:travelwith3ce/views/store/editRoom.dart';

class AllRoomListScreen extends StatefulWidget {
  @override
  _AllRoomListScreenState createState() => _AllRoomListScreenState();
}

class _AllRoomListScreenState extends State<AllRoomListScreen> {
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
    userId = await _loadUserId();

    if (userId != null) {
      setState(() {
        _roomFuture = RoomController().fetchAllRooms();
      });
    } else {
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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No rooms found.'));
          } else {
            List<Map<String, dynamic>> rooms = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> room = rooms[index];
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
                        Text("Loại phòng: ${room['room_type'] ?? 'N/A'}"),
                        Text(
                          "Giá phòng: ${room['room_price'] != null ? '${room['room_price']} VNĐ' : 'N/A'}",
                        ),
                        Text(
                          "Sức chứa: ${room['room_capacity']?.toString() ?? 'N/A'}",
                        ),
                        Text("Trạng thái: ${room['room_status'] ?? 'N/A'}"),
                        Text(
                          "Mô tả: ${room['room_description'] ?? 'N/A'}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Tiện nghi: ${(room['room_amenities'] ?? []).join(', ')}",
                        ),
                        SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: roomImages),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Nút Edit
                            TextButton.icon(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditRoomScreen(roomData: room),
                                  ),
                                );
                                if (result == 'updated') {
                                  _initializeData(); // Làm mới danh sách khi quay lại sau khi cập nhật
                                }
                              },
                              icon: Icon(Icons.edit, color: Colors.blue),
                              label: Text('Edit',
                                  style: TextStyle(color: Colors.blue)),
                            ),
                            SizedBox(width: 8),
                            // Nút Delete
                            TextButton.icon(
                              onPressed: () {
                                // Hiển thị dialog xác nhận xóa
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Confirm Deletion'),
                                      content: Text(
                                          'Are you sure you want to delete this room?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); // Đóng dialog nếu nhấn Cancel
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(
                                                context); // Đóng dialog sau khi xác nhận xóa

                                            try {
                                              // Gọi hàm deleteRoom từ RoomController
                                              await RoomController()
                                                  .deleteRoom(room['room_id']);

                                              // Hiển thị snackbar thông báo thành công
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Room deleted successfully!')),
                                              );

                                              // Reload lại danh sách phòng (có thể gọi lại _initializeData() nếu cần)
                                              _initializeData();
                                            } catch (e) {
                                              // Hiển thị lỗi nếu có vấn đề khi xóa
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Error deleting room: $e')),
                                              );
                                            }
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                              label: Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            )
                          ],
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
