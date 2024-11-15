import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelwith3ce/controllers/userController.dart';
import 'package:travelwith3ce/models/userModel.dart';
import 'package:travelwith3ce/models/userModel.dart'; // Import your User model

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? _user;
  final UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null && userId.isNotEmpty) {
      User? user = await _userController.getUserById(userId);
      setState(() {
        _user = user;
      });
    } else {
      print("User ID is not available");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: const Color(0xff9223F1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _user == null
                ? const Center(child: CircularProgressIndicator())
                : _buildUserInfo(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildListTile(
                    title: 'Edit Profile',
                    icon: Icons.edit,
                    onTap: () {
                      Navigator.pushNamed(context, '/editProfile');
                    },
                  ),
                  _buildListTile(
                    title: 'My Booking',
                    icon: Icons.book,
                    onTap: () {
                      Navigator.pushNamed(context, '/myBooking');
                    },
                  ),
                  _buildListTile(
                    title: 'Delete Account',
                    icon: Icons.delete,
                    onTap: () {
                      _showDeleteConfirmationDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: _user!.imgUser.isNotEmpty
              ? MemoryImage(_getImageFromBase64(_user!.imgUser))
              : const AssetImage('assets/images/profile.png'), // Default image
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _user!.fullnameUser,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _user!.email,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

// Helper method to decode Base64 string
  Uint8List _getImageFromBase64(String base64String) {
    if (base64String.contains(',')) {
      // Split only if there is a comma
      return base64Decode(base64String.split(',')[1]);
    } else {
      // If no comma, decode directly
      return base64Decode(base64String);
    }
  }

  Widget _buildListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      leading: Icon(icon, color: Colors.white),
      onTap: onTap,
      tileColor: Colors.blueAccent.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deleted successfully')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
