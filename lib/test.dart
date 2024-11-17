// // import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: RegisterScreen(),
//     );
//   }
// }

// class RegisterScreen extends StatefulWidget {
//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _agreeToTerms = false;
//   bool _obscurePassword = true; // Biến để kiểm soát việc hiển thị mật khẩu
//   bool _obscureConfirmPassword =
//       true; // Biến để kiểm soát việc hiển thị mật khẩu xác nhận

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {},
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Tạo tài khoản mới",
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 20),
//                 // Các trường thông tin khác...

//                 // Trường mật khẩu
//                 TextFormField(
//                   obscureText: _obscurePassword,
//                   decoration: InputDecoration(
//                     labelText: 'Mật khẩu',
//                     labelStyle: TextStyle(color: Colors.black),
//                     prefixIcon: Icon(Icons.lock, color: Colors.grey),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscurePassword
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscurePassword =
//                               !_obscurePassword; // Chuyển đổi trạng thái
//                         });
//                       },
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                       borderSide: BorderSide(color: Colors.grey),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 // Trường xác nhận mật khẩu
//                 TextFormField(
//                   obscureText: _obscureConfirmPassword,
//                   decoration: InputDecoration(
//                     labelText: 'Xác nhận mật khẩu',
//                     labelStyle: TextStyle(color: Colors.black),
//                     prefixIcon: Icon(Icons.lock, color: Colors.grey),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscureConfirmPassword
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                         color: Colors.grey,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obscureConfirmPassword =
//                               !_obscureConfirmPassword; // Chuyển đổi trạng thái
//                         });
//                       },
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                       borderSide: BorderSide(color: Colors.grey),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 // Checkbox đồng ý với chính sách bảo mật
//                 Row(
//                   children: [
//                     Checkbox(
//                       value: _agreeToTerms,
//                       onChanged: (value) {
//                         setState(() {
//                           _agreeToTerms = value!; // Cập nhật trạng thái đồng ý
//                         });
//                       },
//                     ),
//                     Expanded(
//                       child: Text("Tôi đồng ý với chính sách bảo mật"),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 // Nút tạo tài khoản
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _agreeToTerms
//                         ? () {
//                             if (_formKey.currentState!.validate()) {
//                               // Xử lý logic đăng ký
//                             }
//                           }
//                         : null,
//                     child: Text('Tạo tài khoản'),
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(vertical: 15),
//                       backgroundColor: Colors.blue,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Center(
//                   child: Text("Hoặc đăng ký với"),
//                 ),
//                 SizedBox(height: 10),
//                 // Nút đăng ký với Google
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         // Xử lý đăng ký bằng Google
//                       },
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             'assets/images/google.png',
//                             fit: BoxFit.contain,
//                             width: 40.0,
//                             height: 40.0,
//                           ),
//                           SizedBox(
//                               width:
//                                   10), // Khoảng cách giữa biểu tượng và văn bản
//                           Text(
//                             'Google',
//                             style:
//                                 TextStyle(fontSize: 25.0, color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: 20), // Khoảng cách giữa Google và Facebook
//                     GestureDetector(
//                       onTap: () {
//                         // Xử lý đăng ký bằng Facebook
//                       },
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             'assets/images/facebook.png', // Đảm bảo có hình ảnh Facebook
//                             fit: BoxFit.contain,
//                             width: 40.0,
//                             height: 40.0,
//                           ),
//                           SizedBox(
//                               width:
//                                   10), // Khoảng cách giữa biểu tượng và văn bản
//                           Text(
//                             'Facebook',
//                             style:
//                                 TextStyle(fontSize: 25.0, color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
