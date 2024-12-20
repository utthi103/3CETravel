import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:travelwith3ce/models/userModel.dart'; // Import model User
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Realtime Database
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart'
    as auth; // Sử dụng alias cho FirebaseAuth

class UserController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance; // Sử dụng alias

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

  Future<bool> checkEmailExists(String email) async {
    try {
      final snapshot = await _database.child('tb_user').get();
      if (snapshot.exists) {
        for (var child in snapshot.children) {
          Map<String, dynamic> data =
              Map<String, dynamic>.from(child.value as Map);
          User user = User.fromJson(data);

          if (user.email == email) {
            return true; // Email tồn tại
          }
        }
      }
      return false; // Email không tồn tại
    } catch (e) {
      print("Lỗi kiểm tra email: $e");
      rethrow;
    }
  }

  Future<void> sendOtpCode(String email, String otpCode) async {
    try {
      // Cấu hình SMTP (Thay đổi với thông tin email của bạn)
      final smtpServer = gmail(
          'truongthiutthi@gmail.com', '@151617tt'); // Thay thông tin của bạn

      final message = Message()
        ..from = const Address(
            'your-email@gmail.com', 'Your App Name') // Địa chỉ email của bạn
        ..recipients.add(email)
        ..subject = 'Mã OTP để đặt lại mật khẩu'
        ..text = 'Mã OTP của bạn là: $otpCode';

      // Gửi email
      final sendReport = await send(message, smtpServer);
      print('OTP đã được gửi đến: ' + sendReport.toString());

      // Lưu mã OTP vào Firebase hoặc bất kỳ hệ thống nào bạn sử dụng để kiểm tra sau
    } catch (e) {
      print('Gửi OTP thất bại: $e');
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

  //  Admin
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final snapshot = await _database.child('tb_user').get();
    List<Map<String, dynamic>> users = [];

    if (snapshot.exists) {
      for (var child in snapshot.children) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(child.value as Map);
        data['id'] = child.key; // Thêm id của user từ key của child vào data
        users.add(data);
      }
    }
    return users;
  }

  Future<void> deleteUser(String userKey) async {
    try {
      // Sử dụng userKey thay vì userId
      await _database.child('tb_user').child(userKey).remove();
      print("Người dùng đã được xóa thành công.");
    } catch (e) {
      print("Lỗi khi xóa người dùng: $e");
      rethrow;
    }
  }

  // Helper method to decode Base64 string
  Uint8List _getImageFromBase64(String base64String) {
    if (base64String.contains(',')) {
      // Split only if there is a comma
      return base64Decode(base64String.split(',')[1]);
    } else {
      // If no comma, decode directly
      return base64Decode(base64String);
    }
  }

  // Hàm kiểm tra xem có người dùng nào đang đăng nhập hay không
  void checkUserLoggedIn() {
    auth.User? user = _auth.currentUser; // Sử dụng alias

    if (user != null) {
      print(
          'User is logged in: ${user.uid}'); // In ra user ID nếu đang đăng nhập
    } else {
      print(
          'Error: No user is logged in.'); // In ra lỗi nếu không có người dùng nào
    }
  }
}
