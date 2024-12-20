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

  Future<List<Map<String, dynamic>>> fetchAllRooms() async {
    try {
      // Lấy toàn bộ dữ liệu các phòng từ Firebase
      final snapshot = await _roomRef.get();
      List<Map<String, dynamic>> rooms = [];

      if (snapshot.exists) {
        for (var child in snapshot.children) {
          // Chuyển đổi dữ liệu của mỗi phòng thành Map<String, dynamic>
          Map<String, dynamic> data =
              Map<String, dynamic>.from(child.value as Map);
          rooms.add(data); // Thêm vào danh sách
        }
      }
      return rooms; // Trả về danh sách các phòng
    } catch (e) {
      // Xử lý lỗi
      print("Failed to fetch all rooms: $e");
      return [];
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

  Future<void> updateRoom({
    required String roomId,
    required String roomName,
    required String roomType,
    required double roomPrice,
    required String roomStatus,
    required int roomCapacity,
    required List<String> roomImages,
    required String roomDescription,
    required List<String> roomAmenities,
    required String hotelId,
    required String createdAt,
    required String updatedAt, // createdAt là String
  }) async {
    try {
      // Chuyển đổi createdAt từ String sang DateTime
      DateTime createdAtDateTime = DateTime.parse(createdAt);

      // Tạo đối tượng RoomModel mới từ dữ liệu cập nhật
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
        createdAt: createdAtDateTime, // Giữ nguyên createdAt dưới dạng DateTime
        updatedAt: DateTime.now(), // Cập nhật thời gian sửa đổi
      );

      // Chuyển RoomModel thành JSON để cập nhật vào Firebase
      Map<String, dynamic> roomData = room.toJson();

      // Cập nhật thông tin phòng trong Firebase
      await _roomRef.child(roomId).update(roomData);

      // Thông báo thành công
      print("Room updated successfully!");
    } catch (e) {
      // Xử lý lỗi
      print("Failed to update room: $e");
      rethrow; // Ném lại lỗi nếu cần xử lý thêm ở UI
    }
  }

  // Hàm xóa phòng
  Future<void> deleteRoom(String roomId) async {
    try {
      // Xóa phòng từ Firebase Realtime Database
      await _roomRef.child(roomId).remove();

      // Nếu dùng Firestore thay vì Realtime Database:
      // await _db.collection('rooms').doc(roomId).delete();
    } catch (e) {
      throw Exception('Failed to delete room: $e');
    }
  }

  Future<List<RoomModel>> fetchAllRoom() async {
    final databaseReference = FirebaseDatabase.instance.ref();

    // Lấy dữ liệu từ Realtime Database
    DatabaseEvent event = await databaseReference.child('tb_room').once();

    List<RoomModel> roomList = [];

    // Lấy DataSnapshot từ event
    DataSnapshot snapshot = event.snapshot;
    print("đã chạy hàm fetchRoom");
    if (snapshot.exists) {
      // Ép kiểu snapshot.value thành Map<dynamic, dynamic>
      Map<dynamic, dynamic> rooms =
          Map<dynamic, dynamic>.from(snapshot.value as Map);
      // Duyệt qua các phòng và tạo danh sách RoomModel từ JSON
      rooms.forEach((key, value) {
        roomList.add(RoomModel.fromJson(Map<String, dynamic>.from(
            value))); // Sử dụng fromJson để chuyển đổi dữ liệu
      });
    }

    return roomList;
  }
}
