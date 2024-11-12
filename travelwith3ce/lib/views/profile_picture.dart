import 'dart:convert'; // Thêm để xử lý Base64
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String? base64Image; // Thay đổi từ imageFile sang base64Image
  final Function onTap; // Hàm callback khi nhấn vào hình ảnh

  const ProfilePictureWidget({
    Key? key,
    this.base64Image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(), // Gọi hàm onTap khi nhấn
      child: CircleAvatar(
        radius: 50, // Kích thước của hình tròn
        backgroundImage: base64Image != null
            ? MemoryImage(base64Decode(base64Image!)) // Hiển thị ảnh từ Base64
            : AssetImage('assets/images/profile.png') // Ảnh mặc định
                as ImageProvider, // Chuyển đổi sang ImageProvider
      ),
    );
  }
}
