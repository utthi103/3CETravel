// account_screen.dart
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

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
    return const Row(
      children: [
        CircleAvatar(
          radius: 40, // Adjust size as needed
          backgroundImage:
              AssetImage('assets/images/profile.png'), // Use the provided image
        ),
        SizedBox(width: 16), // Spacing between avatar and text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3CE TRAVEL', // Replace with actual user name
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '3cetravel@gmail.com', // Replace with actual user email
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }

  // ListTile Builder
  Widget _buildListTile(
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white), // White text color
      ),
      leading: Icon(icon, color: Colors.white), // White icon color
      onTap: onTap,
      tileColor:
          Colors.blueAccent.withOpacity(0.2), // Background color for each tile
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners for tiles
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle account deletion logic here
                Navigator.of(context).pop(); // Close the dialog
                // Show a snackbar or a message indicating success
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
