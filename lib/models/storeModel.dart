class Store {
  String idStore;
  String nameStore;
  String phoneStore;
  String addressStore;
  double ratingStore;
  String password;
  String imgStore;
  String usernameStore;

  Store({
    required this.idStore,
    required this.nameStore,
    required this.phoneStore,
    required this.addressStore,
    required this.ratingStore,
    required this.password,
    required this.imgStore,
    required this.usernameStore,
  });

  // Phương thức từ JSON cho việc lấy dữ liệu từ Firebase hoặc API
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      idStore: json['id_store'] ?? '',
      nameStore: json['name_store'] ?? '',
      phoneStore: json['phone_store'] ?? '',
      addressStore: json['address_store'] ?? '',
      ratingStore: (json['rating_store'] ?? 0.0).toDouble(),
      password: json['password'] ?? '',
      imgStore: json['imgStore'] ?? '',
      usernameStore: json['username_store'] ?? '',
    );
  }

  // Phương thức để chuyển đổi đối tượng thành JSON, để lưu dữ liệu vào Firebase hoặc API
  Map<String, dynamic> toJson() {
    return {
      'id_store': idStore,
      'name_store': nameStore,
      'phone_store': phoneStore,
      'address_store': addressStore,
      'rating_store': ratingStore,
      'password': password,
      'imgstore': imgStore,
      'username_Store': usernameStore,
    };
  }
}
