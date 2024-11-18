class BookModel {
  final String idBook; // ID của booking
  final String idUser; // ID của người dùng
  final String idStore;
  final String idRoom; // ID của cửa hàng (hoặc phòng)
  final double price; // Giá của booking
  final DateTime checkInDate;
  final DateTime checkOutDate; // Ngày đặt phòng

  BookModel({
    required this.idBook,
    required this.idUser,
    required this.idStore,
    required this.idRoom,
    required this.price,
    required this.checkInDate,
    required this.checkOutDate,
  });

  // Chuyển từ Map (dữ liệu từ Firebase hoặc cơ sở dữ liệu) sang BookModel
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      idBook: json['id_book'] ?? '',
      idUser: json['id_user'] ?? '',
      idStore: json['id_store'] ?? '',
      idRoom: json['id_room'] ?? '',
      price: (json['price'] as num).toDouble(),
      checkInDate: DateTime.parse(json['date_book']),
      checkOutDate: DateTime.parse(json['date_book']),
    );
  }

  // Chuyển từ BookModel sang Map (dữ liệu để lưu vào Firebase hoặc cơ sở dữ liệu)
  Map<String, dynamic> toJson() {
    return {
      'id_book': idBook,
      'id_user': idUser,
      'id_store': idStore,
      'id_room': idRoom,
      'price': price,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
    };
  }
}
