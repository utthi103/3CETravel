import 'package:flutter/material.dart';
import 'package:travelwith3ce/models/userModel.dart'; // Import model User

class AccountScreen extends StatelessWidget {
  final User user; // Thêm User để nhận thông tin người dùng

  const AccountScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: const Color(0xff9223F1), // Set the app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Information Section
            _buildUserInfo(),
            const SizedBox(height: 20), // Spacing
            // Options List
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, // Set the bottom navigation bar color
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.blue),
              onPressed: () {
                // Navigate to Home
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.blue),
              onPressed: () {
                // Navigate to Favorites
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.blue),
              onPressed: () {
                // Navigate to Notifications
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.blue),
              onPressed: () {
                // Navigate to Account
              },
            ),
          ],
        ),
      ),
    );
  }

  // User Info Widget
  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40, // Adjust size as needed
          backgroundImage: user.imgUser.isNotEmpty
              ? NetworkImage(user.imgUser) // Hiển thị hình ảnh từ URL
              : const AssetImage(
                  'assets/images/profile.png'), // Hình ảnh mặc định
        ),
        const SizedBox(width: 16), // Spacing between avatar and text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.fullnameUser, // Hiển thị tên người dùng thực tế
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Đổi sang màu đen cho dễ đọc
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user.email, // Hiển thị email người dùng thực tế
              style:
                  const TextStyle(color: Colors.black54), // Màu xám cho email
            ),
          ],
        ),
      ],
    );
  }

  // ListTile Builder
  Widget _buildListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.black), // Màu chữ đen
      ),
      leading: Icon(icon, color: Colors.black), // Màu icon đen
      onTap: onTap,
      tileColor: Colors.blueAccent.withOpacity(0.2), // Màu nền cho mỗi tile
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Đường viền bo cho tile
      ),
    );
  }

  // Confirmation Dialog for Deleting Account
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
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle account deletion logic here
                Navigator.of(context).pop(); // Đóng dialog
                // Hiển thị snackbar hoặc thông báo thành công
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
