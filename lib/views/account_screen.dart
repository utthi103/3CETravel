import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelwith3ce/controllers/userController.dart';
import 'package:travelwith3ce/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart'
    as auth; // Sử dụng alias cho FirebaseAuth

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? _user;
  final UserController _userController = UserController();
  final auth.FirebaseAuth _auth =
      auth.FirebaseAuth.instance; // Khởi tạo FirebaseAuth với alias

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
      _showRegistrationPrompt();
    }
  }

  void _showRegistrationPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Nofication"),
          content: const Text("Let's register if you don't have an account."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/login');
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
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
                    title: 'Log Out',
                    icon: Icons.logout,
                    onTap: () {
                      _logOut();
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
              : const AssetImage('assets/images/profile.png'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _user!.fullnameUser,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff9223F1),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _user!.email,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Uint8List _getImageFromBase64(String base64String) {
    if (base64String.contains(',')) {
      return base64Decode(base64String.split(',')[1]);
    } else {
      return base64Decode(base64String);
    }
  }

  Widget _buildListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
        ),
        leading: Icon(icon, color: Color.fromARGB(255, 146, 35, 241)),
        onTap: onTap,
      ),
    );
  }

  void _logOut() async {
    try {
      await _auth.signOut(); // Đăng xuất người dùng
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId'); // Xóa userId khỏi SharedPreferences
      Navigator.pushReplacementNamed(
          context, '/login'); // Điều hướng đến LoginScreen
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error signing out.')),
      );
    }
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
