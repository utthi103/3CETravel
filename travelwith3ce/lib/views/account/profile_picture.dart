// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_database/firebase_database.dart';

// class ImageToBase64Screen extends StatefulWidget {
//   @override
//   _ImageToBase64ScreenState createState() => _ImageToBase64ScreenState();
// }

// class _ImageToBase64ScreenState extends State<ImageToBase64Screen> {
//   final ImagePicker _picker = ImagePicker();
//   String? _base64Image;

//   Future<void> _pickImage() async {
//     final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
//     if (selectedImage != null) {
//       File file = File(selectedImage.path);
//       // Chuyển đổi hình ảnh thành Base64
//       List<int> imageBytes = await file.readAsBytes();
//       _base64Image = base64Encode(imageBytes);
      
//       setState(() {});
//     }
//   }

//   Future<void> _uploadToFirebase() async {
//     if (_base64Image != null) {
//       final databaseRef = FirebaseDatabase.instance.ref('images');
//       await databaseRef.push().set({
//         'image_base64': _base64Image,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//       });
//       print('Hình ảnh đã được tải lên Firebase thành công!');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chuyển Đổi Hình Ảnh Sang Base64'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _base64Image == null
//                 ? Text('Chưa chọn hình ảnh.')
//                 : Image.memory(base64Decode(_base64Image!), height: 200),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: Text('Chọn Hình Ảnh'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _uploadToFirebase,
//               child: Text('Tải Lên Firebase'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }