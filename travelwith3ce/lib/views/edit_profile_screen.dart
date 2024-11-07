// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:travelwith3ce/constant.dart';
// import 'package:travelwith3ce/models/account/profile_picture.dart';
// import 'package:travelwith3ce/models/account/text_field.dart';
// import 'package:travelwith3ce/models/account/edit_button.dart';
// import 'package:travelwith3ce/controllers/current_user_provider.dart';

// class EditProfileScreen extends StatefulWidget {
//   @override
//   _EditProfileScreenState createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   final _fullNameController = TextEditingController();
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // _fetchUserData();
//   }

//   // Future<void> _fetchUserData() async {
//   //   final userProvider =
//   //       Provider.of<CurrentUserProvider>(context, listen: false);
//   //   await userProvider.fetchUserData();
//   //   if (userProvider.userData != null) {
//   //     _fullNameController.text = userProvider.userData!['fullname_user'] ?? '';
//   //     _usernameController.text = userProvider.userData!['username'] ?? '';
//   //     _emailController.text = userProvider.userData!['email'] ?? '';
//   //     _phoneController.text = userProvider.userData!['phone'] ?? '';
//   //     _addressController.text = userProvider.userData!['address'] ?? '';
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Profile', style: TextStyle(color: kTextColor)),
//         backgroundColor: kPrimaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ProfilePictureWidget(),
//             const SizedBox(height: 20),
//             TextFieldWidget(
//               controller: _fullNameController,
//               label: 'Full Name',
//               hint: 'Enter your full name',
//             ),
//             const SizedBox(height: 16),
//             TextFieldWidget(
//               controller: _usernameController,
//               label: 'Username',
//               hint: 'Enter your username',
//             ),
//             const SizedBox(height: 16),
//             TextFieldWidget(
//               controller: _emailController,
//               label: 'Email',
//               hint: 'Enter your email',
//             ),
//             const SizedBox(height: 16),
//             TextFieldWidget(
//               controller: _phoneController,
//               label: 'Phone',
//               hint: 'Enter your phone number',
//             ),
//             const SizedBox(height: 16),
//             TextFieldWidget(
//               controller: _addressController,
//               label: 'Address',
//               hint: 'Enter your address',
//             ),
//             const SizedBox(height: 20),
//             EditButtonWidget(
//               onPressed: () {
//                 // Handle edit action (e.g., save changes)
//                 _updateUserProfile();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _updateUserProfile() {
//     // Implement the update logic here
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelwith3ce/constant.dart';
import 'package:travelwith3ce/models/account/profile_picture.dart';
import 'package:travelwith3ce/models/account/text_field.dart';
import 'package:travelwith3ce/models/account/edit_button.dart';
import 'package:travelwith3ce/controllers/current_user_provider.dart';

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

  String? _imgUser;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userProvider =
        Provider.of<CurrentUserProvider>(context, listen: false);
    await userProvider.fetchUserData();

    if (userProvider.userData != null) {
      _fullNameController.text = userProvider.userData!['fullname_user'] ?? '';
      _usernameController.text = userProvider.userData!['username'] ?? '';
      _emailController.text = userProvider.userData!['email'] ?? '';
      _phoneController.text = userProvider.userData!['phone'] ?? '';
      _addressController.text = userProvider.userData!['address'] ?? '';
      _imgUser = userProvider.userData!['imgUser']; // Lấy hình ảnh người dùng
      setState(() {}); // Cập nhật lại giao diện
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
            // Hiển thị hình ảnh người dùng
            GestureDetector(
              onTap: () {
                // Logic để thay đổi hình ảnh người dùng (có thể mở gallery)
                _changeProfilePicture();
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imgUser != null
                    ? NetworkImage(
                        _imgUser!) // Hoặc Image.asset nếu hình ảnh cục bộ
                    : AssetImage('assets/images/default_avatar.png')
                        as ImageProvider, // Hình ảnh mặc định
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
              onPressed: () {
                _updateUserProfile();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _changeProfilePicture() {
    // Logic để thay đổi hình ảnh người dùng
    // Bạn có thể sử dụng package như image_picker để chọn ảnh từ gallery
  }

  void _updateUserProfile() {
    final userProvider =
        Provider.of<CurrentUserProvider>(context, listen: false);

    final updatedData = {
      'fullname_user': _fullNameController.text,
      'username': _usernameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'imgUser': _imgUser // Cập nhật hình ảnh người dùng nếu thay đổi
    };

    userProvider.updateUserData(updatedData);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully!')),
    );
  }
}
