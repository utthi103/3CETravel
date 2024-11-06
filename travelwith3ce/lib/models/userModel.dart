class User {
  String fullnameUser;
  String username;
  String email;
  String phone;
  String address;
  String password;

  User({
    required this.fullnameUser,
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
    required this.password,
    required String imgUser,
  });

  // Chuyển đổi từ JSON sang User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullnameUser: json['fullnameUser'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      password: json['password'] ?? '',
      imgUser: json['imgUser'] ?? '',
    );
  }

  // Chuyển đổi từ User sang JSON
  Map<String, dynamic> toJson() {
    return {
      'fullname_user': fullnameUser,
      'username': username,
      'email': email,
      'phone': phone,
      'address': address,
      'password': password,
      'imgUser': ""
    };
  }
}
