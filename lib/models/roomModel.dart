class RoomModel {
  String roomId;
  String roomName;
  String roomType;
  double roomPrice;
  String roomStatus;
  int roomCapacity;
  List<String> roomImages; // Danh sách URL ảnh
  String roomDescription;
  List<String> roomAmenities; // Danh sách tiện nghi
  String hotelId;
  DateTime createdAt;
  DateTime updatedAt;

  // Constructor
  RoomModel({
    required this.roomId,
    required this.roomName,
    required this.roomType,
    required this.roomPrice,
    required this.roomStatus,
    required this.roomCapacity,
    required this.roomImages,
    required this.roomDescription,
    required this.roomAmenities,
    required this.hotelId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Phương thức chuyển từ JSON sang RoomModel
  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      roomId: json['room_id'] ?? '', // Giá trị mặc định là chuỗi rỗng
      roomName: json['room_name'] ?? 'Unknown Room',
      roomType: json['room_type'] ?? 'Standard',
      roomPrice:
          (json['room_price'] != null) ? json['room_price'].toDouble() : 0.0,
      roomStatus: json['room_status'] ?? 'Unavailable',
      roomCapacity: json['room_capacity'] ?? 1,
      roomImages: (json['room_images'] != null)
          ? List<String>.from(json['room_images'])
          : [], // Mặc định là danh sách rỗng
      roomDescription: json['room_description'] ?? 'No description available.',
      roomAmenities: (json['room_amenities'] != null)
          ? List<String>.from(json['room_amenities'])
          : [], // Mặc định là danh sách rỗng
      hotelId: json['hotel_id'] ?? '',
      createdAt: (json['created_at'] != null)
          ? DateTime.parse(json['created_at'])
          : DateTime.now(), // Giá trị mặc định là thời gian hiện tại
      updatedAt: (json['updated_at'] != null)
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(), // Giá trị mặc định là thời gian hiện tại
    );
  }

  // Phương thức chuyển từ RoomModel sang JSON
  Map<String, dynamic> toJson() {
    return {
      'room_id': roomId,
      'room_name': roomName,
      'room_type': roomType,
      'room_price': roomPrice,
      'room_status': roomStatus,
      'room_capacity': roomCapacity,
      'room_images': roomImages,
      'room_description': roomDescription,
      'room_amenities': roomAmenities,
      'hotel_id': hotelId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
