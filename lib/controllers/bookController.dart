import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:travelwith3ce/models/bookModel.dart'; // Import model BookModel

class BookingController {
  final DatabaseReference _bookingRef =
      FirebaseDatabase.instance.ref('tb_bookdetail');

  // Hàm thêm thông tin booking vào Firebase
  Future<void> addBooking({
    required String idUser,
    required String idStore,
    required String idRoom,
    required double price,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) async {
    try {
      // Tạo id_book tự động
      String idBook = _bookingRef.push().key!;

      // Tạo đối tượng BookModel
      BookModel booking = BookModel(
          idBook: idBook,
          idUser: idUser,
          idStore: idStore,
          idRoom: idRoom,
          price: price,
          checkInDate: checkInDate,
          checkOutDate: checkOutDate);

      // Lưu booking vào Firebase
      await _bookingRef.child(idBook).set(booking.toJson());

      // Thông báo đăng ký thành công
      print("Booking added successfully!");
    } catch (e) {
      // Xử lý lỗi
      print("Failed to add booking: $e");
      rethrow; // Ném lại lỗi nếu cần xử lý thêm ở UI
    }
  }

  // Hàm lấy tất cả thông tin book từ Firebase
  Future<List<BookModel>> fetchBookings() async {
    try {
      DataSnapshot snapshot = await _bookingRef.get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> bookingsData =
            snapshot.value as Map<dynamic, dynamic>;

        // Chuyển đổi dữ liệu từ Map sang danh sách các đối tượng BookModel
        List<BookModel> bookingsList = bookingsData.entries.map((entry) {
          return BookModel.fromJson(Map<String, dynamic>.from(entry.value));
        }).toList();

        return bookingsList;
      } else {
        return [];
      }
    } catch (e) {
      print("Failed to fetch booking data: $e");
      rethrow;
    }
  }

  // Hàm xóa booking theo id
  Future<void> deleteBooking(String idBook) async {
    try {
      // Xóa booking khỏi Firebase bằng idBook
      await _bookingRef.child(idBook).remove();

      // Thông báo xóa thành công
      print("Booking with id $idBook has been deleted successfully!");
    } catch (e) {
      // Xử lý lỗi
      print("Failed to delete booking with id $idBook: $e");
      rethrow;
    }
  }

  // Hàm tìm kiếm thông tin booking dựa trên idUser và idStore
  Future<List<BookModel>> fetchBookingsByUserAndStore(
      String idUser, String idStore) async {
    try {
      DataSnapshot snapshot = await _bookingRef.get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> bookingsData =
            snapshot.value as Map<dynamic, dynamic>;

        // Lọc dữ liệu booking theo user và store
        List<BookModel> filteredBookings = bookingsData.entries.where((entry) {
          Map<String, dynamic> data = Map<String, dynamic>.from(entry.value);
          return data['id_user'] == idUser && data['id_store'] == idStore;
        }).map((entry) {
          return BookModel.fromJson(Map<String, dynamic>.from(entry.value));
        }).toList();

        return filteredBookings;
      } else {
        return [];
      }
    } catch (e) {
      print("Failed to fetch filtered booking data: $e");
      rethrow;
    }
  }
}
