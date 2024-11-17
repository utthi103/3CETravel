import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelwith3ce/constant.dart';
import 'package:travelwith3ce/controllers/userController.dart';
import 'package:travelwith3ce/views/account/edit_button.dart';
import 'package:travelwith3ce/views/account/text_field.dart';
import 'package:travelwith3ce/models/userModel.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

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
  String? base64Image;
  final ImagePicker _picker = ImagePicker();
  UserController userController = UserController();
  final databaseRf = FirebaseDatabase.instance.ref("tb_user");

  final String defaultImagePath = 'assets/images/profile.png';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<String?> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> _loadUserData() async {
    userId = await _loadUserId();

    if (userId != null) {
      User? user = await userController.getUserById(userId!);
      if (user != null) {
        _fullNameController.text = user.fullnameUser;
        _usernameController.text = user.username;
        _emailController.text = user.email;
        _phoneController.text = user.phone;
        _addressController.text = user.address;
        base64Image = user.imgUser;
      } else {
        _showSnackBar("No user data found");
      }
    } else {
      _showSnackBar("UserId not found in SharedPreferences");
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? selectedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        final imageBytes = await File(selectedImage.path).readAsBytes();
        setState(() {
          base64Image = base64Encode(imageBytes);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _updateUserProfile() async {
    if (userId == null) return;

    final updatedData = {
      'fullname_user': _fullNameController.text,
      'username': _usernameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'imgUser': base64Image ?? '',
    };

    try {
      await databaseRf.child(userId!).update(updatedData);
      _showSnackBar('Profile updated successfully!');
    } catch (error) {
      _showSnackBar('Profile update failed!');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile',
            style: TextStyle(
                color: Colors.black)), // Set title text color to black
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  height: 100,
                  width: 100,
                  child: base64Image != null && base64Image!.isNotEmpty
                      ? Image.memory(
                          base64Decode(base64Image!),
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          defaultImagePath,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildTextField(
                _fullNameController, 'Full Name', 'Enter your full name'),
            const SizedBox(height: 8),
            _buildTextField(
                _usernameController, 'Username', 'Enter your username'),
            const SizedBox(height: 8),
            _buildTextField(_emailController, 'Email', 'Enter your email'),
            const SizedBox(height: 8),
            _buildTextField(
                _phoneController, 'Phone', 'Enter your phone number'),
            const SizedBox(height: 8),
            _buildTextField(
                _addressController, 'Address', 'Enter your address'),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 200,
                child: EditButtonWidget(
                  onPressed: _updateUserProfile,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: TextFieldWidget(
        controller: controller,
        label: label,
        hint: hint,
      ),
    );
  }
}
