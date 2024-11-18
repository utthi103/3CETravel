class favouriteRoomModel {
  String roomId;
  String roomName;
  double roomPrice;
  String roomImage;
  String userId; // Danh sách URL ảnh

  // Constructor
  favouriteRoomModel(
      {required this.roomId,
      required this.roomName,
      required this.roomPrice,
      required this.roomImage,
      required this.userId});

  // Phương thức chuyển từ JSON sang RoomModel
  factory favouriteRoomModel.fromJson(Map<String, dynamic> json) {
    return favouriteRoomModel(
        roomId: json['roomId'] ?? '', // Giá trị mặc định là chuỗi rỗng
        roomName: json['roomName'] ?? 'Unknown Room',
        roomPrice: (json['roomPrice'] != null)
            ? double.tryParse(json['roomPrice']) ?? 0.0
            : 0.0,
        roomImage: json['roomImage'] ?? '',
        userId: json['userId'] ?? '');
  }

  // Phương thức chuyển từ RoomModel sang JSON
  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'roomPrice': roomPrice,
      'roomImage': roomImage,
      'userId': userId
    };
  }
}
