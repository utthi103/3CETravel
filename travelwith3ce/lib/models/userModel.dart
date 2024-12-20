class User {
  // String idUser;
  String fullnameUser;
  String username;
  String email;
  String phone;
  String address;
  String password;
  // String role;
  String imgUser;

  User({
    // required this.idUser,
    required this.fullnameUser,
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
    required this.password,
    // required this.role,
    required this.imgUser,
  });

  // Chuyển đổi từ JSON sang User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // idUser: json['idUser'] ?? '',
      fullnameUser: json['fullname_user'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      password: json['password'] ?? '',
      // role: json['role'] ?? '',
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
      'imgUser': imgUser,
    };
  }
}
