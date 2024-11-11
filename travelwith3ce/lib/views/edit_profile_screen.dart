import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelwith3ce/constant.dart';
import 'package:travelwith3ce/controllers/current_user_provider.dart';
import 'package:travelwith3ce/controllers/userController.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travelwith3ce/models/account/edit_button.dart';
import 'package:travelwith3ce/models/account/profile_picture.dart';
import 'package:travelwith3ce/models/account/text_field.dart';
import 'package:travelwith3ce/models/userModel.dart';
import 'package:travelwith3ce/views/profile_picture.dart';

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
  final ImagePicker _picker = ImagePicker();

  UserController userController = UserController(); // Khởi tạo UserController
  final databaseRf = FirebaseDatabase.instance.ref("tb_user");

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
      } else {
        print("No user data found");
      }
    } else {
      print("UserId not found in SharedPreferences");
    }
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
            ProfilePictureWidget(
              imageFile: _imageFile, // Truyền ảnh đã chọn
              onTap: _pickImage, // Truyền hàm chọn ảnh
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
              onPressed: () {
                _updateUserProfile(); // Gọi hàm cập nhật hồ sơ
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage; // Lưu ảnh đã chọn
      });
    }
  }

  Future<void> _updateUserProfile() async {
    String? downloadURL;

    if (_imageFile != null) {
      final String fileName = _imageFile!.name;
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('images/$fileName');

      await storageRef.putFile(File(_imageFile!.path));
      downloadURL = await storageRef.getDownloadURL();
    }

    databaseRf.child(userId!).update({
      'fullname': _fullNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'image_url': downloadURL ?? "placeholder_image_url",
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }).catchError((error) {
      print("Failed to update profile: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    });
  }
}
