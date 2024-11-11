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
    required String imgUser,
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
        imgUser: "",
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

  // Hàm để đăng nhập người dùng
  Future<Map<String, dynamic>?> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      var bytes = utf8.encode(password);
      var hashedPassword = sha256.convert(bytes).toString();

      final snapshot = await _database.child('tb_user').get();
      if (snapshot.exists) {
        for (var child in snapshot.children) {
          Map<String, dynamic> data =
              Map<String, dynamic>.from(child.value as Map);
          User user = User.fromJson(data);

          if (user.username == username && user.password == hashedPassword) {
            // Nếu đăng nhập thành công, trả về id và user
            return {
              'id': child
                  .key, // Sử dụng child.key để lấy id người dùng từ Firebase
              'user': user,
            };
          }
        }
      }

      // Nếu không tìm thấy người dùng
      print("Đăng nhập thất bại: Sai tên đăng nhập hoặc mật khẩu.");
      return null;
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      rethrow;
    }
  }

  Future<User?> getUserById(String userId) async {
    if (userId.isEmpty) {
      print("User ID không được để trống");
      return null; // Trả về null nếu userId không hợp lệ
    }

    try {
      final snapshot = await _database.child('tb_user').child(userId).get();
      if (snapshot.exists) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        User user = User.fromJson(data);
        return user; // Trả về đối tượng User
      } else {
        print("Không tìm thấy người dùng với ID: $userId");
        return null; // Nếu không tìm thấy người dùng
      }
    } catch (e) {
      print("Lỗi khi lấy thông tin người dùng: $e");
      // Có thể thêm logic để thông báo cho người dùng về lỗi
      return null; // Hoặc bạn có thể ném lại lỗi
    }
  }
}
