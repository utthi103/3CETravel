import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:travelwith3ce/models/storeModel.dart';

class StoreController {
  final DatabaseReference _storeRef = FirebaseDatabase.instance.ref('tb_store');

  Future<void> addStoreAccount({
    required String nameStore,
    required String usernameStore,
    required String phoneStore,
    required String addressStore,
    required double ratingStore,
    required String password,
    required String imgStore,
  }) async {
    try {
      // Mã hóa mật khẩu bằng sha256
      var bytes = utf8.encode(password); // Chuyển mật khẩu thành byte array
      var hashedPassword = sha256.convert(bytes).toString(); // Mã hóa mật khẩu

      // Tạo id tự động cho store
      String idStore = _storeRef.push().key!;

      // Lưu thông tin store vào Firebase
      await _storeRef.child(idStore).set({
        'id_store': idStore,
        'name_store': nameStore,
        'username_store': usernameStore,
        'phone_store': phoneStore,
        'address_store': addressStore,
        'rating_store': ratingStore,
        'password': hashedPassword, // Lưu mật khẩu đã mã hóa
        'img_store': '', // Lưu ảnh store
      });

      // Thông báo đăng ký thành công
      print("Store account added successfully!");
    } catch (e) {
      // Xử lý lỗi
      print("Failed to add store account: $e");
      rethrow; // Ném lại lỗi nếu cần xử lý thêm ở UI
    }
  }

  // Hàm fetchStores để lấy danh sách các cửa hàng
  Future<List<Map<String, dynamic>>> fetchStores() async {
    try {
      // Lấy tất cả dữ liệu từ bảng 'tb_store'
      DataSnapshot snapshot = await _storeRef.get();

      // Kiểm tra xem dữ liệu có tồn tại không
      if (snapshot.exists) {
        // Lấy danh sách cửa hàng từ Firebase và chuyển đổi thành List<Map>
        Map<dynamic, dynamic> storesData =
            snapshot.value as Map<dynamic, dynamic>;

        // Chuyển đổi Map thành List<Map<String, dynamic>>
        List<Map<String, dynamic>> storesList = storesData.entries.map((entry) {
          return {
            'id_store': entry.key,
            'name_store': entry.value['name_store'],
            'username_store': entry.value['username_store'],
            'phone_store': entry.value['phone_store'],
            'address_store': entry.value['address_store'],
            'rating_store': entry.value['rating_store'],
            'password': entry.value['password'], // Mật khẩu đã mã hóa
            'img_store': entry.value['img_store'],
          };
        }).toList();

        return storesList;
      } else {
        print("No data available.");
        return [];
      }
    } catch (e) {
      // Xử lý lỗi
      print("Failed to fetch store data: $e");
      rethrow;
    }
  }

  Future<void> deleteStore(String idStore) async {
    try {
      // Xóa cửa hàng khỏi Firebase bằng id_store
      await _storeRef.child(idStore).remove();

      // Thông báo xóa thành công
      print("Store with id $idStore has been deleted successfully!");
    } catch (e) {
      // Xử lý lỗi
      print("Failed to delete store with id $idStore: $e");
      rethrow;
    }
  }

  Future<Store?> loginStore({
    required String usernameStore,
    required String password,
  }) async {
    try {
      var bytes = utf8.encode(password);
      var hashedPassword = sha256.convert(bytes).toString();

      final snapshot = await _storeRef.get();
      if (snapshot.exists) {
        for (var child in snapshot.children) {
          Map<String, dynamic> data =
              Map<String, dynamic>.from(child.value as Map);
          Store store = Store.fromJson(data);

          if (store.usernameStore == usernameStore &&
              store.password == hashedPassword) {
            // Nếu tìm thấy người dùng, trả về đối tượng Store
            return store;
          }
        }
      }

      // Nếu không tìm thấy người dùng
      print("Đăng nhập thất bại: Sai tên đăng nhập hoặc mật khẩu.");
      print(usernameStore);
      print(hashedPassword);
      return null;
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      rethrow;
    }
  }
}
