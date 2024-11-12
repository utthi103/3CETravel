import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelwith3ce/constant.dart';
import 'package:travelwith3ce/controllers/userController.dart';
import 'package:travelwith3ce/models/account/edit_button.dart';
import 'package:travelwith3ce/models/account/text_field.dart';
import 'package:travelwith3ce/models/userModel.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String? userId;
  XFile? _imageFile; // Biến để lưu trữ ảnh đã chọn
  String? base64Image; // Biến để lưu trữ chuỗi Base64
  final ImagePicker _picker = ImagePicker();
  UserController userController = UserController(); // Khởi tạo UserController
  final databaseRf = FirebaseDatabase.instance.ref("tb_user");

  // Đường dẫn ảnh mặc định
  final String defaultImagePath =
      'assets/images/profile.png'; // Đường dẫn đến ảnh mặc định

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<String?> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Trả về userId từ SharedPreferences
  }

  Future<void> _loadUserData() async {
    userId = await _loadUserId(); // Lấy userId từ SharedPreferences

    if (userId != null) {
      User? user = await userController.getUserById(userId!);
      if (user != null) {
        _fullNameController.text = user.fullnameUser;
        _usernameController.text = user.username;
        _emailController.text = user.email;
        _phoneController.text = user.phone;
        _addressController.text = user.address;
        base64Image = user.imgUser; // Nếu có trường hình ảnh trong User model
      } else {
        print("No user data found");
      }
    } else {
      print("UserId not found in SharedPreferences");
    }
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage; // Lưu ảnh đã chọn
      });

      // Chuyển đổi hình ảnh thành Base64
      List<int> imageBytes = await File(_imageFile!.path).readAsBytes();
      base64Image = base64Encode(imageBytes);
    }
  }

  Future<void> _updateUserProfile() async {
    // Cập nhật thông tin người dùng vào Firebase
    databaseRf.child(userId!).update({
      'fullname': _fullNameController.text,
      'username': _usernameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'image_base64':
          base64Image ?? "placeholder_base64_image", // Lưu chuỗi Base64
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật hồ sơ thành công!')),
      );
    }).catchError((error) {
      print("Failed to update profile: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật hồ sơ thất bại!')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(color: kTextColor)),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage, // Truyền hàm chọn ảnh
              child: ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  height: 100, // Chiều cao cho avatar
                  width: 100, // Chiều rộng cho avatar
                  child: base64Image != null
                      ? Image.memory(
                          base64Decode(base64Image!),
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          defaultImagePath, // Hiển thị ảnh mặc định
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFieldWidget(
              controller: _fullNameController,
              label: 'Full Name',
              hint: 'Enter your full name',
            ),
            const SizedBox(height: 16),
            TextFieldWidget(
              controller: _usernameController,
              label: 'Username',
              hint: 'Enter your username',
            ),
            const SizedBox(height: 16),
            TextFieldWidget(
              controller: _emailController,
              label: 'Email',
              hint: 'Enter your email',
            ),
            const SizedBox(height: 16),
            TextFieldWidget(
              controller: _phoneController,
              label: 'Phone',
              hint: 'Enter your phone number',
            ),
            const SizedBox(height: 16),
            TextFieldWidget(
              controller: _addressController,
              label: 'Address',
              hint: 'Enter your address',
            ),
            const SizedBox(height: 20),
            EditButtonWidget(
              onPressed: _updateUserProfile, // Gọi hàm cập nhật hồ sơ
            ),
          ],
        ),
      ),
    );
  }
}
