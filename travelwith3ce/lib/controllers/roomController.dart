import 'package:firebase_database/firebase_database.dart';
import 'package:travelwith3ce/models/roomModel.dart';

class RoomController {
  final DatabaseReference _roomRef = FirebaseDatabase.instance.ref('tb_room');
  Future<void> addRoom({
    required String roomName,
    required String roomType,
    required double roomPrice,
    required String roomStatus,
    required int roomCapacity,
    required List<String> roomImages,
    required String roomDescription,
    required List<String> roomAmenities,
    required String hotelId,
  }) async {
    try {
      // Tạo id tự động cho room
      String roomId = _roomRef.push().key!;

      // Tạo đối tượng RoomModel từ dữ liệu
      RoomModel room = RoomModel(
        roomId: roomId,
        roomName: roomName,
        roomType: roomType,
        roomPrice: roomPrice,
        roomStatus: roomStatus,
        roomCapacity: roomCapacity,
        roomImages: roomImages,
        roomDescription: roomDescription,
        roomAmenities: roomAmenities,
        hotelId: hotelId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Chuyển RoomModel thành JSON để lưu vào Firebase
      Map<String, dynamic> roomData = room.toJson();

      // Lưu thông tin phòng vào Firebase
      await _roomRef.child(roomId).set(roomData);

      // Thông báo thành công
      print("Room added successfully!");
    } catch (e) {
      // Xử lý lỗi
      print("Failed to add room: $e");
      rethrow; // Ném lại lỗi nếu cần xử lý thêm ở UI
    }
  }

  Future<List<Map<String, dynamic>>> fetchRoomsByHotelId(String hotelId) async {
    try {
      // Lấy toàn bộ dữ liệu các phòng
      final snapshot = await _roomRef.get();
      List<Map<String, dynamic>> rooms = [];

      if (snapshot.exists) {
        for (var child in snapshot.children) {
          // Chuyển đổi dữ liệu của phòng thành Map<String, dynamic>
          Map<String, dynamic> data =
              Map<String, dynamic>.from(child.value as Map);

          // Kiểm tra nếu `hotelId` của phòng trùng với `hotelId` yêu cầu
          if (data['hotel_id'] == hotelId) {
            rooms.add(data); // Thêm phòng vào danh sách nếu khớp
          }
        }
      }
      return rooms;
    } catch (e) {
      // Xử lý lỗi
      print("Failed to fetch rooms by hotelId: $e");
      return [];
    }
  }
}
