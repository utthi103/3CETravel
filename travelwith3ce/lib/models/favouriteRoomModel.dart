class favouriteRoomModel {
  String roomId;
  String roomName;
  double roomPrice;
  String roomImage;
  String userId;
  String description; // Add description field

  // Constructor
  favouriteRoomModel({
    required this.roomId,
    required this.roomName,
    required this.roomPrice,
    required this.roomImage,
    required this.userId,
    required this.description, // Add description to the constructor
  });

  // Factory method to convert from JSON
  factory favouriteRoomModel.fromJson(Map<String, dynamic> json) {
    return favouriteRoomModel(
      roomId: json['roomId'] ?? '',
      roomName: json['roomName'] ?? 'Unknown Room',
      roomPrice: (json['roomPrice'] != null)
          ? double.tryParse(json['roomPrice']) ?? 0.0
          : 0.0,
      roomImage: json['roomImage'] ?? '',
      userId: json['userId'] ?? '',
      description: json['description'] ?? '', // Handle description
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'roomPrice': roomPrice,
      'roomImage': roomImage,
      'userId': userId,
      'description': description, // Include description
    };
  }
}
