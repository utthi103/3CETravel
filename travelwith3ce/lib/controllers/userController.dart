import 'dart:convert';

import 'package:travelwith3ce/models/userModel.dart'; // Import model User
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Realtime Database
import 'package:crypto/crypto.dart';

class UserController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Hàm để đăng ký tài khoản người dùng mới
  Future<void> registerUser({
    required String fullnameUser,
    required String username,
    required String email,
    required String phone,
    required String address,
    required String password,
  }) async {
    try {
      var bytes = utf8.encode(password); // Chuyển mật khẩu thành byte array
      var hashedPassword = sha256.convert(bytes).toString(); // Mã hóa mật khẩu
      // Tạo một đối tượng User từ các thông tin đăng ký
      User newUser = User(
        fullnameUser: fullnameUser,
        username: username,
        email: email,
        phone: phone,
        address: address,
        password: hashedPassword,
      );

      // Kiểm tra các điều kiện cần thiết (như không bỏ trống trường)
      if (fullnameUser.isEmpty ||
          username.isEmpty ||
          email.isEmpty ||
          phone.isEmpty ||
          address.isEmpty ||
          password.isEmpty) {
        throw Exception("Vui lòng điền đầy đủ thông tin.");
      }

      // Lưu thông tin người dùng vào Firebase Realtime Database
      await _database.child('tb_user').push().set(newUser.toJson());

      // Thông báo đăng ký thành công (có thể dùng SnackBar hoặc dialog)
      print("Đăng ký thành công!");
    } catch (e) {
      // Xử lý lỗi
      print("Lỗi đăng ký: $e");
      rethrow; // Có thể ném lại lỗi để xử lý tiếp ở UI
    }
  }
}
