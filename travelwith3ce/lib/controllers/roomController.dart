import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelwith3ce/models/favouriteRoomModel.dart';
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

  Future<List<RoomModel>> fetchNewRoom() async {
    final databaseReference = FirebaseDatabase.instance.ref();

    // Lấy dữ liệu từ Realtime Database, sắp xếp theo cột 'update_at' (dạng chuỗi ISO 8601)
    DatabaseEvent event = await databaseReference
        .child('tb_room')
        .orderByChild('update_at')
        .limitToLast(9) // Sắp xếp theo trường 'update_at'
        .once();

    List<RoomModel> roomList = [];

    // Lấy DataSnapshot từ event
    DataSnapshot snapshot = event.snapshot;
    print("đã chạy hàm fetchNewRoom");

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

  Future<List<favouriteRoomModel>> fetchFavouriteRoomByUserId(
      String userId) async {
    final databaseReference = FirebaseDatabase.instance.ref();

    // Fetch data from the 'tb_favourite' node, filtered by userId
    DatabaseEvent event = await databaseReference
        .child('tb_favourite')
        .orderByChild('userId') // Order by 'userId' field
        .equalTo(userId) // Filter by the provided userId
        .once();

    List<favouriteRoomModel> roomList = [];

    // Get the snapshot of the data
    DataSnapshot snapshot = event.snapshot;
    print("Fetching data from tb_favourite for userId: $userId");

    if (snapshot.exists) {
      // Convert snapshot to a Map
      Map<dynamic, dynamic> rooms =
          Map<dynamic, dynamic>.from(snapshot.value as Map);

      // Iterate through the rooms and create RoomModel objects
      rooms.forEach((key, value) {
        // Convert each room to RoomModel using fromJson method
        favouriteRoomModel room =
            favouriteRoomModel.fromJson(Map<String, dynamic>.from(value));

        // Add the room to the list
        roomList.add(room);
        print('anhneeeeeeeeeeeeee ${room.roomImage}');
      });
    } else {
      print("No favourites found for userId: $userId.");
    }

    return roomList;
  }

  Future<List<RoomModel>> fetchRoomByName(String query) async {
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
        RoomModel room = RoomModel.fromJson(Map<String, dynamic>.from(value));

        // Kiểm tra nếu tên phòng chứa chuỗi tìm kiếm
        if (room.roomName.toLowerCase().contains(query.toLowerCase())) {
          roomList.add(room);
        }
      });
    }

    return roomList;
  }

  Future<void> like(String roomId, String roomImage, String roomName,
      String roomPrice) async {
    try {
      // Fetch userId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        // If the user is not logged in, show an alert or prompt to login
        print('User is not logged in');
        return;
      }

      // Get a reference to the Firebase Realtime Database
      final databaseReference = FirebaseDatabase.instance.ref();

      // Save the user's like to the tb_favourite table
      await databaseReference.child('tb_favourite').push().set({
        'userId': userId,
        'roomId': roomId,
        'roomImage': roomImage,
        'roomName': roomName,
        'roomPrice': roomPrice,
        'liked': 1, // Storing a like value (1 means liked)
      });

      print('Room $roomId liked by user $userId');
    } catch (e) {
      print('Error while liking room: $e');
    }
  }

  Future<void> unLike(String roomId) async {
    // Get the current userId from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId'); // Retrieve userId

    if (userId == null) {
      print("User is not logged in.");
      return; // If userId is not found, return early
    }

    final databaseReference = FirebaseDatabase.instance.ref();

    try {
      // Locate the favourite entry based on roomId and userId
      await databaseReference
          .child('tb_favourite')
          .orderByChild('roomId')
          .equalTo(roomId) // Match by roomId
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          // Now find the specific entry with both roomId and userId
          snapshot.children.forEach((childSnapshot) {
            var fav = childSnapshot.value as Map;
            if (fav['userId'] == userId) {
              // This entry matches the userId and roomId, so remove it
              childSnapshot.ref.remove();
              print("Successfully removed from favourites.");
            }
          });
        } else {
          print("Favourite not found.");
        }
      });
    } catch (e) {
      print("Error removing from favourites: $e");
    }
  }

  Future<RoomModel?> fetchFavouriteRoom(String userId, String roomId) async {
    final databaseReference = FirebaseDatabase.instance.ref();

    // Construct a compound key using both userId and roomId
    String compoundKey = '$userId\_$roomId';

    // Query the 'tb_favourite' node with the compound key
    DatabaseEvent event = await databaseReference
        .child('tb_favourite')
        .child(compoundKey) // Use compound key to fetch specific entry
        .once();

    // Check if data exists for the given compound key
    if (event.snapshot.exists) {
      // Convert the snapshot value into a RoomModel object and return it
      return RoomModel.fromJson(
          Map<String, dynamic>.from(event.snapshot.value as Map));
    } else {
      return null; // Return null if no data is found
    }
  }

  Future<String?> fetchRoomDescription(String roomId) async {
  try {
    final databaseReference = FirebaseDatabase.instance.ref('tb_room/$roomId');
    DatabaseEvent event = await databaseReference.once();

    if (event.snapshot.exists) {
      Map<dynamic, dynamic> roomData =
          Map<dynamic, dynamic>.from(event.snapshot.value as Map);
      return roomData['room_description'] as String?;
    }
    return null;
  } catch (error) {
    print("Error fetching room details: $error");
    return null;
  }
}
  
  Future<List<RoomModel>> fetchFavouriteRooms(
      String userId, String roomId) async {
    final databaseReference = FirebaseDatabase.instance.ref();

    // Query to get all favorites by a specific user
    DatabaseEvent event = await databaseReference
        .child('tb_favourite')
        .orderByChild('userId')
        .equalTo(userId) // Filter by userId
        .once();

    List<RoomModel> roomList = [];

    // Check if there is data in the snapshot
    if (event.snapshot.exists) {
      // Loop through the rooms and filter by roomId
      Map<dynamic, dynamic> rooms =
          Map<dynamic, dynamic>.from(event.snapshot.value as Map);
      rooms.forEach((key, value) {
        var roomData = Map<String, dynamic>.from(value);
        if (roomData['roomId'] == roomId) {
          // Filter by roomId
          roomList.add(RoomModel.fromJson(roomData)); // Add RoomModel to list
        }
      });
    }

    return roomList; // Return list of rooms
  }
}
