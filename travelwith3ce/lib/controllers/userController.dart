import 'dart:convert';
import 'package:travelwith3ce/models/userModel.dart'; // Import model User
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Realtime Database
import 'package:crypto/crypto.dart';

class UserController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Hàm để tạo userID
  String createUserID() {
    return _database.child('tb_user_test').push().key!; // Tạo ID tự động
  }

  Future<void> registerUser({
    required String userID,
    required String fullnameUser,
    required String username,
    required String email,
    required String phone,
    required String address,
    required String password,
    required String imgUser,
  }) async {
    try {
      var bytes = utf8.encode(password); // Mã hóa mật khẩu
      var hashedPassword = sha256.convert(bytes).toString(); // Mã hóa mật khẩu

      // Tạo userID mới
      String userID = _database.child('tb_user_test').push().key!;

      // Tạo một đối tượng User từ các thông tin đăng ký
      User newUser = User(
        userID: userID, // Gán userID vào đối tượng User
        fullnameUser: fullnameUser,
        username: username,
        email: email,
        phone: phone,
        address: address,
        password: hashedPassword,
        imgUser: imgUser,
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
      await _database.child('tb_user_test').child(userID).set(newUser.toJson());
      print("Đăng ký thành công với ID: $userID");
    } catch (e) {
      print("Lỗi đăng ký: $e");
      rethrow; // Ném lại lỗi để xử lý tiếp ở UI
    }
  }

  Future<User?> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      var bytes = utf8.encode(password);
      var hashedPassword = sha256.convert(bytes).toString();

      final snapshot = await _database.child('tb_user_test').get();
      if (snapshot.exists) {
        for (var child in snapshot.children) {
          if (child.value != null) {
            Map<String, dynamic> data =
                Map<String, dynamic>.from(child.value as Map);
            print("Dữ liệu người dùng: $data"); // Kiểm tra dữ liệu
            User user = User.fromJson(data);

            // Kiểm tra nếu username và password khớp
            if (user.username.isNotEmpty &&
                user.password.isNotEmpty &&
                user.username == username &&
                user.password == hashedPassword) {
              print("Đăng nhập thành công!");
              return user;
            }
          } else {
            print("Giá trị của child là null");
          }
        }
      }

      print("Đăng nhập thất bại: Sai tên đăng nhập hoặc mật khẩu.");
      return null;
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      rethrow;
    }
  }
}
