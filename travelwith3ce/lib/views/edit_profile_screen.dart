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
  String? base64Image; // To store Base64 representation of the image
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
        base64Image = user.imgUser; // Load the user's image
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
        // Convert the image to Base64
        File imageFile = File(selectedImage.path);
        base64Image = base64Encode(imageFile.readAsBytesSync());
      });
    }
  }

  Future<void> _updateUserProfile() async {
    // Update user information in Firebase
    databaseRf.child(userId!).update({
      'fullname_user': _fullNameController.text,
      'username': _usernameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'imgUser': base64Image ?? "placeholder_base64_image",
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }).catchError((error) {
      print("Failed to update profile: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile update failed!')),
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
              onTap: _pickImage,
              child: ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
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
              onPressed: _updateUserProfile,
            ),
          ],
        ),
      ),
    );
  }
}
