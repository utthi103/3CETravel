import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureWidget extends StatelessWidget {
  final XFile? imageFile; // Biến để lưu ảnh đã chọn
  final Function onTap; // Hàm callback khi nhấn vào hình ảnh

  const ProfilePictureWidget({
    Key? key,
    this.imageFile,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(), // Gọi hàm onTap khi nhấn
      child: CircleAvatar(
        radius: 50, // Kích thước của hình tròn
        backgroundImage: imageFile != null
            ? FileImage(File(imageFile!.path)) // Hiển thị ảnh đã chọn
            : AssetImage('assets/images/default_profile.png') // Ảnh mặc định
                as ImageProvider, // Chuyển đổi sang ImageProvider
      ),
    );
  }
}
