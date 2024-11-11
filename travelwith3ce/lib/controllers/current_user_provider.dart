import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Thêm import này

class CurrentUserProvider with ChangeNotifier {
  Map<String, dynamic>? userData;

  // Fetch user data from Firebase Realtime Database
  Future<void> fetchUserData(String userId) async {
    final DatabaseReference userRef =
        FirebaseDatabase.instance.ref('users/$userId');

    // Sử dụng once() để lấy dữ liệu một lần
    final DatabaseEvent event = await userRef.once();

    if (event.snapshot.exists) {
      // Chuyển đổi giá trị từ snapshot thành Map
      userData = Map<String, dynamic>.from(event.snapshot.value as Map);
      notifyListeners(); // Cập nhật UI khi có dữ liệu mới
    } else {
      userData = null; // Nếu không tồn tại, gán userData là null
    }
  }

  // Update user data in Firebase Realtime Database

  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('tb_user')
        .doc(userId)
        .update(data);
  }
}
