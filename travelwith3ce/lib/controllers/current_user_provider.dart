import 'package:flutter/material.dart';

class CurrentUserProvider with ChangeNotifier {
  Map<String, dynamic>? userData;

  Future<void> fetchUserData() async {
    // Logic để lấy dữ liệu người dùng từ cơ sở dữ liệu
    // Ví dụ tạm thời
    userData = {
      'fullname_user': 'John Doe',
      'username': 'johndoe',
      'email': 'john@example.com',
      'phone': '1234567890',
      'address': '123 Main St',
      'imgUser': 'https://example.com/path_to_user_image.jpg', // URL hình ảnh
    };
    notifyListeners();
  }

  void updateUserData(Map<String, dynamic> updatedData) {
    userData = updatedData;
    notifyListeners();
  }
}
