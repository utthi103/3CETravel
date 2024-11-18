import 'package:flutter/material.dart';
import 'package:travelwith3ce/controllers/storeController.dart'; // Đảm bảo bạn import StoreController

class CreateStoreScreen extends StatefulWidget {
  @override
  _CreateStoreScreenState createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers cho các trường nhập liệu
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // Các biến để điều khiển trạng thái hiển thị mật khẩu
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Khởi tạo StoreController
  final StoreController _storeController = StoreController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo tài khoản cửa hàng'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Tên cửa hàng
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Tên cửa hàng',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên cửa hàng';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              // Tên đăng nhập
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Tên đăng nhập',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên đăng nhập';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Số điện thoại
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Địa chỉ
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Địa chỉ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Đánh giá
              TextFormField(
                controller: _ratingController,
                decoration: InputDecoration(
                  labelText: 'Đánh giá',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập đánh giá';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Vui lòng nhập số hợp lệ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Mật khẩu
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Xác nhận mật khẩu
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng xác nhận mật khẩu";
                  } else if (value != _passwordController.text) {
                    return "Mật khẩu không khớp";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Button Tạo Tài Khoản với màu nền tùy chỉnh
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Thực hiện gọi hàm addStoreAccount
                    try {
                      await _storeController.addStoreAccount(
                        nameStore: _nameController.text,
                        usernameStore: _usernameController.text,
                        phoneStore: _phoneController.text,
                        addressStore: _addressController.text,
                        ratingStore: double.parse(_ratingController.text),
                        password: _passwordController.text,
                        imgStore:
                            "", // Nếu cần thêm ảnh cửa hàng thì truyền vào
                      );
                      // Hiển thị thông báo thành công
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Tạo tài khoản thành công!")),
                      );
                    } catch (e) {
                      // Hiển thị lỗi nếu có
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lỗi: ${e.toString()}")),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Màu chữ
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Tạo Tài Khoản'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
